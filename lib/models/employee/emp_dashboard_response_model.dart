// To parse this JSON data, do
//
//     final empDashboardResponseModel = empDashboardResponseModelFromJson(jsonString);

import 'dart:convert';

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

    EmpData({
        this.statistics,
        this.tasks,
    });

    factory EmpData.fromJson(Map<String, dynamic> json) => EmpData(
        statistics: json["statistics"] == null ? null : EmpStatistics.fromJson(json["statistics"]),
        tasks: json["tasks"] == null ? [] : List<EmpTask>.from(json["tasks"]!.map((x) => EmpTask.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "statistics": statistics?.toJson(),
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
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
        dailyTasks: json["daily_tasks"],
        weeklyTasks: json["weekly_tasks"],
        monthlyTasks: json["monthly_tasks"],
        yearlyTasks: json["yearly_tasks"],
        onceTasks: json["once_tasks"],
        requestedTasks: json["requested_tasks"],
    );

    Map<String, dynamic> toJson() => {
        "daily_tasks": dailyTasks,
        "weekly_tasks": weeklyTasks,
        "monthly_tasks": monthlyTasks,
        "yearly_tasks": yearlyTasks,
        "once_tasks": onceTasks,
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

    EmpTask({
        this.taskNo,
        this.name,
        this.description,
        this.assignedDate,
        this.deadline,
        this.status,
        this.type,
    });

    factory EmpTask.fromJson(Map<String, dynamic> json) => EmpTask(
        taskNo: json["task_no"],
        name: json["name"],
        description: json["description"],
        assignedDate: json["assigned_date"] == null ? null : DateTime.parse(json["assigned_date"]),
        deadline: json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        status: json["status"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "task_no": taskNo,
        "name": name,
        "description": description,
        "assigned_date": assignedDate?.toIso8601String(),
        "deadline": deadline?.toIso8601String(),
        "status": status,
        "type": type,
    };
}

