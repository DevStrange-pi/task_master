import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/models/create_task_response_model.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
// import '../models/get_employees_response_model.dart';
// import '../models/task_details_response_model.dart';
import '../models/all_tasks_response_model.dart';
import '../models/get_employees_response_model.dart';
import '../network/http_req.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';

class AddTaskController extends GetxController {
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  TextEditingController dateCont = TextEditingController();

  List<String> taskTypeDropdownOptions = [
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly",
    "Once"
  ];
  String taskTypeSelected = "Weekly";
  final RxList<DropdownItem<String>> assignDropdownOptions =
      <DropdownItem<String>>[].obs;
  List<DropdownItem<String>> assignSelected = [];
  List<int> selectedIds = [];
  final multiSelectController = MultiSelectController<String>();
  final RxList<Employee> employeeList = <Employee>[].obs;
  final RxBool canPop = true.obs;

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    await getEmployees();
    multiSelectController.addListener(() {
      if (multiSelectController.isOpen) {
        canPop.value = false;
      } else {
        canPop.value = true;
      }
    });
  }

  @override
  void onClose() {
    assignDropdownOptions.clear();
    assignSelected.clear();
    super.onClose();
  }

  void createDropdownOptions() {
    assignDropdownOptions.clear();
    for (var employee in employeeList) {
      assignDropdownOptions.add(DropdownItem(
        label: employee.name ?? "",
        value: employee.name ?? "",
      ));
    }
    assignDropdownOptions.refresh();
    // ignore: invalid_use_of_protected_member
    multiSelectController.addItems(assignDropdownOptions.value);
  }

  void createSelectedDropdownOptions(List<String?> names) {
    assignSelected.clear();
    for (var name in names) {
      assignSelected.add(DropdownItem(
        label: name ?? "",
        value: name ?? "",
      ));
    }
  }

  Future<bool> getEmployees() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp =
        await HttpReq.getApi(apiUrl: AppUrl().getEmployees, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      GetEmployeesResponseModel employeeListResp =
          GetEmployeesResponseModel.fromJson(respBody);
      employeeList.value = employeeListResp.data?.employees ?? [];
      createDropdownOptions();
      circularLoader.hideCircularLoader();
      return true;
    } else {
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
      return false;
    }
  }

  Future<bool> submitTaskDetails(String name, String desc, String type,
      String deadline, List<int> employeeIds) async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    try {
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var resp = await HttpReq.postApi(
          apiUrl: AppUrl().addTask,
          headers: headers,
          body: {
            "name": name,
            "description": desc,
            "type": type,
            "deadline": deadline,
            "employee_ids": employeeIds
          });
      var respBody = json.decode(resp!.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        CreateTaskResponseModel taskCreatedResp =
            CreateTaskResponseModel.fromJson(respBody);
        myBotToast(taskCreatedResp.message ?? "");
        Get.back(result: true);
        circularLoader.hideCircularLoader();
        return true;
      } else {
        circularLoader.hideCircularLoader();
        myBotToast(respBody["message"]);
        return false;
      }
    } catch (e) {
      circularLoader.hideCircularLoader();
      return false;
    }
  }

  void setDeadlineToTodayMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day, 0, 0);
    dateCont.text = DateFormat('dd MMMM yyyy, hh:mm a').format(midnight);
  }

  Future<void> showDateTimePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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

        dateCont.text = formattedDateTime;
      }
    }
    if (selectedDate == null) {
      dateCont.clear();
    }
    FocusScope.of(Get.context!).unfocus();
  }

  String convertToApiDateFormat(String input) {
    final dateTime = DateFormat('dd MMMM yyyy, hh:mm a').parse(input);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  void onSubmitPressed() async {
    selectedIds = assignSelected
        .map((selected) => employeeList
            .firstWhereOrNull(
              (emp) => emp.name == selected.label,
            )
            ?.id)
        .whereType<int>()
        .toList();
    if (taskNameController.text.isEmpty) {
      myBotToast("Please enter Task Name");
      return;
    }
    if (descController.text.isEmpty) {
      myBotToast("Please enter Task description");
      return;
    }
    if (dateCont.text.isEmpty) {
      myBotToast("Please enter Deadline Date & time");
      return;
    }
    // ignore: invalid_use_of_protected_member

    if (selectedIds.isEmpty) {
      myBotToast("Please provide Assigned Employee(s)");
      return;
    }
    await submitTaskDetails(
        taskNameController.text,
        descController.text,
        taskTypeSelected.toString().toLowerCase(),
        convertToApiDateFormat(dateCont.text),
        selectedIds);
  }
}
