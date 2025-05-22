import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/employee/emp_my_profile_page_controller.dart';
import '../../styles/colors.dart';
import '../../widgets/menu_tile.dart';
import '../../widgets/speed_button.dart';
import '../../widgets/speed_textfield.dart';

class EmpMyProfileTasksPage extends StatelessWidget {
  EmpMyProfileTasksPage({super.key});
  final EmpMyProfilePageController empMyProfilePageController =
      Get.find<EmpMyProfilePageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    const Text(
                      "Total Tasks",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Till now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      onPressed: () {
                        empMyProfilePageController.onTapCalendarIcon();
                      },
                      icon: const Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.black,
                      ),
                    ),
                    // IconButton(
                    //   padding: EdgeInsets.zero,
                    //   visualDensity:
                    //       const VisualDensity(horizontal: -4, vertical: -4),
                    //   onPressed: () {
                    //     // reportingEmpDetailsController.onTapExcelSheetIcon();
                    //   },
                    //   icon: Image.asset(
                    //     'assets/excel_icon.png', // Replace with your asset path
                    //     width: 24,
                    //     height: 24,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Visibility(
                visible: empMyProfilePageController.isDatePickerVisible.value,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(38, 0, 38, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(99, 182, 183, 183),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14))),
                      child: Column(
                        children: [
                          SpeedTextfield(
                            isPasswordHidden: false,
                            needSuffixIcon: true,
                            suffixIconData: Icons.calendar_month_sharp,
                            labelText: "From Date",
                            hintText: "Select here...",
                            textEditingController:
                                empMyProfilePageController.fromDateCont,
                            isDateTimePicker: true,
                            fieldOnTap: () {
                              empMyProfilePageController
                                  .showFromDateTimePicker();
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SpeedTextfield(
                            isPasswordHidden: false,
                            needSuffixIcon: true,
                            suffixIconData: Icons.calendar_month_sharp,
                            labelText: "To Date",
                            hintText: "Select here...",
                            textEditingController:
                                empMyProfilePageController.toDateCont,
                            isDateTimePicker: true,
                            fieldOnTap: () {
                              empMyProfilePageController.showToDateTimePicker();
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SpeedButton(
                            elevation: 1,
                            buttonText: "Done",
                            onPressed: () {
                              empMyProfilePageController.onTapDone();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(
                empMyProfilePageController.tasksCountList!.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: MenuTile(
                      title: empMyProfilePageController
                          .tasksCountList![index]!["name"]!,
                      count: int.parse(empMyProfilePageController
                          .tasksCountList![index]!["count"]!),
                      onTap: () {
                        empMyProfilePageController.onTapMenuTile(
                            empMyProfilePageController
                                    .tasksCountList![index]!["name"] ??
                                "");
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    // Center(
    //   child: Text(
    //     "Tasks will be shown here.",
    //     style: TextStyle(fontSize: 18, color: Colors.grey[700]),
    //   ),
    // );
  }
}
