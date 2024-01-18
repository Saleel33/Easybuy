import 'package:e_commerce_app/viewmodel/provider/numberverificationProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

FirebaseAuth auth = FirebaseAuth.instance;

final otpController = TextEditingController();

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  Widget build(BuildContext context) {
    final providerObj = Provider.of<Numberverification>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: providerObj.userNumber,
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile Number',
                    hintStyle: TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white70)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 365,
              height: 55,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {
                    providerObj.verifyUserPhoneNumber();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OTP_Page()),
                    );
                  },
                  child: Text(
                    "Send OTP",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class OTP_Page extends StatefulWidget {
  OTP_Page({super.key});

  @override
  State<OTP_Page> createState() => _OTP_PageState();
}

class _OTP_PageState extends State<OTP_Page> {
  @override
  Widget build(BuildContext context) {
   final providerObj = Provider.of<Numberverification>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: otpController,
                  decoration: InputDecoration(
                    hintText: 'Enter OTP',
                    hintStyle: TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white70)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 365,
              height: 55,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {
                    if (otpFieldVisibility) {
                     providerObj. verifyOTPCode(context);
                    } else {
                    providerObj.  verifyUserPhoneNumber();
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

 

 

 
}


bool otpFieldVisibility = false;
