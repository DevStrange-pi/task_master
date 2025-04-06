import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/assign_task_controller.dart';
import 'package:task_master/styles/colors.dart';
import 'package:task_master/widgets/child_app_bar.dart';
import 'package:task_master/widgets/speed_button.dart';
import 'package:task_master/widgets/speed_dropdown.dart';
import 'package:task_master/widgets/speed_textfield.dart';

class AssignTaskPage extends StatelessWidget {
  AssignTaskPage({super.key});
  final AssignTaskController assignTaskController =
      Get.find<AssignTaskController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const ChildAppBar(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Assign a Task",
                  style: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 32),
                ),
                const SizedBox(
                  height: 12,
                ),
                SpeedTextfield(
                  labelText: "Task Name",
                  hintText: "Type here...",
                  textEditingController:
                      assignTaskController.taskNameController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedTextfield(
                  isTextArea: true,
                  labelText: "Description",
                  hintText: "Type here...",
                  textEditingController: assignTaskController.descController,
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedDropdown(
                  labelText: "Task Type",
                  dropdownItems: assignTaskController.taskTypeDropdownOptions,
                  selectedValue: assignTaskController.taskTypeSelected,
                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedTextfield(
                  isPasswordHidden: false,
                  needSuffixIcon: true,
                  suffixIconData: Icons.calendar_month_sharp,
                  labelText: "Deadline Date Time",
                  hintText: "Select here...",
                  textEditingController: assignTaskController.dateCont,
                  isDateTimePicker: true,
                  fieldOnTap: () {
                    assignTaskController.showDateTimePicker();
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                SpeedDropdown(
                  labelText: "Whom to Assign",
                  dropdownItems: assignTaskController.assignDropdownOptions,
                  selectedValue: assignTaskController.assignSelected,
                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 32,
                ),
                SpeedButton(
                  buttonText: "Submit",
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
