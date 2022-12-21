import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:walkerrr/providers/user_provider.dart';

const baseAPI = 'https://walking-backend.onrender.com';

Future<void> postUser(postedEmail, uid, displayname) async {
  final url = Uri.http(baseAPI, '/api/users');
  await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
          {'email': postedEmail, 'uid': uid, 'displayName': displayname}));
  return;
}

Future<void> deleteUserDB(uid) async {
  final url = Uri.http(baseAPI, '/api/users/$uid');
  await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  return;
}

Future getUserFromDB(uid) async {
  final url = Uri.http(baseAPI, '/api/users/$uid');
  final user = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  final parsedUser = jsonDecode(user.body)[0];
  return parsedUser;
}

Future patchQuestsFromDB(uid, newQuest) async {
  final url = Uri.http(baseAPI, '/api/users/$uid');
  final currentQuests = userObject["quests"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'quests': [...currentQuests, newQuest]
      }));
}
