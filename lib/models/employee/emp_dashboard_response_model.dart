// To parse this JSON data, do
//
//     final empDashboardResponseModel = empDashboardResponseModelFromJson(jsonString);

import 'dart:convert';

import '../all_tasks_response_model.dart';

EmpDashboardResponseModel empDashboardResponseModelFromJson(String str) => EmpDashboardResponseModel.fromJson(json.decode(str));

String empDashboardResponseModelToJson(EmpDashboardResponseModel data) => json.encode(data.toJson());

class EmpDashboardResponseModel {
    String? status;
    EmpData? data;

    EmpDashboardResponseModel({
        this.status,
        this.data,
    });

    factory EmpDashboardResponseModel.fromJson(Map<String, dynamic> json) => EmpDashboardResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : EmpData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class EmpData {
    EmpStatistics? statistics;
    List<EmpTask>? tasks;
    List<Task>? createdAndAssigned;

    EmpData({
        this.statistics,
        this.tasks,
        this.createdAndAssigned,
    });

    factory EmpData.fromJson(Map<String, dynamic> json) => EmpData(
        statistics: json["statistics"] == null ? null : EmpStatistics.fromJson(json["statistics"]),
        tasks: json["tasks"] == null ? [] : List<EmpTask>.from(json["tasks"]!.map((x) => EmpTask.fromJson(x))),
        createdAndAssigned: json["created_and_assigned"] == null ? [] : List<Task>.from(json["created_and_assigned"]!.map((x) => Task.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "statistics": statistics?.toJson(),
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "created_and_assigned": createdAndAssigned == null ? [] : List<dynamic>.from(createdAndAssigned!.map((x) => x.toJson())),
    };
}

class EmpStatistics {
    int? dailyTasks;
    int? weeklyTasks;
    int? monthlyTasks;
    int? yearlyTasks;
    int? onceTasks;
    int? requestedTasks;

    EmpStatistics({
        this.dailyTasks,
        this.weeklyTasks,
        this.monthlyTasks,
        this.yearlyTasks,
        this.onceTasks,
        this.requestedTasks,
    });

    factory EmpStatistics.fromJson(Map<String, dynamic> json) => EmpStatistics(
        onceTasks: json["once_tasks"],
        dailyTasks: json["daily_tasks"],
        weeklyTasks: json["weekly_tasks"],
        monthlyTasks: json["monthly_tasks"],
        yearlyTasks: json["yearly_tasks"],
        requestedTasks: json["requested_tasks"],
    );

    Map<String, dynamic> toJson() => {
        "once_tasks": onceTasks,
        "daily_tasks": dailyTasks,
        "weekly_tasks": weeklyTasks,
        "monthly_tasks": monthlyTasks,
        "yearly_tasks": yearlyTasks,
        "requested_tasks": requestedTasks,
    };
}

class EmpTask {
    int? taskNo;
    String? name;
    String? description;
    DateTime? assignedDate;
    DateTime? deadline;
    String? status;
    String? type;
    List<String>? assignedTo;

    EmpTask({
        this.taskNo,
        this.name,
        this.description,
        this.assignedDate,
        this.deadline,
        this.status,
        this.type,
        this.assignedTo,
    });

    factory EmpTask.fromJson(Map<String, dynamic> json) => EmpTask(
        taskNo: json["task_no"],
        name: json["name"],
        description: json["description"],
        assignedDate: json["assigned_date"] == null ? null : DateTime.parse(json["assigned_date"]),
        deadline: json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        status: json["status"],
        type: json["type"],
        assignedTo: json["assigned_to"] == null ? [] : List<String>.from(json["assigned_to"]!),
    );

    Map<String, dynamic> toJson() => {
        "task_no": taskNo,
        "name": name,
        "description": description,
        "assigned_date": assignedDate?.toIso8601String(),
        "deadline": deadline?.toIso8601String(),
        "status": status,
        "type": type,
        "assigned_to": assignedTo,
    };
}

