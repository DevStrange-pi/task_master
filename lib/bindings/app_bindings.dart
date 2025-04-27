import 'package:get/get.dart';
import 'package:task_master/controllers/add_profile_controller.dart';
import 'package:task_master/controllers/all_tasks_controller.dart';
import 'package:task_master/controllers/add_task_controller.dart';
import 'package:task_master/controllers/employee/emp_my_task_page_controller.dart';
import 'package:task_master/controllers/task_list_controller.dart';
import 'package:task_master/models/employee/emp_dashboard_response_model.dart';

import '../controllers/employee/emp_home_page_controller.dart';
import '../controllers/employee/emp_request_task_page_controller.dart';
import '../controllers/employee/emp_task_details_page_controller.dart';
import '../controllers/employee/emp_task_list_page_controller.dart';
import '../controllers/home_page_controller.dart';
import '../controllers/login_page_controller.dart';
import '../controllers/intro_page_controller.dart';
import '../controllers/task_details_controller.dart';
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntroPageController(), fenix: true);
    Get.lazyPut(() => LoginPageController(), fenix: true);
    Get.lazyPut(() => HomePageController(), fenix: true);
    Get.lazyPut(() => AddProfileController(), fenix: true);
    Get.lazyPut(() => AllTasksController(), fenix: true);
    Get.lazyPut(() => TaskListController(), fenix: true);
    Get.lazyPut(() => AddTaskController(), fenix: true);
    Get.lazyPut(() => TaskDetailsController(), fenix: true);
    Get.lazyPut(() => EmpHomePageController(), fenix: true);
    Get.lazyPut(() => EmpMyTaskPageController(), fenix: true);
    Get.lazyPut(() => EmpTaskListPageController(), fenix: true);
    Get.lazyPut(() => EmpTaskDetailsPageController(), fenix: true);
    // Get.lazyPut(() => EmpRequestTaskPageController(), fenix: true);
  }
}
