import 'package:flutter/material.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/presentation_singlequest.dart';
import 'package:walkerrr/common/single_quest.dart';
import 'package:walkerrr/common/styling_variables.dart';
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
        child: ValueListenableBuilder(
            valueListenable: CurrentSteps.currentSteps,
            builder: ((context, value, child) {
              return ListView(
                children: [
                  PresentationSingleQuest(
                      questTitle: "Walk 10 Steps",
                      questGoal: 10,
                      questCurrent: value,
                      questReward: 4000),
                  PresentationSingleQuest(
                      questTitle: "Walk 5000 Steps",
                      questGoal: 5000,
                      questCurrent: value,
                      questReward: 500),
                  PresentationSingleQuest(
                      questTitle: "Walk 10000 Steps",
                      questGoal: 5000,
                      questCurrent: value,
                      questReward: 1000)
                ],
              );
            })),
      ),
    );
  }
}
