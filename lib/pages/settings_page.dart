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
    isDisplayNameSaved = true;
  }

  // Future<void> updateEmail() async {
  //   final newEmail = _controllerEmail.text;
  //   patchEmail(userObject['email'], newEmail);
  //   _controllerEmail.text = newEmail;
  //   isEmailSaved = true;
  // }

  // Future<void> updatePassword() async {
  //   final newPassword = _controllerPassword.text;
  //   patchPassword(userObject['password'], newPassword);
  //   _controllerPassword.text = newPassword;
  //   isPasswordSaved = true;
  // }

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

// ==================== User settings page ====================

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
  bool isFormLocked = true;

  bool isDisplayNameSaved = true;
  bool isEmailSaved = true;
  bool isPasswordSaved = true;
  bool isFormSaved = false;

  bool isObscure = true;

  Widget _entryFieldDisplayName(
    String displayName,
    TextEditingController _controllerDisplayName,
  ) {
    return TextFormField(
      enabled: isDisplayNameEditingEnabled,
      validator: _displayNameValidator,
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
        filled: isDisplayNameEditingEnabled,
        fillColor: Colors.black12,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: GlobalStyleVariables.secondaryColour),
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
                : !isDisplayNameSaved
                    ? Icons.toggle_on_rounded
                    : Icons.task_alt_outlined,
          ),
          onPressed: () {
            updateUserName();
            setState(() {
              isDisplayNameEditingEnabled = false;
            });
          },
        ),
      ),
    );
  }

  Widget _entryFieldEmail(
    String email,
    TextEditingController _controllerEmail,
  ) {
    return TextFormField(
      enabled: isEmailEditingEnabled,
      validator: _emailValidator,
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
        filled: isEmailEditingEnabled,
        fillColor: Colors.black12,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: GlobalStyleVariables.secondaryColour),
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
                : !isEmailSaved
                    ? Icons.toggle_on_rounded
                    : Icons.task_alt_outlined,
          ),
          onPressed: () {
            // updateEmail();
            setState(() {
              isEmailEditingEnabled = false;
            });
          },
        ),
      ),
    );
  }

  Widget _entryFieldPassword(
    String password,
    TextEditingController _controllerPassword,
  ) {
    return TextFormField(
      enabled: isPasswordEditingEnabled,
      obscureText: isObscure,
      validator: _passwordValidator,
      onChanged: ((value) => (value.isEmpty)
          ? _password = value
          : _password = _controllerPassword.text),
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
        filled: isPasswordEditingEnabled,
        fillColor: Colors.black12,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: GlobalStyleVariables.secondaryColour),
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
                : !isPasswordSaved
                    ? Icons.toggle_on_rounded
                    : Icons.task_alt_outlined,
          ),
          onPressed: () {
            // updatePassword();
            setState(() {
              isPasswordEditingEnabled = false;
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
        filled: isPasswordEditingEnabled,
        fillColor: Colors.black12,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: GlobalStyleVariables.secondaryColour),
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
    );
  }

// <=============

// ============= Buttons =============>

  // Widget _signOutButton() {
  //   return ElevatedButton(
  //     onPressed: signOut,
  //     style: ElevatedButton.styleFrom(
  //         backgroundColor: GlobalStyleVariables.secondaryColour, foregroundColor: Colors.white),
  //     child: const Text("Sign Out"),
  //   );
  // }

  // Widget _deleteUserButton() {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.red[600], foregroundColor: Colors.white),
  //     onPressed: deleteUser,
  //     child: const Text("Delete Account"),
  //   );
  // }

  // Widget _changeUserName() {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.blue[600], foregroundColor: Colors.white),
  //     onPressed: updateUserName,
  //     child: const Text("Change Username"),
  //   );
  // }

  int _selectedIndex = 0;

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
      isFormLocked = false;
      isFormSaved = false;
    });
  }

  void disableEditing() {
    setState(() {
      isDisplayNameEditingEnabled = false;
      isEmailEditingEnabled = false;
      isPasswordEditingEnabled = false;
      isFormLocked = true;
      isObscure = true;
    });
  }

  // <=============

  // ============= Pages =============>
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      const MainPedometer(), //Page 0
      const QuestList(),
      Container(
        // Page 2
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          child: !isFormLocked
                              ? _entryFieldPasswordConfirm("Re-type password",
                                  _controllerPasswordConfirm)
                              : Container(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SpeedDial(
                    icon: Icons.person_outlined,
                    activeIcon: Icons.close,
                    spacing: 3,
                    openCloseDial: isDialOpen,
                    renderOverlay: false,
                    closeManually: false,
                    spaceBetweenChildren: 4,
                    backgroundColor: GlobalStyleVariables.secondaryColour,
                    visible: true,
                    curve: Curves.bounceInOut,
                    children: [
                      SpeedDialChild(
                        child: const Icon(Icons.edit_note, color: Colors.white),
                        backgroundColor: GlobalStyleVariables.secondaryColour,
                        onTap: () => {
                          (isFormLocked) ? enableEditing() : disableEditing()
                        },
                        label: 'Edit profile',
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        labelBackgroundColor:
                            GlobalStyleVariables.secondaryColour,
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.logout, color: Colors.white),
                        backgroundColor: Colors.green,
                        onTap: () => signOut(),
                        label: 'Sign Out',
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        labelBackgroundColor: Colors.green,
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.delete_forever_outlined,
                            color: Colors.white),
                        backgroundColor: Colors.red[800],
                        onTap: () => deleteUser(),
                        label: 'Delete account',
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        labelBackgroundColor: Colors.red[800],
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.delete_forever_outlined,
                            color: Colors.white),
                        backgroundColor: Colors.red[800],
                        onTap: () => deleteUser(),
                        label: 'Delete account',
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        labelBackgroundColor: Colors.red[800],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: _title(),
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
      ),
    );
  }
}

// <=============