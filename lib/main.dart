import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/user_data_storage.dart';
import 'widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';

void setLocalUserObject() async {
  try {
    final user = await SecureStorage().getUserObject();
    await UserContext().updateUserObject(jsonDecode(user));
    print("inside func $userObject");
  } catch (e) {
    print(e);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setLocalUserObject();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const WidgetTree(),
    );
  }
}
