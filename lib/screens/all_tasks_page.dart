import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/all_tasks_controller.dart';
import 'package:task_master/widgets/scaffold_main.dart';

import '../widgets/menu_tile.dart';

class AllTasksPage extends StatelessWidget {
  AllTasksPage({super.key});
  final AllTasksController allTasksController = Get.find<AllTasksController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      title: "All Tasks",
      content: RefreshIndicator(
        onRefresh: () async {
          await allTasksController.getTaskCount();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 70),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  allTasksController.tasksCountList!.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: MenuTile(
                        title: allTasksController.tasksCountList![index]!["name"]!,
                        count: int.parse(
                            allTasksController.tasksCountList![index]!["count"]!),
                        onTap: () {
                          allTasksController.onTapMenuTile(allTasksController.tasksCountList![index]!["name"]!);
                        },
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
