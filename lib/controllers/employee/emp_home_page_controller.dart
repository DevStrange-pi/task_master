import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_url.dart';
import '../../constants/strings.dart';
import '../../models/employee/emp_dashboard_response_model.dart';
import '../../network/http_req.dart';
import '../../utilities/circular_loader.dart';
import '../../utilities/utilities.dart';

class EmpHomePageController extends GetxController{
  Rx<EmpStatistics> statistics = EmpStatistics().obs;
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();
  RxString empName = "User".obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    empName.value = prefs!.getString(SpString.name) ?? "User";
    await getTaskCount();
  }
  Future<bool> getTaskCount() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {"Authorization": "Bearer $token", "Content-Type": "application/json", "Accept": "application/json"};
    var resp = await HttpReq.getApi(apiUrl: AppUrl().employeeHome, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      EmpDashboardResponseModel tokenData = EmpDashboardResponseModel.fromJson(respBody);
      statistics.value = tokenData.data?.statistics ?? EmpStatistics();
      circularLoader.hideCircularLoader();
      // myBotToast(respBody["message"]);
      return true;
    } else {
      circularLoader.hideCircularLoader();
      myBotToast( respBody["message"]);
      // syllabusModelList.value = syllabusData.data!;
      return false;
    }
  }

  // void addTaskTapped()async{
  //   bool res = await Get.toNamed(AppRoutes.addTaskPage);
  //   if (res) {
  //     await getTaskCount();
  //   }
  // }
}