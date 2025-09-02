import 'package:get/get.dart';

import '../controllers/employee/emp_created_assigned_page_controller.dart';


class EmpCreatedAssignedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpCreatedAssignedPageController>(() => EmpCreatedAssignedPageController());
  }
}