import 'package:get/get.dart';

class TaskListController extends GetxController{

  List<Map<String,dynamic>>? tasksList;
  @override
  void onInit() {
    tasksList = Get.arguments ?? [];
    super.onInit();
  }

}