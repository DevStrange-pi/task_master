import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/employee/emp_add_task_page_controller.dart';
import '../../styles/colors.dart';
import '../../widgets/child_app_bar.dart';
import '../../widgets/speed_button.dart';
import '../../widgets/speed_dropdown.dart';
import '../../widgets/speed_multi_dropdown.dart';
import '../../widgets/speed_textfield.dart';

class EmpAddTaskPage extends StatelessWidget {
  EmpAddTaskPage({super.key});
  final EmpAddTaskPageController empAddTaskPageController =
      Get.find<EmpAddTaskPageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: empAddTaskPageController.canPop.value,
        onPopInvokedWithResult: (didPop, result) {
          if (empAddTaskPageController.multiSelectController.isOpen) {
            if (!didPop) {
              empAddTaskPageController.multiSelectController.closeDropdown();
            }
          }
        },
        child: GestureDetector(
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
                      "Add a Task",
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
                          empAddTaskPageController.taskNameController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SpeedTextfield(
                      isTextArea: true,
                      labelText: "Description",
                      hintText: "Type here...",
                      textEditingController:
                          empAddTaskPageController.descController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SpeedDropdown(
                      labelText: "Task Type",
                      dropdownItems:
                          empAddTaskPageController.taskTypeDropdownOptions,
                      selectedValue: empAddTaskPageController.taskTypeSelected,
                      onChanged: (val) {
                        empAddTaskPageController.taskTypeSelected = val;
                        if (val == "Daily") {
                          empAddTaskPageController.setDeadlineToTodayMidnight();
                        }else {
                          empAddTaskPageController.enableDeadlineField();
                        }
                      },
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
                      textEditingController: empAddTaskPageController.dateCont,
                      isDateTimePicker: true,
                      isEnabled: !empAddTaskPageController.isDeadlineDisabled.value,
                      fieldOnTap: empAddTaskPageController.isDeadlineDisabled.value
                          ? null
                          : () {
                              empAddTaskPageController.showDateTimePicker();
                            },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => SpeedMultiDropdown(
                        multiSelectController:
                            empAddTaskPageController.multiSelectController,
                        labelText: "Whom to Assign",
                        dropdownItems:
                            // ignore: invalid_use_of_protected_member
                            empAddTaskPageController.assignDropdownOptions.value,
                        selectedValues: empAddTaskPageController.assignSelected,
                        onChanged: (val) {
                          debugPrint("OnSelectionChange: $val");
                          empAddTaskPageController
                              .createSelectedDropdownOptions(val);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SpeedButton(
                      buttonText: "Submit",
                      onPressed: () {
                        empAddTaskPageController.onSubmitPressed();
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
