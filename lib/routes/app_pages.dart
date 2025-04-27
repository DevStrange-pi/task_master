import 'package:get/get.dart';
import 'package:task_master/screens/add_profile_page.dart';
import 'package:task_master/screens/all_tasks_page.dart';
import 'package:task_master/screens/add_task_page.dart';
import 'package:task_master/screens/employee/emp_task_details_page.dart';
import 'package:task_master/screens/employee/emp_task_list_page.dart';
import 'package:task_master/screens/home_page.dart';
import 'package:task_master/screens/task_details_page.dart';
import 'package:task_master/screens/task_list_page.dart';

import '../screens/employee/emp_home_page.dart';
import '../screens/employee/emp_my_task_page.dart';
import '../screens/intro_page.dart';
import '../screens/login_page.dart';
import 'app_routes.dart';


class AppPages {
  static var pages = [
    GetPage(
      name: AppRoutes.introPage,
      page: () => const IntroPage(),
    ),
    GetPage(
      name: AppRoutes.loginPage,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.homePage,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.addProfilePage,
      page: () => AddProfilePage(),
    ),
    GetPage(
      name: AppRoutes.allTasksPage,
      page: () => AllTasksPage(),
    ),
    GetPage(
      name: AppRoutes.taskListPage,
      page: () => TaskListPage(),
    ),
    GetPage(
      name: AppRoutes.addTaskPage,
      page: () => AddTaskPage(),
    ),
    GetPage(
      name: AppRoutes.taskDetailsPage,
      page: () => TaskDetailsPage(),
    ),
    // EMPLOYEE
    GetPage(
      name: AppRoutes.employeeHomePage,
      page: () => EmpHomePage(),
    ),
    GetPage(
      name: AppRoutes.employeeMyTaskPage,
      page: () => EmpMyTaskPage(),
    ),
    GetPage(
      name: AppRoutes.employeeTaskListPage,
      page: () => EmpTaskListPage(),
    ),
    GetPage(
      name: AppRoutes.employeeTaskDetailsPage,
      page: () => EmpTaskDetailsPage(),
    ),
    // GetPage(
    //   name: AppRoutes.employeeRequestTaskPage,
    //   page: () => EmpRequestTaskPage(),
    // ),
  ];
}
