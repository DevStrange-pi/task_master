import 'dart:convert';

import 'all_tasks_response_model.dart';

GetProfileResponseModel getProfileResponseModelFromJson(String str) =>
    GetProfileResponseModel.fromJson(json.decode(str));

String employeeDetailsResponseModelToJson(GetProfileResponseModel data) =>
    json.encode(data.toJson());

class GetProfileResponseModel {
  String? status;
  EmployeeData? data;

  GetProfileResponseModel({
    this.status,
    this.data,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProfileResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : EmployeeData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class EmployeeData {
  Employee? employee;

  EmployeeData({
    this.employee,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
        employee: json["employee"] == null
            ? null
            : Employee.fromJson(json["employee"]),
      );

  Map<String, dynamic> toJson() => {
        "employee": employee?.toJson(),
      };
}