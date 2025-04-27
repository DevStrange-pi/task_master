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

class HomePageController extends GetxController{
  Rx<Statistics> statistics = Statistics().obs;
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();
  RxString empName = "Admin".obs;

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    empName.value = prefs!.getString(SpString.name) ?? "Admin";
    await getTaskCount();
    super.onInit();
  }
  Future<bool> getTaskCount() async {
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token)!;
    var headers = {"Authorization": "Bearer $token", "Content-Type": "application/json", "Accept": "application/json"};
    var resp = await HttpReq.getApi(apiUrl: AppUrl().adminHome, headers: headers);
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      AdminHomeResponseModel tokenData = AdminHomeResponseModel.fromJson(respBody);
      statistics.value = tokenData.data?.statistics ?? Statistics();
      circularLoader.hideCircularLoader();
      return true;
      // myBotToast( respBody["message"]);
    } else {
      circularLoader.hideCircularLoader();
      myBotToast( respBody["message"]);
      // syllabusModelList.value = syllabusData.data!;
      return false;
    }
  }

  void addTaskTapped()async{
    bool res = await Get.toNamed(AppRoutes.addTaskPage);
    if (res) {
      await getTaskCount();
    }
  }
}