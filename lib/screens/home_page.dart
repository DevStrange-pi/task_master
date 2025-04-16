import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/routes/app_routes.dart';
import 'package:task_master/widgets/menu_tile.dart';

import '../widgets/scaffold_main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      title: "Admin",
      content: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MenuTile(
              title: "All Task",
              onTap: () {
                Get.toNamed(AppRoutes.allTasksPage, arguments: {
                  "pending_tasks": 8,
                  "completed_tasks": 1,
                  "expired_tasks": 1,
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            MenuTile(
              title: "Assign Task",
              onTap: () {
                Get.toNamed(AppRoutes.assignTaskPage);
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
          ],
        ),
      ),
    );
  }
}
