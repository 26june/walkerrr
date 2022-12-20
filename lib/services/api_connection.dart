import 'dart:convert';
import 'package:http/http.dart' as http;

const baseAPI = 'https://walking.cyclic.app';

Future<void> postUser(postedEmail, uid, displayname) async {
  final url = Uri.http("192.168.0.47:9095", '/api/users');
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
  final url = Uri.http("192.168.0.47:9095", '/api/users/$uid');
  await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  return;
}

Future getUserFromDB(uid) async {
  final url = Uri.http("192.168.0.47:9095", '/api/users/$uid');
  final user = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  final parsedUser = jsonDecode(user.body)[0];
  return parsedUser;
}
