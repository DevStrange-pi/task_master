import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/all_tasks_response_model.dart';
import '../../models/employee/emp_dashboard_response_model.dart';
import '../../styles/colors.dart';
import '../../utilities/circular_loader.dart';
import '../../utilities/utilities.dart';
import '../../network/http_req.dart';
import '../../constants/app_url.dart';
import '../../constants/strings.dart';

class EmpCreatedAssignedPageController extends GetxController {
  RxList<Task>? tasksList = <Task>[].obs;
  RxList<List<String>> employeeNameList = <List<String>>[].obs;

  RxList<String> countdowns = <String>[].obs;
  Map<String, Color> taskStatusColor = {
    "pending": AppColors.amber,
    "completed": AppColors.lightGreen,
    "expired": AppColors.lightRed,
    "requested": AppColors.white,
  };
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    initAsync();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    await onRefresh();
    startCountdowns();
  }

  Future<void> onRefresh() async {
    circularLoader.showCircularLoader();
    try {
      String token = prefs!.getString(SpString.token)!;
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var resp = await HttpReq.getApi(apiUrl: AppUrl().employeeHome, headers: headers);
      var respBody = json.decode(resp!.body);
      if (resp.statusCode == 200) {
        EmpDashboardResponseModel dashboard = EmpDashboardResponseModel.fromJson(respBody);
        // Use createdAndAssigned list from EmpData
        tasksList!.assignAll(dashboard.data?.createdAndAssigned ?? <Task>[]);
        updateCountdowns();
        createEmployeeNameList();
      } else {
        myBotToast(respBody["message"]);
      }
    } catch (e) {
      myBotToast("Failed to load tasks");
    } finally {
      circularLoader.hideCircularLoader();
    }
  }

  void createEmployeeNameList() {
    employeeNameList.value = tasksList!.map((task) {
      // If employees is not null and not empty, extract their names
      if (task.employees != null && task.employees!.isNotEmpty) {
        return task.employees!.map((e) => e.name ?? '').toList();
      } else {
        return <String>[]; // Empty list if no employees
      }
    }).toList();
  }

  void startCountdowns() {
    updateCountdowns();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => updateCountdowns());
  }

  void updateCountdowns() {
    if (tasksList == null) return;
    final now = DateTime.now();
    final List<String> updated = [];
    for (var task in tasksList!) {
      if (task.status == "pending" && task.deadline != null) {
        int diffSeconds;
        try {
          diffSeconds = task.deadline!.difference(now).inSeconds;
        } catch (_) {
          diffSeconds = 0;
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
        }
      } else {
        updated.add("");
      }
    }
    countdowns.value = updated;
  }

  Future<void> deleteTask(BuildContext context, int taskId) async {
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
    if (result == true) {
      circularLoader.showCircularLoader();
      try {
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
          await onRefresh();
        } else {
          myBotToast(respBody["message"]);
        }
      } catch (e) {
        myBotToast("Failed to delete task");
      } finally {
        circularLoader.hideCircularLoader();
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

