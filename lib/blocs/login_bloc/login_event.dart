part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class SendOtpToPhoneEvent extends LoginEvent {
  final String phoneNumber;

  SendOtpToPhoneEvent({required this.phoneNumber});
}

final class OnPhoneOtpSendEvent extends LoginEvent {
  final String verificationId;
  final int? token;

  OnPhoneOtpSendEvent({
    required this.verificationId,
    required this.token,
  });
}

final class VerifySendOtpEvent extends LoginEvent {
  final String verificationId;
  final String otpCode;

  VerifySendOtpEvent({
    required this.verificationId,
    required this.otpCode,
  });
}

final class OnPhoneAuthErrorEvent extends LoginEvent {
  final String error;

  OnPhoneAuthErrorEvent({required this.error});
}

final class OnPhoneAuthVerificationCompletedEvent extends LoginEvent {
  final AuthCredential authCredential;

  OnPhoneAuthVerificationCompletedEvent({required this.authCredential});
}

final class LogoutEventLogin extends LoginEvent {}
