import 'package:get/get.dart';

import '../models/admin_home_response_model.dart';

final Rx<Statistics> globalStatistics = Statistics(
  totalTasks: 0,
  pendingTasks: 0,
  completedTasks: 0,
  expiredTasks: 0,
  requestedTasks: 0,
  totalEmployees: 0,
).obs;

final RxList<Map<String, String>> globalTasksCountList = <Map<String, String>>[].obs;