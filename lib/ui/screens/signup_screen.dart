import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:view_point/blocs/signup_bloc/signup_bloc.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/data/models/user_model.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/common_widgets/custom_textfield.dart';
import 'package:view_point/ui/screens/login_screen.dart';
import 'package:view_point/ui/screens/signup_otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final phoneNumberController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        } else if (state is PhoneAuthCodeSentSuccessStateSignUp) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpOtpScreen(
                phoneNumber: phoneNumberController.text,
                verificationId: state.verificationId,
                userModel: UserModel(
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                  registrationFlag: true,
                  isAdmin: false,
                ),
              ),
            ),
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
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/login.json',
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.cover,
                        repeat: true,
                      ),
                      const Text(
                        'Admin Panel Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 48),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Full Name',
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Enter your name',
                        controller: nameController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 20),
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
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        title: 'Get OTP',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignupBloc>().add(
                                  SignUpSendOtpToPhoneEvent(
                                    phoneNumber: phoneNumberController.text,
                                    userModel: UserModel(
                                      name: nameController.text,
                                      phoneNumber: phoneNumberController.text,
                                      registrationFlag: true,
                                      isAdmin: false,
                                    ),
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Log In',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: MyColors.tertiaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
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
