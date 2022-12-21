import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkerrr/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:walkerrr/services/user_data_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  bool _isLogin = true;
  bool _isVisible = true;
  bool _dontStore = false;
  bool _clearInput = false;

  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final SecureStorage _secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
  }

  Future<void> fetchSecureStorageData() async {
    _controllerDisplayName.text = await _secureStorage.getDisplayName() ?? '';
    _controllerEmail.text = await _secureStorage.getEmail() ?? '';
    _controllerPassword.text = await _secureStorage.getPassWord() ?? '';
  }

  Future<void> signInWithEmailAndPassword() async {
    if (!_dontStore) {
      await _secureStorage.setDisplayName(_controllerDisplayName.text);
      await _secureStorage.setEmail(_controllerEmail.text);
      await _secureStorage.setPassWord(_controllerPassword.text);
    }
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
    if (!_dontStore) {
      await _secureStorage.setDisplayName(_controllerDisplayName.text);
      await _secureStorage.setEmail(_controllerEmail.text);
      await _secureStorage.setPassWord(_controllerPassword.text);
    }
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          displayname: _controllerDisplayName.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return (_isLogin) ? const Text("Login") : const Text("Register");
  }

  Widget _entryFieldDisplayName(
    String displayName,
    TextEditingController _controllerDisplayName,
  ) {
    return TextField(
      enableSuggestions: true,
      controller: _controllerDisplayName,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline_outlined),
        labelText: displayName,
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
        prefixIcon: const Icon(Icons.alternate_email_outlined),
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
        prefixIcon: const Icon(Icons.password_outlined),
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
        onPressed: _isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(_isLogin ? "Login" : "Register"));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
          });
        },
        child: Text(_isLogin ? "Register Instead" : "Login Instead"));
  }

  Widget _dontStoreMyData() {
    return CheckboxListTile(
      title: const Text("Don't Store My Data", style: TextStyle(fontSize: 12)),
      value: _dontStore,
      onChanged: (bool? value) {
        setState(() {
          _dontStore = value!;
        });
      },
      // controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _clearForm() {
    return CheckboxListTile(
      title: const Text("Clear Form", style: TextStyle(fontSize: 12)),
      value: _clearInput,
      onChanged: (bool? value) {
        _controllerDisplayName.clear();
        _controllerEmail.clear();
        _controllerPassword.clear();
        setState(() {
          errorMessage = '';
          _clearInput = value!;
        });
      },
      // controlAffinity: ListTileControlAffinity.leading,
    );
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
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (!_isLogin)
                      ? _entryFieldDisplayName("name", _controllerDisplayName)
                      : const SizedBox(width: double.infinity, height: 60.0),
                  _entryFieldEmail("email", _controllerEmail),
                  _entryFieldPassword("password", _controllerPassword),
                  _errorMessage(),
                  _submitButton(),
                  _loginOrRegisterButton(),
                  _dontStoreMyData(),
                  _clearForm(),
                ]),
          ),
        ));
  }
}
