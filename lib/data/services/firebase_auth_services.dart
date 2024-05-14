import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:view_point/data/models/user_model.dart';

class FirebaseAuthServices {
  FirebaseAuth authentication = FirebaseAuth.instance;
  User? firebaseUser;
  FirebaseFirestore database = FirebaseFirestore.instance;

  Future<void> loginWithPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await authentication.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<String> addUserToDB(UserModel userModel) async {
    try {
      await database.collection('users').doc(authentication.currentUser!.uid).set(userModel.toMap());
      return 'Success';
    } catch (e) {
      return 'Something went wrong ${e.toString()}';
    }
  }

  Future<String> checkRegistrationStatus() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseAuthServices().database.collection('users').doc(FirebaseAuthServices().authentication.currentUser!.uid).get();
      if (userData['registrationFlag'] == true) {
        return 'Success';
      } else {
        return 'Please sign up first';
      }
    } catch (e) {
      return 'Something went wrong ${e.toString()}';
    }
  }
  Future<bool> checkAdminStatus() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseAuthServices().database.collection('users').doc(FirebaseAuthServices().authentication.currentUser!.uid).get();
      return userData['isAdmin'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await authentication.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
