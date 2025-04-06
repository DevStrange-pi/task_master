import 'package:get/get.dart';
import 'package:task_master/controllers/add_profile_controller.dart';
import 'package:task_master/controllers/all_tasks_controller.dart';
import 'package:task_master/controllers/assign_task_controller.dart';
import 'package:task_master/controllers/task_list_controller.dart';

import '../controllers/home_page_controller.dart';
import '../controllers/login_page_controller.dart';
import '../controllers/intro_page_controller.dart';
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntroPageController(), fenix: true);
    Get.lazyPut(() => LoginPageController(), fenix: true);
    Get.lazyPut(() => HomePageController(), fenix: true);
    Get.lazyPut(() => AddProfileController(), fenix: true);
    Get.lazyPut(() => AllTasksController(), fenix: true);
    Get.lazyPut(() => TaskListController(), fenix: true);
    Get.lazyPut(() => AssignTaskController(), fenix: true);
  }
}
