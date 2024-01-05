import 'package:e_commerce_app/view/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignInPage extends StatelessWidget {
  SignInPage({super.key});
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: Color.fromARGB(255, 7, 57, 73),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'username',
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 55,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'email',
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
                        final newuser =
                            await auth.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                        // ignore: unnecessary_null_comparison
                        if (newuser != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => MyNavigationBar()),
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
                      "Submit",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
