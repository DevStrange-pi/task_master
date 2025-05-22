import 'package:get/get.dart';

import '../controllers/employee/emp_my_profile_page_controller.dart';

class EmpMyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpMyProfilePageController>(() => EmpMyProfilePageController());
  }
}