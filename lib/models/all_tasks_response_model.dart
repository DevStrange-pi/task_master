// To parse this JSON data, do
//
//     final allTasksResponseModel = allTasksResponseModelFromJson(jsonString);

import 'dart:convert';

AllTasksResponseModel allTasksResponseModelFromJson(String str) => AllTasksResponseModel.fromJson(json.decode(str));

String allTasksResponseModelToJson(AllTasksResponseModel data) => json.encode(data.toJson());

class AllTasksResponseModel {
    String? status;
    Data? data;

    AllTasksResponseModel({
        this.status,
        this.data,
    });

    factory AllTasksResponseModel.fromJson(Map<String, dynamic> json) => AllTasksResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    List<Task>? tasks;

    Data({
        this.tasks,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        tasks: json["tasks"] == null ? [] : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
    };
}

class Task {
    int? id;
    int? taskId;
    int? taskNo;
    String? name;
    String? description;
    String? type;
    List<String>? assignedTo;
    DateTime? deadline;
    String? status;
    DateTime? createdAt;
    int? createdBy;
    DateTime? updatedAt;
    int? expiredCount; 
    List<Employee>? employees;
    List<dynamic>? photos;

    Task({
        this.id,
        this.taskId,
        this.taskNo,
        this.name,
        this.description,
        this.type,
        this.assignedTo,
        this.deadline,
        this.status,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.expiredCount,
        this.employees,
        this.photos
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        taskId: json["task_id"],
        taskNo: json["task_no"],
        name: json["name"],
        description: json["description"],
        type: json["type"],
        assignedTo: json["assigned_to"] == null ? [] : List<String>.from(json["assigned_to"]!),
        deadline: json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        expiredCount: json["expired_count"],
        employees: json["employees"] == null ? [] : List<Employee>.from(json["employees"]!.map((x) => Employee.fromJson(x))),
        photos: (() {
          final raw = json["photos"];
          if (raw == null || raw == "") return [];
          if (raw is List) {
            return List<String>.from(raw.map((x) => x.toString()));
          }
          if (raw is String) {
            try {
              final decoded = jsonDecode(raw);
              if (decoded is List) {
                return List<String>.from(decoded.map((x) => x.toString()));
              }
            } catch (e) {
              // If it's not a valid JSON string, just return it as a single-item list
              return [raw];
            }
          }
          return [];
        })(),
        // photos: json["photos"] == null || json["photos"] == "" ? [] : List<String>.from(json["photos"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "task_no": taskNo,
        "name": name,
        "description": description,
        "type": type,
        "assigned_to": assignedTo,
        "deadline": deadline?.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt?.toIso8601String(),
        "expired_count": expiredCount,
        "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
        "photos": photos == null
          ? []
          : photos is List<String>
              ? photos
              : List<String>.from(photos!.map((x) => x.toString())),
          };
    bool isNull() {
      return id == null && name == null && description == null && type == null && deadline == null && status == null && createdAt == null && updatedAt == null && employees == null;
    }
}


class Employee {
    int? id;
    String? name;
    String? email;
    String? status;
    int? assignedBy;
    String? contactNumber;
    String? designation;
    String? employeeId;
    String? username;
    dynamic imagePath;
    String? role;
    String? deviceToken;
    DateTime? createdAt;
    DateTime? updatedAt;
    Pivot? pivot;
    LatestLocation? latestLocation;

    Employee({
        this.id,
        this.name,
        this.email,
        this.status,
        this.assignedBy,
        this.contactNumber,
        this.designation,
        this.employeeId,
        this.username,
        this.imagePath,
        this.role,
        this.deviceToken,
        this.createdAt,
        this.updatedAt,
        this.pivot,
        this.latestLocation,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        status: json["status"],
        assignedBy: json["assigned_by"],
        contactNumber: json["contact_number"],
        designation: json["designation"],
        employeeId: json["employee_id"],
        username: json["username"],
        imagePath: json["image_path"],
        role: json["role"],
        deviceToken: json["device_token"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
        latestLocation: json["latest_location"] == null ? null : LatestLocation.fromJson(json["latest_location"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "status": status,
        "assigned_by": assignedBy,
        "contact_number": contactNumber,
        "designation": designation,
        "employee_id": employeeId,
        "username": username,
        "image_path": imagePath,
        "role": role,
        "device_token": deviceToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
    };
}

class LatestLocation {
  int? id;
  int? employeeId;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;

  LatestLocation({
    this.id,
    this.employeeId,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory LatestLocation.fromJson(Map<String, dynamic> json) => LatestLocation(
        id: json["id"],
        employeeId: json["employee_id"],
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"] ,
        // != null
        //     ? double.tryParse(json["latitude"].toString())
        //     : null,
        longitude: json["longitude"] ,
        // != null
        //     ? double.tryParse(json["longitude"].toString())
        //     : null,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "name": name,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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

