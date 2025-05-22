// To parse this JSON data, do
//
//     final empTaskUpdatedResponseModel = empTaskUpdatedResponseModelFromJson(jsonString);

import 'dart:convert';

import '../all_tasks_response_model.dart';

EmpTaskUpdatedResponseModel empTaskUpdatedResponseModelFromJson(String str) => EmpTaskUpdatedResponseModel.fromJson(json.decode(str));

String empTaskUpdatedResponseModelToJson(EmpTaskUpdatedResponseModel data) => json.encode(data.toJson());

class EmpTaskUpdatedResponseModel {
    String? status;
    String? message;
    UpdatedData? data;

    EmpTaskUpdatedResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory EmpTaskUpdatedResponseModel.fromJson(Map<String, dynamic> json) => EmpTaskUpdatedResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : UpdatedData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class UpdatedData {
    Task? task;

    UpdatedData({
        this.task,
    });

    factory UpdatedData.fromJson(Map<String, dynamic> json) => UpdatedData(
        task: json["task"] == null ? null : Task.fromJson(json["task"]),
    );

    Map<String, dynamic> toJson() => {
        "task": task?.toJson(),
    };
}

// class UpdatedTask {
//     int? id;
//     String? name;
//     String? description;
//     String? type;
//     DateTime? deadline;
//     String? status;
//     DateTime? createdAt;
//     DateTime? updatedAt;
//     List<UpdatedEmployee>? employees;

//     UpdatedTask({
//         this.id,
//         this.name,
//         this.description,
//         this.type,
//         this.deadline,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//         this.employees,
//     });

//     factory UpdatedTask.fromJson(Map<String, dynamic> json) => UpdatedTask(
//         id: json["id"],
//         name: json["name"],
//         description: json["description"],
//         type: json["type"],
//         deadline: json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
//         status: json["status"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//         employees: json["employees"] == null ? [] : List<UpdatedEmployee>.from(json["employees"]!.map((x) => UpdatedEmployee.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "description": description,
//         "type": type,
//         "deadline": deadline?.toIso8601String(),
//         "status": status,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
//     };
// }

// class UpdatedEmployee {
//     int? id;
//     String? name;
//     String? email;
//     String? contactNumber;
//     String? designation;
//     String? employeeId;
//     String? username;
//     dynamic imagePath;
//     String? role;
//     DateTime? createdAt;
//     DateTime? updatedAt;
//     UpdatedPivot? pivot;

//     UpdatedEmployee({
//         this.id,
//         this.name,
//         this.email,
//         this.contactNumber,
//         this.designation,
//         this.employeeId,
//         this.username,
//         this.imagePath,
//         this.role,
//         this.createdAt,
//         this.updatedAt,
//         this.pivot,
//     });

//     factory UpdatedEmployee.fromJson(Map<String, dynamic> json) => UpdatedEmployee(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         contactNumber: json["contact_number"],
//         designation: json["designation"],
//         employeeId: json["employee_id"],
//         username: json["username"],
//         imagePath: json["image_path"],
//         role: json["role"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//         pivot: json["pivot"] == null ? null : UpdatedPivot.fromJson(json["pivot"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "contact_number": contactNumber,
//         "designation": designation,
//         "employee_id": employeeId,
//         "username": username,
//         "image_path": imagePath,
//         "role": role,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "pivot": pivot?.toJson(),
//     };
// }

// class UpdatedPivot {
//     int? taskId;
//     int? employeeId;

//     UpdatedPivot({
//         this.taskId,
//         this.employeeId,
//     });

//     factory UpdatedPivot.fromJson(Map<String, dynamic> json) => UpdatedPivot(
//         taskId: json["task_id"],
//         employeeId: json["employee_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "task_id": taskId,
//         "employee_id": employeeId,
//     };
// }
