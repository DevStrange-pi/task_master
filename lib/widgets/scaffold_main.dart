import 'package:flutter/material.dart';
import 'package:task_master/styles/colors.dart';
import 'package:task_master/widgets/main_app_bar.dart';

class ScaffoldMain extends StatelessWidget {
  const ScaffoldMain(
      {super.key,
      required this.title,
      required this.content,
      this.isTitleContainer = true,this.infoWidget = const SizedBox()});

  final String title;
  final Widget content;
  final bool isTitleContainer;
  final Widget infoWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
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
