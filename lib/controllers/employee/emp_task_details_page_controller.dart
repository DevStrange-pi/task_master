import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/models/employee/emp_task_updated_response_model.dart';

import '../../constants/app_url.dart';
import '../../constants/strings.dart';
import '../../models/all_tasks_response_model.dart';
import '../../models/get_employees_response_model.dart';
import '../../network/http_req.dart';
import '../../routes/app_routes.dart';
import '../../utilities/circular_loader.dart';
import '../../utilities/utilities.dart';

class EmpTaskDetailsPageController extends GetxController {
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
  RxString taskTypeSelected = "Daily".obs;
  List<String> taskStatus = [
    "Pending",
    "Completed",
    "Requested",
    "Expired",
  ];
  List<String> disabledItems = [];
  RxString taskStatusSelected = "Pending".obs;
  final RxList<DropdownItem<String>> assignDropdownOptions =
      <DropdownItem<String>>[].obs;
  List<DropdownItem<String>> assignSelected = [];
  List<int> selectedIds = [];
  final multiSelectController = MultiSelectController<String>();
  final RxList<Employee> employeeList = <Employee>[].obs;
  final RxBool canPop = true.obs;

  Rx<Task> task = Task().obs;
  // final String taskId = Get.arguments["taskId"];
  bool? statusFlag;
  bool isEmployee = true;
  bool isAdmin = false;
  RxBool isMultiDropdownValueChanged = false.obs;
  List<String> originalValues = [];
  String originaltaskStatusSelected = "";

  RxList<File> selectedFiles = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    task.value = Get.arguments;
    statusFlag = task.value.status == "completed" ||
            task.value.status == "expired" ||
            task.value.status == "requested"
        ? false
        : true;
    prefs = await SharedPreferences.getInstance();
    isEmployee = prefs!.getString(SpString.role) == "admin" ? false : true;
    isAdmin = prefs!.getString(SpString.role) == "admin" ? true : false;
    await Future.wait([
      getEmployees(),
    ]);
    taskStatusSelected.value =
        task.value.status?.toString().capitalizeFirst ?? "Pending";
    originaltaskStatusSelected = taskStatusSelected.value;
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

  Future<void> pickFromGallery() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      selectedFiles.addAll(images.map((xfile) => File(xfile.path)));
    }
  }

  Future<void> pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      selectedFiles.add(File(photo.path));
    }
  }

  // Future<void> pickFiles() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     type: FileType.image, // or FileType.any for all files
  //   );
  //   if (result != null) {
  //     selectedFiles.value = result.paths.map((path) => File(path!)).toList();
  //   }
  // }

  void removeFile(int index) {
    selectedFiles.removeAt(index);
  }

  Future<void> uploadFiles() async {
    // Implement your upload logic here (API call, etc.)
    // Use selectedFiles list
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
    if (task.value.employees == null) {
      return;
    }
    assignSelected = task.value.employees!
        .map((employee) => DropdownItem(
              label: employee.name ?? "",
              value: employee.name ?? "",
              selected: true,
            ))
        .toList();
    originalValues = assignSelected.map((e) => e.value).toList()..sort();
  }

  void getDefaultValues() {
    taskNameController.text = task.value.name ?? "";
    descController.text = task.value.description ?? "";
    if (task.value.deadline != null) {
      final DateTime dateTime = task.value.deadline!;
      final formattedDateTime =
          DateFormat('dd MMMM yyyy, hh:mm a').format(dateTime);
      dateCont.text = formattedDateTime;
    } else {
      dateCont.text = "";
    }
    taskTypeSelected.value = task.value.type?.capitalizeFirst ?? "";
  }

  bool get isPhotoUploadEnabled {
    return statusFlag == true &&
        isEmployee == true &&
        taskStatusSelected.value.toLowerCase() == "completed";
  }

  Future<List<String>> getSelectedFilesAsBase64() async {
    List<String> base64Images = [];
    for (var file in selectedFiles) {
      final bytes = await file.readAsBytes();
      final base64Str = base64Encode(bytes);
      final mimeType = lookupMimeType(file.path) ?? 'image/png';
      base64Images.add('data:$mimeType;$base64Str');
    }
    return base64Images;
  }

  Future<bool> getEmployees() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp = await HttpReq.getApi(
        apiUrl: AppUrl().empGetEmployees, headers: headers);
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
      List<String> base64Images = await getSelectedFilesAsBase64();
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var resp = await HttpReq.patchApi(
          apiUrl: AppUrl().employeeUpdateTask(task.value.id!),
          headers: headers,
          body: {
            // "name": name,
            // "description": desc,
            // "type": type,
            "status": status,
            // "deadline": deadline,
            "employee_ids": employeeIds,
            "photo_base64": base64Images,
          });
      var respBody = json.decode(resp!.body);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        EmpTaskUpdatedResponseModel taskDetails =
            EmpTaskUpdatedResponseModel.fromJson(respBody);
        myBotToast(taskDetails.message ?? "");
        // Get.back(result: true);
        Get.offAllNamed(AppRoutes.employeeHomePage,
            arguments: {"fromUpdateStatus": true});
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

  String convertToApiDateFormat(String input) {
    final dateTime = DateFormat('dd MMMM yyyy, hh:mm a').parse(input);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  void compareMultiDropdownValues(List<String> val) {
    final newValues = val.toList()..sort();
    bool isChanged = !(const ListEquality().equals(originalValues, newValues));
    isMultiDropdownValueChanged.value = isChanged;
    debugPrint("isMultiDropdownValueChanged: $isChanged");
    if (isMultiDropdownValueChanged.value) {
      taskStatusSelected.value = "Requested";
      if (statusFlag!) {
        disabledItems.clear();
      }
    } else {
      taskStatusSelected.value = originaltaskStatusSelected;
      if (statusFlag!) {
        disabledItems.addAll(["Requested", "Expired"]);
      }
    }
  }
  
  Future<void> onRefresh()async{
    initAsync();
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
