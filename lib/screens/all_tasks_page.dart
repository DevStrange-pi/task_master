import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/all_tasks_controller.dart';
import 'package:task_master/widgets/scaffold_main.dart';

import '../routes/app_routes.dart';
import '../widgets/menu_tile.dart';

class AllTasksPage extends StatelessWidget {
  AllTasksPage({super.key});
  final AllTasksController allTasksController = Get.find<AllTasksController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      title: "All Tasks",
      content: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(allTasksController.tasksCountList!.length,
                (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: MenuTile(
                  title: allTasksController.tasksCountList![index]["name"]!,
                  onTap: () {
                    Get.toNamed(AppRoutes.taskListPage, arguments: [
                      {"name": "Daily Office Cleaning"},
                      {"name": "Client Meeting"},
                      {"name": "System Update"} // this object is from another api call /api/admin/tasks
                    ]);
                  },
                ),
              );
            })
            // [
            //   const SizedBox(
            //     height: 30,
            //   ),
            //   MenuTile(
            //     title: "Completed Task",
            //     onTap: () {
            //       Get.toNamed(AppRoutes.TASK_LIST_PAGE, arguments: [
            //         {"name": "Daily Office Cleaning"},
            //         {"name": "Client Meeting"},
            //         {"name": "System Update"}
            //       ]);
            //     },
            //   ),
            //   const SizedBox(
            //     height: 30,
            //   ),
            //   MenuTile(
            //     title: "Expired Task",
            //     onTap: () {
            //       Get.toNamed(AppRoutes.TASK_LIST_PAGE, arguments: [
            //         {"name": "Daily Office Cleaning"},
            //         {"name": "Client Meeting"},
            //         {"name": "System Update"}
            //       ]);
            //     },
            //   ),
            // ],
            ),
      ),
    );
  }
}
