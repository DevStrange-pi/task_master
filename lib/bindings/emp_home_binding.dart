import 'package:get/get.dart';

import '../controllers/employee/emp_home_page_controller.dart';

class EmpHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpHomePageController>(() => EmpHomePageController());
  }
}