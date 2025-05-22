import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/all_tasks_response_model.dart';
import '../../styles/colors.dart';

class EmpTaskListPageController extends GetxController {
  RxList<Task>? tasksList = <Task>[].obs;
  String? title;
  String fromPage = "";

  Map<String, Color> taskStatusColor = {
    "pending": AppColors.amber,
    "completed": AppColors.lightGreen,
    "expired": AppColors.lightRed,
    "requested": AppColors.white,
  };

  @override
  void onInit() {
    if (Get.arguments.length > 2) {
      fromPage = Get.arguments[2];
    }
    title = Get.arguments[1] ?? "";
    tasksList!.value = Get.arguments[0] ?? <Task>[];

    super.onInit();
  }
}
