import 'package:get/get.dart';

import '../controllers/employee/emp_notification_page_controller.dart';

class EmpNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpNotificationPageController>(() => EmpNotificationPageController());
  }
}