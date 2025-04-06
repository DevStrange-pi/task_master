import 'package:get/get.dart';
import 'package:task_master/screens/add_profile_page.dart';
import 'package:task_master/screens/all_tasks_page.dart';
import 'package:task_master/screens/assign_task_page.dart';
import 'package:task_master/screens/home_page.dart';
import 'package:task_master/screens/task_list_page.dart';

import '../screens/intro_page.dart';
import '../screens/login_page.dart';
import 'app_routes.dart';


class AppPages {
  static var pages = [
    GetPage(
      name: AppRoutes.INTRO_PAGE,
      page: () => const IntroPage(),
    ),
    GetPage(
      name: AppRoutes.LOGIN_PAGE,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.HOME_PAGE,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoutes.ADD_PROFILE_PAGE,
      page: () => AddProfilePage(),
    ),
    GetPage(
      name: AppRoutes.ALL_TASKS_PAGE,
      page: () => AllTasksPage(),
    ),
    GetPage(
      name: AppRoutes.TASK_LIST_PAGE,
      page: () => TaskListPage(),
    ),
    GetPage(
      name: AppRoutes.ASSIGN_TASK_PAGE,
      page: () => AssignTaskPage(),
    ),
    
  ];
}
