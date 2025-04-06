import 'package:get/get.dart';

class AllTasksController extends GetxController {
  Map<String, dynamic>? tasksCount;
  List<Map<String, String>>? tasksCountList;
  @override
  void onInit() {
    tasksCount = Get.arguments;
    tasksCountList = convertTaskMap(tasksCount ?? {});
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<Map<String, String>> convertTaskMap(Map<String, dynamic> taskMap) {
    if (taskMap.isEmpty) {
      return [];
    }
    return taskMap.entries.map((entry) {
      final name = entry.key
          .split('_')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');

      return {
        "name": name,
        "count": entry.value.toString(),
      };
    }).toList();
  }
}
