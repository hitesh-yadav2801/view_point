import 'package:flutter/material.dart';
import 'package:view_point/core/constants/my_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.color = MyColors.blackColor,
    this.textColor = MyColors.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: MyColors.blackColor),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
