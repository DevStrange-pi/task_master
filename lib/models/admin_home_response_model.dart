// To parse this JSON data, do
//
//     final adminHomeResponseModel = adminHomeResponseModelFromJson(jsonString);

import 'dart:convert';

AdminHomeResponseModel adminHomeResponseModelFromJson(String str) => AdminHomeResponseModel.fromJson(json.decode(str));

String adminHomeResponseModelToJson(AdminHomeResponseModel data) => json.encode(data.toJson());

class AdminHomeResponseModel {
    String? status;
    DataHome? data;

    AdminHomeResponseModel({
        this.status,
        this.data,
    });

    factory AdminHomeResponseModel.fromJson(Map<String, dynamic> json) => AdminHomeResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : DataHome.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class DataHome {
    Statistics? statistics;

    DataHome({
        this.statistics,
    });

    factory DataHome.fromJson(Map<String, dynamic> json) => DataHome(
        statistics: json["statistics"] == null ? null : Statistics.fromJson(json["statistics"]),
    );

    Map<String, dynamic> toJson() => {
        "statistics": statistics?.toJson(),
    };
}

class Statistics {
    int? totalTasks;
    int? pendingTasks;
    int? completedTasks;
    int? expiredTasks;
    int? totalEmployees;

    Statistics({
        this.totalTasks,
        this.pendingTasks,
        this.completedTasks,
        this.expiredTasks,
        this.totalEmployees,
    });

    factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
        totalTasks: json["total_tasks"],
        pendingTasks: json["pending_tasks"],
        completedTasks: json["completed_tasks"],
        expiredTasks: json["expired_tasks"],
        totalEmployees: json["total_employees"],
    );

    Map<String, dynamic> toJson() => {
        "total_tasks": totalTasks,
        "pending_tasks": pendingTasks,
        "completed_tasks": completedTasks,
        "expired_tasks": expiredTasks,
        "total_employees": totalEmployees,
    };
    bool isEmpty() {
    return totalTasks == null &&
        pendingTasks == null &&
        completedTasks == null &&
        expiredTasks == null &&
        totalEmployees == null;
  }
}
