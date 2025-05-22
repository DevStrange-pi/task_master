import 'package:get/get.dart';

import '../controllers/reporting_page_controller.dart';

class ReportingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportingPageController>(() => ReportingPageController());
  }
}