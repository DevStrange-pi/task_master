// To parse this JSON data, do
//
//     final empLocationTrackResponseModel = empLocationTrackResponseModelFromJson(jsonString);

import 'dart:convert';

EmpLocationTrackResponseModel empLocationTrackResponseModelFromJson(String str) => EmpLocationTrackResponseModel.fromJson(json.decode(str));

String empLocationTrackResponseModelToJson(EmpLocationTrackResponseModel data) => json.encode(data.toJson());

class EmpLocationTrackResponseModel {
    String? status;
    LocationData? data;

    EmpLocationTrackResponseModel({
        this.status,
        this.data,
    });

    factory EmpLocationTrackResponseModel.fromJson(Map<String, dynamic> json) => EmpLocationTrackResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : LocationData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class LocationData {
    int? employeeId;
    double? latitude;
    double? longitude;
    String? name;
    String? address;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    LocationData({
        this.employeeId,
        this.latitude,
        this.longitude,
        this.name,
        this.address,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        employeeId: json["employee_id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        name: json["name"],
        address: json["address"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "latitude": latitude,
        "longitude": longitude,
        "name": name,
        "address": address,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
