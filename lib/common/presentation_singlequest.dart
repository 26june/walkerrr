import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/styling_variables.dart';

class PresentationSingleQuest extends StatefulWidget {
  const PresentationSingleQuest(
      {super.key,
      required this.questTitle,
      required this.questGoal,
      required this.questCurrent,
      required this.questReward});

  final String questTitle;
  final int questGoal;
  final int questCurrent;
  final int questReward;

  @override
  State<PresentationSingleQuest> createState() =>
      _PresentationSingleQuestState();
}

class _PresentationSingleQuestState extends State<PresentationSingleQuest> {
  String buttonText = "Start Quest";
  bool isButtonActive = true;
  bool notClaimed = true;

  @override
  Widget build(BuildContext context) {
    final progressCalc = isButtonActive
        ? 0
        : (widget.questCurrent / widget.questGoal) > 1
            ? 1
            : (widget.questCurrent / widget.questGoal);
    progressCalc >= 1.0 && notClaimed
        ? {buttonText = "Claim", isButtonActive = true, notClaimed = false}
        : null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: GlobalStyleVariables.invItemBorderColour, width: 5),
          color: GlobalStyleVariables.invItemBackGroundColour),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.questTitle),
          Text(
              "Progress: ${isButtonActive && notClaimed ? 0 : widget.questCurrent}/${widget.questGoal}"),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 30,
            lineHeight: 8.0,
            percent: isButtonActive && notClaimed
                ? 0
                : (widget.questCurrent / widget.questGoal) > 1
                    ? 1
                    : (widget.questCurrent / widget.questGoal),
            progressColor: GlobalStyleVariables.secondaryColour,
          ),
          Text("Reward: ${widget.questReward} coins"),
          ElevatedButton(
              onPressed: isButtonActive
                  ? () {
                      if (buttonText == "Claim") {
                        setState(() {
                          CurrentCoins.currentCoins.value += 4000;
                          buttonText = "Claimed";
                          isButtonActive = false;
                        });
                      } else {
                        setState(() {
                          buttonText = "Quest Started";
                          isButtonActive = false;
                        });
                      }
                    }
                  : null,
              child: Text(buttonText))
        ],
      ),
    );
  }
}
