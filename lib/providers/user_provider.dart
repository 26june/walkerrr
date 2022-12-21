import 'package:flutter/material.dart';

var userObject = {};

class UserContext {
  Future<void> updateUserObject(userFromDB) async {
    userObject = userFromDB;
  }
}
