import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/data/services/firebase_auth_services.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String loginResult = '';
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  UserCredential? userCredential;
  String resultOfRegistrationStatus = '';

  bool adminStatus = false;

  LoginBloc() : super(LoginScreenInitialState()) {
    on<LoginEvent>((_, emit) => emit(LoginScreenLoadingState()));
    on<LogoutEventLogin>(_onLogoutEventLogin);
    on<SendOtpToPhoneEvent>((event, emit) async {
      try {
        await firebaseAuthServices.loginWithPhone(
            phoneNumber: event.phoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) {
              add(OnPhoneAuthVerificationCompletedEvent(
                  authCredential: credential));
            },
            verificationFailed: (FirebaseAuthException e) =>
                add(OnPhoneAuthErrorEvent(error: e.toString())),
            codeSent: (String verificationId, int? refreshToken) => add(
                OnPhoneOtpSendEvent(
                    verificationId: verificationId, token: refreshToken)),
            codeAutoRetrievalTimeout: (String verificationId) {});
      } catch (e) {
        emit(LoginScreenErrorState(error: e.toString()));
      }
    });
    on<OnPhoneOtpSendEvent>((event, emit) {
      emit(PhoneAuthCodeSentSuccessState(verificationId: event.verificationId));
    });
    on<VerifySendOtpEvent>((event, emit) async {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: event.verificationId, smsCode: event.otpCode);
        add(OnPhoneAuthVerificationCompletedEvent(authCredential: credential));
      } catch (e) {
        emit(LoginScreenErrorState(error: e.toString()));
      }
    });
    on<OnPhoneAuthErrorEvent>((event, emit) {
      emit(LoginScreenErrorState(error: event.error));
    });
    on<OnPhoneAuthVerificationCompletedEvent>((event, emit) async {
      try {
        await firebaseAuthServices.authentication
            .signInWithCredential(event.authCredential)
            .then((value) async {
          emit(SignUpScreenOtpSuccessState());
          emit(LoginScreenLoadingState());
          resultOfRegistrationStatus = await firebaseAuthServices.checkRegistrationStatus();
          adminStatus = await firebaseAuthServices.checkAdminStatus();
          if (resultOfRegistrationStatus == 'Success') {
            //print(adminStatus);
            if(adminStatus == true) {
              emit(LoginScreenLoadedState());
            } else {
              firebaseAuthServices.authentication.signOut();
              emit(LoginScreenErrorState(error: 'Please ask for the admin permission first'));
            }
            //adminStatus == true ? emit(LoginScreenLoadingState()) : emit(LoginScreenErrorState(error: 'Please ask for the admin permission first'));
          } else {
            firebaseAuthServices.authentication.signOut();
            emit(LoginScreenErrorState(error: resultOfRegistrationStatus));
          }
        });
      } catch (e) {
        emit(LoginScreenErrorState(error: e.toString()));
      }
    });
  }

  void _onLogoutEventLogin(LogoutEventLogin event, Emitter<LoginState> emit) async {
    try{
      await firebaseAuthServices.authentication.signOut();
      emit(LogoutSuccessStateLogin());
    } catch (e) {
      emit(LoginScreenErrorState(error: e.toString()));
    }
  }
}
