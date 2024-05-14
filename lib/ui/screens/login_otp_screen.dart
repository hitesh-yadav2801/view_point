import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/blocs/login_bloc/login_bloc.dart';
import 'package:view_point/core/constants/app_padding.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/common_widgets/custom_textfield.dart';
import 'package:view_point/ui/screens/admin_panel_screen.dart';

class LoginOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const LoginOtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginScreenErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        } else if (state is LoginScreenLoadedState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminPanelScreen(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is LoginScreenLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          backgroundColor: MyColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Padding(
              padding: AppPadding.mainPadding,
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Verify OTP',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  'Enter the OTP sent to your phone number \n',
                              style: TextStyle(fontSize: 14),
                            ),
                            TextSpan(
                              text: '+91 ${widget.phoneNumber}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight
                                    .bold, // Make the phone number bold
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()){
                            context.read<LoginBloc>().add(
                              VerifySendOtpEvent(
                                verificationId: widget.verificationId,
                                otpCode: _otpController.text,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                  color: MyColors
                                      .tertiaryColor // Make the phone number bold
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
          ),
        );
      },
    );
  }
}
