import 'package:flutter/material.dart';
import 'package:task_master/styles/colors.dart';

class MenuTile extends StatelessWidget {
  const MenuTile(
      {super.key,
      required this.title,
      this.onTap,
      this.count,
      this.statusColor,
      this.expiredCount,
      this.deadlineTimer,
      this.needReassign,
      this.reassignCallback,
      this.customFloatingWidget,
      this.userList});
  final String title;
  final void Function()? onTap;
  final int? count;
  final int? expiredCount;
  final String? deadlineTimer;
  final bool? needReassign;
  final void Function()? reassignCallback;
  final Color? statusColor;
  final Widget? customFloatingWidget;
  final List<String>? userList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        expiredCount != null
            ? Positioned(
                right: 75,
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: AppColors.black),
                  child: Text(
                    "Expired $expiredCount times",
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white),
                  ),
                ),
              )
            : const SizedBox(),
        deadlineTimer != null
            ? Positioned(
                left: 63,
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: AppColors.lightRed),
                  child: Text(
                    deadlineTimer!,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white),
                  ),
                ),
              )
            : const SizedBox(),
        userList != null && userList!.isNotEmpty
            ? Positioned(
                left: 60,
                // right: 60,
                bottom: (userList!.length / 2).ceil() > 2
                    ? (0.7 * (userList!.length / 2).floor()) *
                        (userList!.length / 2).ceil()
                    : 0,
                // top: 0,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 120),
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    color: AppColors.lightestBlue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      (userList!.length / 2).ceil(),
                      (rowIndex) {
                        final start = rowIndex * 2;
                        final end = (start + 2 < userList!.length)
                            ? start + 2
                            : userList!.length;
                        final rowUsers = userList!.sublist(start, end);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: rowUsers
                              .map((user) => Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 8, bottom: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Tooltip(
                                    message: user,
                                    waitDuration:
                                        const Duration(milliseconds: 100),
                                    showDuration:
                                        const Duration(seconds: 1),
                                    child: Text(
                                      user,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.black
                                            .withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                              .toList(),
                        );
                      },
                    ),
                  ),
                  // Wrap(
                  //   spacing: 8,
                  //   runSpacing: 4,
                  //   children: userList!
                  //       .map((user) => Container(
                  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //             decoration: BoxDecoration(
                  //               color: AppColors.lightGrey,
                  //               borderRadius: BorderRadius.circular(14),
                  //             ),
                  //             child: Text(
                  //               user,
                  //               style: TextStyle(
                  //                 color: AppColors.black.withValues(alpha: 0.7), // 0.7 alpha
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 12,
                  //               ),
                  //               // overflow: TextOverflow.ellipsis,
                  //             ),
                  //           ))
                  //       .toList(),
                  // ),
                ),
              )
            : const SizedBox(),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(
              56,
              expiredCount != null || deadlineTimer != null ? 24 : 16,
              56,
              userList != null && userList!.isNotEmpty
                  ? (userList!.length / 2).ceil() >= 2
                      ? 34.0 * (userList!.length / 2).ceil()
                      : 42.0
                  : 8,
            ),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: AppColors.darkGrey,
                  offset: Offset(1, 2),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 11,
                          color: AppColors.lightGrey,
                          offset: Offset(1, 2),
                          spreadRadius: 6,
                        ),
                      ],
                      border: const Border(
                          top: BorderSide(color: AppColors.grey),
                          right: BorderSide(color: AppColors.grey))),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 22),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      gradient: LinearGradient(
                        colors: [AppColors.lightBlue, AppColors.blue],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        statusColor == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 8,
                                backgroundColor: statusColor,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        needReassign != null
            ? Positioned(
                right: 36,
                top: 34,
                child: IconButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(AppColors.white),
                      shape: WidgetStatePropertyAll(
                        CircleBorder(
                          side: BorderSide(color: AppColors.grey),
                        ),
                      )),
                  padding: EdgeInsets.zero,
                  visualDensity:
                      const VisualDensity(horizontal: -2, vertical: -2),
                  onPressed: reassignCallback,
                  icon: const Icon(
                    Icons.restart_alt_rounded,
                  ),
                ),
              )
            : const SizedBox(),
        count != null
            ? Positioned(
                right: 36,
                top: 0,
                child: CircleAvatar(
                  backgroundColor: AppColors.black,
                  radius: 19,
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : customFloatingWidget != null
                ? Positioned(
                    right: 36,
                    top: 0,
                    child: customFloatingWidget!,
                    // Text(
                    //   count.toString(),
                    //   style: const TextStyle(
                    //       color: AppColors.white,
                    //       fontWeight: FontWeight.bold),
                    // ),
                  )
                : const SizedBox(),
      ],
    );
  }
}
