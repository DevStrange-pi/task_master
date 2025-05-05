import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/assets.dart';
import '../styles/colors.dart';

class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChildAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: 80 + statusBarHeight,
      padding: EdgeInsets.fromLTRB(12, statusBarHeight, 12, 0),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.lightBlue, AppColors.blue],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
                padding: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 28,
                )),
          ),
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.lightestBlue,
            child: Image.asset(
              profileAsset,
              height: 28,
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
