import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';

class SingleQuest extends StatefulWidget {
  const SingleQuest(
      {super.key,
      required this.questTitle,
      required this.questGoal,
      required this.questOffset,
      required this.questCurrent});

  final String questTitle;
  final int questGoal;
  final int questOffset;
  final int questCurrent;

  @override
  State<SingleQuest> createState() => _SingleQuestState();
}

class _SingleQuestState extends State<SingleQuest> {
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
                "Progress: ${widget.questCurrent - widget.questOffset} / ${widget.questGoal}"),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 20,
              lineHeight: 8.0,
              percent: ((widget.questCurrent - widget.questOffset) /
                          widget.questGoal) >
                      1.0
                  ? 1.0
                  : ((widget.questCurrent - widget.questOffset) /
                      widget.questGoal),
              progressColor: Colors.blue,
            ),
            ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                        setState(() {
                          patchQuestsFromDB(userObject['uid'], {
                            "questTitle": widget.questTitle,
                            "questGoal": widget.questGoal,
                            "questOffset": widget.questOffset,
                            "questCurrent": widget.questCurrent
                          });
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
