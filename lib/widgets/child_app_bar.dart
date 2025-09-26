import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/assets.dart';
import '../constants/strings.dart';
import '../styles/colors.dart';
import '../utilities/utilities.dart';

class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChildAppBar({super.key, this.title});
  final String? title;

  Future<String?> _getRoleKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SpString.role); // your key name
  }

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
                padding: const EdgeInsets.only(left: 6),
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
          FutureBuilder(
              future: _getRoleKey(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                final role = snapshot.data ?? "guest";
                return PopupMenuButton<String>(
                  borderRadius: BorderRadius.circular(32),
                  offset: const Offset(0, 65),
                  color: Colors.white, // Popup background color
                  onSelected: (value) async {
                    if (value == 'logout') {
                      await AppUtility().logout();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      height: 16,
                      value: 'role',
                      child: Text(role),
                    ),
                    const PopupMenuItem(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      radius: 28,
                      backgroundColor: AppColors.lightestBlue,
                      child: Image.asset(
                        profileAsset,
                        height: 28,
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
