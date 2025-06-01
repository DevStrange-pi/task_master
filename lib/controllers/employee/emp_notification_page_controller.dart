import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_url.dart';
import '../../constants/strings.dart';
import '../../network/http_req.dart';
import '../../utilities/circular_loader.dart';
import '../../utilities/utilities.dart';

class NotificationsResponse {
  final String status;
  final List<NotificationItem> notifications;

  NotificationsResponse({
    required this.status,
    required this.notifications,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      status: json['status'] ?? '',
      notifications: (json['data']['notifications'] as List)
          .map((e) => NotificationItem.fromJson(e))
          .toList(),
    );
  }
}
class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String type;
  final int recipientId;
  final String recipientType;
  final Map<String, dynamic>? data;
  final DateTime sentAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.recipientId,
    required this.recipientType,
    this.data,
    required this.sentAt,
    required this.createdAt,
    required this.updatedAt,
    this.read = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      recipientId: json['recipient_id'] ?? 0,
      recipientType: json['recipient_type'] ?? '',
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      sentAt: DateTime.parse(json['sent_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'recipient_id': recipientId,
        'recipient_type': recipientType,
        'data': data,
        'sent_at': sentAt.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'read': read,
      };
}

class EmpNotificationPageController extends GetxController {
  SharedPreferences? prefs;
  CircularLoader circularLoader = Get.find<CircularLoader>();

  RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  RxInt notificationCount = 0.obs;
  RxBool isLoading = false.obs;

  int get unreadCount => notifications.where((n) => !n.read).length;

  @override
  void onInit() {
    super.onInit();
    initAsync();
    markAllAsRead();
  }

  void initAsync() async {
    prefs = await SharedPreferences.getInstance();
    await fetchNotifications();
  }

  void addNotification(NotificationItem notification) {
    notifications.insert(0, notification);
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.read = true;
    }
    notifications.refresh();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    circularLoader.showCircularLoader();
    String token = prefs!.getString(SpString.token) ?? "";
    var headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    var resp = await HttpReq.getApi(
      apiUrl: AppUrl().getNotifications,
      headers: headers,
    );
    var respBody = json.decode(resp!.body);
    if (resp.statusCode == 200) {
      isLoading.value = false;
      circularLoader.hideCircularLoader();
      notifications.value = NotificationsResponse.fromJson(respBody).notifications;
      notificationCount.value = notifications.length;
    } else {
      isLoading.value = false;
      circularLoader.hideCircularLoader();
      myBotToast(respBody["message"]);
    }
  }
}
