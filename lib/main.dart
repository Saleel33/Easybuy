import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/viewmodel/provider/APIfetchingprovider.dart';
import 'package:e_commerce_app/viewmodel/provider/cartprovider.dart';
import 'package:e_commerce_app/viewmodel/provider/numberverificationProvider.dart';
import 'package:e_commerce_app/viewmodel/provider/signInWithGoogle.dart';
import 'package:e_commerce_app/view/dashbord.dart';
import 'package:e_commerce_app/view/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => APIfetchingProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => signInWithGoogleProvider()),
        ChangeNotifierProvider(create: (_) => Numberverification())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/productpage': (context) => ProductPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
        },
      ),
    );
  }
}
