import 'package:get/get.dart';

import '../controllers/admin/admin_home_page_controller.dart';


class AdminHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminHomePageController>(() => AdminHomePageController());
  }
}