import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/add_task_controller.dart';
import 'package:task_master/styles/colors.dart';
import 'package:task_master/widgets/child_app_bar.dart';
import 'package:task_master/widgets/speed_button.dart';
import 'package:task_master/widgets/speed_dropdown.dart';
import 'package:task_master/widgets/speed_textfield.dart';

import '../widgets/speed_multi_dropdown.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({super.key});
  final AddTaskController addTaskController = Get.find<AddTaskController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: addTaskController.canPop.value,
        onPopInvokedWithResult: (didPop, result) {
          if (addTaskController.multiSelectController.isOpen) {
            if (!didPop) {
              addTaskController.multiSelectController.closeDropdown();
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
                          addTaskController.taskNameController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SpeedTextfield(
                      isTextArea: true,
                      labelText: "Description",
                      hintText: "Type here...",
                      textEditingController: addTaskController.descController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SpeedDropdown(
                      labelText: "Task Type",
                      dropdownItems: addTaskController.taskTypeDropdownOptions,
                      selectedValue: addTaskController.taskTypeSelected.value,
                      onChanged: (val) {
                        addTaskController.taskTypeSelected.value = val;
                        // if (val == "Daily") {
                        //   addTaskController.setDeadlineToTodayMidnight();
                        // }else{
                        //   addTaskController.enableDeadlineField();
                        // }
                        addTaskController.setDefaultDeadlineForTaskType(val);
                      },
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Obx(
                      () => addTaskController.taskTypeSelected.value == "Weekly"
                          ? Column(
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
                                  value: addTaskController.selectedWeekday ??
                                      addTaskController.weekdays[0],
                                  items: addTaskController.weekdays.map((day) {
                                    return DropdownMenuItem<String>(
                                      value: day,
                                      child: Text(day),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      addTaskController.selectedWeekday = val;
                                      DateTime nextDate = addTaskController
                                          .getNextWeekdayDate(val);
                                      DateTime deadline = DateTime(
                                          nextDate.year,
                                          nextDate.month,
                                          nextDate.day,
                                          19,
                                          0,
                                          0);
                                      addTaskController.dateCont.text =
                                          '${val} 7:00 PM';
                                      addTaskController.weeklyDeadlineForApi =
                                          deadline;
                                      print(deadline);
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
                                  controller: addTaskController.dateCont,
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
                            )
                          : SpeedTextfield(
                              isPasswordHidden: false,
                              needSuffixIcon: true,
                              suffixIconData: Icons.calendar_month_sharp,
                              labelText: "Deadline Date Time",
                              hintText: "Select here...",
                              textEditingController: addTaskController.dateCont,
                              isDateTimePicker: true,
                              isEnabled:
                                  !addTaskController.isDeadlineDisabled.value,
                              fieldOnTap: addTaskController
                                      .isDeadlineDisabled.value
                                  ? null
                                  : () {
                                      addTaskController.showDateTimePicker();
                                    },
                            ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => SpeedMultiDropdown(
                        multiSelectController:
                            addTaskController.multiSelectController,
                        labelText: "Whom to Assign",
                        dropdownItems:
                            // ignore: invalid_use_of_protected_member
                            addTaskController.assignDropdownOptions.value,
                        selectedValues: addTaskController.assignSelected,
                        onChanged: (val) {
                          debugPrint("OnSelectionChange: $val");
                          addTaskController.createSelectedDropdownOptions(val);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SpeedButton(
                      buttonText: "Submit",
                      onPressed: () {
                        addTaskController.onSubmitPressed();
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
