import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/network/http_overrides.dart';

import 'bindings/app_bindings.dart';
import 'constants/strings.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'styles/colors.dart';
import 'utilities/circular_loader.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences? prefs;
  prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(SpString.token) ?? "";
  HttpOverrides.global = MyHttpOverrides();
  Get.put(CircularLoader());
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key,this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.leftToRightWithFade,
      debugShowCheckedModeBanner: false,
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
      initialRoute:token != null && token!.isNotEmpty ? AppRoutes.homePage : AppRoutes.introPage,
      // home: const IntroPage(),
    );
  }
}

