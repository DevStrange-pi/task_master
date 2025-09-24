import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin/admin_home_page_controller.dart';
import '../../globals/observables.dart';
import '../../routes/app_routes.dart';
import '../../widgets/menu_tile.dart';
import '../../widgets/scaffold_main.dart';

class AdminHomePage extends StatelessWidget {
  final AdminHomePageController adminHomePageController = Get.find<AdminHomePageController>();
  AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ScaffoldMain(
        isHome: true,
        title: adminHomePageController.empName.value,
        content: RefreshIndicator(
          onRefresh: () async {
            await adminHomePageController.getTaskCount();
            await adminHomePageController.getEmpTaskCount();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => MenuTile(
                      title: "All Task",
                      count: globalStatistics.value.totalTasks,
                      // homePageController.statistics.value.totalTasks,
                      onTap: () {
                        Get.toNamed(AppRoutes.allTasksPage,
                            arguments:
                                adminHomePageController.statistics.value.toJson());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MenuTile(
                    title: "My Tasks",
                    onTap: () {
                      Get.toNamed(AppRoutes.employeeMyTaskPage,
                          arguments:
                              adminHomePageController.empStatistics.value.toJson());
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MenuTile(
                    title: "Outgoing Tasks",
                    count:
                        adminHomePageController.empStatistics.value.requestedTasks,
                    onTap: () {
                      adminHomePageController.createdAndAssignedTapped();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MenuTile(
                    title: "My Profile",
                    onTap: () {
                      adminHomePageController.goToMyProfile();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MenuTile(
                    title: "Add Task",
                    onTap: () {
                      adminHomePageController.addTaskTapped();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MenuTile(
                    title: "Add Employee",
                    onTap: () {
                      adminHomePageController.addEmployeeTapped();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Obx(
                    () => MenuTile(
                      count: globalStatistics.value.totalEmployees,
                      title: "Reporting",
                      onTap: () {
                        adminHomePageController.goToReporting();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}