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

  String formatDateTime(DateTime dt) {
    // Remove trailing 'Z' if present, ensure 6 digits for microseconds
    String s = dt.toString();
    if (s.endsWith('Z')) {
      s = s.substring(0, s.length - 1);
    }
    // Ensure microseconds are 6 digits
    if (dt.microsecond == 0 && !s.contains('.')) {
      s += '.000000';
    } else if (dt.microsecond != 0 && s.split('.').last.length < 6) {
      var parts = s.split('.');
      s = '${parts[0]}.${parts[1].padRight(6, '0')}';
    } else {
      String main = "${dt.year.toString().padLeft(4, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.day.toString().padLeft(2, '0')} "
          "${dt.hour.toString().padLeft(2, '0')}:"
          "${dt.minute.toString().padLeft(2, '0')}:"
          "${dt.second.toString().padLeft(2, '0')}";

      // Get microseconds as 6 digits
      String micro = dt.microsecond.toString().padLeft(6, '0');
      return "$main.$micro";
    }
    return s;
  }

  void updateCountdowns() {
    if (tasksList == null) return;
    final now = DateTime.now();
    // final now = DateTime.now();
    final List<String> updated = [];
    for (var task in tasksList!) {
      if (task.status == "pending" && task.deadline != null) {
        // Duration diff;
        int diffSeconds;
        if (task.type!.toLowerCase() == "daily") {
          // Set deadline to today at 23:59:59
          final nowLocal = DateTime.now();
          final todayEnd =
              DateTime(nowLocal.year, nowLocal.month, nowLocal.day, 23, 59, 59);
          diffSeconds = todayEnd.millisecondsSinceEpoch ~/ 1000 -
              nowLocal.millisecondsSinceEpoch ~/ 1000;
        } else {
          final deadline = task.deadline!;
          // Format deadline for display
          String formattedDeadline = formatDateTime(deadline);
          final newDeadline = DateTime.parse(formattedDeadline);
          // print("\n\n");
          // print('Deadline (formatted): $formattedDeadline');
          diffSeconds = newDeadline.millisecondsSinceEpoch ~/ 1000 -
              now.millisecondsSinceEpoch ~/ 1000;
        }
        if (diffSeconds < 0) {
          diffSeconds = 0;
          updated.add("");
        } else {
          int days = diffSeconds ~/ (24 * 3600);
          int hours = (diffSeconds % (24 * 3600)) ~/ 3600;
          int minutes = (diffSeconds % 3600) ~/ 60;
          int seconds = diffSeconds % 60;
          updated.add("${days}D ${hours}h ${minutes}m ${seconds}s");
          // print('Now: $now');
          // print('diffSeconds: $diffSeconds');
          // print('days: $days, hours: $hours, minutes: $minutes, seconds: $seconds');
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
