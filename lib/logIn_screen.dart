import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Initialisiert Firebase Authentication für Authentifizierungsoperationen.
  final TextEditingController _emailController =
      TextEditingController(); // Controller für das E-Mail-Textfeld.
  final TextEditingController _passwordController =
      TextEditingController(); // Controller für das Passwort-Textfeld.
  final GlobalKey<FormState> _formKey = GlobalKey<
      FormState>(); // Schlüssel für das Formular, um Validierung und Zustand zu verwalten.

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Überprüft, ob das Formular gültig ist (alle Validatoren sind erfüllt).
      try {
        // Hier wird versucht, den Benutzer mit E-Mail und Passwort anzumelden.
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text
              .trim(), // Holt die getrimmte E-Mail-Adresse vom E-Mail-Controller.
          password: _passwordController.text
              .trim(), // Holt das getrimmte Passwort vom Passwort-Controller.
        );
        if (userCredential.user != null) {
          // Überprüft, ob die Anmeldung erfolgreich war.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Fangt spezifische Firebase Auth-Fehler ab und zeigt eine Fehlermeldung an.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Email oder Passwort falsch. Bitte erneut versuchen.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anmeldung"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key:
              _formKey, // Verknüpft das Formular mit dem Schlüssel, um Validierung und Zustand zu verwalten.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller:
                    _emailController, // Verknüpft das E-Mail-Textfeld mit dem Controller.
                decoration: const InputDecoration(
                    labelText:
                        "E-Mail"), // Fügt eine Beschriftung "E-Mail" zum Textfeld hinzu.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // Überprüft, ob der Wert null oder leer ist.
                    return "Bitte geben Sie Ihre E-Mail ein"; // Gibt eine Fehlermeldung zurück, wenn das Feld leer ist.
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    // Überprüft das E-Mail-Format mit einem regulären Ausdruck.
                    return "Bitte geben Sie eine gültige E-Mail-Adresse ein"; // Gibt eine Fehlermeldung zurück, wenn die E-Mail nicht gültig ist.
                  }
                  return null; // Gibt null zurück, wenn das Feld gültig ist.
                },
              ),
              TextFormField(
                controller:
                    _passwordController, // Verknüpft das Passwort-Textfeld mit dem Controller.
                obscureText:
                    true, // Verbirgt den eingegebenen Text für Passwortfelder.
                decoration: const InputDecoration(
                    labelText:
                        "Passwort"), // Fügt eine Beschriftung "Passwort" zum Textfeld hinzu.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // Überprüft, ob der Wert null oder leer ist.
                    return "Bitte geben Sie Ihr Passwort ein"; // Gibt eine Fehlermeldung zurück, wenn das Feld leer ist.
                  }
                  return null; // Gibt null zurück, wenn das Feld gültig ist.
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Anmelden"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: const Text("Noch keinen Account? Registrieren"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController
        .dispose(); // Stellt sicher, dass der Teil der App, der deine E-Mail speichert, aufgeräumt wird.
    _passwordController.dispose(); // Macht dasselbe für dein Passwort.
    super
        .dispose(); // Dies ist wie das Aufräumen der letzten Reste der App, um sicherzustellen, dass alles richtig beendet wird.
    //Es sagt der App, dass sie nun alle Aufgaben beendet hat und bereit ist, sich vollständig zu schließen.
  }
}
