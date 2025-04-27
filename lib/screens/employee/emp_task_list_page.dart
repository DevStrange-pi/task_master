import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/employee/emp_task_list_page_controller.dart';
import '../../routes/app_routes.dart';
import '../../styles/colors.dart';
import '../../widgets/menu_tile.dart';
import '../../widgets/scaffold_main.dart';

class EmpTaskListPage extends StatelessWidget {
  EmpTaskListPage({super.key});
  final EmpTaskListPageController empTaskListPageController =
      Get.find<EmpTaskListPageController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      infoWidget: Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        showDuration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87.withValues(alpha: 0.7),
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 0), // for tooltip container top height
        richMessage: WidgetSpan(
          child: Column(
            children: List.generate(
                empTaskListPageController.taskStatusColor.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0), // for tooltip container bottom height
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 14,
                      color: empTaskListPageController.taskStatusColor.values
                          .elementAt(index),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      empTaskListPageController.taskStatusColor.keys
                          .elementAt(index)
                          .capitalizeFirst!,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.greyWhite.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width / 1.8, 0, 20, 0), // for tooltip container width
        child: const Icon(
          Icons.info_outline,
          size: 32,
          color: AppColors.white,
        ),
      ),
      title: empTaskListPageController.title!,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: empTaskListPageController.tasksList!.isEmpty
                  ? [
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.2),
                        child: Text(
                          "No tasks found",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ]
                  : List.generate(
                      empTaskListPageController.tasksList!.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Tooltip(
                            padding: const EdgeInsets.all(12),
                            showDuration: const Duration(minutes: 1),
                            message:
                                'Name: ${empTaskListPageController.tasksList![index].name!}\n\nDescription: ${empTaskListPageController.tasksList![index].description!}',
                            textStyle: const TextStyle(
                                fontSize: 18, color: AppColors.greyWhite),
                            margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: MenuTile(
                              statusColor:
                                  empTaskListPageController.taskStatusColor[
                                      empTaskListPageController
                                          .tasksList![index].status!],
                              title: empTaskListPageController
                                  .tasksList![index].name!,
                              onTap: () {
                                Get.toNamed(AppRoutes.employeeTaskDetailsPage,
                                    arguments: empTaskListPageController
                                        .tasksList![index]
                                    // {
                                    //   "taskId": empTaskListPageController
                                    //       .tasksList![index].id!
                                    //       .toString(),
                                    //   "taskName":
                                    //       empTaskListPageController.tasksList![index].name!,
                                    //   "taskDescription": empTaskListPageController
                                    //       .tasksList![index].description!,
                                    //   "taskType":
                                    //       empTaskListPageController.tasksList![index].type!,
                                    //   "taskStatus": empTaskListPageController
                                    //       .tasksList![index].status!,
                                    // }
                                    );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
