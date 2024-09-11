import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Aktuell angemeldeten Benutzer abrufen
    User? user = _auth.currentUser;

    // Extrahiere den Namen (Teil vor dem @ in der E-Mail)
    String email = user?.email ?? "Benutzer";
    String userName = email.split('@')[0]; // Teil vor dem @

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Willkommen, $userName!",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Schön, dass Du da bist!"),
              const SizedBox(height: 20),
              Text(
                "E-Mail: $email",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _auth.signOut().then((value) {
                    Navigator.of(context).pushReplacementNamed("/login");
                  });
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: const Text("Abmelden"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
