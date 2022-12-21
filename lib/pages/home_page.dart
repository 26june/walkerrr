import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkerrr/auth.dart';
import 'package:walkerrr/pages/quests_tab.dart';
import 'package:walkerrr/pages/steps_main_page.dart';
import 'package:walkerrr/pages/login_register_page.dart';
import 'package:walkerrr/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

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

  Widget _title() {
    if (_selectedIndex == 0) {
      return const Text('Steps');
    } else if (_selectedIndex == 1) {
      return const Text('Quests');
    } else {
      return const Text('Login');
    }
  }

  Widget _userDisplayName() {
    return Text("User Display Name");
  }

  Widget _userUid() {
    return Text(user?.email ?? "User Email");
  }

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
          backgroundColor: Colors.pink, foregroundColor: Colors.white),
      onPressed: deleteUser,
      child: const Text("Delete Account"),
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
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () async {
        Navigator.of(context).pop();
        await Auth().deleteUser();
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text(
          "This will delete your account permenantly. \n Do you wish to continue?"),
      actions: [
        cancelButton,
        continueButton,
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
      QuestList(),
      Container(
        // Page 2
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userDisplayName(),
            _userUid(),
            _signOutButton(),
            _deleteUserButton(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_outlined),
            label: "Steps",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: "Quests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: "Login",
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
