import 'package:flutter/widgets.dart';
import 'package:task_master/styles/colors.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({super.key, required this.title, this.onTap});
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 64),
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
        child: Container(
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
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
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
            ],
          ),
        ),
      ),
    );
  }
}
