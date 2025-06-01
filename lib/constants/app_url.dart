// const String baseUrl = "http://test.speedupinfotech.com/api"; //For Development
import 'package:flutter_dotenv/flutter_dotenv.dart';

String get baseUrl => dotenv.env['BASE_URL'] ?? '';

class AppUrl {
  final String login = "$baseUrl/login";
  final String register = "$baseUrl/register";

  // ADMIN
  final String adminHome = "$baseUrl/admin/dashboard";
  final String allTasks = "$baseUrl/admin/tasks";
  String getTaskDetails(taskId) {
    return "$baseUrl/admin/tasks/$taskId";
  }

  String updateTaskDetails(taskId) {
    return "$baseUrl/admin/tasks/$taskId";
  }

  // final String taskDetails = "$baseUrl/admin/tasks/1";
  final String getEmployees = "$baseUrl/admin/employees";
  final String logout = "$baseUrl/logout";
  final String addTask = "$baseUrl/admin/tasks";
  String getEmployeeReportUrl({
    required String fromDate,
    required String toDate,
    required int employeeId,
  }) {
    return "$baseUrl/admin/tasks/employee-report"
        "?from_date=$fromDate&to_date=$toDate&employee_id=$employeeId";
  }

  String getTaskReportUrl({
    required String fromDate,
    required String toDate,
    required int employeeId,
  }) {
    return "$baseUrl/admin/task-report"
        "?from_date=$fromDate&to_date=$toDate&employee_id=$employeeId";
  }
  String adminUpdateTask(int taskId) {
    return "$baseUrl/admin/tasks/$taskId/status";
  }
  
// COMMON
  final String getProfile = "$baseUrl/profile";
  final String sendFcmToken = "$baseUrl/save-device-token";

// EMPLOYEE
  final String employeeHome = "$baseUrl/employee/dashboard";
  final String employeeTasks = "$baseUrl/employee/tasks";
  String employeeUpdateTask(int taskId) {
    return "$baseUrl/employee/tasks/$taskId/status";
  }

  final String empGetEmployees = "$baseUrl/employee/employees";
  String getEmployeeReportUrlForEmployee({
    required String fromDate,
    required String toDate,
  }) {
    return "$baseUrl/employee/employee-report?from_date=$fromDate&to_date=$toDate";
  }
  String trackLocationForEmployee(int empId,String baseUrlPrefs){
    return "$baseUrlPrefs/employee/$empId/track-location";
  }

  final String getNotifications = "$baseUrl/notifications";
}
