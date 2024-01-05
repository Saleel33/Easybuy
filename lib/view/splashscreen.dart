import 'package:e_commerce_app/view/loginpage.dart';
import 'package:e_commerce_app/view/navbar.dart';
import 'package:e_commerce_app/view/numberverification.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (auth.currentUser?.uid == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MyNavigationBar()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Image.asset(
        'assets/images/easybuy-.png',
        height: 100,
        width: 100,
      )),
    );
  }
}
