import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkerrr/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  bool isLogin = true;
  bool _isVisible = true;

  final TextEditingController _controllerDisplayName =
      TextEditingController(text: "");
  final TextEditingController _controllerEmail =
      TextEditingController(text: "");
  final TextEditingController _controllerPassword =
      TextEditingController(text: "");

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text("Login");
  }

  Widget _entryFieldDisplayName(
    String displayname,
    TextEditingController _controllerDisplayName,
  ) {
    return TextField(
      enableSuggestions: true,
      controller: _controllerDisplayName,
      decoration: InputDecoration(
        labelText: displayname,
      ),
    );
  }

  Widget _entryFieldEmail(
    String email,
    TextEditingController _controllerEmail,
  ) {
    return TextField(
      enableSuggestions: true,
      controller: _controllerEmail,
      decoration: InputDecoration(
        labelText: email,
      ),
    );
  }

  Widget _entryFieldPassword(
    String password,
    TextEditingController _controllerPassword,
  ) {
    return TextField(
      obscureText: _isVisible,
      enableSuggestions: false,
      autocorrect: false,
      controller: _controllerPassword,
      decoration: InputDecoration(
        labelText: password,
        suffixIcon: IconButton(
          icon: Icon(
            _isVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == "" ? "" : "Error: $errorMessage");
  }

  Widget _submitButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, foregroundColor: Colors.white),
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(isLogin ? "Login" : "Register"));
  }

  Widget _clearForm() {
    return TextButton(
        onPressed: () {
          _controllerDisplayName.clear();
          _controllerEmail.clear();
          _controllerPassword.clear();
        },
        child: const Text("Clear form"));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? "Register Instead" : "Login Instead"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryFieldDisplayName("display_name", _controllerDisplayName),
            _entryFieldEmail("email", _controllerEmail),
            _entryFieldPassword("password", _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
            _clearForm(),
          ],
        ),
      ),
    );
  }
}
