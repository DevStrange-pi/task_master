import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_url.dart';
import '../../constants/strings.dart';
import '../../models/all_tasks_response_model.dart';
import '../../network/http_req.dart';
import '../../styles/colors.dart';
import '../../utilities/circular_loader.dart';
import '../../utilities/utilities.dart';

class EmpTaskListPageController extends GetxController {
  RxList<Task>? tasksList = <Task>[].obs;
  List<Task>? tasks = <Task>[].obs;
  String? title;
  String fromPage = "";

  RxList<String> countdowns = <String>[].obs;
  static RxBool taskDeleted = false.obs;
  Timer? _timer;

  Map<String, Color> taskStatusColor = {
    "pending": AppColors.amber,
    "completed": AppColors.lightGreen,
    "expired": AppColors.lightRed,
    "requested": AppColors.white,
  };

  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    if (Get.arguments.length > 2) {
      fromPage = Get.arguments[2];
    }
    title = Get.arguments[1] ?? "";
    tasksList!.value = Get.arguments[0] ?? <Task>[];
    prefs = await SharedPreferences.getInstance();
    startCountdowns();
    if (fromPage == "fromReporting") {
      await onRefresh();
    }
  }

  void startCountdowns() {
    updateCountdowns();
    _timer?.cancel();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => updateCountdowns());
  }

  void updateCountdowns() {
    if (tasksList == null) return;
    final now = DateTime.now().toUtc();
    final List<String> updated = [];
    for (var task in tasksList!) {
      if (task.status == "pending" && task.deadline != null) {
        Duration diff;
        if (task.type!.toLowerCase() == "daily") {
          // Set deadline to today at 23:59:59
          final nowLocal = DateTime.now();
          final todayEnd =
              DateTime(nowLocal.year, nowLocal.month, nowLocal.day, 23, 59, 59);
          diff = todayEnd.difference(nowLocal);
        } else {
          final deadline = task.deadline!.toUtc();
          diff = deadline.difference(now);
        }
        if (diff.isNegative) {
          diff = Duration.zero;
          updated.add("");
        } else {
          int days = diff.inDays;
          int hours = diff.inHours % 24;
          int minutes = diff.inMinutes % 60;
          int seconds = diff.inSeconds % 60;
          updated.add("${days}D ${hours}h ${minutes}m ${seconds}s");
        }
      } else {
        updated.add("");
      }
    }
    countdowns.value = updated;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<bool> getEmployeeMyTasks() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp =
        await HttpReq.getApi(apiUrl: AppUrl().employeeTasks, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      AllTasksResponseModel tasksDetails =
          AllTasksResponseModel.fromJson(respBody);
      tasks = tasksDetails.data?.tasks ?? <Task>[];
      circularLoader.hideCircularLoader();
      return true;
      // myBotToast( respBody["message"]);
    } else {
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
      // syllabusModelList.value = syllabusData.data!;
      return false;
    }
  }

  Future<void> deleteTask(BuildContext context, int taskId) async {
    debugPrint("Task id : $taskId");
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );

    if (result != null && result) {
      circularLoader.showCircularLoader();
      String token = prefs!.getString(SpString.token)!;
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var resp = await HttpReq.deleteApi(
          apiUrl: AppUrl().deleteEmployeeTask(taskId), headers: headers);
      var respBody = json.decode(resp!.body);
      if (resp.statusCode == 200) {
        // Call get API again
        await onRefresh();
        taskDeleted.value = true;
      } else {
        circularLoader.hideCircularLoader();
        myBotToast(respBody["message"]);
      }
    }
  }

  Future<void> onRefresh() async {
    List<Task> filteredTasks = [];
    print("Title: $title, From Page: $fromPage");
    if (await getEmployeeMyTasks()) {
      if (fromPage == "fromReporting") {
        filteredTasks = tasks!
            .where((task) =>
                task.status.toString() == title!.toLowerCase().split(" ").first)
            .toList();
      } else {
        // due to weekly, monthly, yearly page in between
        filteredTasks = tasks!
            .where((task) =>
                task.type.toString() == title!.toLowerCase().split(" ").first)
            .toList();
      }
      tasksList!.assignAll(filteredTasks);
      updateCountdowns();
    } else {
      myBotToast("No Task Found", duration: 2);
    }
  }
}
