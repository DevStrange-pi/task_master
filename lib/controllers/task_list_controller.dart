import 'package:get/get.dart';

import '../models/all_tasks_response_model.dart';

class TaskListController extends GetxController{

  List<Task>? tasksList = <Task>[].obs;
  String? title;
  @override
  void onInit() {
    title = Get.arguments[1] ?? "";
    tasksList = Get.arguments[0] ?? <Task>[];
    super.onInit();
  }

}