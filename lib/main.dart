import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/app_bindings.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'styles/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.leftToRightWithFade,
      debugShowCheckedModeBanner: false,
      // initialRoute: AppRoutes.INTRO_PAGE,
      getPages: AppPages.pages,
      builder: BotToastInit(),
      initialBinding: AppBindings(),
      theme: ThemeData(
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: AppColors.white,
          headerBackgroundColor: AppColors.blue,
          headerForegroundColor: AppColors.white,
        ),
        colorScheme: const ColorScheme.light(
            outlineVariant:
                Colors.transparent, // this is to remove unnecessary divider lines in datePicker dialogs and all
            primary: AppColors.blue,
            surface: AppColors.white),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.INTRO_PAGE ,
      // home: const IntroPage(),
    );
  }
}

