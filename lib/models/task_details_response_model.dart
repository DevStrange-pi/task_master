// To parse this JSON data, do
//
//     final taskDetailsResponseModel = taskDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

TaskDetailsResponseModel taskDetailsResponseModelFromJson(String str) => TaskDetailsResponseModel.fromJson(json.decode(str));

String taskDetailsResponseModelToJson(TaskDetailsResponseModel data) => json.encode(data.toJson());

class TaskDetailsResponseModel {
    String? status;
    Data? data;
    String? message;

    TaskDetailsResponseModel({
        this.status,
        this.data,
        this.message,
    });

    factory TaskDetailsResponseModel.fromJson(Map<String, dynamic> json) => TaskDetailsResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    Task? task;

    Data({
        this.task,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        task: json["task"] == null ? null : Task.fromJson(json["task"]),
    );

    Map<String, dynamic> toJson() => {
        "task": task?.toJson(),
    };
}

class Task {
    int? id;
    String? name;
    String? description;
    String? type;
    DateTime? deadline;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<Employee>? employees;

    Task({
        this.id,
        this.name,
        this.description,
        this.type,
        this.deadline,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.employees,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        type: json["type"],
        deadline: json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        employees: json["employees"] == null ? [] : List<Employee>.from(json["employees"]!.map((x) => Employee.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "type": type,
        "deadline": deadline?.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
    };

    bool isNull() {
      return id == null && name == null && description == null && type == null && deadline == null && status == null && createdAt == null && updatedAt == null && employees == null;
    }
}

class Employee {
    int? id;
    String? name;
    String? email;
    String? contactNumber;
    String? designation;
    String? employeeId;
    String? username;
    dynamic imagePath;
    String? role;
    DateTime? createdAt;
    DateTime? updatedAt;
    Pivot? pivot;

    Employee({
        this.id,
        this.name,
        this.email,
        this.contactNumber,
        this.designation,
        this.employeeId,
        this.username,
        this.imagePath,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.pivot,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        contactNumber: json["contact_number"],
        designation: json["designation"],
        employeeId: json["employee_id"],
        username: json["username"],
        imagePath: json["image_path"],
        role: json["role"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "contact_number": contactNumber,
        "designation": designation,
        "employee_id": employeeId,
        "username": username,
        "image_path": imagePath,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
    };
}

class Pivot {
    int? taskId;
    int? employeeId;

    Pivot({
        this.taskId,
        this.employeeId,
    });

    factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        taskId: json["task_id"],
        employeeId: json["employee_id"],
    );

    Map<String, dynamic> toJson() => {
        "task_id": taskId,
        "employee_id": employeeId,
    };
}
