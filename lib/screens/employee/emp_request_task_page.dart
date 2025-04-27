// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:task_master/controllers/employee/emp_request_task_page_controller.dart';

// class EmpRequestTaskPage extends StatelessWidget {
//   EmpRequestTaskPage({super.key});
//   final EmpRequestTaskPageController empRequestTaskPageController =
//       Get.find<EmpRequestTaskPageController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => PopScope(
//         canPop: addTaskController.canPop.value,
//         onPopInvokedWithResult: (didPop, result) {
//           if (addTaskController.multiSelectController.isOpen) {
//             if (!didPop) {
//               addTaskController.multiSelectController.closeDropdown();
//             }
//           }
//         },
//         child: GestureDetector(
//           onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//           child: Scaffold(
//             appBar: const ChildAppBar(),
//             body: Padding(
//               padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Add a Task",
//                       style: TextStyle(
//                           color: AppColors.blue,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 32),
//                     ),
//                     const SizedBox(
//                       height: 12,
//                     ),
//                     SpeedTextfield(
//                       labelText: "Task Name",
//                       hintText: "Type here...",
//                       textEditingController:
//                           addTaskController.taskNameController,
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     SpeedTextfield(
//                       isTextArea: true,
//                       labelText: "Description",
//                       hintText: "Type here...",
//                       textEditingController: addTaskController.descController,
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     SpeedDropdown(
//                       labelText: "Task Type",
//                       dropdownItems: addTaskController.taskTypeDropdownOptions,
//                       selectedValue: addTaskController.taskTypeSelected,
//                       onChanged: (val) {
//                         addTaskController.taskTypeSelected = val;
//                       },
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     SpeedTextfield(
//                       isPasswordHidden: false,
//                       needSuffixIcon: true,
//                       suffixIconData: Icons.calendar_month_sharp,
//                       labelText: "Deadline Date Time",
//                       hintText: "Select here...",
//                       textEditingController: addTaskController.dateCont,
//                       isDateTimePicker: true,
//                       fieldOnTap: () {
//                         addTaskController.showDateTimePicker();
//                       },
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     Obx(
//                       () => SpeedMultiDropdown(
//                         multiSelectController:
//                             addTaskController.multiSelectController,
//                         labelText: "Whom to Assign",
//                         dropdownItems:
//                             // ignore: invalid_use_of_protected_member
//                             addTaskController.assignDropdownOptions.value,
//                         selectedValues: addTaskController.assignSelected,
//                         onChanged: (val) {
//                           debugPrint("OnSelectionChange: $val");
//                           addTaskController.createSelectedDropdownOptions(val);
//                         },
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 32,
//                     ),
//                     SpeedButton(
//                       buttonText: "Submit",
//                       onPressed: () {
//                         addTaskController.onSubmitPressed();
//                       },
//                     ),
//                     const SizedBox(
//                       height: 32,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }