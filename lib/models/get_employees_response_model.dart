// To parse this JSON data, do
//
//     final getEmployeesResponseModel = getEmployeesResponseModelFromJson(jsonString);

import 'dart:convert';

import 'all_tasks_response_model.dart';


GetEmployeesResponseModel getEmployeesResponseModelFromJson(String str) => GetEmployeesResponseModel.fromJson(json.decode(str));

String getEmployeesResponseModelToJson(GetEmployeesResponseModel data) => json.encode(data.toJson());

class GetEmployeesResponseModel {
    String? status;
    Data? data;

    GetEmployeesResponseModel({
        this.status,
        this.data,
    });

    factory GetEmployeesResponseModel.fromJson(Map<String, dynamic> json) => GetEmployeesResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    List<Employee>? employees;

    Data({
        this.employees,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        employees: json["employees"] == null ? [] : List<Employee>.from(json["employees"]!.map((x) => Employee.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
    };
}
