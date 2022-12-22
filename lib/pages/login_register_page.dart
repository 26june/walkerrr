import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkerrr/auth.dart';
import 'package:walkerrr/services/user_data_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  bool _isLogin = true; // Login/Register button text change
  bool _isVisible = true; // Show/Hide password
  bool _dontStore = false; // Secure Storage will not be updated

// Form text boxes controller

  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

// ======== Secure Storage =========>

  final String _keyDisplayName = 'displayName';
  final String _keyEmail = 'email';
  final String _keyPassWord = 'password';

  final SecureStorage _secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
    // setSecureStorageData();
    // deleteSecureStorageData();
  }

  Future<void> fetchSecureStorageData() async {
    _controllerDisplayName.text = await _secureStorage.getDisplayName() ?? '';
    _controllerEmail.text = await _secureStorage.getEmail() ?? '';
    _controllerPassword.text = await _secureStorage.getPassWord() ?? '';
    // setState(() {
    //   _isLogin = true;
    // });
  }

  // Future<void> setSecureStorageData() async {
  //   await _secureStorage.write(key: _keyDisplayName);
  //   await _secureStorage.write(key: _keyEmail);
  //   await _secureStorage.write(key: _keyPassWord);
  // }

  // Future<void> deleteSecureStorageData() async {
  //   await _secureStorage.delete(key: _keyDisplayName);
  //   await _secureStorage.delete(key: _keyEmail);
  //   await _secureStorage.delete(key: _keyPassWord);
  // }

// <========

// ======== Login / Register auth =========>

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
// <========

// Page App bar login/register title

  Widget _title() {
    return (_isLogin) ? const Text("Login") : const Text("Register");
  }

// ======== Form =========>

  Widget _entryFieldDisplayName(
    String displayName,
    TextEditingController _controllerDisplayName,
  ) {
    return TextFormField(
      enableSuggestions: true,
      controller: _controllerDisplayName,
      validator: (value) {
        if (value == '') {
          return 'Enter your name!';
        }
        return null;
      },
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
    return TextFormField(
      enableSuggestions: true,
      controller: _controllerEmail,
      validator: (value) {
        if (value == '') {
          return 'Enter a valid email!';
        }
        return null;
      },
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
    return TextFormField(
      obscureText: _isVisible,
      enableSuggestions: false,
      autocorrect: false,
      controller: _controllerPassword,
      validator: (value) {
        if (value == '') {
          return 'Enter a valid password!';
        }
        return null;
      },
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
      title: const Text("Don't Save Data", style: TextStyle(fontSize: 12)),
      value: _dontStore,
      onChanged: (bool? value) {
        setState(() {
          _dontStore = value!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _clearMyData() {
    return TextButton(
        onPressed: () {
          _controllerDisplayName.clear();
          _controllerEmail.clear();
          _controllerPassword.clear();
          setState(() {
            errorMessage = '';
          });
        },
        child: const Text("Clear Form", style: TextStyle(fontSize: 12)));
  }

// <========

// ======== Login page structure =========>

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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: double.infinity,
                        child: Center(
                          child: (!_isLogin)
                              ? _entryFieldDisplayName(
                                  "name", _controllerDisplayName)
                              : const SizedBox(
                                  width: double.infinity,
                                ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        child: _entryFieldEmail("email", _controllerEmail),
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        child: _entryFieldPassword(
                            "password", _controllerPassword),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: _errorMessage(),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        child: _submitButton(),
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        child: _loginOrRegisterButton(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: _dontStoreMyData(),
                      ),
                      Expanded(
                        child: _clearMyData(),
                      ),
                    ],
                  )
                ]),
          ),
        ));
  }
}
// <========
