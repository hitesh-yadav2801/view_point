import 'package:flutter/material.dart';
import 'package:view_point/core/constants/my_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final Icon? prefixIcon;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.prefixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: const TextStyle(color: MyColors.blackColor, fontSize: 16.0),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16.0),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(12.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: MyColors.blackColor,
            width: 0.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: MyColors.blackColor,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}