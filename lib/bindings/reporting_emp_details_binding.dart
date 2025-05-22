import 'package:get/get.dart';

import '../controllers/reporting_emp_details_controller.dart';

class ReportingEmpDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportingEmpDetailsController>(() => ReportingEmpDetailsController());
  }
}