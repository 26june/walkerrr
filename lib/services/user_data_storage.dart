import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create _secureStorage
  final _secureStorage = const FlutterSecureStorage();

  final String _keyDisplayName = 'displayName';
  final String _keyEmail = 'email';
  final String _keyPassWord = 'password';

  Future setDisplayName(String displayName) async {
    await _secureStorage.write(key: _keyDisplayName, value: displayName);
  }

  Future<String?> getDisplayName() async {
    return await _secureStorage.read(key: _keyDisplayName);
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

  // delete data from _secureStorage
  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll();
  }
}
