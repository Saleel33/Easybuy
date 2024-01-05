import 'package:e_commerce_app/provider/signInWithGoogle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

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
            Center(child: CircleAvatar(radius: 55)),
            Spacer(),
            SizedBox(
              width: width,
              child: ElevatedButton(
                  onPressed: () {
                    providerObj.signOut(context);
                  },
                  child: Text('Log Out')),
            )
          ],
        ));
  }
}
