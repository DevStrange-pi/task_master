import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task_master/styles/colors.dart';

class CircularLoader extends GetxController {
  var isLoading = false.obs;
  OverlayEntry? _overlayEntry;

  bool get isLoaderActive => isLoading.value;
  
  void showCircularLoader() {
    if (!isLoading.value) {
      isLoading.value = true;

      _overlayEntry = OverlayEntry(builder: (context) => CircularLoaderWidget());

      Overlay.of(Get.overlayContext!).insert(_overlayEntry!);
    }
  }

  void hideCircularLoader() {
    if (isLoading.value) {
      isLoading.value = false;
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

class CircularLoaderWidget extends StatelessWidget {
  const CircularLoaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final loaderController = Get.find<CircularLoader>();

    return loaderController.isLoading.value
        ? Positioned.fill(
            child: Stack(
              children: [
                AbsorbPointer(
                  absorbing: loaderController.isLoading.value,
                  child: Container(
                    color: Colors.black.withValues(alpha:0.5), // Optional: semi-transparent background
                  ),
                ),
                Center(
                  child: LoadingAnimationWidget.progressiveDots(
                    color: AppColors.blue,
                    size: 100,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
