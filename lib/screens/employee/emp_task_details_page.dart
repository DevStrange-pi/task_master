// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/employee/emp_task_details_page_controller.dart';
import '../../styles/colors.dart';
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
              child: RefreshIndicator(
                onRefresh: () async {
                  await empTaskDetailsPageController.onRefresh();
                },
                child: empTaskDetailsPageController.task.value.isNull()
                    ? const SizedBox()
                    : SingleChildScrollView(
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
                                enabled:
                                    empTaskDetailsPageController.statusFlag! &&
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
                            // Obx(() {
                            //   if (empTaskDetailsPageController.taskTypeSelected.value == "Weekly") {
                            //     return Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         DropdownButtonFormField<String>(
                            //           decoration: const InputDecoration(
                            //             labelText: "Select Weekday",
                            //             border: OutlineInputBorder(),
                            //           ),
                            //           value: empTaskDetailsPageController.selectedWeekday ?? empTaskDetailsPageController.weekdays[0],
                            //           items: empTaskDetailsPageController.weekdays.map((day) {
                            //             return DropdownMenuItem<String>(
                            //               value: day,
                            //               child: Text(day),
                            //             );
                            //           }).toList(),
                            //           onChanged: (val) {
                            //             if (val != null) {
                            //               empTaskDetailsPageController.selectedWeekday = val;
                            //               DateTime nextDate = empTaskDetailsPageController.getNextWeekdayDate(val);
                            //               DateTime deadline = DateTime(nextDate.year, nextDate.month, nextDate.day, 19, 0, 0);
                            //               empTaskDetailsPageController.dateCont.text = '${val} 7:00 PM';
                            //               empTaskDetailsPageController.weeklyDeadlineForApi = deadline;
                            //             }
                            //           },
                            //         ),
                            //         const SizedBox(height: 8),
                            //         TextField(
                            //           enabled: false,
                            //           controller: empTaskDetailsPageController.dateCont,
                            //           decoration: const InputDecoration(
                            //             labelText: "Deadline",
                            //             border: OutlineInputBorder(),
                            //           ),
                            //         ),
                            //       ],
                            //     );
                            //   } else {
                            //     return 
                                SpeedTextfield(
                                  isEnabled: empTaskDetailsPageController.statusFlag! &&
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
                            // const SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        return AppColors
                                            .white; // Always white, even when disabled
                                      },
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: empTaskDetailsPageController
                                              .isPhotoUploadEnabled
                                      ? AppColors.lightBlue : AppColors.lightestBlue,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.upload_file,
                                    color: empTaskDetailsPageController
                                              .isPhotoUploadEnabled
                                      ? AppColors.lightBlue : AppColors.lightBlue.withValues(alpha: 0.55),
                                    size: 22,
                                  ),
                                  label: Text(
                                    "Upload Photos",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: empTaskDetailsPageController
                                              .isPhotoUploadEnabled
                                      ? AppColors.lightBlue : AppColors.lightBlue.withValues(alpha: 0.55),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: empTaskDetailsPageController
                                              .isPhotoUploadEnabled
                                      ? () {
                                          // empTaskDetailsPageController.pickFiles();
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => SafeArea(
                                              child: Wrap(
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.camera_alt,
                                                      color: AppColors.lightBlue,
                                                    ),
                                                    title: const Text(
                                                      'Camera',
                                                    ),
                                                    onTap: () {
                                                      Get.back();
                                                      empTaskDetailsPageController
                                                          .pickFromCamera();
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.photo_library,
                                                      color: AppColors.lightBlue,
                                                    ),
                                                    title: const Text('Gallery'),
                                                    onTap: () {
                                                      Get.back();
                                                      empTaskDetailsPageController
                                                          .pickFromGallery();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Obx(() => Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: empTaskDetailsPageController
                                      .selectedFiles
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final file = entry.value;
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            file,
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              empTaskDetailsPageController
                                                  .removeFile(index),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: AppColors.lightRed,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close,
                                                color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                )),
                            const SizedBox(height: 16),
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
      ),
    );
  }
}
