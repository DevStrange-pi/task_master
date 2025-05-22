import 'package:get/get.dart';

import '../controllers/employee/emp_task_details_page_controller.dart';

class EmpTaskDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpTaskDetailsPageController>(() => EmpTaskDetailsPageController());
  }
}