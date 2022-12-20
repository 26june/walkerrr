import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuestList extends StatefulWidget {
  const QuestList({super.key});

  @override
  State<QuestList> createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {
  int _progress = 0, _questSteps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 5.0,
              percent: _progress.toDouble(),
              center: Text("Quest 1"),
              progressColor: Colors.green,
            ),
            Text("Current Steps: $_questSteps"),
            Text("Current Percentage: $_progress"),
            ElevatedButton(onPressed: () {}, child: Text("Start Quest"))
          ],
        ),
      ),
    );
  }
}
