import 'package:e_commerce_app/provider/signInWithGoogle.dart';
import 'package:e_commerce_app/view/navbar.dart';
import 'package:e_commerce_app/view/numberverification.dart';
import 'package:e_commerce_app/view/dashbord.dart';
import 'package:e_commerce_app/view/signinpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({
    super.key,
  });
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  signInWithGoogleProvider providerObj = signInWithGoogleProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/easybuy-.png',
                      height: 200,
                      width: 300,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'password',
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
                    onPressed: () async {
                      try {
                        final newuser = await auth.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);
                        // ignore: unnecessary_null_comparison
                        if (newuser != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProductPage()),
                          );
                        } else {
                          print('error');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Invalid username or password',
                            style: TextStyle(fontSize: 17),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(10),
                        ));
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'OR',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: 50,
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/google-icon.png'),
                          ),
                          Text(
                            'sign in with',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  onTap: () async {
                    // obj.signInWithGoogle();
                    UserCredential userCredential =
                        await providerObj.signInWithGoogle();
                    if (userCredential != true) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyNavigationBar()));
                    } else {}
                  },
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: 50,
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/phone_icon.png'),
                          ),
                          Text(
                            'with OTP',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  onTap: () {
                    // obj.signInWithGoogle();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PhoneNumber()));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account ?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 17),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
