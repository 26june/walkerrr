import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkerrr/main.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';
import 'package:walkerrr/services/user_data_storage.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    String? uid = result.user?.uid;
    final userFromDB = await getUserFromDB(uid);
    UserContext().updateUserObject(userFromDB);
    SecureStorage().setUserObject(userObject);
    setLocalUserObject();
  }

  Future<void> createUserWithEmailAndPassword({
    required String displayname,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await postUser(email, user?.uid, displayname);
      final userFromDB = await getUserFromDB(user?.uid);
      UserContext().updateUserObject(userFromDB);
      SecureStorage().setUserObject(userObject);
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteUser() async {
    await deleteUserDB(currentUser?.uid);
    await SecureStorage().setUserObject({"null": "null"});
    await currentUser?.delete();
  }

  Future<void> signOut() async {
    await SecureStorage().setUserObject({"null": "null"});
    await _firebaseAuth.signOut();
  }
}
