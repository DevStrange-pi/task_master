import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_url.dart';
import '../constants/strings.dart';
import '../models/all_tasks_response_model.dart';
import '../models/get_employees_response_model.dart';
import '../network/http_req.dart';
import '../routes/app_routes.dart';
import '../utilities/circular_loader.dart';
import '../utilities/utilities.dart';

class ReportingPageController extends GetxController {
  final RxList<Employee> employeeList = <Employee>[].obs;
  bool flag = false;

  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    await getEmployees();
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

  void onTapMenuTile(
      String title, int empId, LatestLocation? latestLocation) async {
    flag = await Get.toNamed(
      AppRoutes.reportingEmpDetailsPage,
      arguments: [
        title,
        empId,
        latestLocation ??
            LatestLocation(
                latitude: "0.0",
                longitude: "0.0",
                name: "No Location Found",
                address: "")
      ],
    );
  }

  void onBackPressed() {
    Get.back(result: flag);
  }
}
