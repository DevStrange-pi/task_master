// To parse this JSON data, do
//
//     final createTaskResponseModel = createTaskResponseModelFromJson(jsonString);

import 'dart:convert';

import 'all_tasks_response_model.dart';

CreateTaskResponseModel createTaskResponseModelFromJson(String str) => CreateTaskResponseModel.fromJson(json.decode(str));

String createTaskResponseModelToJson(CreateTaskResponseModel data) => json.encode(data.toJson());

class CreateTaskResponseModel {
    String? status;
    String? message;
    TaskCreatedData? data;

    CreateTaskResponseModel({
        this.status,
        this.message,
        this.data,
    });

    factory CreateTaskResponseModel.fromJson(Map<String, dynamic> json) => CreateTaskResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : TaskCreatedData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class TaskCreatedData {
    Task? task;

    TaskCreatedData({
        this.task,
    });

    factory TaskCreatedData.fromJson(Map<String, dynamic> json) => TaskCreatedData(
        task: json["task"] == null ? null : Task.fromJson(json["task"]),
    );

    Map<String, dynamic> toJson() => {
        "task": task?.toJson(),
    };
}

