import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:walkerrr/providers/user_provider.dart';

const baseAPI = 'https://walking-backend.onrender.com';

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

Future<void> patchQuestsToDB(uid, newQuest) async {
  final url = Uri.http("192.168.0.47:9095", '/api/users/$uid');
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

Future<void> patchCoins(uid, increment) async {
  final url = Uri.http("192.168.0.47:9095", '/api/users/$uid');
  final currentCoins = userObject["coins"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'coins': currentCoins + increment}));
}

Future<void> patchComplete(uid, currentQuest) async {
  final url = Uri.http("192.168.0.47:9095", '/api/users/$uid');
  final currentQuests = userObject["quests"];
  final removeable = [];
  currentQuests.asMap().forEach((index, quest) => {
        if (quest["questTitle"] == currentQuest)
          {quest["questCompleted"] = true, removeable.add(quest)},
      });
  for (var quest in removeable) {
    currentQuests.remove(quest);
  }
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'quests': currentQuests}));
}

Future<void> patchTrophiesToDB(uid, newTrophy) async {
  final url = Uri.http("192.168.0.47:9095", '/api/users/$uid');
  final currentTrophies = userObject["tropies"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'trophies': [...currentTrophies, newTrophy]
      }));
}

// {trophy_name: "hello", achieved_by: "Completing 10000 steps in one day", trophy_img: "https://imgurl.com"}
// ["hello", "trophy2"]