import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/task_list_controller.dart';
import 'package:task_master/routes/app_routes.dart';
import 'package:task_master/styles/colors.dart';
import 'package:task_master/widgets/scaffold_main.dart';

import '../widgets/menu_tile.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({super.key});
  final TaskListController taskListController = Get.find<TaskListController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      title: taskListController.title!,
      content: RefreshIndicator(
        onRefresh: () async {
          await taskListController.onRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  taskListController.tasksList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Tooltip(
                        padding: const EdgeInsets.all(12),
                        showDuration: const Duration(seconds: 10),
                        message:
                            'Name: ${taskListController.tasksList[index].name}\n\nDescription: ${taskListController.tasksList[index].description}',
                        textStyle: const TextStyle(
                            fontSize: 18, color: AppColors.greyWhite),
                        margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: MenuTile(
                          userList:
                              taskListController.fromPage == "fromReporting"
                                  ? []
                                  : taskListController.employeeNameList[index],
                          // const [
                          //   "John Doe",
                          //   "Jane Smith",
                          //   "Vrushali Pandarpatte",
                          //   "Siddhartha Venugopalan"
                          // ],
                          deadlineTimer:
                              taskListController.tasksList[index].status ==
                                      "pending"
                                  ? taskListController.countdowns.length > index
                                      ? (taskListController
                                              .countdowns[index].isNotEmpty
                                          ? taskListController.countdowns[index]
                                          : null)
                                      : null
                                  : null,
                          customFloatingWidget: GestureDetector(
                            onTap: () async {
                              await taskListController.deleteTask(context,
                                  taskListController.tasksList[index].id!);
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  AppColors.darkGrey.withValues(alpha: 0.8),
                              radius: 19,
                              child: const Icon(Icons.delete,
                                  color: AppColors.red),
                            ),
                          ),
                          title: taskListController.tasksList[index].name!,
                          expiredCount: taskListController
                                      .tasksList[index].status ==
                                  "pending"
                              ? taskListController.tasksList[index].expiredCount
                              : null,
                          needReassign:
                              taskListController.tasksList[index].status ==
                                      "expired"
                                  ? true
                                  : null,
                          reassignCallback: () {
                            taskListController.reassignCallback(context,
                                taskListController.tasksList[index].id!);
                          },
                          onTap: () {
                            Get.toNamed(AppRoutes.taskDetailsPage, arguments: {
                              "taskId": taskListController.tasksList[index].id!
                                  .toString(),
                              "taskName":
                                  taskListController.tasksList[index].name!,
                              "taskDescription": taskListController
                                  .tasksList[index].description!,
                              "taskType":
                                  taskListController.tasksList[index].type!,
                              "taskStatus":
                                  taskListController.tasksList[index].status!,
                            });
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
      ),
    );
  }
}
