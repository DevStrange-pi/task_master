import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';
import '../routes/app_routes.dart';
import '../styles/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  String? token;
  String? role;
  SharedPreferences? prefs;
  int splashTime = 3;
  bool openedSettings = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initAsync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (openedSettings && state == AppLifecycleState.resumed) {
      openedSettings = false;
      initAsync();
    }
  }

  void initAsync() async {
    await Future.delayed(Duration(seconds: splashTime));
    await requestPermissions();
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString(SpString.token) ?? "";
    role = prefs!.getString(SpString.role) ?? "";

    // Only navigate if permission is granted
    if (await ensureLocationPermission()) {
      token != null && token!.isNotEmpty
          ? role != null && role!.isNotEmpty
              ? role == "super_admin"
                  ? Get.offAllNamed(AppRoutes.homePage)
                  : role == "admin"
                      ? Get.offAllNamed(AppRoutes.adminHomePage)
                      : Get.offAllNamed(AppRoutes.employeeHomePage)
                : Get.offAllNamed(AppRoutes.introPage)
          : Get.offAllNamed(AppRoutes.introPage);
    }
  }

  Future<void> requestPermissions() async {
    await [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.notification, // For Android 13+
      Permission.locationAlways
    ].request();
    // final status = await Permission.locationAlways.request();
    // debugPrint("Location Permission Granted: ${status.isGranted}");
  }

  Future<bool> ensureLocationPermission() async {
    var status = await Permission.locationAlways.status;

    bool isAllTime = false;
    if (GetPlatform.isAndroid) {
      isAllTime = status.isGranted &&
          (await Permission.locationWhenInUse.status).isGranted &&
          (await Permission.location.status).isGranted;
    } else if (GetPlatform.isIOS) {
      isAllTime = status.isGranted &&
          (await Permission.locationWhenInUse.status).isGranted;
    } else {
      isAllTime = status.isGranted;
    }

    if (isAllTime) return true;

    // Request permission
    status = await Permission.locationAlways.request();

    // Re-check after request
    if (GetPlatform.isAndroid) {
      isAllTime = status.isGranted &&
          (await Permission.locationWhenInUse.status).isGranted &&
          (await Permission.location.status).isGranted;
    } else if (GetPlatform.isIOS) {
      isAllTime = status.isGranted &&
          (await Permission.locationWhenInUse.status).isGranted;
    } else {
      isAllTime = status.isGranted;
    }

    if (isAllTime) return true;

    // Show dialog and redirect to settings or close app
    bool openSettings = await showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'This app requires location permission "Allow all the time" to function.\n\n'
              'Please select "Allow all the time" in app settings.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
    if (openSettings == true) {
      openedSettings = true;
      await openAppSettings();
      // Do not return true yet, wait for app to resume and check again
      return false;
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightBlue, AppColors.blue],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/splash.gif',
            width: 280,
            height: 280,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
