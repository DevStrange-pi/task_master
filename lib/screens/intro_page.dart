import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/assets.dart';
import '../routes/app_routes.dart';
import '../styles/colors.dart';
import '../widgets/speed_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: AppColors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Image.asset(
                    LOGO,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 32.0,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Building Your Empire with",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                  ),
                ),
                const Text(
                  "Speedup Infotech",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const SizedBox(
                  height: 25,
                ),
                SpeedButton(
                  invertedColors: true,
                  buttonText: "Get Started",
                  onPressed: () {
                    // routeHistoryController.addRoute(AppRoutes.LOGIN_PAGE,RouteHistoryNames.INITIAL);
                    Get.toNamed(AppRoutes.loginPage);
                    // PersistentNavBarNavigator.pushNewScreen(context, screen: LoginPage());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
