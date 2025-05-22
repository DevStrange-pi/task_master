// To parse this JSON data, do
//
//     final gettEmployeeReportResponseModel = gettEmployeeReportResponseModelFromJson(jsonString);

import 'dart:convert';

import 'all_tasks_response_model.dart';

GettEmployeeReportResponseModel gettEmployeeReportResponseModelFromJson(String str) => GettEmployeeReportResponseModel.fromJson(json.decode(str));

String gettEmployeeReportResponseModelToJson(GettEmployeeReportResponseModel data) => json.encode(data.toJson());

class GettEmployeeReportResponseModel {
    String? status;
    EmployeeReportData? data;

    GettEmployeeReportResponseModel({
        this.status,
        this.data,
    });

    factory GettEmployeeReportResponseModel.fromJson(Map<String, dynamic> json) => GettEmployeeReportResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : EmployeeReportData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class EmployeeReportData {
    DateTime? fromDate;
    DateTime? toDate;
    String? employeeId;
    int? pendingTasks;
    int? completedTasks;
    int? expiredTasks;
    int? requestedTasks;
    List<Task>? tasks;

    EmployeeReportData({
        this.fromDate,
        this.toDate,
        this.employeeId,
        this.pendingTasks,
        this.completedTasks,
        this.expiredTasks,
        this.requestedTasks,
        this.tasks,
    });

    factory EmployeeReportData.fromJson(Map<String, dynamic> json) => EmployeeReportData(
        fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
        toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
        employeeId: json["employee_id"],
        pendingTasks: json["pending_tasks"],
        completedTasks: json["completed_tasks"],
        expiredTasks: json["expired_tasks"],
        requestedTasks: json["requested_tasks"],
        tasks: json["tasks"] == null ? [] : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
        "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
        "employee_id": employeeId,
        "pending_tasks": pendingTasks,
        "completed_tasks": completedTasks,
        "expired_tasks": expiredTasks,
        "requested_tasks": requestedTasks,
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
    };
}

// class Task {
//     int? id;
//     String? name;
//     String? description;
//     String? type;
//     DateTime? deadline;
//     String? status;
//     dynamic photos;
//     DateTime? createdAt;
//     DateTime? updatedAt;
//     int? expiredCount;
//     List<Employee>? employees;

//     Task({
//         this.id,
//         this.name,
//         this.description,
//         this.type,
//         this.deadline,
//         this.status,
//         this.photos,
//         this.createdAt,
//         this.updatedAt,
//         this.expiredCount,
//         this.employees,
//     });

//     factory Task.fromJson(Map<String, dynamic> json) => Task(
//         id: json["id"],
//         name: json["name"],
//         description: json["description"],
//         type: json["type"],
//         deadline: json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
//         status: json["status"],
//         photos: json["photos"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//         expiredCount: json["expired_count"],
//         employees: json["employees"] == null ? [] : List<Employee>.from(json["employees"]!.map((x) => Employee.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "description": description,
//         "type": type,
//         "deadline": deadline?.toIso8601String(),
//         "status": status,
//         "photos": photos,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "expired_count": expiredCount,
//         "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
//     };
// }

// class Employee {
//     int? id;
//     String? name;
//     Pivot? pivot;

//     Employee({
//         this.id,
//         this.name,
//         this.pivot,
//     });

//     factory Employee.fromJson(Map<String, dynamic> json) => Employee(
//         id: json["id"],
//         name: json["name"],
//         pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "pivot": pivot?.toJson(),
//     };
// }

// class Pivot {
//     int? taskId;
//     int? employeeId;

//     Pivot({
//         this.taskId,
//         this.employeeId,
//     });

//     factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
//         taskId: json["task_id"],
//         employeeId: json["employee_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "task_id": taskId,
//         "employee_id": employeeId,
//     };
// }

