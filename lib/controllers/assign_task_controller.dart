import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AssignTaskController extends GetxController {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  TextEditingController dateCont = TextEditingController();

  List<String> taskTypeDropdownOptions = ["Daily", "Weekly", "Monthly"];
  String taskTypeSelected = "Daily";
  List<String> assignDropdownOptions = ["Gaurav", "Sakshi", "Srushti"];
  String assignSelected = "Sakshi";

  Future<void> showDateTimePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final formattedDateTime =
            DateFormat('dd MMMM yyyy, hh:mm a').format(finalDateTime);

        dateCont.text = formattedDateTime;
      }
    }
  }
}
