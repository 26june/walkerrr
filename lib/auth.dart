import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';

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
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteUser() async {
    await deleteUserDB(currentUser?.uid);
    await currentUser?.delete();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
