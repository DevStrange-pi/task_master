import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../models/all_tasks_response_model.dart';
import '../models/employee/emp_task_updated_response_model.dart';
import '../network/http_req.dart';
import '../routes/app_routes.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';
import '../widgets/speed_textfield.dart';

class TaskListController extends GetxController {
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  List<Task>? tasks = <Task>[].obs;
  List<Task>? tasksList = <Task>[].obs;
  String? title;
  String fromPage = "";
  TextEditingController deadlineDateCont = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    fromPage = Get.arguments[2];
    title = Get.arguments[1] ?? "";
    tasksList = Get.arguments[0] ?? <Task>[];
    prefs = await SharedPreferences.getInstance();
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

  Future<void> deleteTask(int taskId) async {
    print("Task id : $taskId");
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp =
        await HttpReq.deleteApi(apiUrl: AppUrl().deleteTask(taskId), headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      // Call get API again
      await getAllTasks();
    } else {
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
    }
  }

  Future<void> onRefresh() async {
    if (await getAllTasks()) {
      List<Task> filteredTasks = tasks!
          .where((task) => task.status.toString() == title!.toLowerCase().split(" ").first)
          .toList();
      tasksList!.assignAll(filteredTasks);
    } else {
      myBotToast("No Task Found", duration: 2);
    }
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
}
