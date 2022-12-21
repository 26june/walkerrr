import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:walkerrr/common/single_quest.dart';

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
            SingleQuest(questTitle: "Walk 500 Steps Today", questGoal: 500, questOffset: 100, questCurrent: 700),
            SingleQuest(questTitle: "Walk 1000 Steps in Total", questGoal: 1000, questOffset: 100, questCurrent: 350),
          ],
        ),
      ),
    );
  }
}
