import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../styles/colors.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                LOGO,
                height: 32,
              ),
            ),
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.lightestBlue,
              child: Image.asset(
                PROFILE,
                height: 32,
              ),
            )
          ],
        ),
      );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(100);
}