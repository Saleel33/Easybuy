import 'package:e_commerce_app/view/navbar.dart';
import 'package:e_commerce_app/view/numberverification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Numberverification extends ChangeNotifier {
  final userNumber = TextEditingController();
  void verifyUserPhoneNumber() {
    auth.verifyPhoneNumber(
      phoneNumber: userNumber.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then(
              (value) => print('Logged In Successfully'),
            );
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        receivedID = verificationId;
        otpFieldVisibility = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('TimeOut');
      },
    );
    notifyListeners();
  }

  Future<void> verifyOTPCode(context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: receivedID,
      smsCode: otpController.text,
    );
    await auth.signInWithCredential(credential).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyNavigationBar()));
      print('User Login In Successful');
    });
    notifyListeners();
  }

  var receivedID = '';
}
