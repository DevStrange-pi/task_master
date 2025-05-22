import 'package:get/get.dart';

import '../controllers/employee/emp_task_list_page_controller.dart';

class EmpTaskListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpTaskListPageController>(() => EmpTaskListPageController());
  }
}