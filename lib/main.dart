import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "login_screen.dart";
import "profile_screen.dart";
import "registration_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const RegistrationScreen(),
      routes: {
        "/login": (context) => const LoginScreen(),
        "/profile": (context) => ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
