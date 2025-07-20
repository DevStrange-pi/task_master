import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../models/all_tasks_response_model.dart';
import '../models/employee/emp_task_updated_response_model.dart';
import '../models/get_employee_report_response_model.dart';
import '../network/http_req.dart';
import '../routes/app_routes.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';
import '../widgets/speed_textfield.dart';

class TaskListController extends GetxController {
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  List<Task> tasks = <Task>[];
  RxList<Task> tasksList = <Task>[].obs;
  RxList<List<String>> employeeNameList = <List<String>>[].obs;
  String? title;
  String fromPage = "";
  TextEditingController deadlineDateCont = TextEditingController();
  RxBool isLoading = false.obs;
  Rx<EmployeeReportData> reportData = EmployeeReportData().obs;
  RxList<Map<String, String>?>? tasksCountList = <Map<String, String>>[].obs;

  static RxBool taskDeleted = false.obs;
  RxList<String> countdowns = <String>[].obs;
  Timer? _timer;

  String fromDate = "";
  String toDate = "";
  int employeeId = 0;

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    fromPage = Get.arguments[2];
    title = Get.arguments[1] ?? "";
    tasksList.value = Get.arguments[0] ?? <Task>[];
    createEmployeeNameList();
    if (fromPage == "fromReporting") {
      fromDate = Get.arguments[3] ?? "";
      toDate = Get.arguments[4] ?? "";
      employeeId = Get.arguments[5] ?? 0;
    }
    prefs = await SharedPreferences.getInstance();
    startCountdowns();
    if (fromPage == "fromReporting") {
      fromReportingRefreshCall();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startCountdowns() {
    updateCountdowns();
    _timer?.cancel();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => updateCountdowns());
  }

