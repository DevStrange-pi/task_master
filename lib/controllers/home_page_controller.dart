import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../models/admin_home_response_model.dart';
import '../network/http_req.dart';
import '../routes/app_routes.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';
import 'task_list_controller.dart';
import '../globals/observables.dart';

class HomePageController extends GetxController {
  Rx<Statistics> statistics = Statistics().obs;
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();
  RxString empName = "Admin".obs;

  @override
  void onInit() {
    initAsync();
    super.onInit();

    // Listen for task deletion events
    // ever(TaskListController.taskDeleted, (deleted) {
    //   if (deleted == true) {
    //     getTaskCount();
    //     TaskListController.taskDeleted.value = false; // Reset the flag
    //   }
    // });
  }
  
  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    empName.value = prefs!.getString(SpString.name) ?? "Admin";
    if (Get.arguments != null &&
        Get.arguments is Map &&
        Get.arguments['fromUpdateStatus'] == true) {
      await getTaskCount();
    } else {
      await getTaskCount();
    }
  }

  void goToReporting() async {
    final flag = await Get.toNamed(AppRoutes.reportingPage);
    if (flag != null && flag == true) {
      getTaskCount();
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
        await HttpReq.getApi(apiUrl: AppUrl().adminHome, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      AdminHomeResponseModel tokenData =
          AdminHomeResponseModel.fromJson(respBody);
      statistics.value = tokenData.data?.statistics ?? Statistics();

      final statsJson = tokenData.data?.statistics?.toJson() ?? {};
      globalStatistics.value = Statistics.fromJson(statsJson);

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

  void addTaskTapped() async {
    var res = await Get.toNamed(AppRoutes.addTaskPage);
    if (res != null && res == true) {
      await getTaskCount();
    }
  }
}
