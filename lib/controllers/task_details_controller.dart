import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/models/get_employees_response_model.dart';
import 'package:task_master/routes/app_routes.dart';
// import 'package:task_master/models/task_details_response_model.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../models/all_tasks_response_model.dart';
import '../models/task_details_response_model.dart';
import '../network/http_req.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';

class TaskDetailsController extends GetxController {
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  Rx<Task>? task = Task().obs;
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
  RxString taskTypeSelected = "Daily".obs;
  List<String> taskStatus = ["Pending", "Completed", "Expired", "Requested"];
  RxString taskStatusSelected = "Pending".obs;
  final RxList<DropdownItem<String>> assignDropdownOptions =
      <DropdownItem<String>>[].obs;
  List<DropdownItem<String>> assignSelected = [];
  List<int> selectedIds = [];
  final multiSelectController = MultiSelectController<String>();
  final RxList<Employee> employeeList = <Employee>[].obs;
  final RxBool canPop = true.obs;

  final String taskId = Get.arguments["taskId"];
  final bool statusFlag =
      Get.arguments["taskStatus"] == "completed" ? false : true;
  final RxList<String> photoBase64List = <String>[].obs;

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    await Future.wait([
      getTask(),
      getEmployees(),
    ]);
    taskStatusSelected.value =
        Get.arguments["taskStatus"]?.toString().capitalizeFirst ?? "Pending";
    createDropdownOptions();
    getDefaultValues();
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
    multiSelectController.clearAll();
    multiSelectController.items.clear();
    assignDropdownOptions.clear();
    createAssignSelected();
    for (var employee in employeeList) {
      int indx = assignSelected
          .indexWhere((element) => element.value == employee.name);
      if (indx != -1) {
        assignDropdownOptions.add(DropdownItem(
          label: employee.name ?? "",
          value: employee.name ?? "",
          selected: true,
        ));
      } else {
        assignDropdownOptions.add(DropdownItem(
          label: employee.name ?? "",
          value: employee.name ?? "",
        ));
      }
    }
    assignDropdownOptions.refresh();
    Future.microtask(() {
      // ignore: invalid_use_of_protected_member
      multiSelectController.addItems(assignDropdownOptions.value);
    });
  }

  void createAssignSelected() {
    if (task?.value == null || task?.value.employees == null) {
      return;
    }
    assignSelected = task!.value.employees!
        .map((employee) => DropdownItem(
              label: employee.name ?? "",
              value: employee.name ?? "",
              selected: true,
            ))
        .toList();
  }

  void getDefaultValues() {
    taskNameController.text = task?.value.name ?? "";
    descController.text = task?.value.description ?? "";
    if (task?.value.deadline != null) {
      final DateTime dateTime = task!.value.deadline!;
      final formattedDateTime =
          DateFormat('dd MMMM yyyy, hh:mm a').format(dateTime);
      dateCont.text = formattedDateTime;
    } else {
      dateCont.text = "";
    }
    taskTypeSelected.value = task?.value.type?.capitalizeFirst ?? "";
  }

  Future<bool> getTask() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp = await HttpReq.getApi(
        apiUrl: AppUrl().getTaskDetails(taskId), headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      TaskDetailsResponseModel taskDetails =
          TaskDetailsResponseModel.fromJson(respBody);
      task?.value = taskDetails.data?.task ?? Task();
      photoBase64List.clear();
      if (task?.value.photos != null) {
        photoBase64List.assignAll(task!.value.photos!.map((e) => e.toString()));
      }
      circularLoader.hideCircularLoader();
      return true;
    } else {
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
      return false;
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
      circularLoader.hideCircularLoader();
      return true;
    } else {
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
      return false;
    }
  }

  void storeSelectedValues(List<String> val) {
    assignSelected.clear();
    for (var element in val) {
      assignSelected.add(DropdownItem(
        label: element,
        value: element,
        selected: true,
      ));
    }
  }

  Future<void> showDateTimePicker() async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
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
    FocusScope.of(Get.context!).unfocus();
  }

  Future<bool> updateTaskDetails(String name, String desc, String type,
      String status, String deadline, List<int> employeeIds) async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    try {
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var resp = await HttpReq.patchApi(
          apiUrl: AppUrl().updateTaskDetails(taskId),
          headers: headers,
          body: {
            "name": name,
            "description": desc,
            "type": type,
            "status": status,
            "deadline": deadline,
            "employee_ids": employeeIds
          });
      var respBody = json.decode(resp!.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        TaskDetailsResponseModel taskDetails =
            TaskDetailsResponseModel.fromJson(respBody);
        myBotToast(taskDetails.message ?? "");
        // Get.back(result: true);
        // Get.until((route) => Get.currentRoute == AppRoutes.homePage);
        circularLoader.hideCircularLoader();
        Get.offAllNamed(AppRoutes.homePage,
            arguments: {"fromUpdateStatus": true});
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

  String convertToApiDateFormat(String input) {
    final dateTime = DateFormat('dd MMMM yyyy, hh:mm a').parse(input);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  void onUpdatePressed() async {
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

    if (selectedIds.isEmpty) {
      myBotToast("Please provide Assigned Employee(s)");
      return;
    }
    await updateTaskDetails(
        taskNameController.text,
        descController.text,
        taskTypeSelected.toString().toLowerCase(),
        taskStatusSelected.value.toString().toLowerCase(),
        convertToApiDateFormat(dateCont.text),
        selectedIds);
  }
}
