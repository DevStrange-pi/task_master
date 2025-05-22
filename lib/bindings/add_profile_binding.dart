import 'package:get/get.dart';
import 'package:task_master/controllers/add_profile_controller.dart';

class AddProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProfileController>(() => AddProfileController());
  }
}