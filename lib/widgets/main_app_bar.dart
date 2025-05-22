import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/utilities/utilities.dart';

import '../constants/assets.dart';
import '../main.dart';
import '../styles/colors.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function()? onBackPressed;
  final bool? isHome;
  const MainAppBar({super.key,this.onBackPressed,this.isHome});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isHome !=null ? null:IconButton(
        padding: const EdgeInsets.only(left: 8),
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: onBackPressed ?? () {
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
              height: 32,
            ),
          ),
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
                radius: 32,
                backgroundColor: AppColors.lightestBlue,
                child: Image.asset(
                  profileAsset,
                  height: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
