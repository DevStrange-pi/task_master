// To parse this JSON data, do
//
//     final taskDetailsResponseModel = taskDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'all_tasks_response_model.dart';

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
