

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/common_widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'lib/core/assets/animations/login.json',
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.cover,
                repeat: true,
              ),
              const Text(
                'Admin Panel Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Phone Number',
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter phone number',
                controller: phoneNumberController,
              ),
              const SizedBox(height: 24),
              CustomButton(title: 'Get OTP', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
