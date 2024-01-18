import 'package:e_commerce_app/view/loginpage.dart';
import 'package:e_commerce_app/view/numberverification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class signInWithGoogleProvider extends ChangeNotifier {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signOut(context) {
    auth.signOut();
    GoogleSignIn().signOut();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
    notifyListeners();
  }
}
