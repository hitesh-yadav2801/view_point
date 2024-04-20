import 'package:flutter/material.dart';
import 'package:view_point/core/constants/app_padding.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/common_widgets/custom_textfield.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.mainPadding,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Enter the OTP sent to your phone number \n',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: '+91 ${widget.phoneNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold, // Make the phone number bold
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  hintText: 'Enter 6-digit OTP',
                  controller: _otpController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  title: 'Verify OTP',
                  onPressed: () {},
                ),
                const SizedBox(height: 20,),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Didn\'t receive any OTP? ',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: 'RESEND CODE',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: MyColors.tertiaryColor// Make the phone number bold
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
