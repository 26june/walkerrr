import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import "package:walkerrr/providers/step_provider.dart" as globalSteps;

class SingleQuest extends StatefulWidget {
  const SingleQuest(
      {super.key,
      required this.questTitle,
      required this.questGoal,
      required this.questCurrent});

  final String questTitle;
  final int questGoal;
  final int questCurrent;

  @override
  State<SingleQuest> createState() => _SingleQuestState();
}

class _SingleQuestState extends State<SingleQuest> {
  int questOffset = 0;
  bool isButtonActive = true;
  String buttonText = "Start Quest?";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: [
            Text(widget.questTitle),
            Text(
                "Progress: ${isButtonActive ? 0 : (widget.questCurrent - questOffset)}/ ${widget.questGoal}"),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 20,
              lineHeight: 8.0,
              percent: isButtonActive
                  ? 0
                  : (widget.questCurrent - questOffset) / widget.questGoal,
              progressColor: Colors.blue,
            ),
            ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                        setState(() {
                          questOffset = globalSteps.globalSteps;
                          isButtonActive = false;
                          buttonText = "Quest Started";
                        });
                      }
                    : null,
                child: Text(buttonText))
          ],
        ),
      ),
    );
  }
}
