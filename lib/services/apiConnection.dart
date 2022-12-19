import 'dart:convert';
import 'package:http/http.dart' as http;

final baseAPI = 'https://walking.cyclic.app';

Future<void> postUser(postedEmail, uid) async {
  final url = Uri.http(baseAPI, '/api/users');
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'email': postedEmail, 'uid': uid}));
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
