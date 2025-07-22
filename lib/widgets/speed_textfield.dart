import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/colors.dart';

class SpeedTextfield extends StatelessWidget {
  final String labelText;
  final bool needPrefixIcon;
  final bool needSuffixIcon;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final int maxLengthLimit;
  final bool isPasswordHidden;
  final bool isDateTimePicker;
  final Function()? suffixIconOnPressed;
  final Function()? fieldOnTap;
  final String hintText;
  final bool isTextArea;
  final bool isEnabled;

  const SpeedTextfield({
    super.key,
    required this.labelText,
    this.hintText = "Type here...",
    this.prefixIconData = Icons.abc,
    this.suffixIconData = Icons.abc,
    required this.textEditingController,
    this.textInputType = TextInputType.text,
    this.maxLengthLimit = 0,
    this.isDateTimePicker = false,
    this.isPasswordHidden = false,
    this.needPrefixIcon = false,
    this.needSuffixIcon = false,
    this.suffixIconOnPressed,
    this.fieldOnTap,
    this.isTextArea = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          width: 2,
          color: isEnabled
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
              TextFormField(
                enabled: isEnabled,
                maxLines: isTextArea ? 7 : 1,
                style: TextStyle(
                  color: isEnabled
                      ? AppColors.blue
                      : AppColors.lightBlue.withValues(alpha: 0.70),
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                ),
                readOnly: isDateTimePicker,
                onTap: isDateTimePicker ? fieldOnTap : null,
                keyboardType: textInputType,
                maxLength: maxLengthLimit == 0 ? null : maxLengthLimit,
                obscureText: isPasswordHidden,
                controller: textEditingController,
                decoration: InputDecoration(
                  counterText: "",
                  prefixIcon: needPrefixIcon
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Icon(
                            prefixIconData,
                            color: AppColors.darkGrey,
                          ),
                        )
                      : null,
                  suffixIcon: needSuffixIcon
                      ? Padding(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: IconButton(
                            icon: Icon(
                              suffixIconData,
                              color: isDateTimePicker
                                  ? isEnabled
                                      ? AppColors.blue
                                      : AppColors.lightBlue
                                          .withValues(alpha: 0.55)
                                  : AppColors.darkGrey,
                            ),
                            color: isDateTimePicker
                                ? AppColors.blue
                                : AppColors.darkGrey,
                            onPressed: suffixIconOnPressed,
                          ),
                        )
                      : null,
                  labelText: hintText,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(
                    decoration: TextDecoration.none,
                    letterSpacing: -0.01,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                          color: AppColors.white)),
                  disabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                          color: AppColors.white)),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                          color: AppColors.white)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                          color: AppColors.white)),
                  filled: true,
                  fillColor: AppColors.white,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            width: double.infinity,
            decoration: BoxDecoration(
                color: isEnabled
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
