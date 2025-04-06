import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/add_profile_controller.dart';
import 'package:task_master/widgets/scaffold_main.dart';
import 'package:task_master/widgets/speed_button.dart';
import 'package:task_master/widgets/speed_textfield.dart';

class AddProfilePage extends StatelessWidget {
  AddProfilePage({super.key});
  final AddProfileController addProfileController =
      Get.find<AddProfileController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScaffoldMain(
        title: "Add Profile",
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SpeedTextfield(
                  labelText: "Name",
                  hintText: "Type here...",
                  textEditingController: addProfileController.nameController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedTextfield(
                  labelText: "Email ID",
                  hintText: "Type here...",
                  textEditingController: addProfileController.emailController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedTextfield(
                  labelText: "Contact Number",
                  hintText: "Type here...",
                  textEditingController: addProfileController.mobileController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedTextfield(
                  labelText: "Designation",
                  hintText: "Type here...",
                  textEditingController:
                      addProfileController.designationController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedTextfield(
                  labelText: "Employee ID",
                  hintText: "Type here...",
                  textEditingController:
                      addProfileController.employeeIdController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedTextfield(
                  labelText: "Username",
                  hintText: "Type here...",
                  textEditingController:
                      addProfileController.usernameController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedTextfield(
                  labelText: "Password",
                  hintText: "Type here...",
                  textEditingController:
                      addProfileController.passwordController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedButton(
                  buttonText: "Upload Photo",
                  onPressed: () {},
                ),
                 const SizedBox(
                  height: 16,
                ),
                //TODO: uploaded photo thumbnail here
                 const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 28,
                ),
                SpeedButton(
                  buttonText: "Submit",
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}
