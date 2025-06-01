import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../routes/app_routes.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init(BuildContext context) async {
    // Request permissions
    await _messaging.requestPermission();

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      unreadCount.value++;
      // messages coming here
      _showNotification(message);
    });

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
    //   // Handle background messages
    //   print('Handling a background message: ${message.messageId}');
    // });

    // Handle notification tap when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle navigation or logic here
      _handleNotificationTap(message);
    });

    // Optionally handle notification tap when app is launched from terminated state
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }
  void _handleNotificationTap(RemoteMessage message) {
    // You can check payload here
    print('Notification payload: ${message.data}');
    // Navigate to notification page
    Get.toNamed(AppRoutes.employeeNotificationPage);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}