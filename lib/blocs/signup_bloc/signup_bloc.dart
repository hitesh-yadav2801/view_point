
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/blocs/login_bloc/login_bloc.dart';
import 'package:view_point/data/models/user_model.dart';
import 'package:view_point/data/services/firebase_auth_services.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  String loginResult = '';
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  UserCredential? userCredential;
  String dataStorageResult = '';
  bool adminStatus = false;
  SignupBloc() : super(SignupInitialState()) {
    on<SignupEvent>((_, emit) => emit(LoginScreenLoadingStateSignUp()));
    on<SignUpSendOtpToPhoneEvent>((event, emit) async {
      try {
        print('here');
        await firebaseAuthServices.loginWithPhone(
            phoneNumber: event.phoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) {
              add(SignUpOnPhoneAuthVerificationCompletedEvent(
                  authCredential: credential, userModel: event.userModel ));
            },
            verificationFailed: (FirebaseAuthException e) =>
                add(SignUpOnPhoneAuthErrorEvent(error: e.toString())),
            codeSent: (String verificationId, int? refreshToken) => add(
                SignUpOnPhoneOtpSendEvent(
                    verificationId: verificationId, token: refreshToken, userModel: event.userModel)),
            codeAutoRetrievalTimeout: (String verificationId) {});
      } catch (e) {
        print(e.toString());
        emit(LoginScreenErrorStateSignUp(error: e.toString()));
      }
    });
    on<SignUpOnPhoneOtpSendEvent>((event, emit) {
      emit(PhoneAuthCodeSentSuccessStateSignUp(verificationId: event.verificationId));
    });
    on<SignUpVerifySendOtpEvent>((event, emit) async {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: event.verificationId, smsCode: event.otpCode);
        add(SignUpOnPhoneAuthVerificationCompletedEvent(authCredential: credential, userModel: event.userModel,));
      } catch (e) {
        emit(LoginScreenErrorStateSignUp(error: e.toString()));
      }
    });
    on<SignUpOnPhoneAuthErrorEvent>((event, emit) {
      emit(LoginScreenErrorStateSignUp(error: event.error));
    });
    on<SignUpOnPhoneAuthVerificationCompletedEvent>((event, emit) async {
      try {
        await firebaseAuthServices.authentication
            .signInWithCredential(event.authCredential)
            .then((value) async {
          emit(SignUpScreenOtpSuccessStateSignUp());
          emit(LoginScreenLoadingStateSignUp());
          dataStorageResult = await firebaseAuthServices.addUserToDB(event.userModel);
          adminStatus = await firebaseAuthServices.checkAdminStatus();
          if (dataStorageResult == 'success') {
            if(adminStatus == true) {
              emit(LoginScreenLoadedStateSignUp());
            } else {
              firebaseAuthServices.authentication.signOut();
              emit(LoginScreenErrorStateSignUp(error: 'Please ask for the admin permission first'));
            }
          } else {
            firebaseAuthServices.authentication.signOut();
            emit(LoginScreenErrorStateSignUp(error: dataStorageResult));
          }
        });
      } catch (e) {
        //firebaseAuthServices.authentication.signOut();
        print(e.toString());
        emit(LoginScreenErrorStateSignUp(error: e.toString()));
      }
    });
  }
}
