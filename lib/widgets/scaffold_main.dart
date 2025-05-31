import 'package:flutter/material.dart';
import 'package:task_master/styles/colors.dart';
import 'package:task_master/widgets/main_app_bar.dart';

class ScaffoldMain extends StatelessWidget {
  const ScaffoldMain(
      {super.key,
      required this.title,
      required this.content,
      this.isTitleContainer = true,this.infoWidget = const SizedBox(),this.isHome,this.onBackPressed,this.isNotificationsVisible = false,this.onNotificationsPressed,this.notificationCount = 0});

  final String title;
  final Widget content;
  final bool isTitleContainer;
  final Widget infoWidget;
  final void Function()? onBackPressed;
  final bool? isHome; 
  final bool isNotificationsVisible;
  final void Function()? onNotificationsPressed;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        notificationCount: notificationCount,
        onNotificationsPressed: onNotificationsPressed,
        isNotificationsVisible: isNotificationsVisible,
        isHome: isHome,
        onBackPressed: onBackPressed,
      ),
      body: Column(
        children: [
          isTitleContainer
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(40, 16, 20, 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(46),
                      bottomLeft: Radius.circular(46),
                      bottomRight: Radius.circular(46),
                    ),
                    gradient: LinearGradient(
                      colors: [AppColors.lightBlue, AppColors.blue],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white),
                      ),
                      infoWidget,
                    ],
                  ),
                )
              : const SizedBox(),
          Expanded(child: content)
        ],
      ),
    );
  }
}
