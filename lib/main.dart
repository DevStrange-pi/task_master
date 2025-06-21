import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/constants/strings.dart';
// import 'package:task_master/network/http_overrides.dart';

// import 'bindings/app_bindings.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/notification_service.dart';
import 'styles/colors.dart';
import 'utilities/circular_loader.dart';

String? logo;
String? flavor;
SharedPreferences? prefs;
RxInt unreadCount = 0.obs;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await envConfig();
  prefs = await SharedPreferences.getInstance();
  // HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseMessaging.instance.getToken().then((token) {
    print("Firebase Messaging Token: $token");
    prefs!.setString(SpString.fcmToken, token!);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(CircularLoader());
 
  runApp(const MyApp());
}

Future<void> requestStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    // Permission granted, proceed
  } else {
    // Show dialog or handle denied permissions
  }
}

Future<void> envConfig() async {
  flavor = const String.fromEnvironment('FLAVOR');
  switch (flavor) {
    case 'speedup':
      logo = 'assets/logo_speedup.png';
      break;
    case 'fortunecloud':
      logo = 'assets/logo_fortunecloud.jpg';
      break;
    case 'fortunecloudpcmc':
      logo = 'assets/logo_fortunecloudpcmc.jpg';
      break;
    default:
      logo = 'assets/logo_speedup.png'; // fallback
  }
  await dotenv.load(fileName: ".env.$flavor");
  // Save baseUrl to SharedPreferences for background isolate
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('BASE_URL', dotenv.env['BASE_URL'] ?? '');
  prefs.setString('FLAVOR', flavor ?? "speedup");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationService().init(context);
    return GetMaterialApp(
        defaultTransition: Transition.leftToRightWithFade,
        debugShowCheckedModeBanner: false,
        getPages: AppPages.pages,
        builder: BotToastInit(),
        // initialBinding: AppBindings(),
        theme: ThemeData(
          datePickerTheme: const DatePickerThemeData(
            backgroundColor: AppColors.white,
            headerBackgroundColor: AppColors.blue,
            headerForegroundColor: AppColors.white,
          ),
          colorScheme: const ColorScheme.light(
              outlineVariant: Colors
                  .transparent, // this is to remove unnecessary divider lines in datePicker dialogs and all
              primary: AppColors.blue,
              surface: AppColors.white),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.splashPage

        // home: const IntroPage(),
        );
  }

}
