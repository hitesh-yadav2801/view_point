part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginScreenInitialState extends LoginState {}

final class LoginScreenLoadingState extends LoginState {}

final class LoginScreenLoadedState extends LoginState {}

final class LoginScreenErrorState extends LoginState {
  final String error;

  LoginScreenErrorState({required this.error});
}

final class PhoneAuthCodeSentSuccessState extends LoginState {
  final String verificationId;

  PhoneAuthCodeSentSuccessState({required this.verificationId});
}

final class SignUpScreenOtpSuccessState extends LoginState {}

final class LogoutSuccessStateLogin extends LoginState {}
