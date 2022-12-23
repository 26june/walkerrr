import 'package:flutter/material.dart';
import 'package:walkerrr/common/single_quest.dart';
import 'package:walkerrr/providers/step_provider.dart' as globalSteps;
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';

class QuestList extends StatefulWidget {
  const QuestList({super.key});

  @override
  State<QuestList> createState() => _QuestListState();
}

final currentQuests = userObject["quests"];

findOffset(questTitle) {
  var returnValue = globalSteps.globalSteps;
  currentQuests?.forEach((quest) {
    if (quest['questTitle'] == questTitle) {
      returnValue = quest['questOffset'];
    }
  });
  return returnValue;
}

startTime(questTitle) {
  var returnValue = DateTime.now().toIso8601String();
  var newTime = DateTime.now();
  var finished = false;
  currentQuests?.forEach((quest) {
    if (quest['questTitle'] == questTitle) {
      returnValue = quest['questStart'];
      if (DateTime.parse(returnValue)
              .add(
                const Duration(days: 1),
              )
              .compareTo(newTime) !=
          1) {
        returnValue = DateTime.now().toIso8601String();
        finished = true;
      }
    }
  });
  if (finished == true) {
    patchComplete(userObject['uid'], questTitle);
    getUserFromDB(userObject['uid']);
    return returnValue;
  } else {
    return returnValue;
  }
}

getCurrent(questTitle) {
  var returnValue = globalSteps.globalSteps;
  currentQuests?.forEach((quest) {
    if (quest['questTitle'] == questTitle) {
      if (quest['questCurrent'] > globalSteps.globalSteps) {
        returnValue = quest['questCurrent'] += globalSteps.globalSteps;
      }
    }
  });
  return returnValue;
}

class _QuestListState extends State<QuestList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // SingleQuest(
            //   questTitle: "Walk 500 Steps",
            //   questGoal: 500,
            //   questOffset: findOffset("Walk 500 Steps"),
            //   questCurrent: getCurrent("Walk 500 Steps"),
            //   questStart: startTime("Walk 500 Steps"),
            //   reward: 50,
            //   completed: false,
            // ),
            // SingleQuest(
            //   questTitle: "Walk 5000 Steps",
            //   questGoal: 5000,
            //   questOffset: findOffset("Walk 5000 Steps"),
            //   questCurrent: getCurrent("Walk 5000 Steps"),
            //   questStart: startTime("Walk 5000 Steps"),
            //   reward: 1000,
            //   completed: false,
            // ),
            SingleQuest(
              questTitle: "Walk 10000 Steps",
              questGoal: 10000,
              questOffset: findOffset("Walk 10000 Steps"),
              questCurrent: getCurrent("Walk 10000 Steps"),
              questStart: startTime("Walk 10000 Steps"),
              reward: 2500,
              completed: false,
            )
          ],
        ),
      ),
    );
  }
}
