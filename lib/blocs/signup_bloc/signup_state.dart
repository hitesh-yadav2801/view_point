part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitialState extends SignupState {}

final class LoginScreenLoadingStateSignUp extends SignupState {}

final class LoginScreenLoadedStateSignUp extends SignupState {}

final class LoginScreenErrorStateSignUp extends SignupState {
  final String error;

  LoginScreenErrorStateSignUp({required this.error});
}

final class PhoneAuthCodeSentSuccessStateSignUp extends SignupState {
  final String verificationId;

  PhoneAuthCodeSentSuccessStateSignUp({required this.verificationId});
}

final class SignUpScreenOtpSuccessStateSignUp extends SignupState {}



