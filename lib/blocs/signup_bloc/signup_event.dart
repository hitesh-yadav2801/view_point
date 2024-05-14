part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

final class SignUpSendOtpToPhoneEvent extends SignupEvent {
  final String phoneNumber;
  final UserModel userModel;

  SignUpSendOtpToPhoneEvent({required this.phoneNumber, required this.userModel});
}

final class SignUpOnPhoneOtpSendEvent extends SignupEvent {
  final String verificationId;
  final int? token;
  final UserModel userModel;

  SignUpOnPhoneOtpSendEvent({
    required this.verificationId,
    required this.token,
    required this.userModel,
  });
}

final class SignUpVerifySendOtpEvent extends SignupEvent {
  final String verificationId;
  final String otpCode;

  final UserModel userModel;

  SignUpVerifySendOtpEvent({
    required this.verificationId,
    required this.otpCode,
    required this.userModel,
  });
}

final class SignUpOnPhoneAuthErrorEvent extends SignupEvent {
  final String error;

  SignUpOnPhoneAuthErrorEvent({required this.error});
}

final class SignUpOnPhoneAuthVerificationCompletedEvent extends SignupEvent {
  final AuthCredential authCredential;
  final UserModel userModel;

  SignUpOnPhoneAuthVerificationCompletedEvent({required this.authCredential, required this.userModel});
}


