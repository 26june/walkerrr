import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';
import "package:walkerrr/providers/step_provider.dart" as globalSteps;

void checkCompletion(progessCalc, currentQuest, reward) {
  print(currentQuest);
  if (progessCalc >= 1.0) {
    patchComplete(userObject['uid'], currentQuest);
    patchCoins(userObject['uid'], reward);
  }
}

class SingleQuest extends StatefulWidget {
  const SingleQuest({
    super.key,
    required this.questTitle,
    required this.questGoal,
    required this.questCurrent,
    required this.questOffset,
    required this.questStart,
    required this.reward,
    required this.completed,
  });

  final String questTitle;
  final int questGoal;
  final int questCurrent;
  final int questOffset;
  final int reward;
  final String questStart;
  final bool completed;

  @override
  State<SingleQuest> createState() => _SingleQuestState();
}

class _SingleQuestState extends State<SingleQuest> {
  bool isButtonActive = true;
  String buttonText = "Start Quest?";
  final currentQuests = userObject["quests"];
  @override
  Widget build(BuildContext context) {
    if (currentQuests != null) {
      currentQuests.forEach((quest) => {
            if (quest["questTitle"] == widget.questTitle)
              {
                isButtonActive = false,
                buttonText = "Quest Active",
              }
            else
              {null}
          });
    }
    final progessCalc = isButtonActive
        ? 0
        : ((widget.questCurrent - widget.questOffset) / widget.questGoal) > 1
            ? 1
            : (widget.questCurrent - widget.questOffset) / widget.questGoal;
    progessCalc >= 1.0 ? buttonText = "Claim" : null;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: [
            Text(widget.questTitle),
            Text("Progress: ${(progessCalc * 100).toInt()}%"),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 20,
              lineHeight: 8.0,
              percent: isButtonActive
                  ? 0
                  : ((widget.questCurrent - widget.questOffset) /
                              widget.questGoal) >
                          1
                      ? 1
                      : ((widget.questCurrent - widget.questOffset) /
                          widget.questGoal),
              progressColor: Colors.blue,
            ),
            ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                        setState(() {
                          final newQuest = {
                            "questTitle": widget.questTitle,
                            "questGoal": widget.questGoal,
                            "questOffset": globalSteps.globalSteps,
                            "questCurrent": widget.questCurrent,
                            "questStart": widget.questStart,
                            "questReward": widget.reward,
                            "questCompleted": widget.completed
                          };
                          patchQuestsToDB(userObject['uid'], newQuest);
                          final currentQuests = userObject["quests"];
                          userObject["quests"] = [...currentQuests, newQuest];
                          isButtonActive = false;
                        });
                      }
                    : () {
                        checkCompletion(
                            progessCalc, widget.questTitle, widget.reward);
                      }, // add claim button conditional
                style: isButtonActive
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white)
                    : progessCalc == 1.0
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white)
                        : ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white),
                child: Text(buttonText))
          ],
        ),
      ),
    );
  }
}
