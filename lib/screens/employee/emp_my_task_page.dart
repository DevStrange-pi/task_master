import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/employee/emp_my_task_page_controller.dart';
import '../../widgets/menu_tile.dart';
import '../../widgets/scaffold_main.dart';

class EmpMyTaskPage extends StatelessWidget {
  EmpMyTaskPage({super.key});
  final EmpMyTaskPageController empMyTaskPageController = Get.find<EmpMyTaskPageController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      title: "My Tasks",
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 70),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                empMyTaskPageController.tasksCountList!.length,
                (index) {
                  
                  return Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: MenuTile(
                      title: empMyTaskPageController.tasksCountList![index]!["name"]!,
                      count: int.parse(
                          empMyTaskPageController.tasksCountList![index]!["count"]!),
                      onTap: () {
                        empMyTaskPageController.onTapMenuTile(empMyTaskPageController.tasksCountList![index]!["name"]!);
                      },
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