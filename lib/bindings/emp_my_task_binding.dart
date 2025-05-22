import 'package:get/get.dart';

import '../controllers/employee/emp_my_task_page_controller.dart';

class EmpMyTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpMyTaskPageController>(() => EmpMyTaskPageController());
  }
}