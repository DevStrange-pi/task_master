import 'dart:convert';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../background/location_service.dart';
import '../../constants/app_url.dart';
import '../../constants/strings.dart';
import '../../globals/observables.dart';
import '../../models/admin_home_response_model.dart';
import '../../models/employee/emp_dashboard_response_model.dart';
import '../../network/http_req.dart';
import '../../routes/app_routes.dart';
import '../../utilities/circular_loader.dart';
import '../../utilities/utilities.dart';
import '../reporting_page_controller.dart';


class AdminHomePageController extends GetxController {
  Rx<Statistics> statistics = Statistics().obs;
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();
  RxString empName = "Admin".obs;

  @override
  void onInit() {
    initAsync();
    super.onInit();

    // Listen for task deletion events
    ever(ReportingPageController.employeeDeleted, (deleted) {
      if (deleted == true) {
        getTaskCount();
        ReportingPageController.employeeDeleted.value = false; // Reset the flag
      }
    });
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

    // emp home initAsync
    await initializeService();
    await saveFcmToken();
    if (Get.arguments != null &&
        Get.arguments is Map &&
        Get.arguments['fromUpdateStatus'] == true) {
      await getEmpTaskCount();
    } else {
      await getEmpTaskCount();
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

  // THIS IS ADMIN SIDE ADD TASK TAP FUNCTION
  // void addTaskTapped() async {
  //   var res = await Get.toNamed(AppRoutes.addTaskPage);
  //   if (res != null && res == true) {
  //     await getTaskCount();
  //   }
  // }

  void addEmployeeTapped() async {
    var res = await Get.toNamed(AppRoutes.addProfilePage);
    if (res != null && res == true) {
      await getTaskCount();
    }
  } 


// EMP HOME PAGE CONTROLLER 


Rx<EmpStatistics> empStatistics = EmpStatistics().obs;
  // SharedPreferences? prefs;
  // CircularLoader circularLoader = Get.find<CircularLoader>();
  // RxString empName = "User".obs;

  // @override
  // void onInit() {
  //   initAsync();
  //   super.onInit();
  // }

  // void initAsync() async {
    // prefs = await SharedPreferences.getInstance();
    // empName.value = prefs!.getString(SpString.name) ?? "User";
   // cut pasted in above initAsync
  // }

  void goToMyProfile() {
    Get.toNamed(AppRoutes.employeeMyProfilePage);
  }

  Future<void> saveFcmToken() async {
    String fcmToken = prefs!.getString(SpString.fcmToken) ?? "";
    String token = prefs!.getString(SpString.token) ?? "";
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp = await HttpReq.postApi(
      apiUrl: AppUrl().sendFcmToken,
      headers: headers,
      body: {'device_token': fcmToken},
    );
    print(resp!.body);
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundServiceOnStart,
        autoStart: true,
        autoStartOnBoot: true,
        isForegroundMode: false,
        initialNotificationTitle: 'Speed Up',
        initialNotificationContent: 'App is running in background',
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: backgroundServiceOnStart,
        onBackground: onIosBackground,
      ),
    );
    service.startService();
  }

  Future<bool> getEmpTaskCount() async {
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
      empStatistics.value = tokenData.data?.statistics ?? EmpStatistics();
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

  void addTaskTapped()async{
    var res = await Get.toNamed(AppRoutes.employeeAddTaskPage);
    if (res != null && res == true) {
      await getEmpTaskCount();
    }
  }

  void createdAndAssignedTapped() {
    Get.toNamed(AppRoutes.employeeCreatedAndAssignedPage);
  }

}
