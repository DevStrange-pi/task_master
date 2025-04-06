// final String baseUrl = "https://app.cocolifehealthcare.com.ph"; //For Production

// const String baseUrl = "https://educationcarrier.org/laravel/public/api"; //For Development
const String baseUrl = "http://hrms.speedupinfotech.com/public/api"; //For Development

// const String baseUrl ="http://dheeraj.000.pe/public/api"; //For Development

class AppUrl {
  final String login = "$baseUrl/login";
  final String register = "$baseUrl/register";
  final String syllabusDetails = "$baseUrl/syllabus/";
  final String countdownDetails = "$baseUrl/coundown";
  final String getMcqQuestions = "$baseUrl/mcq-questions/";
  final String totalCalls = "$baseUrl/total-calls";
  final String applyJob = "$baseUrl/apply-job";
  final String getPlacementCalls = "$baseUrl/get-placement-calls/";

  final String getProfileDetails = "$baseUrl/profile/";
  String getMockHistoryDetails(studentId) {
    return "$baseUrl/students/$studentId/mock-history";
  }

  final String uploadResume = "$baseUrl/students/";
  final String submitAnswer = "$baseUrl/submit-mcq-answer";
  final String notification = "$baseUrl/notifications/";
  final String messages = "$baseUrl/messages/";
}
