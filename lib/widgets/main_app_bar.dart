import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/utilities/utilities.dart';

import '../constants/assets.dart';
import '../main.dart';
import '../styles/colors.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function()? onBackPressed;
  final bool? isHome;
  final bool isNotificationsVisible;
  final void Function()? onNotificationsPressed;
  final int notificationCount;
  const MainAppBar(
      {super.key,
      this.onBackPressed,
      this.isHome,
      this.isNotificationsVisible = false,
      this.onNotificationsPressed,
      this.notificationCount = 0});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isHome != null
          ? null
          : IconButton(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: onBackPressed ??
                  () {
                    Get.back();
                  },
            ),
      toolbarHeight: 100,
      backgroundColor: AppColors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: AppColors.black,
            ),
            child: Image.asset(
              logo!,
              height: 24,
            ),
          ),
          Row(
            children: [
              isNotificationsVisible
                  ? Stack(
                      children: [
                        IconButton(
                          onPressed: onNotificationsPressed,
                          icon: const Icon(
                            Icons.notifications,
                            color: AppColors.amber,
                            size: 40,
                          ),
                        ),
                        notificationCount > 0
                            ? Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    notificationCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(width: 8),
              // Profile Icon
              PopupMenuButton<String>(
                borderRadius: BorderRadius.circular(32),
                offset: const Offset(0, 65),
                color: Colors.white, // Popup background color
                onSelected: (value) async {
                  if (value == 'logout') {
                    await AppUtility().logout();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    height: 16,
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
                // Remove default splash/highlight by wrapping with InkWell
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.lightestBlue,
                    child: Image.asset(
                      profileAsset,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
