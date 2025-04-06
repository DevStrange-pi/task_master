import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/task_list_controller.dart';
import 'package:task_master/widgets/scaffold_main.dart';

import '../widgets/menu_tile.dart';

class TaskListPage extends StatelessWidget {
   TaskListPage({super.key});
  final TaskListController taskListController = Get.find<TaskListController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      title:"Pending Task",
      content: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            taskListController.tasksList!.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: MenuTile(
            title: taskListController.tasksList![index]["name"],
            onTap: () {},
          ),
              );
            },
          ),
        ),
      ),
    );

  }
}
