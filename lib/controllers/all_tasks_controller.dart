import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/globals/observables.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../models/admin_home_response_model.dart';
import '../models/all_tasks_response_model.dart';
import '../network/http_req.dart';
import '../routes/app_routes.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';
import 'task_list_controller.dart';

class AllTasksController extends GetxController {
  // Map<String, dynamic>? tasksCount;
  // List<Map<String, String>?>? tasksCountList = <Map<String, String>>[].obs;
  List<Task>? tasks = <Task>[].obs;
  List<Task> filteredTasks = <Task>[].obs;

  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  @override
  void onInit() {
    initAsync();
    super.onInit();

    // Listen for task deletion events
    ever(TaskListController.taskDeleted, (deleted) {
      if (deleted == true) {
        getTaskCount();
        TaskListController.taskDeleted.value = false; // Reset the flag
      }
    });
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    // tasksCount = Get.arguments;
    // tasksCountList!.assignAll(convertTaskMap(tasksCount ?? {}));
    await getTaskCount();
  }

  List<Map<String, String>?> convertTaskMap(Map<String, dynamic> taskMap) {
    if (taskMap.isEmpty) {
      return [];
    }
    return taskMap.entries
        .where((entry) =>
            entry.key.contains("tasks") && !entry.key.contains("total_tasks"))
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

  Future<bool> getTaskCount() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp =
        await HttpReq.getApi(apiUrl: AppUrl().adminHome, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      AdminHomeResponseModel tokenData =
          AdminHomeResponseModel.fromJson(respBody);
      // tasksCount = tokenData.data?.statistics?.toJson() ?? {};
      // tasksCountList!.assignAll(convertTaskMap(tasksCount ?? {}));

      final statsJson = tokenData.data?.statistics?.toJson() ?? {};
      globalStatistics.value = Statistics.fromJson(statsJson);
      globalTasksCountList.assignAll(convertTaskMap(statsJson) as Iterable<Map<String, String>>);


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

  void onTapMenuTile(String title) async {
    String newTitle = title.split(" ").first;
    if (await getAllTasks()) {
      filteredTasks = tasks!
          .where((task) => task.status.toString() == newTitle.toLowerCase())
          .toList();
      if (filteredTasks.isNotEmpty) {
        Get.toNamed(
          AppRoutes.taskListPage,
          arguments: [filteredTasks, title, ""],
        );
      } else {
        myBotToast("No Task Found", duration: 2);
      }
    } else {
      myBotToast("No Task Found", duration: 2);
    }
  }
}
