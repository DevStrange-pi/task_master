import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:task_master/widgets/child_app_bar.dart';

import '../../controllers/employee/emp_notification_page_controller.dart';
import '../../styles/colors.dart';

class EmpNotificationPage extends StatelessWidget {
  EmpNotificationPage({super.key});
  final statusBarHeight =
      MediaQueryData.fromView(ui.PlatformDispatcher.instance.implicitView!)
          .padding
          .top;
  final EmpNotificationPageController empNotificationPageController =
      Get.find<EmpNotificationPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(
        title: 'Notifications',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await empNotificationPageController.fetchNotifications();
        },
        child: Obx(() {
          if (empNotificationPageController.notifications.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height - 80 - statusBarHeight,
                  child: Center(
                      child: Text(
                    'No notifications',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: empNotificationPageController.isLoading.value
                          ? Colors.transparent
                          : AppColors.darkGrey,
                    ),
                  )),
                ),
              ],
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: empNotificationPageController.notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  empNotificationPageController.notifications[index];
              return ListTile(
                visualDensity: const VisualDensity(horizontal: 4, vertical: 4),
                title: Text(
                  notification.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue),
                ),
                subtitle: Text(
                  notification.body,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightBlue),
                ),
                trailing: Text(
                  '${notification.sentAt.day}/${notification.sentAt.month}/${notification.sentAt.year} ${notification.sentAt.hour.toString().padLeft(2, '0')}:${notification.sentAt.minute.toString().padLeft(2, '0')}',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.darkGrey),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.grey,
              thickness: 1,
              height: 16,
            ),
          );
        }),
      ),
    );
  }
}
