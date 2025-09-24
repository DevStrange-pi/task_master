import 'dart:convert';

import 'package:flutter/material.dart';
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
  RxBool isLoading = false.obs;
  static RxBool employeeDeleted = false.obs;
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();
  bool isAdmin = false;

  @override
  void onInit() {
    initAsync();
    super.onInit();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    isAdmin = prefs!.getString(SpString.role) == "admin" ? true : false;
    await getEmployees();
  }

  Future<bool> getEmployees() async {
    circularLoader.showCircularLoader();
    isLoading.value = true;
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
      if (isAdmin) {
        removeSuperAdmin();
      }
      circularLoader.hideCircularLoader();
      isLoading.value = false;
      return true;
    } else {
      circularLoader.hideCircularLoader();
      isLoading.value = false;
      myBotToast(respBody["message"]);
      return false;
    }
  }

  void removeSuperAdmin() {
    employeeList.removeWhere((element) => element.role == "super_admin");
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

  Future<void> onRefresh() async {
    initAsync();
  }

  void onBackPressed() {
    Get.back(result: flag);
  }

  Future<void> deleteEmployee(BuildContext context, int empId) async {
    debugPrint("Employee id : $empId");
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete this Employee?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );

    if (result != null && result) {
      circularLoader.showCircularLoader();
      // isLoading.value = true;
      String token = prefs!.getString(SpString.token)!;
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var resp = await HttpReq.deleteApi(
          apiUrl: AppUrl().deleteEmployee(empId), headers: headers);
      var respBody = json.decode(resp!.body);
      if (resp.statusCode == 200) {
        // Call get API again
        await getEmployees();
        employeeDeleted.value = true;
      } else {
        circularLoader.hideCircularLoader();
        myBotToast(respBody["message"]);
      }
    }
  }
}
