import 'package:get/get.dart';
import 'package:task_master/bindings/add_profile_binding.dart';
import 'package:task_master/bindings/home_binding.dart';
import 'package:task_master/bindings/login_binding.dart';
import 'package:task_master/screens/add_profile_page.dart';
import 'package:task_master/screens/all_tasks_page.dart';
import 'package:task_master/screens/add_task_page.dart';
import 'package:task_master/screens/employee/emp_my_profile_page.dart';
import 'package:task_master/screens/employee/emp_notification_page.dart';
import 'package:task_master/screens/employee/emp_task_details_page.dart';
import 'package:task_master/screens/employee/emp_task_list_page.dart';
import 'package:task_master/screens/home_page.dart';
import 'package:task_master/screens/reporting_emp_details_page.dart';
import 'package:task_master/screens/splash_screen.dart';
import 'package:task_master/screens/task_details_page.dart';
import 'package:task_master/screens/task_list_page.dart';

import '../bindings/add_task_binding.dart';
import '../bindings/all_tasks_binding.dart';
import '../bindings/emp_add_task_binding.dart';
import '../bindings/emp_home_binding.dart';
import '../bindings/emp_my_profile_binding.dart';
import '../bindings/emp_my_task_binding.dart';
import '../bindings/emp_notification_binding.dart';
import '../bindings/emp_task_details_binding.dart';
import '../bindings/emp_task_list_binding.dart';
import '../bindings/intro_binding.dart';
import '../bindings/reporting_binding.dart';
import '../bindings/reporting_emp_details_binding.dart';
import '../bindings/task_details_binding.dart';
import '../bindings/task_list_binding.dart';
import '../screens/employee/emp_add_task_page.dart';
import '../screens/employee/emp_home_page.dart';
import '../screens/employee/emp_my_task_page.dart';
import '../screens/intro_page.dart';
import '../screens/login_page.dart';
import '../screens/reporting_page.dart';
import 'app_routes.dart';

class AppPages {
  static var pages = [
    GetPage(
      name: AppRoutes.splashPage,
      page: () => SplashScreen(),
    ),
    GetPage(
        name: AppRoutes.introPage,
        page: () => IntroPage(),
        binding: IntroBinding()),
    GetPage(
        name: AppRoutes.loginPage,
        page: () => LoginPage(),
        binding: LoginBinding()),
    GetPage(
        name: AppRoutes.homePage,
        page: () => HomePage(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.addProfilePage,
        page: () => AddProfilePage(),
        binding: AddProfileBinding()),
    GetPage(
        name: AppRoutes.allTasksPage,
        page: () => AllTasksPage(),
        binding: AllTasksBinding()),
    GetPage(
        name: AppRoutes.taskListPage,
        page: () => TaskListPage(),
        binding: TaskListBinding()),
    GetPage(
        name: AppRoutes.addTaskPage,
        page: () => AddTaskPage(),
        binding: AddTaskBinding()),
    GetPage(
        name: AppRoutes.taskDetailsPage,
        page: () => TaskDetailsPage(),
        binding: TaskDetailsBinding()),
    GetPage(
        name: AppRoutes.reportingPage,
        page: () => ReportingPage(),
        binding: ReportingBinding()),
    GetPage(
        name: AppRoutes.reportingEmpDetailsPage,
        page: () => ReportingEmpDetailsPage(),
        binding: ReportingEmpDetailsBinding()),

    // EMPLOYEE
    GetPage(
        name: AppRoutes.employeeHomePage,
        page: () => EmpHomePage(),
        binding: EmpHomeBinding()),
    GetPage(
        name: AppRoutes.employeeMyTaskPage,
        page: () => EmpMyTaskPage(),
        binding: EmpMyTaskBinding()),
    GetPage(
        name: AppRoutes.employeeTaskListPage,
        page: () => EmpTaskListPage(),
        binding: EmpTaskListBinding()),
    GetPage(
        name: AppRoutes.employeeTaskDetailsPage,
        page: () => EmpTaskDetailsPage(),
        binding: EmpTaskDetailsBinding()),
    GetPage(
      name: AppRoutes.employeeAddTaskPage,
      page: () => EmpAddTaskPage(),
      binding: EmpAddTaskBinding(),
    ),
    GetPage(
        name: AppRoutes.employeeMyProfilePage,
        page: () => EmpMyProfilePage(),
        binding: EmpMyProfileBinding()),
    GetPage(
        name: AppRoutes.employeeNotificationPage,
        page: () => EmpNotificationPage(),
        binding: EmpNotificationBinding()),
  ];
}
