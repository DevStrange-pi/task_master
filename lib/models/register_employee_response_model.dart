// To parse this JSON data, do
//
//     final registerEmployeeResponseModel = registerEmployeeResponseModelFromJson(jsonString);

import 'dart:convert';

RegisterEmployeeResponseModel registerEmployeeResponseModelFromJson(String str) => RegisterEmployeeResponseModel.fromJson(json.decode(str));

String registerEmployeeResponseModelToJson(RegisterEmployeeResponseModel data) => json.encode(data.toJson());

class RegisterEmployeeResponseModel {
    String? status;
    String? message;
    RegisterData? data;

    RegisterEmployeeResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory RegisterEmployeeResponseModel.fromJson(Map<String, dynamic> json) => RegisterEmployeeResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : RegisterData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class RegisterData {
    RegisteredEmployee? employee;
    String? token;

    RegisterData({
        this.employee,
        this.token,
    });

    factory RegisterData.fromJson(Map<String, dynamic> json) => RegisterData(
        employee: json["employee"] == null ? null : RegisteredEmployee.fromJson(json["employee"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "employee": employee?.toJson(),
        "token": token,
    };
}

class RegisteredEmployee {
    String? name;
    String? email;
    String? contactNumber;
    String? designation;
    String? employeeId;
    String? username;
    dynamic imagePath;
    String? role;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    RegisteredEmployee({
        this.name,
        this.email,
        this.contactNumber,
        this.designation,
        this.employeeId,
        this.username,
        this.imagePath,
        this.role,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory RegisteredEmployee.fromJson(Map<String, dynamic> json) => RegisteredEmployee(
        name: json["name"],
        email: json["email"],
        contactNumber: json["contact_number"],
        designation: json["designation"],
        employeeId: json["employee_id"],
        username: json["username"],
        imagePath: json["image_path"],
        role: json["role"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "contact_number": contactNumber,
        "designation": designation,
        "employee_id": employeeId,
        "username": username,
        "image_path": imagePath,
        "role": role,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
