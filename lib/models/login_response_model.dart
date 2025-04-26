// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    String? status;
    String? message;
    Data? data;

    LoginResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    Employee? employee;
    String? token;
    String? role;

    Data({
        this.employee,
        this.token,
        this.role,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
        token: json["token"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "employee": employee?.toJson(),
        "token": token,
        "role": role,
    };
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
    };
}
