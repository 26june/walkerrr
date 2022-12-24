import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkerrr/auth.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/pages/quests_tab.dart';
import 'package:walkerrr/pages/steps_main_page.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';
import 'package:walkerrr/services/user_data_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController();

  // ==================== User MongoDB data edit ====================>

  Widget _userUid() {
    return Text(user?.email ?? "User Email");
  }

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> deleteUser() async {
    showAlertDialog(context);
  }

  Future<void> updateUserName() async {
    final newUsername = _controllerDisplayName.text;
    patchUsername(userObject['uid'], newUsername);
    _controllerDisplayName.text = newUsername;
    setState(() {
      isDisplayNameSaved = true;
    });
  }

  Future<void> updateEmail() async {
    final newEmail = _controllerEmail.text;
    // patchEmail(userObject['email'], newEmail);
    _controllerEmail.text = newEmail;
    setState(() {
      isEmailSaved = true;
    });
  }

  Future<void> updatePassword() async {
    final newPassword = _controllerPassword.text;
    // patchPassword(userObject['password'], newPassword);
    _controllerPassword.text = newPassword;
    setState(() {
      isPasswordSaved = true;
    });
  }

  // <=============

  Widget _title() {
    if (_selectedIndex == 0) {
      return const Text('Steps');
    } else if (_selectedIndex == 1) {
      return const Text('Quests');
    } else {
      return const Text('Settings');
    }
  }

// ==================== USER SETTINGS PAGE ====================

// --------- Secure storage ---------

  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirm =
      TextEditingController();

  final SecureStorage _secureStorage = SecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
    // setSecureStorageData();
    // deleteSecureStorageData();
  }

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is removed from the
  //   // widget tree.
  //   _controllerDisplayName.dispose();
  //   _controllerEmail.dispose();
  //   _controllerPassword.dispose();
  //   _controllerPasswordConfirm.dispose();
  //   super.dispose();
  // }

  Future<void> fetchSecureStorageData() async {
    _controllerDisplayName.text = await _secureStorage.getDisplayName() ?? '';
    _controllerEmail.text = await _secureStorage.getEmail() ?? '';
    _controllerPassword.text = await _secureStorage.getPassWord() ?? '';
  }

// --------- Form validation ---------

  final AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  String? _password = '';
  String? _passwordConfirm = '';

  final _displayNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter new display name'),
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

