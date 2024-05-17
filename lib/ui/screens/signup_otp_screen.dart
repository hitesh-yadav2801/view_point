import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/blocs/signup_bloc/signup_bloc.dart';
import 'package:view_point/core/constants/app_padding.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/data/models/user_model.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/common_widgets/custom_textfield.dart';
import 'package:view_point/ui/screens/admin_panel_screen.dart';

class SignUpOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final UserModel userModel;

  const SignUpOtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.userModel,
  });

  @override
  State<SignUpOtpScreen> createState() => _SignUpOtpScreenState();
}

class _SignUpOtpScreenState extends State<SignUpOtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is LoginScreenErrorStateSignUp) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        } else if (state is LoginScreenLoadedStateSignUp ) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please ask for admin approval'),
            ),
          );
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
        if (state is LoginScreenLoadingStateSignUp) {
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
                          if (_formKey.currentState!.validate()) {
                            context.read<SignupBloc>().add(SignUpVerifySendOtpEvent(verificationId: widget.verificationId, otpCode: _otpController.text, userModel: widget.userModel));
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
