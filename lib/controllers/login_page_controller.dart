import 'dart:convert';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../models/login_response_model.dart';
import '../network/http_req.dart';
import '../routes/app_routes.dart';
import '../utilities/utilities.dart';

class LoginPageController extends GetxController {
  late SharedPreferences prefs;
  // RxString email ="".obs;
  // RxString password ="".obs;
  var emailController = TextEditingController();
  
  var passController = TextEditingController();
  RxBool isPasswordHidden = true.obs;

  RxBool needLoader = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !(isPasswordHidden.value);
  }

  @override
  void onInit() async {
    super.onInit();
    sharedData();
  }

  @override
  void onClose() {
    emailController.clear();
    passController.clear();
    super.onClose();
  }

  void sharedData() async {
    prefs = await SharedPreferences.getInstance();
  }

  void storeToken(String token) async {
    prefs.setString(SpString.token, token);
    print('the token is here : $token');
  }

  void storeRole(String role) async {
    prefs.setString(SpString.role, role);
  }
  void storeStudentId(int id) async {
    prefs.setInt("SpString.STID", id);
  }

  void storePlacementStatus(int id) async {
    prefs.setInt("SpString.PL_STATUS", id);
  }

  Future<void> login() async {
    if (checkValidation()) {
      try {
        // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // final String deviceId = androidInfo.id;
        needLoader.value = true;
        var body = {"username": emailController.text, "password": passController.text/*"device_id":deviceId*/};
        var resp = await HttpReq.postApi(apiUrl: AppUrl().login, body: body);
        var respBody = json.decode(resp!.body);
        LoginResponseModel loginData = LoginResponseModel.fromJson(respBody);
        // print("Login data ========================= $loginData");
        if (resp.statusCode == 200) {
          needLoader.value = false;
          myBotToast(respBody["message"]);
          storeToken(loginData.data!.token!);
          storeRole(loginData.data!.role!);
          // storeStudentId(loginData.studentId!);
          // storePlacementStatus(loginData.placementStatus ?? 0);
          // routeHistoryController.addRoute(AppRoutes.SCREEN_NAV_PAGE, RouteHistoryNames.INITIAL);
          Get.offAllNamed(AppRoutes.homePage,arguments: loginData.data!);
        } else {
          needLoader.value = false;
          myBotToast("${respBody["message"]}\n${respBody["data"]}");
        }
      } catch (e) {
        needLoader.value = false;
        print(e.toString());
      }
    }
  }

  // Future<void> login() async {
  //   if (checkValidation()) {
  //     final String response = await rootBundle.loadString('assets/response/login.json');
  //     final respBody = await json.decode(response);
  //     Future.delayed(Duration(seconds: 2),(){
  //       myBotToast(text: respBody["message"]);
  //       storeToken(respBody["access_token"]!);
  //       storeStudentId(respBody["student_id"]);
  //       // routeHistoryController.addRoute(AppRoutes.SCREEN_NAV_PAGE, RouteHistoryNames.INITIAL);
  //       // Get.offAllNamed(AppRoutes.SCREEN_NAV_PAGE);
  //       // routeHistoryController.addRoute(AppRoutes.SCREEN_NAV_PAGE, RouteHistoryNames.INITIAL);
  //       Get.offAllNamed(AppRoutes.SCREEN_NAV_PAGE);
  //     });
  //   }
  // }

  bool checkValidation() {
    if (emailController.text.isEmpty) {
      myBotToast("Email cannot be empty");
      return false;
    } else if (passController.text.isEmpty) {
      myBotToast("Password cannot be empty");
      return false;
    }
    return true;
  }
}
