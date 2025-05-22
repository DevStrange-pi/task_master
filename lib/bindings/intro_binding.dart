import 'package:get/get.dart';

import '../controllers/intro_page_controller.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroPageController>(() => IntroPageController());
  }
}