import 'package:flutter/material.dart';

import '../styles/colors.dart';

class SpeedButton extends StatelessWidget {
  final String? buttonText;
  final bool invertedColors;
  final bool hasInfiniteWidth;
  final bool needLoader;
  final bool isDisabled;
  final void Function()? onPressed;
  final double buttonHeight;
  const SpeedButton(
      {super.key,
      required this.buttonText,
      this.invertedColors = false,
      this.hasInfiniteWidth = true,
      this.needLoader = false,
      this.isDisabled = false,
      required this.onPressed,
      this.buttonHeight = 50.0});
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: ElevatedButton(
        onPressed: onPressed!,
        style: ButtonStyle(
          minimumSize: hasInfiniteWidth ? WidgetStatePropertyAll(Size.fromHeight(buttonHeight)) : null,
          backgroundColor: invertedColors
              ? const WidgetStatePropertyAll(AppColors.white)
              : isDisabled ? const WidgetStatePropertyAll(AppColors.lightestBlue)  : const WidgetStatePropertyAll(AppColors.lightBlue),
          elevation: const WidgetStatePropertyAll(16),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ))
        ),
        child: needLoader
            ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(
                
                  color: invertedColors ? AppColors.lightBlue : AppColors.white,
                ),
            )
            : Text(
                buttonText!,
                style: TextStyle(
                  color: invertedColors ? AppColors.lightBlue : AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: buttonHeight / 2.8,
                ),
              ),
      ),
    );
  }
}
