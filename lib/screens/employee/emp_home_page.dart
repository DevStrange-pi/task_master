import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/routes/app_routes.dart';
import 'package:task_master/widgets/menu_tile.dart';

import '../../controllers/employee/emp_home_page_controller.dart';
import '../../widgets/scaffold_main.dart';

class EmpHomePage extends StatelessWidget {
  EmpHomePage({super.key});
  final EmpHomePageController empHomePageController =
      Get.find<EmpHomePageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ScaffoldMain(
        isHome: true,
        isNotificationsVisible: true,
        // notificationCount: 1,
        onNotificationsPressed: () {
          Get.toNamed(AppRoutes.employeeNotificationPage);
        },
        title: empHomePageController.empName.value,
        content: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MenuTile(
                title: "My Tasks",
                onTap: () {
                  Get.toNamed(AppRoutes.employeeMyTaskPage,
                      arguments:
                          empHomePageController.statistics.value.toJson());
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MenuTile(
                title: "My Profile",
                onTap: () {
                  empHomePageController.goToMyProfile();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MenuTile(
                title: "Add Task",
                onTap: () {
                  empHomePageController.addTaskTapped();
                },
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
