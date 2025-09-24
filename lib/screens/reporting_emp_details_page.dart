import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/reporting_emp_details_controller.dart';
import 'package:task_master/styles/colors.dart';
import 'package:task_master/widgets/scaffold_main.dart';
import 'package:task_master/widgets/speed_button.dart';

import '../widgets/menu_tile.dart';
import '../widgets/speed_textfield.dart';

class ReportingEmpDetailsPage extends StatelessWidget {
  ReportingEmpDetailsPage({super.key});
  final ReportingEmpDetailsController reportingEmpDetailsController =
      Get.find<ReportingEmpDetailsController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        reportingEmpDetailsController.onBackPressed();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Obx(
          () => ScaffoldMain(
            onBackPressed: reportingEmpDetailsController.onBackPressed,
            title: reportingEmpDetailsController.employeeName.value,
            content: RefreshIndicator(
              onRefresh: () async {
                await reportingEmpDetailsController.onRefresh();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Visibility(
                        visible: !reportingEmpDetailsController.isAdmin,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        "Last Location",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(99, 182, 183, 183),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(14),
                                              bottomRight: Radius.circular(14))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reportingEmpDetailsController
                                                      .latestLocation.value!.name!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.darkGrey,
                                                  ),
                                                ),
                                                reportingEmpDetailsController
                                                        .latestLocation
                                                        .value!
                                                        .address!
                                                        .isEmpty
                                                    ? const SizedBox()
                                                    : Text(
                                                        reportingEmpDetailsController
                                                            .latestLocation
                                                            .value!
                                                            .address!,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.darkGrey,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            visualDensity: const VisualDensity(
                                                horizontal: -4, vertical: -4),
                                            onPressed: () {
                                              reportingEmpDetailsController
                                                  .onTapLocationIcon();
                                            },
                                            icon: const Row(
                                              children: [
                                                // Text(
                                                //   "Show on Map",
                                                //   style: TextStyle(
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.bold,
                                                //     color: AppColors.lightBlue,
                                                //   ),
                                                // ),
                                                Icon(
                                                  Icons.location_on,
                                                  color: AppColors.blue,
                                                  size: 22,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                          ],
                        ),
                      ),
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
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              onPressed: () {
                                reportingEmpDetailsController.onTapCalendarIcon();
                              },
                              icon: const Icon(
                                Icons.calendar_month_rounded,
                                color: AppColors.black,
                              ),
                            ),
                            Visibility(
                              visible: !reportingEmpDetailsController.isAdmin,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                onPressed: () {
                                  reportingEmpDetailsController
                                      .onTapExcelSheetIcon();
                                },
                                icon: Image.asset(
                                  'assets/excel_icon.png', // Replace with your asset path
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: reportingEmpDetailsController
                              .isDatePickerVisible.value,
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
                                          reportingEmpDetailsController
                                              .fromDateCont,
                                      isDateTimePicker: true,
                                      fieldOnTap: () {
                                        reportingEmpDetailsController
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
                                          reportingEmpDetailsController
                                              .toDateCont,
                                      isDateTimePicker: true,
                                      fieldOnTap: () {
                                        reportingEmpDetailsController
                                            .showToDateTimePicker();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    SpeedButton(
                                      elevation: 1,
                                      buttonText: "Done",
                                      onPressed: () {
                                        reportingEmpDetailsController.onTapDone();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ...List.generate(
                        reportingEmpDetailsController.tasksCountList!.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: MenuTile(
                              title: reportingEmpDetailsController
                                  .tasksCountList![index]!["name"]!,
                              count: int.parse(reportingEmpDetailsController
                                  .tasksCountList![index]!["count"]!),
                              onTap: () {
                                reportingEmpDetailsController.onTapMenuTile(
                                    reportingEmpDetailsController
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
            ),
          ),
        ),
      ),
    );
  }
}
