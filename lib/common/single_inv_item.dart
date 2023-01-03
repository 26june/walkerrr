import 'package:flutter/material.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';

class SingleInventoryItem extends StatefulWidget {
  const SingleInventoryItem(
      {super.key, required this.asset, required this.name});

  final String name;
  final Widget asset;

  @override
  State<SingleInventoryItem> createState() => _SingleInventoryItemState();
}

class _SingleInventoryItemState extends State<SingleInventoryItem> {
  bool isButtonActive = true;
  final currentlyEquipped = userObject['equippedArmour'];
  String buttonText = "Equip";

  @override
  Widget build(BuildContext context) {
    if (currentlyEquipped == widget.name) {
      isButtonActive = false;
      buttonText = "Equipped";
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      // color: GlobalStyleVariables.invItemBackGroundColour,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
              color: GlobalStyleVariables.invItemBorderColour, width: 5),
          color: GlobalStyleVariables.invItemBackGroundColour),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          widget.asset,
          Text(widget.name),
          ElevatedButton(
              onPressed: isButtonActive
                  ? () {
                      setState(() {
                        patchArmour(userObject['uid'], widget.name);
                        userObject['equippedArmour'] = widget.name;
                        isButtonActive = false;
                        buttonText = "Equipped";
                      });
                    }
                  : null,
              child: const Text("Equip"))
        ],
      ),
    );
  }
}
