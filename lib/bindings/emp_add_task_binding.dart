import 'package:get/get.dart';

import '../controllers/employee/emp_add_task_page_controller.dart';


class EmpAddTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpAddTaskPageController>(() => EmpAddTaskPageController());
  }
}