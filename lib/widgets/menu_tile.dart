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
      this.needReassign,
      this.reassignCallback});
  final String title;
  final void Function()? onTap;
  final int? count;
  final int? expiredCount;
  final bool? needReassign;
  final void Function()? reassignCallback;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          expiredCount != null
              ? Positioned(
                  right: 70,
                  top: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          Container(
            width: double.infinity,
            margin:
                EdgeInsets.fromLTRB(56, expiredCount != null ? 22 : 16, 56, 8),
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
          needReassign != null
              ? Positioned(
                  right: 36,
                  top: 34,
                  child: IconButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.white),
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
              : const SizedBox(),
        ],
      ),
    );
  }
}
