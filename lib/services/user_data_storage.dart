import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:walkerrr/providers/user_provider.dart';

// Login screen form keys for Secure Storage

final String _keyDisplayName = 'displayName';
final String _keyEmail = 'email';
final String _keyPassWord = 'password';

class SecureStorage {
  // Create _secureStorage
  final _secureStorage = const FlutterSecureStorage();

// ======== Secure Storage functions for login screen ========>

  Future setDisplayName(String displayName) async {
    await _secureStorage.write(key: _keyDisplayName, value: displayName);
  }

  Future<String?> getDisplayName() async {
    return await _secureStorage.read(key: _keyDisplayName);
  }

  Future deleteDisplayName() async {
    return await _secureStorage.delete(key: _keyDisplayName);
  }

  Future setEmail(String email) async {
    await _secureStorage.write(key: _keyEmail, value: email);
  }

  Future<String?> getEmail() async {
    return await _secureStorage.read(key: _keyEmail);
  }

  Future setPassWord(String password) async {
    await _secureStorage.write(key: _keyPassWord, value: password);
  }

  Future<String?> getPassWord() async {
    return await _secureStorage.read(key: _keyPassWord);
  }

  Future deletePassWord() async {
    return await _secureStorage.delete(key: _keyPassWord);
  }

// <=========

// ======== Secure Storage functions for MongoDB =========>

  Future<void> setUserObject(userObj) async {
    final user = jsonEncode(userObj);
    await _secureStorage.write(key: "localUserObject", value: user);
  }

  Future getUserObject() async {
    return await _secureStorage.read(key: "localUserObject");
  }

  Future deleteUserObject() async {
    return await _secureStorage.delete(key: "localUserObject");
  }
  // <=========
}
