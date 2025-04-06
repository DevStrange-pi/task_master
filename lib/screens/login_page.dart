import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_page_controller.dart';
import '../routes/app_routes.dart';
import '../styles/colors.dart';
import '../widgets/speed_button.dart';
import '../widgets/speed_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final loginPageController = Get.find<LoginPageController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.blue,
        body: Center(
          child: Container(
            // elevation: 16,
            decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.7),
                  ),
                ]),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  SpeedTextfield(
                    isPasswordHidden: false,
                    needPrefixIcon: true,
                    prefixIconData: Icons.email_sharp,
                    labelText: "Email",
                    hintText: "Type here...",
                    textEditingController: loginPageController.emailController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Obx(
                    () => SpeedTextfield(
                      needPrefixIcon: true,
                      needSuffixIcon: true,
                      isPasswordHidden: loginPageController.isPasswordHidden.value,
                      prefixIconData: Icons.key_sharp,
                      suffixIconData: loginPageController.isPasswordHidden.value
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye_rounded,
                      labelText: "Password",
                      hintText: "Type here...",
                      textEditingController: loginPageController.passController,
                      suffixIconOnPressed: () {
                        loginPageController.togglePasswordVisibility();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Obx(
                    () => Center(
                      child: SpeedButton(
                        needLoader: loginPageController.needLoader.value,
                        buttonText: "Login",
                        onPressed: () async {
                          Get.offAllNamed(AppRoutes.HOME_PAGE);
                          // await loginPageController.login();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // Center(
                  //   child: Column(
                  //     children: [
                  //       const Text(
                  //           "Done have an account?",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             color: AppColors.darkGrey,
                  //             // Colors.redAccent,
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 16,
                  //           ),
                  //         ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           Get.to(() => RegisterPage());
                  //         },
                  //         child: const Text(
                  //           "Register Now",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             color: 
                  //             Colors.redAccent,
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 16,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
