import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkerrr/auth.dart';
import 'package:walkerrr/services/user_data_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';

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

// ======== Secure Storage =========>

  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirm =
      TextEditingController();

  // final String _keyDisplayName = 'displayName';
  // final String _keyEmail = 'email';
  // final String _keyPassWord = 'password';

  final SecureStorage _secureStorage = SecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
    // setSecureStorageData();
    // deleteSecureStorageData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controllerDisplayName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerPasswordConfirm.dispose();
    super.dispose();
  }

  Future<void> fetchSecureStorageData() async {
    _controllerDisplayName.text = await _secureStorage.getDisplayName() ?? '';
    _controllerEmail.text = await _secureStorage.getEmail() ?? '';
    _controllerPassword.text = await _secureStorage.getPassWord() ?? '';
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

// ======== Form widgets =========>

// Flutter validation package methods
  final AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  String? _password = '';
  String? _passwordConfirm = '';

  final _displayNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(2, errorText: 'Min. 2 letters'),
  ]);
  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(5, errorText: 'Min. 5 letters'),
    EmailValidator(errorText: "Invalid email address"),
  ]);
  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(3, errorText: 'Min. 2 letters'),
    // MaxLengthValidator(20, errorText: "Password cannot be loger than 20 characters"),
    // PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'Password must contain at least one special character')
  ]);
  final _passwordConfirmValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
  ]);

  // Form field widgets

  Widget _entryFieldDisplayName(
    String displayName,
    TextEditingController _controllerDisplayName,
  ) {
    return TextFormField(
      validator: _displayNameValidator,
      controller: _controllerDisplayName,
      cursorColor: Colors.green,
      decoration: InputDecoration(
        hintText: 'Enter your name',
        hintStyle: TextStyle(
          color: Colors.black26,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
        prefixIcon: const Icon(Icons.person_outline_outlined),
        label: const Text(
          'Name',
          style: TextStyle(
            color: Colors.black54,
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _entryFieldEmail(
    String email,
    TextEditingController _controllerEmail,
  ) {
    return TextFormField(
      validator: _emailValidator,
      controller: _controllerEmail,
      cursorColor: Colors.green,
      decoration: InputDecoration(
        hintText: 'Enter your email',
        hintStyle: TextStyle(
          color: Colors.black26,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
        prefixIcon: const Icon(Icons.alternate_email_outlined),
        label: const Text(
          'Email',
          style: TextStyle(
            color: Colors.black54,
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _entryFieldPassword(
    String password,
    TextEditingController _controllerPassword,
  ) {
    return TextFormField(
      obscureText: _isVisible,
      validator: _passwordValidator,
      onChanged: ((value) => (value.isEmpty)
          ? _password = value
          : _password = _controllerPassword.text),
      controller: _controllerPassword,
      cursorColor: Colors.green,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.black26,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
        prefixIcon: const Icon(Icons.password_outlined),
        label: const Text(
          'Password',
          style: TextStyle(
            color: Colors.black54,
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
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

  Widget _entryFieldPasswordConfirm(
    String passwordConfirm,
    TextEditingController _controllerPasswordConfirm,
  ) {
    return TextFormField(
      obscureText: _isVisible,
      validator: _passwordConfirmValidator,
      onChanged: ((value) => _passwordConfirm = value),
      controller: _controllerPasswordConfirm,
      cursorColor: Colors.green,
      decoration: InputDecoration(
        hintText: 'Re-type password',
        hintStyle: TextStyle(
          color: Colors.black26,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
        prefixIcon: const Icon(
          Icons.password_outlined,
        ),
        label: const Text(
          'Confirm password',
          style: TextStyle(
            color: Colors.black54,
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == "" ? "" : "$errorMessage");
  }

  Widget _submitButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, foregroundColor: Colors.white),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_isLogin) _submitValidation();
            {
              if (_passwordConfirm == _password ||
                  _passwordConfirm == _controllerPassword.text) {
                _submitValidation();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.pink,
                      content: const Text("Re-type both passwords!")),
                );
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.pink,
                  content: Text(errorMessage == ""
                      ? "Check form fields!"
                      : "Error: $errorMessage!")),
            );
          }
        },
        child: Text(_isLogin ? "Login" : "Register"));
  }

  void _submitValidation() {
    _isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
    _formKey.currentState?.save();
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
          });
        },
        child: Text(_isLogin ? "Register Instead" : "Login Instead",
            style: const TextStyle(
              color: Colors.blue,
              letterSpacing: 0.5,
              fontSize: 14,
            )));
  }

  Widget _dontStoreMyData() {
    return CheckboxListTile(
      title: const Text(
        "Don't Save Data",
        style: TextStyle(color: Colors.black54, fontSize: 12),
      ),
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
          setState(() {
            errorMessage = '';
            _formKey.currentState?.reset();
          });
          _controllerDisplayName.clear();
          _controllerEmail.clear();
          _controllerPassword.clear();
          _controllerPasswordConfirm.clear();
        },
        child: const Text(
          "Clear Form",
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ));
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
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: double.infinity,
                        child: (!_isLogin)
                            ? _entryFieldDisplayName(
                                "Your name", _controllerDisplayName)
                            : const SizedBox(
                                width: double.infinity,
                              ),
                      ),
                      Container(
                        height: 80,
                        width: double.infinity,
                        child: _entryFieldEmail("Your email", _controllerEmail),
                      ),
                      Container(
                        height: 80,
                        width: double.infinity,
                        child: _entryFieldPassword(
                            "Enter password", _controllerPassword),
                      ),
                      if (!_isLogin)
                        Container(
                          height: 80,
                          width: double.infinity,
                          child: _entryFieldPasswordConfirm(
                              "Re-type password", _controllerPasswordConfirm),
                        ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        width: 150,
                        child: _submitButton(),
                      ),
                      Container(
                        height: 40,
                        width: 150,
                        child: _loginOrRegisterButton(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: _dontStoreMyData(),
                      ),
                      Expanded(
                        child: _clearMyData(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
// <========
