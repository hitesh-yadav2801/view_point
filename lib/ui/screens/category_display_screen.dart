import 'dart:async';
import 'package:flutter/material.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/data/models/category_model.dart';
import 'package:view_point/ui/screens/view_360.dart';

class CategoryDisplayScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const CategoryDisplayScreen({super.key, required this.categoryModel});

  @override
  _CategoryDisplayScreenState createState() => _CategoryDisplayScreenState();
}

class _CategoryDisplayScreenState extends State<CategoryDisplayScreen> {
  int _timerValue = 3;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerValue > 0) {
          _timerValue--;
        } else {
          timer.cancel();
          // Delay the navigation by 500 milliseconds
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavigatorButton(
                  categoryModel: widget.categoryModel,
                ),
              ),
            );
          });
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.categoryModel.categoryName,
              style: const TextStyle(fontSize: 24, color: MyColors.whiteColor),
            ),
            const SizedBox(height: 20),
            Text(
              'Redirecting to Video in $_timerValue seconds...',
              style: const TextStyle(fontSize: 16, color: MyColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
