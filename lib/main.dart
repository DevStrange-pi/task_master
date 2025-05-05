
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:task_master/network/http_overrides.dart';

import 'bindings/app_bindings.dart';
import 'constants/strings.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'styles/colors.dart';
import 'utilities/circular_loader.dart';


String? logo;
String? flavor;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await envConfig();
  SharedPreferences? prefs;
  prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(SpString.token) ?? "";
  String? role = prefs.getString(SpString.role) ?? "";
  // HttpOverrides.global = MyHttpOverrides();
  Get.put(CircularLoader());
  runApp(MyApp(token: token, role: role));
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
}
class MyApp extends StatelessWidget {
  final String? token;
  final String? role;
  const MyApp({super.key, this.token, this.role});

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
            outlineVariant: Colors
                .transparent, // this is to remove unnecessary divider lines in datePicker dialogs and all
            primary: AppColors.blue,
            surface: AppColors.white),
        useMaterial3: true,
      ),
      initialRoute: token != null && token!.isNotEmpty
          ? role != null && role!.isNotEmpty
              ? role == "admin"
                  ? AppRoutes.homePage
                  : AppRoutes.employeeHomePage
              : AppRoutes.introPage
          : AppRoutes.introPage,
      // home: const IntroPage(),
    );
  }
}
