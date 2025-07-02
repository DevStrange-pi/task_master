import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/controllers/employee/emp_my_profile_page_controller.dart';
import 'package:task_master/screens/employee/emp_my_profile_tasks_page.dart';
import 'package:task_master/widgets/scaffold_main.dart';

class EmpMyProfilePage extends StatelessWidget {
  EmpMyProfilePage({super.key});

  final EmpMyProfilePageController empMyProfilePageController =
      Get.find<EmpMyProfilePageController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        empMyProfilePageController.onBackPressed();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
          length: 2,
          child: ScaffoldMain(
            onBackPressed: empMyProfilePageController.onBackPressed,
            title: "My Profile",
            content: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    // borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(
                        child: Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Tasks",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await empMyProfilePageController.onRefresh();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Obx(
                                () => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                      empMyProfilePageController
                                          .profileData.length, (index) {
                                    final isBlue = index % 2 == 0;
                                    return Container(
                                      color: isBlue
                                          ? Colors.blue[50]
                                          : Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 12),
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              empMyProfilePageController
                                                          .profileData[index]
                                                      ['label'] ??
                                                  '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              empMyProfilePageController
                                                          .profileData[index]
                                                      ['value'] ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Tasks Tab (replace with your actual tasks widget)
                      EmpMyProfileTasksPage()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