  void updateCountdowns() {
    if (tasksList.isEmpty) return;
    final now = DateTime.now().toUtc();
    final List<String> updated = [];
    for (var task in tasksList) {
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

  void reassignCallback(BuildContext context, int taskId) async {
    debugPrint("Task id : $taskId");
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to reassign this task?'),
        actions: [
          TextButton(
            onPressed: () {
              deadlineDateCont.clear();
              Get.back(result: false);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              deadlineDateCont.clear();
              Get.back(result: true);
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );

    if (result == true) {
      final result1 = await showDialog<bool>(
        context: Get.context!,
        builder: (context) => AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          titlePadding: const EdgeInsets.fromLTRB(18, 24, 0, 10),
          title: const Text('Select the Deadline Date'),
          content: SizedBox(
            height: 90,
            child: SpeedTextfield(
              isPasswordHidden: false,
              needSuffixIcon: true,
              suffixIconData: Icons.calendar_month_sharp,
              labelText: "Deadline Date Time",
              hintText: "Select here...",
              textEditingController: deadlineDateCont,
              isDateTimePicker: true,
              fieldOnTap: () {
                showDateTimePicker();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                deadlineDateCont.clear();
                Get.back(result: false);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: true);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (result1 == true) {
        await updateAdminTaskDetails("pending", deadlineDateCont.text, taskId);
      }
    }
  }

  Future<void> showDateTimePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: deadlineDateCont.text.isNotEmpty
          ? DateFormat("d MMMM yyyy").parse(deadlineDateCont.text)
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final formattedDateTime =
            DateFormat('dd MMMM yyyy, hh:mm a').format(finalDateTime);

        deadlineDateCont.text = formattedDateTime;
      }
    } else {
      if (deadlineDateCont.text.isEmpty) {
        deadlineDateCont.clear();
      }
    }

    FocusScope.of(Get.context!).unfocus();
  }

  Future<void> updateAdminTaskDetails(
      String status, String deadline, int taskId) async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    try {
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      String parsedDeadlineDate = "";
      DateTime tempDatetime = DateFormat("d MMMM yyyy, h:mm a").parse(deadline);
      parsedDeadlineDate =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDatetime);
      // .toIso8601String()
      // .split('T')
      // .first;
      var resp = await HttpReq.patchApi(
          apiUrl: AppUrl().adminUpdateTask(taskId),
          headers: headers,
          body: {
            // "name": name,
            // "description": desc,
            // "type": type,
            "status": status,
            "deadline": parsedDeadlineDate,
          });
      var respBody = json.decode(resp!.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        EmpTaskUpdatedResponseModel taskDetails =
            EmpTaskUpdatedResponseModel.fromJson(respBody);
        myBotToast(taskDetails.message ?? "");
        // myBotToast('Success \nTask reassigned!');
        //
        circularLoader.hideCircularLoader();
        if (fromPage == "fromReporting") {
          Get.back(result: true);
        } else {
          // Get.back();
          // Get.back(result: true);
          Get.offAllNamed(AppRoutes.homePage,
              arguments: {"fromUpdateStatus": true});
        }
      } else {
        circularLoader.hideCircularLoader();
        myBotToast(respBody["message"]);
      }
    } catch (e) {
      circularLoader.hideCircularLoader();
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
          apiUrl: AppUrl().deleteTask(taskId), headers: headers);
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
    if (fromPage == "fromReporting") {
      fromReportingRefreshCall();
    } else {
      String titleToCompare = title!.toLowerCase().split(" ").first;
      if (await getAllTasks()) {
        List<Task> filteredTasks = tasks
            .where((task) => task.status.toString() == titleToCompare)
            .toList();
        tasksList.assignAll(filteredTasks);
        updateCountdowns();
        createEmployeeNameList();
      } else {
        myBotToast("No Task Found", duration: 2);
      }
    }
  }

  void fromReportingRefreshCall() async {
    String titleToCompare = title!.toLowerCase().split(" ").first;
    if (await getEmployeeReport(
        fromDate: fromDate, toDate: toDate, employeeId: employeeId)) {
      List<Task> filteredTasks = reportData.value.tasks!
          .where((task) => task.status.toString() == titleToCompare)
          .toList();
      tasksList.assignAll(filteredTasks);
      updateCountdowns();
      createEmployeeNameList();
    } else {
      myBotToast("No Task Found", duration: 2);
    }
  }

  Future<bool> getEmployeeReport({
    required String fromDate,
    required String toDate,
    required int employeeId,
  }) async {
    CircularLoader circularLoader = Get.find<CircularLoader>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    circularLoader.showCircularLoader();

    String token = prefs.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    String parsedFromDate = "";
    String parsedToDate = "";
    try {
      parsedFromDate = DateFormat('dd MMMM yyyy')
          .parse(fromDate)
          .toIso8601String()
          .split('T')
          .first;
    } catch (_) {}
    try {
      parsedToDate = DateFormat('dd MMMM yyyy')
          .parse(toDate)
          .toIso8601String()
          .split('T')
          .first;
    } catch (_) {}

    final url = AppUrl().getEmployeeReportUrl(
      fromDate: parsedFromDate,
      toDate: parsedToDate,
      employeeId: employeeId,
    );

    var resp = await HttpReq.getApi(apiUrl: url, headers: headers);
    var respBody = json.decode(resp!.body);

    if (resp.statusCode == 200) {
      GettEmployeeReportResponseModel employeeReportResp =
          GettEmployeeReportResponseModel.fromJson(respBody);
      reportData.value = employeeReportResp.data ?? EmployeeReportData();
      tasksCountList!.assignAll(convertTaskMap(reportData.value.toJson()));
      circularLoader.hideCircularLoader();
      return true;
    } else {
      circularLoader.hideCircularLoader();
      myBotToast("Something went wrong");
      return false;
    }
  }

  List<Map<String, String>?> convertTaskMap(Map<String, dynamic> taskMap) {
    if (taskMap.isEmpty) {
      return [];
    }
    return taskMap.entries
        .where((entry) => entry.key.contains("_tasks"))
        .map((entry) {
      final name = entry.key
          .split('_')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');

      return {
        "name": name,
        "count": entry.value.toString(),
      };
    }).toList();
  }

  Future<bool> getAllTasks() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp =
        await HttpReq.getApi(apiUrl: AppUrl().allTasks, headers: headers);
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

  void createEmployeeNameList() {
    employeeNameList.value = tasksList.map((task) {
      // If employees is not null and not empty, extract their names
      if (task.employees != null && task.employees!.isNotEmpty) {
        return task.employees!.map((e) => e.name ?? '').toList();
      } else {
        return <String>[]; // Empty list if no employees
      }
    }).toList();
  }
}
