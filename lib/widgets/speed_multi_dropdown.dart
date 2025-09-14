import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../styles/colors.dart';

class SpeedMultiDropdown extends StatelessWidget {
  final String labelText;
  final void Function(List<String>)? onChanged;
  final List<DropdownItem<String>> dropdownItems;
  final List<DropdownItem<String>> selectedValues;
  final MultiSelectController<String> multiSelectController;
  final bool enabled;

  const SpeedMultiDropdown({
    super.key,
    required this.multiSelectController,
    required this.labelText,
    required this.dropdownItems,
    required this.selectedValues,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            width: 2,
            color: enabled
                ? AppColors.lightBlue
                : AppColors.lightBlue.withValues(alpha: 0.55),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 34),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: MultiDropdown<String>(
                      items: dropdownItems,
                      controller: multiSelectController,
                      enabled: enabled,
                      searchEnabled: true,
                      chipDecoration: ChipDecoration(
                        labelStyle: TextStyle(
                          color: enabled ? AppColors.black : AppColors.darkGrey,
                        ),
                        deleteIcon: enabled
                            ? null
                            : const Icon(
                                Icons.close,
                                size: 0,
                              ),
                        backgroundColor: AppColors.lightestBlue,
                        wrap: true,
                        runSpacing: 2,
                        spacing: 8,
                      ),
                      fieldDecoration: FieldDecoration(
                        hintText: 'Select Employees',
                        hintStyle: TextStyle(
                            color: enabled
                                ? AppColors.blue
                                : AppColors.lightBlue.withValues(alpha: 0.55),
                            fontWeight: FontWeight.bold),
                        showClearIcon: false,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      dropdownDecoration: const DropdownDecoration(
                        elevation: 8,
                        marginTop: 2,
                        maxHeight: 500,
                        header: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            'Select Employees from the list',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      dropdownItemDecoration: const DropdownItemDecoration(
                        selectedIcon:
                            Icon(Icons.check_box, color: Colors.green),
                        disabledIcon: Icon(Icons.lock, color: Colors.grey),
                      ),
                      onSelectionChange: onChanged),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: enabled
                    ? AppColors.lightBlue
                    : AppColors.lightBlue.withValues(alpha: 0.55),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: Text(
                labelText,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
