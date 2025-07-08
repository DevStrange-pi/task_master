import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_url.dart';
import '../../constants/strings.dart';
import '../../globals/observables.dart';
import '../../models/all_tasks_response_model.dart';
import '../../models/employee/emp_dashboard_response_model.dart';
import '../../network/http_req.dart';
import '../../routes/app_routes.dart';
import '../../utilities/circular_loader.dart';
import '../../utilities/utilities.dart';
import 'emp_task_list_page_controller.dart';

class EmpMyTaskPageController extends GetxController {
  Map<String, dynamic>? tasksCount;
  List<Map<String, String>?>? tasksCountList = <Map<String, String>>[].obs;
  List<Task>? tasks = <Task>[].obs;
  List<Task> filteredTasks = <Task>[].obs;

  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  @override
  void onInit() {
    initAsync();
    super.onInit();
    // Listen for task deletion events
    ever(EmpTaskListPageController.taskDeleted, (deleted) {
      if (deleted == true) {
        getTaskCount();
        EmpTaskListPageController.taskDeleted.value = false; // Reset the flag
      }
    });
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    // tasksCount = Get.arguments;
    // tasksCountList!.assignAll(convertTaskMap(tasksCount ?? {}));
    await getTaskCount();
  }

  List<Map<String, String>> convertTaskMap(Map<String, dynamic> taskMap) {
    if (taskMap.isEmpty) {
      return [];
    }
    return taskMap.entries
        .where((entry) =>
            entry.key.contains("tasks") &&
            !entry.key.contains("requested_tasks"))
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

  Future<bool> getTaskCount() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp =
        await HttpReq.getApi(apiUrl: AppUrl().employeeHome, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      EmpDashboardResponseModel tokenData =
          EmpDashboardResponseModel.fromJson(respBody);
      // statistics.value = tokenData.data?.statistics ?? EmpStatistics();
      final statsJson = tokenData.data?.statistics?.toJson() ?? {};
      // final statsJson = respBody['data']?['statistics'] ?? {};
      globalEmpStatistics.value = EmpStatistics.fromJson(statsJson);
      globalTasksCountList.assignAll(convertTaskMap(statsJson));
      circularLoader.hideCircularLoader();
      // myBotToast(respBody["message"]);
      return true;
    } else {
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
      // syllabusModelList.value = syllabusData.data!;
      return false;
    }
  }

  void onTapMenuTile(String title) async {
    String newTitle = title.split(" ").first;
    if (await getEmployeeMyTasks()) {
      filteredTasks = tasks!
          .where((task) => task.type.toString() == newTitle.toLowerCase())
          .toList();
      if (filteredTasks.isNotEmpty) {
        Get.toNamed(
          AppRoutes.employeeTaskListPage,
          arguments: [filteredTasks, title],
        );
      } else {
        myBotToast("No Task Found", duration: 2);
      }
    } else {
      myBotToast("No Task Found", duration: 2);
    }
  }
}
