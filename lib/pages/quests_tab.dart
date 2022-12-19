import 'package:flutter/material.dart';
import 'package:walkerrr/pages/steps_main_page.dart';

class QuestList extends StatefulWidget {
  const QuestList({super.key});

  @override
  State<QuestList> createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {
  Stream<dynamic> stepData = MainPedometerState().steps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(stepData),
      ),
    );
  }
}
