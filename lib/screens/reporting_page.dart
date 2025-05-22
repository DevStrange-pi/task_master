import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/reporting_page_controller.dart';

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
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 70),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  reportingPageController.employeeList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: MenuTile(
                        title:
                            reportingPageController.employeeList[index].name ??
                                "",
                        // count: int.parse(
                        //     reportingPageController.tasksCountList![index]!["count"]!),
                        onTap: () {
                          reportingPageController.onTapMenuTile(
                              reportingPageController
                                      .employeeList[index].name ??
                                  "",
                              reportingPageController.employeeList[index].id!);
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
    );
  }
}
