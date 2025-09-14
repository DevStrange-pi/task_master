import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_url.dart';
import '../../constants/strings.dart';
import '../../models/all_tasks_response_model.dart';
import '../../models/get_employee_report_response_model.dart';
import '../../models/get_profile_response_model.dart';
import '../../network/http_req.dart';
import '../../routes/app_routes.dart';
import '../../utilities/circular_loader.dart';
import '../../utilities/utilities.dart';

class EmpMyProfilePageController extends GetxController {
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  Employee profileDetails = Employee();
  RxList<Map<String, String>> profileData = <Map<String, String>>[].obs;
  Rx<EmployeeReportData> reportData = EmployeeReportData().obs;
  RxList<Map<String, String>?>? tasksCountList = <Map<String, String>>[].obs;
  List<Task> filteredTasks = <Task>[].obs;
  bool flag = false;

  RxBool isDatePickerVisible = true.obs;
  TextEditingController fromDateCont = TextEditingController();
  TextEditingController toDateCont = TextEditingController();
  String originalFromDate = "";
  String originalToDate = "";

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    await getProfile();
    //
    DateTime today = DateTime.now();
    originalToDate = DateFormat('dd MMMM yyyy').format(today);
    toDateCont.text = originalToDate;

    DateTime oneMonthAgo = today.subtract(const Duration(days: 30));
    originalFromDate = DateFormat('dd MMMM yyyy').format(oneMonthAgo);
    fromDateCont.text = originalFromDate;
    // await initNotifications();
    await getEmployeeReport(
        fromDate: fromDateCont.text, toDate: toDateCont.text);
  }

  void onTapCalendarIcon() {
    isDatePickerVisible.value = !isDatePickerVisible.value;
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

  Future<void> showFromDateTimePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateFormat("d MMMM yyyy").parse(originalFromDate),
      // DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final formattedDateTime = DateFormat('dd MMMM yyyy').format(selectedDate);

      fromDateCont.text = formattedDateTime;
      originalFromDate = formattedDateTime;
    }
    // if (selectedDate == null)
    else {
      // fromDateCont.clear();
      fromDateCont.text = originalFromDate;
    }
    FocusScope.of(Get.context!).unfocus();
  }

  Future<void> showToDateTimePicker() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateFormat("d MMMM yyyy").parse(originalToDate),
        // DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
        // DateTime(2100),
        );

    if (selectedDate != null) {
      final formattedDateTime = DateFormat('dd MMMM yyyy').format(selectedDate);
      toDateCont.text = formattedDateTime;
      originalToDate = formattedDateTime;
    }
    // if (selectedDate == null)
    else {
      // toDateCont.clear();
      toDateCont.text = originalToDate;
    }
    FocusScope.of(Get.context!).unfocus();
  }

  void onTapDone() async {
    await getEmployeeReport(
        fromDate: fromDateCont.text, toDate: toDateCont.text);
  }

  void onTapMenuTile(String title) async {
    String newTitle = title.split(" ").first;
    if (reportData.value.tasks != null && reportData.value.tasks!.isNotEmpty) {
      filteredTasks = reportData.value.tasks!
          .where((task) => task.status.toString() == newTitle.toLowerCase())
          .toList();
      if (filteredTasks.isNotEmpty) {
        final result = await Get.toNamed(
          AppRoutes.employeeTaskListPage,
          arguments: [filteredTasks, title, "fromReporting"],
        );
        flag = result ?? false;
        if (flag) {
          await getEmployeeReport(
            fromDate: fromDateCont.text,
            toDate: toDateCont.text,
          );
        }
      } else {
        myBotToast("No Task Found", duration: 2);
      }
    } else {
      myBotToast("No Task Found", duration: 2);
    }
  }

  Future<bool> getEmployeeReport({
    required String fromDate,
    required String toDate,
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

    final url = AppUrl().getEmployeeReportUrlForEmployee(
      fromDate: parsedFromDate,
      toDate: parsedToDate,
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

  String formatKey(String key) {
    return key
        .split('_')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  Future<bool> getProfile() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp =
        await HttpReq.getApi(apiUrl: AppUrl().getProfile, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      GetProfileResponseModel profileResponseModel =
          GetProfileResponseModel.fromJson(respBody);
      profileDetails = profileResponseModel.data?.employee ?? Employee();
      createProfileData();
      circularLoader.hideCircularLoader();
      return true;
    } else {
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
      return false;
    }
  }

  void createProfileData() {
    profileData.value = profileDetails
        .toJson()
        .entries
        .where((entry) =>
            entry.key != "image_path" &&
            entry.key != "pivot" &&
            entry.key != "device_token" &&
            entry.key != "status" &&
            entry.key != "assigned_by"
            )
        .map((entry) {
      final value = entry.value;
      final valueStr = value?.toString() ?? '';

      String displayValue;
      if (value == null || valueStr.isEmpty) {
        displayValue = '-';
      } else if (value is DateTime) {
        displayValue = formatDateTime(value);
      } else if (value is String && isIsoDateTime(value)) {
        displayValue = formatDateTime(DateTime.parse(value));
      } else {
        displayValue = valueStr;
      }

      return {
        "label": entry.key.toLowerCase().contains('contact_number')
            ? 'Contact'
            : formatKey(entry.key),
        "value": displayValue,
      };
    }).toList();
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final localDateTime = dateTime.toLocal();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(localDateTime);
  }

  bool isIsoDateTime(String input) {
    final isoRegex = RegExp(
      r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z?$',
    );
    return isoRegex.hasMatch(input);
  }

  void onBackPressed() {
    Get.back(result: true
        // flag
        );
  }

  Future<void> onRefresh() async {
    initAsync();
  }
}
