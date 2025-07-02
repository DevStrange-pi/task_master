import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/reporting_page_controller.dart';

import '../styles/colors.dart';
import '../widgets/menu_tile.dart';
import '../widgets/scaffold_main.dart';

class ReportingPage extends StatelessWidget {
  ReportingPage({super.key});
  final ReportingPageController reportingPageController =
      Get.find<ReportingPageController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (reportingPageController.flag) {
          reportingPageController.onBackPressed();
        } else {
          Get.back(result: false);
        }
        return false;
      },
      child: ScaffoldMain(
        onBackPressed: reportingPageController.onBackPressed,
        title: "Reporting",
        content: Obx(
          () => reportingPageController.employeeList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      "No Employees found",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: reportingPageController.isLoading.value
                            ? Colors.transparent
                            : AppColors.darkGrey,
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                onRefresh: () async{
                  await reportingPageController.onRefresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          reportingPageController.employeeList.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: MenuTile(
                                customFloatingWidget: GestureDetector(
                                  onTap: () async {
                                    await reportingPageController.deleteEmployee(context,
                                        reportingPageController
                                            .employeeList[index].id!);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: AppColors.darkGrey,
                                    radius: 19,
                                    child: Icon(Icons.delete,
                                        color: AppColors.red),
                                  ),
                                ),
                                title: reportingPageController
                                        .employeeList[index].name ??
                                    "",
                                // count: int.parse(
                                //     reportingPageController.tasksCountList![index]!["count"]!),
                                onTap: () {
                                  reportingPageController.onTapMenuTile(
                                      reportingPageController
                                              .employeeList[index].name ??
                                          "",
                                      reportingPageController
                                          .employeeList[index].id!,
                                      reportingPageController
                                          .employeeList[index].latestLocation);
                                },
                              ),
                            );
                          },
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
