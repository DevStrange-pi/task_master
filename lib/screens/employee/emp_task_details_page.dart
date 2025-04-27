// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/employee/emp_task_details_page_controller.dart';
import '../../widgets/child_app_bar.dart';
import '../../widgets/speed_button.dart';
import '../../widgets/speed_dropdown.dart';
import '../../widgets/speed_multi_dropdown.dart';
import '../../widgets/speed_textfield.dart';

class EmpTaskDetailsPage extends StatelessWidget {
  EmpTaskDetailsPage({super.key});
  final EmpTaskDetailsPageController empTaskDetailsPageController =
      Get.find<EmpTaskDetailsPageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: empTaskDetailsPageController.canPop.value,
        onPopInvokedWithResult: (didPop, result) {
          if (empTaskDetailsPageController.multiSelectController.isOpen) {
            if (!didPop) {
              empTaskDetailsPageController.multiSelectController
                  .closeDropdown();
            }
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: const ChildAppBar(),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: empTaskDetailsPageController.task.value.isNull()
                  ? const SizedBox()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          SpeedTextfield(
                            isEnabled: false,
                            labelText: "Task Name",
                            hintText: "Type here...",
                            textEditingController:
                                empTaskDetailsPageController.taskNameController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SpeedTextfield(
                            isEnabled: false,
                            isTextArea: true,
                            labelText: "Description",
                            hintText: "Type here...",
                            textEditingController:
                                empTaskDetailsPageController.descController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(
                            () => SpeedDropdown(
                              enabled:
                                  empTaskDetailsPageController.statusFlag! &&
                                      !empTaskDetailsPageController.isEmployee,
                              labelText: "Task Type",
                              dropdownItems: empTaskDetailsPageController
                                  .taskTypeDropdownOptions,
                              selectedValue: empTaskDetailsPageController
                                  .taskTypeSelected.value,
                              onChanged: (val) {
                                empTaskDetailsPageController
                                    .taskTypeSelected.value = val;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(
                            () => SpeedDropdown(
                              enabled: empTaskDetailsPageController
                                      .statusFlag! &&
                                  empTaskDetailsPageController.isEmployee &&
                                  !empTaskDetailsPageController
                                      .isMultiDropdownValueChanged.value,
                              labelText: "Status",
                              dropdownItems:
                                  empTaskDetailsPageController.taskStatus,
                              selectedValue: empTaskDetailsPageController
                                  .taskStatusSelected.value,
                              disabledItems: empTaskDetailsPageController
                                      .isMultiDropdownValueChanged.value
                                  ? []
                                  : empTaskDetailsPageController.disabledItems,
                              onChanged: (val) {
                                empTaskDetailsPageController
                                    .taskStatusSelected.value = val;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SpeedTextfield(
                            isEnabled:
                                empTaskDetailsPageController.statusFlag! &&
                                    !empTaskDetailsPageController.isEmployee,
                            isPasswordHidden: false,
                            needSuffixIcon: true,
                            suffixIconData: Icons.calendar_month_sharp,
                            labelText: "Deadline Date Time",
                            hintText: "Select here...",
                            textEditingController:
                                empTaskDetailsPageController.dateCont,
                            isDateTimePicker: true,
                            fieldOnTap: () {
                              empTaskDetailsPageController.showDateTimePicker();
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SpeedMultiDropdown(
                            enabled: empTaskDetailsPageController.statusFlag! &&
                                empTaskDetailsPageController.isEmployee,
                            multiSelectController: empTaskDetailsPageController
                                .multiSelectController,
                            labelText: "Whom to Assign",
                            dropdownItems: empTaskDetailsPageController
                                .assignDropdownOptions.value,
                            selectedValues:
                                empTaskDetailsPageController.assignSelected,
                            onChanged: (val) {
                              empTaskDetailsPageController
                                  .storeSelectedValues(val);
                              debugPrint("OnSelectionChange: $val");
                              empTaskDetailsPageController
                                  .compareMultiDropdownValues(val);
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          SpeedButton(
                            isDisabled:
                                !empTaskDetailsPageController.statusFlag!,
                            buttonText: "Update",
                            onPressed: () {
                              empTaskDetailsPageController.onUpdatePressed();
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
