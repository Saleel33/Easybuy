import 'package:e_commerce_app/viewmodel/provider/signInWithGoogle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  User? user = FirebaseAuth.instance.currentUser;
  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final providerObj = Provider.of<signInWithGoogleProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          children: [
            Center(
                child: CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 55,
                    child: user?.photoURL != null
                        ? ClipOval(
                            child: Image.network(user!.photoURL!),
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 70,
                          ))),
            Text(
              user?.email ?? 'Gust',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            SizedBox(
              width: width / 1.2,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  onPressed: () {
                    providerObj.signOut(context);
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ));
  }
}
