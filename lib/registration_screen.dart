import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'login_screen.dart'; 

class RegistrationScreen extends StatefulWidget { /
  const RegistrationScreen({super.key}); 

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState(); 
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final TextEditingController _emailController = TextEditingController(); // die E-Mail vom Benutzer speichern.
  final TextEditingController _passwordController = TextEditingController(); // das Passwort vom Benutzer speichern.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // die Eingaben des Benutzers überprüfen.

  Future<void> _register() async { //
    if (_formKey.currentState!.validate()) { // Wenn die Eingaben des Benutzers richtig sind:
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword( // Wir versuchen, einen neuen Benutzer mit der E-Mail und dem Passwort zu erstellen.
          email: _emailController.text.trim(), // unnötige Leerzeichen werden hiermit entfernt.
          password: _passwordController.text.trim(), 
        );
        if (userCredential.user != null) { // Wenn der Benutzer erfolgreich erstellt wurde:
          Navigator.pushReplacement( 
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } on FirebaseAuthException catch (e) { 
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(content: Text(e.message ?? "Registrierung fehlgeschlagen")), 
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrierung"), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Form(
          key: _formKey, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              TextFormField(
                controller: _emailController, 
                decoration: const InputDecoration(labelText: "E-Mail"), 
                validator: (value) {
                  if (value == null || value.isEmpty) { 
                    return "Bitte geben Sie Ihre E-Mail ein"; 
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) { 
                    return "Bitte geben Sie eine gültige E-Mail-Adresse ein"; 
                  }
                  return null; 
                },
              ),
              TextFormField(
                controller: _passwordController, 
                obscureText: true, // Das Passwort wird versteckt, damit es niemand sehen kann.
                decoration: const InputDecoration(labelText: "Passwort"), 
                validator: (value) {
                  if (value == null || value.isEmpty) { 
                    return "Bitte geben Sie Ihr Passwort ein"; 
                  }
                  if (value.length < 6) { // Wenn das Passwort kürzer als 6 Zeichen ist:
                    return "Das Passwort muss mindestens 6 Zeichen lang sein"; // Zeige eine Fehlermeldung.
                  }
                  return null; 
                },
              ),
              const SizedBox(height: 20), 
              ElevatedButton(
                onPressed: _register, 
                child: const Text("Registrieren"), 
              ),
              TextButton(
                onPressed: () { 
                  Navigator.pushReplacement( 
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text("Bereits registriert? Anmelden"), 
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {// Diese Methode wird aufgerufen, wenn der Bildschirm nicht mehr benötigt wird.
    _emailController.dispose(); // Wir geben das Werkzeug für die E-Mail wieder zurück, damit es keine Ressourcen mehr verbraucht.
    _passwordController.dispose(); // Wir geben das Werkzeug für das Passwort ebenfalls zurück, damit es keine Ressourcen mehr verbraucht.
    super.dispose(); 
  }
}
