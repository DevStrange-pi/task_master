// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/task_details_controller.dart';
import 'package:task_master/widgets/speed_multi_dropdown.dart';

import '../styles/colors.dart';
import '../widgets/child_app_bar.dart';
import '../widgets/speed_button.dart';
import '../widgets/speed_dropdown.dart';
import '../widgets/speed_textfield.dart';

class TaskDetailsPage extends StatelessWidget {
  TaskDetailsPage({super.key});

  final TaskDetailsController taskDetailsController =
      Get.find<TaskDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: taskDetailsController.canPop.value,
        onPopInvokedWithResult: (didPop, result) {
          if (taskDetailsController.multiSelectController.isOpen) {
            if (!didPop) {
              taskDetailsController.multiSelectController.closeDropdown();
            }
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: const ChildAppBar(),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: taskDetailsController.task!.value.isNull()
                  ? const SizedBox()
                  : RefreshIndicator(
                      onRefresh: () async {
                        taskDetailsController.initAsync();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                                  taskDetailsController.taskNameController,
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
                                  taskDetailsController.descController,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Obx(
                              () => SpeedDropdown(
                                enabled: taskDetailsController.statusFlag,
                                labelText: "Task Type",
                                dropdownItems: taskDetailsController
                                    .taskTypeDropdownOptions,
                                selectedValue: taskDetailsController
                                    .taskTypeSelected.value,
                                onChanged: (val) {
                                  taskDetailsController.taskTypeSelected.value =
                                      val;
                                  taskDetailsController.setDefaultDeadlineForTaskType(val);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Obx(
                              () => SpeedDropdown(
                                enabled: taskDetailsController.statusFlag,
                                labelText: "Status",
                                dropdownItems: taskDetailsController.taskStatus,
                                selectedValue: taskDetailsController
                                    .taskStatusSelected.value,
                                onChanged: (val) {
                                  taskDetailsController
                                      .taskStatusSelected.value = val;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            Obx(() {
                              if (taskDetailsController
                                      .taskTypeSelected.value ==
                                  "Weekly" && taskDetailsController.statusFlag) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.lightBlue,
                                            width: 2,
                                          ),
                                        ),
                                        labelText: "Select Weekday",
                                        labelStyle: TextStyle(
                                            color: AppColors.lightBlue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.lightBlue,
                                          ),
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      value: taskDetailsController
                                              .selectedWeekday ??
                                          taskDetailsController.weekdays[0],
                                      items: taskDetailsController.weekdays
                                          .map((day) {
                                        return DropdownMenuItem<String>(
                                          value: day,
                                          child: Text(day),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          taskDetailsController
                                              .selectedWeekday = val;
                                          DateTime nextDate =
                                              taskDetailsController
                                                  .getNextWeekdayDate(val);
                                          DateTime deadline = DateTime(
                                              nextDate.year,
                                              nextDate.month,
                                              nextDate.day,
                                              19,
                                              0,
                                              0);
                                          taskDetailsController.dateCont.text =
                                              '$val 7:00 PM';
                                          taskDetailsController
                                              .weeklyDeadlineForApi = deadline;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    TextField(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      enabled: false,
                                      controller:
                                          taskDetailsController.dateCont,
                                      decoration: const InputDecoration(
                                        labelText: "Deadline",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: AppColors.grey,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SpeedTextfield(
                                  isEnabled: taskDetailsController.statusFlag,
                                  isPasswordHidden: false,
                                  needSuffixIcon: true,
                                  suffixIconData: Icons.calendar_month_sharp,
                                  labelText: "Deadline Date Time",
                                  hintText: "Select here...",
                                  textEditingController:
                                      taskDetailsController.dateCont,
                                  isDateTimePicker: true,
                                  fieldOnTap: () {
                                    taskDetailsController.showDateTimePicker();
                                  },
                                );
                              }
                            }),
                            const SizedBox(
                              height: 16,
                            ),
                            Obx(
                              () => SpeedMultiDropdown(
                                enabled: taskDetailsController.statusFlag,
                                multiSelectController:
                                    taskDetailsController.multiSelectController,
                                labelText: "Whom to Assign",
                                dropdownItems: taskDetailsController
                                    .assignDropdownOptions.value,
                                selectedValues:
                                    taskDetailsController.assignSelected,
                                onChanged: (val) {
                                  taskDetailsController
                                      .storeSelectedValues(val);
                                  debugPrint("OnSelectionChange: $val");
                                  debugPrint(
                                      "assignSelected: ${taskDetailsController.assignSelected}");
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Visibility(visible: !taskDetailsController.statusFlag, child: Obx(() => buildPhotoThumbnails(context))),
                            const SizedBox(
                              height: 32,
                            ),
                            SpeedButton(
                              isDisabled: !taskDetailsController.statusFlag,
                              buttonText: "Update",
                              onPressed: () {
                                taskDetailsController.onUpdatePressed();
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
      ),
    );
  }

  Widget buildPhotoThumbnails(BuildContext context) {
    final photos = taskDetailsController.photoBase64List;
    if (photos.isEmpty) return const SizedBox();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: photos.map<Widget>((base64Str) {
        final cleanedBase64 = base64Str.contains(';')
            ? base64Str.split(';').last
            : base64Str.replaceAll('\\', '');
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: InteractiveViewer(
                  child: Image.memory(
                    base64Decode(cleanedBase64.contains(',')
                        ? cleanedBase64.split(',').last
                        : cleanedBase64),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              base64Decode(cleanedBase64.contains(',')
                  ? cleanedBase64.split(',').last
                  : cleanedBase64),
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}
