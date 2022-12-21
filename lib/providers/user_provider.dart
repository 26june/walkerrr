var userObject = {};

class UserContext {
  Future<void> updateUserObject(userFromDB) async {
    userObject = userFromDB;
  }
}
