import 'package:flutter/material.dart';

import '../styles/colors.dart';

class SpeedDropdown extends StatelessWidget {
  final String labelText;
  final void Function(dynamic)? onChanged;
  final List<dynamic> dropdownItems;
  final dynamic selectedValue;
  final bool enabled;
  final List<dynamic> disabledItems;

  const SpeedDropdown({
    super.key,
    required this.labelText,
    required this.dropdownItems,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.disabledItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const SizedBox(
                height: 34,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  hint: Text('Select Task Type',
                      style: TextStyle(
                          color: enabled
                              ? AppColors.blue
                              : AppColors.blue.withValues(alpha: 0.5),
                          fontSize: 16)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: const InputDecoration(
                      border:
                          UnderlineInputBorder(borderSide: BorderSide.none)),
                  style: TextStyle(
                      color: enabled
                          ? AppColors.blue
                          : AppColors.blue.withValues(alpha: 0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  value: selectedValue,
                  items: dropdownItems.map((item) {
                    final bool isDisabled = disabledItems.contains(item);
                    return DropdownMenuItem(
                      value: isDisabled ? null : item,
                      enabled: !isDisabled,
                      child: IgnorePointer(
                        ignoring: isDisabled,
                        child: Text(
                          item.toString(),
                          style: TextStyle(
                            color: isDisabled
                                ? Colors.grey
                                : enabled
                                    ? AppColors.blue
                                    : AppColors.blue.withValues(alpha: 0.5),
                            fontWeight: isDisabled
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: enabled ? onChanged : null,
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            width: double.infinity,
            decoration: BoxDecoration(
                color: enabled
                    ? AppColors.lightBlue
                    : AppColors.lightBlue.withValues(alpha: 0.55),
                borderRadius: const BorderRadius.all(Radius.circular(6))),
            child: Text(
              labelText,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
