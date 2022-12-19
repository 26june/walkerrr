import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> postUser(postedEmail, uid) async {
  final url = Uri.http('192.168.0.47:9095', '/api/users');
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'email': postedEmail, 'uid': uid}));
  return;
}

Future<void> deleteUserDB(uid) async {
  final url = Uri.http('192.168.0.47:9095', '/api/users/$uid');
  await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  return;
}