// --------- Form fields widgets ---------

  bool isDisplayNameEditingEnabled = false;
  bool isEmailEditingEnabled = false;
  bool isPasswordEditingEnabled = false;
  bool isEditingEnabled = false;

  bool isDisplayNameFocused = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool isPasswordConfirmFocused = false;

  bool isDisplayNameChanged = false;
  bool isEmailChanged = false;
  bool isPasswordChanged = false;

  bool isDisplayNameSaved = true;
  bool isEmailSaved = true;
  bool isPasswordSaved = true;
  bool isFormSaved = false;

  bool isObscure = true;

  String? newDisplayName = '';
  String? newEmail = '';
  String? newPassword = '';

  Widget _entryFieldDisplayName(
    String displayName,
    TextEditingController _controllerDisplayName,
  ) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isDisplayNameFocused = true;
              print(
                  'isDisplayNameFocused ================ $isDisplayNameFocused');
            });
          } else {
            setState(() {
              isDisplayNameFocused = false;
              print(
                  'isDisplayNameFocused ================ $isDisplayNameFocused');
            });
          }
        },
        child: TextFormField(
          enabled: isDisplayNameEditingEnabled,
          validator: _displayNameValidator,
          onChanged: ((value) => {
                setState(
                  () {
                    isDisplayNameChanged = true;
                    newDisplayName = value;
                    print(
                        'isDisplayNameChanged ================ $isDisplayNameChanged');
                  },
                )
              }),
          controller: _controllerDisplayName,
          cursorColor: GlobalStyleVariables.secondaryColour,
          decoration: InputDecoration(
            hintText: 'Enter new display name',
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            filled: isDisplayNameFocused,
            fillColor: Colors.black12,
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GlobalStyleVariables.secondaryColour),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            icon: const Icon(Icons.person_outline_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                !isDisplayNameEditingEnabled
                    ? Icons.toggle_off_outlined
                    : !isDisplayNameChanged
                        ? Icons.toggle_on_rounded
                        : !isDisplayNameSaved
                            ? Icons.toggle_off_outlined
                            : Icons.save_outlined,
              ),
              onPressed: () {
                updateUserName();
                setState(() {
                  print(
                      'isDisplayNameSaved ================ $isDisplayNameSaved');
                  isDisplayNameEditingEnabled = false;
                  print(
                      'isDisplayNameSaved ================ $isDisplayNameSaved');
                });
              },
            ),
          ),
        ));
  }

  Widget _entryFieldEmail(
    String email,
    TextEditingController _controllerEmail,
  ) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isEmailFocused = true;
            });
          } else {
            setState(() {
              isEmailFocused = false;
            });
          }
        },
        child: TextFormField(
          enabled: isEmailEditingEnabled,
          validator: _emailValidator,
          onChanged: ((value) => {
                setState(
                  () {
                    isEmailChanged = true;
                    newEmail = value;
                  },
                )
              }),
          controller: _controllerEmail,
          cursorColor: GlobalStyleVariables.secondaryColour,
          decoration: InputDecoration(
            hintText: 'Enter new email',
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            filled: isEmailFocused,
            fillColor: Colors.black12,
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GlobalStyleVariables.secondaryColour),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            icon: const Icon(Icons.alternate_email_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                !isEmailEditingEnabled
                    ? Icons.toggle_off_outlined
                    : !isEmailChanged
                        ? Icons.toggle_on_rounded
                        : !isEmailSaved
                            ? Icons.toggle_off_outlined
                            : Icons.save_outlined,
              ),
              onPressed: () {
                updateEmail();
                setState(() {
                  isEmailSaved = true;
                  print('isEmailSaved ================ $isEmailSaved');
                  isEmailEditingEnabled = false;
                  print('isEmailSaved ================ $isEmailSaved');
                });
              },
            ),
          ),
        ));
  }

  Widget _entryFieldPassword(
    String password,
    TextEditingController _controllerPassword,
  ) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isPasswordFocused = true;
            });
          } else {
            setState(() {
              isPasswordFocused = false;
            });
          }
        },
        child: TextFormField(
          enabled: isPasswordEditingEnabled,
          obscureText: isObscure,
          validator: _passwordValidator,
          onChanged: ((value) => {
                setState(
                  () {
                    isPasswordChanged = true;
                    newPassword = value;
                  },
                )
              }),
          controller: _controllerPassword,
          cursorColor: GlobalStyleVariables.secondaryColour,
          decoration: InputDecoration(
            hintText: 'Change your password',
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            filled: isPasswordFocused,
            fillColor: Colors.black12,
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GlobalStyleVariables.secondaryColour),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            icon: const Icon(Icons.password_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                !isPasswordEditingEnabled
                    ? Icons.toggle_off_outlined
                    : !isPasswordChanged
                        ? Icons.toggle_on_rounded
                        : !isPasswordSaved
                            ? Icons.toggle_off_outlined
                            : Icons.save_outlined,
              ),
              onPressed: () {
                updateUserName();
                setState(() {
                  isPasswordSaved = true;
                  print('isPasswordSaved ================ $isPasswordSaved');
                  isPasswordEditingEnabled = false;
                  print('isPasswordSaved ================ $isPasswordSaved');
                });
              },
            ),
          ),
        ));
  }

  Widget _entryFieldPasswordConfirm(
    String passwordConfirm,
    TextEditingController _controllerPasswordConfirm,
  ) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              isPasswordConfirmFocused = true;
            });
          } else {
            setState(() {
              isPasswordConfirmFocused = false;
            });
          }
        },
        child: TextFormField(
          enabled: isPasswordEditingEnabled,
          obscureText: isObscure,
          validator: _passwordConfirmValidator,
          onChanged: ((value) => _passwordConfirm = value),
          controller: _controllerPasswordConfirm,
          cursorColor: GlobalStyleVariables.secondaryColour,
          decoration: InputDecoration(
            hintText: 'Re-type your new password',
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
            filled: isPasswordConfirmFocused,
            fillColor: Colors.black12,
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GlobalStyleVariables.secondaryColour),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.password_outlined,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
            ),
          ),
        ));
  }

