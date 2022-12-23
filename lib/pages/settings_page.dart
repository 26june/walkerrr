import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkerrr/auth.dart';
import 'package:walkerrr/pages/quests_tab.dart';
import 'package:walkerrr/pages/steps_main_page.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';
import 'package:walkerrr/services/user_data_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController();

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
    _controllerDisplayName.text = '';
  }

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

// --------- Secure storage fetch (does not work) ---------

  final SecureStorage _secureStorage = SecureStorage();
  var userCredentialsState = [];

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
  }

  Future<void> fetchSecureStorageData() async {
    final displayName = await _secureStorage.getDisplayName() ?? '';
    final email = await _secureStorage.getEmail() ?? '';
    final password = await _secureStorage.getPassWord() ?? '';
    final userCredentials = [displayName, email, password];
  }

// --------- User data edit ---------

  Widget _userUid() {
    return Text(user?.email ?? "User Email");
  }

// --------- Buttons ---------

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, foregroundColor: Colors.white),
      child: const Text("Sign Out"),
    );
  }

  Widget _deleteUserButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[600], foregroundColor: Colors.white),
      onPressed: deleteUser,
      child: const Text("Delete Account"),
    );
  }

  Widget _changeUserName() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600], foregroundColor: Colors.white),
      onPressed: updateUserName,
      child: const Text("Change Username"),
    );
  }

  final TextEditingController _controllerDisplayName = TextEditingController();

  Widget _entryFieldDisplayName(
    String displayName,
    TextEditingController _controllerDisplayName,
  ) {
    return TextFormField(
      enableSuggestions: true,
      controller: _controllerDisplayName,
      validator: (value) {
        if (value == '') {
          return 'Change your display name...';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        labelText: displayName,
      ),
    );
  }

  int _selectedIndex = 0;

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[600])),
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () async {
        Navigator.of(context).pop();
        await Auth().deleteUser();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red[600])),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Row(
                children: const [
                  Text('Welcome to Walkerrr!', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: _userUid(),
            ),
            Container(
              height: 100,
              width: double.infinity,
              child: _entryFieldDisplayName(
                  "New Display name", _controllerDisplayName),
            ),
            Container(
              height: 150,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _changeUserName(),
                  _signOutButton(),
                  _deleteUserButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
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
        items:  [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Lightning.png", height: 24, fit: BoxFit.cover,),
            label: "Steps",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Flag.png",  height: 24, fit: BoxFit.cover,),
            label: "Quests",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/icon_Settings.png", height: 24, fit: BoxFit.cover,),
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
