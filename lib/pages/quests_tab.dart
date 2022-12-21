import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:walkerrr/common/single_quest.dart';
import 'package:walkerrr/providers/step_provider.dart' as globalSteps;

class QuestList extends StatefulWidget {
  const QuestList({super.key});

  @override
  State<QuestList> createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SingleQuest(questTitle: "Walk 500 Steps", questGoal: 500, questCurrent: globalSteps.globalSteps)
          ],
        ),
      ),
    );
  }
}
