import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/home_page_controller.dart';
import 'package:task_master/routes/app_routes.dart';
import 'package:task_master/widgets/menu_tile.dart';

import '../globals/observables.dart';
import '../widgets/scaffold_main.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomePageController homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ScaffoldMain(
        isHome: true,
        title: homePageController.empName.value,
        content: RefreshIndicator(
          onRefresh: () async {
            await homePageController.getTaskCount();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 40,bottom: 40),
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
                                homePageController.statistics.value.toJson());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MenuTile(
                    title: "Add Task",
                    onTap: () {
                      homePageController.addTaskTapped();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MenuTile(
                    title: "Add Employee",
                    onTap: () {
                      Get.toNamed(AppRoutes.addProfilePage);
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MenuTile(
                    title: "Reporting",
                    onTap: () {
                      homePageController.goToReporting();
                    },
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
