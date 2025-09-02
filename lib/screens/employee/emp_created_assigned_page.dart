import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/employee/emp_created_assigned_page_controller.dart';
import '../../widgets/scaffold_main.dart';
import '../../styles/colors.dart';
import '../../widgets/menu_tile.dart';
import '../../routes/app_routes.dart';

class EmpCreatedAssignedPage extends StatelessWidget {
  EmpCreatedAssignedPage({super.key});
  final EmpCreatedAssignedPageController empCreatedAssignedPageController =
      Get.find<EmpCreatedAssignedPageController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      // infoWidget, title, and content copied and adapted from EmpTaskListPage
      // Replace all 'empTaskListPageController' with 'empCreatedAssignedPageController'
      infoWidget: Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        showDuration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87.withAlpha(179),
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
        richMessage: WidgetSpan(
          child: Column(
            children: List.generate(
                empCreatedAssignedPageController.taskStatusColor.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 14,
                      color: empCreatedAssignedPageController.taskStatusColor.values.elementAt(index),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      empCreatedAssignedPageController.taskStatusColor.keys.elementAt(index).capitalizeFirst!,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.greyWhite.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 1.8, 0, 20, 0),
        child: const Icon(
          Icons.info_outline,
          size: 32,
          color: AppColors.white,
        ),
      ),
      title: 'Outgoing Tasks',
      content: RefreshIndicator(
        onRefresh: () async {
          await empCreatedAssignedPageController.onRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: empCreatedAssignedPageController.tasksList!.isEmpty
                    ? [
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.2),
                          child: Text(
                            "No tasks found",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.black.withAlpha(128),
                            ),
                          ),
                        ),
                      ]
                    : List.generate(
                        empCreatedAssignedPageController.tasksList!.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Tooltip(
                              padding: const EdgeInsets.all(12),
                              showDuration: const Duration(minutes: 1),
                              message:
                                  'Name:  ${empCreatedAssignedPageController.tasksList![index].name!}\n\nDescription:  ${empCreatedAssignedPageController.tasksList![index].description!}',
                              textStyle: const TextStyle(fontSize: 18, color: AppColors.greyWhite),
                              margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                              child: Obx(
                                () => MenuTile(
                                  deadlineTimer: empCreatedAssignedPageController.tasksList![index].status == "pending"
                                      ? empCreatedAssignedPageController.countdowns.length > index
                                          ? (empCreatedAssignedPageController.countdowns[index].isNotEmpty
                                              ? empCreatedAssignedPageController.countdowns[index]
                                              : null)
                                          : null
                                      : null,
                                  customFloatingWidget: GestureDetector(
                                    onTap: () async {
                                      await empCreatedAssignedPageController.deleteTask(
                                          context,
                                          empCreatedAssignedPageController.tasksList![index].id!);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.darkGrey.withAlpha(204),
                                      radius: 19,
                                      child: const Icon(Icons.delete, color: AppColors.red),
                                    ),
                                  ),
                                  statusColor: empCreatedAssignedPageController.taskStatusColor[
                                      empCreatedAssignedPageController.tasksList![index].status!],
                                  title: empCreatedAssignedPageController.tasksList![index].name!,
                                  userList: empCreatedAssignedPageController.employeeNameList[index],
                                  onTap: () {
                                    Get.toNamed(
                                        AppRoutes.employeeTaskDetailsPage,
                                        arguments: empCreatedAssignedPageController.tasksList![index]);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}