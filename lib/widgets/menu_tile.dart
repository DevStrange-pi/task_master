import 'package:flutter/material.dart';
import 'package:task_master/styles/colors.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({super.key, required this.title, this.onTap, this.count});
  final String title;
  final void Function()? onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(56, 16, 56, 8),
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
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          count != null
              ? Positioned(
                  right: 36,
                  top: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.lightBlue,
                    radius: 19,
                    child: Text(
                      count.toString(),
                      style: const TextStyle(color: AppColors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
