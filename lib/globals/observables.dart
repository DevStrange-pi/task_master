import 'package:get/get.dart';

import '../models/admin_home_response_model.dart';
import '../models/employee/emp_dashboard_response_model.dart';

final Rx<Statistics> globalStatistics = Statistics(
  totalTasks: 0,
  pendingTasks: 0,
  completedTasks: 0,
  expiredTasks: 0,
  requestedTasks: 0,
  totalEmployees: 0,
).obs;

final RxList<Map<String, String>> globalTasksCountList =
    <Map<String, String>>[].obs;

final Rx<EmpStatistics> globalEmpStatistics = EmpStatistics(
  dailyTasks: 0,
  weeklyTasks: 0,
  monthlyTasks: 0,
  yearlyTasks: 0,
  onceTasks: 0,
  requestedTasks: 0,
).obs;

