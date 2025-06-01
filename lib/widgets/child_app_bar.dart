import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/assets.dart';
import '../styles/colors.dart';

class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChildAppBar({super.key, this.title});
  final String? title;

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
                padding: const EdgeInsets.only( left: 6),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 28,
                )),
          ),
          title == null
              ? const SizedBox()
              : Text(
                  title!,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
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