// <=============

// ============= Buttons =============>

  int _selectedIndex = 0;

  Widget _deleteUserButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('DANGER ZONE:'),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600], foregroundColor: Colors.white),
          onPressed: (() => deleteUser()),
          child: const Text("Delete Account"),
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[600])),
      child: const Text("Cancel"),
    );
    Widget continueButton = ElevatedButton(
      onPressed: () async {
        Navigator.of(context).pop();
        await Auth().deleteUser();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red[600])),
      child: const Text("Continue"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Account Permanently"),
      content: const Text(
          "This will delete your account permenantly. \n\nDo you wish to continue?"),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cancelButton,
              continueButton,
            ],
          ),
        )
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void enableEditing() {
    setState(() {
      isDisplayNameEditingEnabled = true;
      isEmailEditingEnabled = true;
      isPasswordEditingEnabled = true;
      isEditingEnabled = true;
      isFormSaved = false;
    });
  }

  void disableEditing() {
    setState(() {
      isDisplayNameEditingEnabled = false;
      isEmailEditingEnabled = false;
      isPasswordEditingEnabled = false;
      isEditingEnabled = false;
      isObscure = true;
    });
  }

  // <=============

  // ============= Pages =============>

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      const MainPedometer(), //Page 0
      const QuestList(),
      Container(
        // Page 2
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
                height: 4,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Welcome to Walkerrr',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 24,
                    ),
                  ),
                  const Text('Email from firebase:'),
                  _userUid(),
                ],
              ),
              const SizedBox(
                width: double.infinity,
                height: 20,
              ),
              Form(
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
                            child: _entryFieldDisplayName(
                                "New display name", _controllerDisplayName)),
                        Container(
                          height: 80,
                          width: double.infinity,
                          child:
                              _entryFieldEmail("Your email", _controllerEmail),
                        ),
                        Container(
                          height: 80,
                          width: double.infinity,
                          child: _entryFieldPassword(
                              "Enter password", _controllerPassword),
                        ),
                        Container(
                          height: 80,
                          width: double.infinity,
                          child: isEditingEnabled
                              ? _entryFieldPasswordConfirm("Re-type password",
                                  _controllerPasswordConfirm)
                              : Container(),
                        ),
                        Container(
                          height: 40,
                          width: double.infinity,
                          child: isEditingEnabled
                              ? _deleteUserButton()
                              : Container(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: GlobalStyleVariables.secondaryColour,
        actions: <Widget>[
          if (_selectedIndex == 2)
            PopupMenuButton<int>(
              enabled: true,
              elevation: 4,
              offset: Offset(0, 58),
              shape: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24, width: 1)),
              onCanceled: () {
                //check if all changes saved
                disableEditing();
              },
              onSelected: (value) {
                if (value == 1) {
                  enableEditing();
                  print('isEditingEnabled ================ $isEditingEnabled');
                  ;
                } else if (value == 2) {
                  signOut();
                }
              },
              icon: const Icon(Icons.account_circle),
              color: GlobalStyleVariables.secondaryColour,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      const Icon(Icons.edit_note),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("Edit profile",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      const Icon(Icons.logout_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Sign Out",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: PageView(
        controller: controller,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Lightning.png",
              height: 24,
              fit: BoxFit.cover,
            ),
            label: "Steps",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Flag.png",
              height: 24,
              fit: BoxFit.cover,
            ),
            label: "Quests",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Settings.png",
              height: 24,
              fit: BoxFit.cover,
            ),
            label: "Settings",
          )
        ],
        onTap: (index) {
          controller.jumpToPage(index);

          /// Switching the PageView tabs
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
