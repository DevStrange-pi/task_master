import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_master/models/get_employee_report_response_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../models/all_tasks_response_model.dart';
import '../network/http_req.dart';
import '../routes/app_routes.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';

class ReportingEmpDetailsController extends GetxController {
  RxString employeeName = "".obs;
  int? employeeId;
  Rx<LatestLocation?> latestLocation = LatestLocation(
          latitude: "0.0",
          longitude: "0.0",
          name: "No Location Found",
          address: "")
      .obs;
  Rx<EmployeeReportData> reportData = EmployeeReportData().obs;
  RxList<Map<String, String>?>? tasksCountList = <Map<String, String>>[].obs;
  List<Task> filteredTasks = <Task>[].obs;

  TextEditingController fromDateCont = TextEditingController();
  TextEditingController toDateCont = TextEditingController();
  String originalFromDate = "";
  String originalToDate = "";

  RxBool isDatePickerVisible = true.obs;
  bool flag = false;

  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    employeeName.value = Get.arguments[0];
    employeeId = Get.arguments[1];
    latestLocation.value = Get.arguments[2];

    DateTime today = DateTime.now();
    originalToDate = DateFormat('dd MMMM yyyy').format(today);
    toDateCont.text = originalToDate;

    DateTime oneMonthAgo = today.subtract(const Duration(days: 30));
    originalFromDate = DateFormat('dd MMMM yyyy').format(oneMonthAgo);
    fromDateCont.text = originalFromDate;
    await initNotifications();
    await getEmployeeReport(
        fromDate: fromDateCont.text,
        toDate: toDateCont.text,
        employeeId: employeeId!);
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: DarwinInitializationSettings());
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          OpenFile.open(response.payload!);
        }
      },
    );
  }

  void onTapCalendarIcon() {
    isDatePickerVisible.value = !isDatePickerVisible.value;
  }

  void onTapLocationIcon() async {
    final lat = latestLocation.value?.latitude;
    final lng = latestLocation.value?.longitude;
    if (lat != null && lng != null && lat != "0.0" && lng != "0.0") {
      final url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        myBotToast('Could not open Google Maps');
      }
    } else {
      myBotToast('No valid location found');
    }
  }

  void onTapExcelSheetIcon() async {
    await downloadTaskReportExcel(
        fromDate: fromDateCont.text,
        toDate: toDateCont.text,
        employeeId: employeeId!);
  }

  void onTapDone() async {
    await getEmployeeReport(
        fromDate: fromDateCont.text,
        toDate: toDateCont.text,
        employeeId: employeeId!);
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

  Future<void> downloadTaskReportExcel({
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
      "Accept":
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    };

    // Parse and format dates as yyyy-MM-dd
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

    final url = AppUrl().getTaskReportUrl(
      fromDate: parsedFromDate,
      toDate: parsedToDate,
      employeeId: employeeId,
    );

    final response = await HttpReq.getApi(apiUrl: url, headers: headers);

    if (response != null && response.statusCode == 200) {
      try {
        // Use Documents directory for iOS, Downloads for Android
        Directory? directory;
        if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
        }
        final filePath =
            "${directory.path}/task_report_${DateTime.now().millisecondsSinceEpoch}.xlsx";
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);

        circularLoader.hideCircularLoader();
        debugPrint("Excel downloaded: $filePath");
        myBotToast("Excel downloaded: $filePath");

        // Show local notification
        await flutterLocalNotificationsPlugin.show(
          0,
          'Excel Downloaded',
          'Tap to open the file',
          const NotificationDetails(
            iOS: DarwinNotificationDetails(),
            android: AndroidNotificationDetails(
              'download_channel',
              'Downloads',
              channelDescription: 'Notification channel for downloads',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: filePath,
        );
      } catch (e) {
        circularLoader.hideCircularLoader();
        myBotToast("Failed to save file: $e");
      }
    } else {
      circularLoader.hideCircularLoader();
      myBotToast("Failed to download report");
    }
  }

  void onBackPressed() {
    Get.back(result: flag);
  }

  void onTapMenuTile(String title) async {
    String newTitle = title.split(" ").first;
    if (reportData.value.tasks != null && reportData.value.tasks!.isNotEmpty) {
      filteredTasks = reportData.value.tasks!
          .where((task) => task.status.toString() == newTitle.toLowerCase())
          .toList();
      if (filteredTasks.isNotEmpty) {
        flag = await Get.toNamed(
          AppRoutes.taskListPage,
          arguments: [filteredTasks, title, "fromReporting"],
        );
        if (flag) {
          await getEmployeeReport(
              fromDate: fromDateCont.text,
              toDate: toDateCont.text,
              employeeId: employeeId!);
        } else {}
      } else {
        myBotToast("No Task Found", duration: 2);
      }
    } else {
      myBotToast("No Task Found", duration: 2);
    }
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
}
