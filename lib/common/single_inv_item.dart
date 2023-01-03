import 'package:flutter/material.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/pages/steps_main_page.dart';
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
  final currentlyEquipped = userObject['equippedArmour'];
  bool isButtonActive = true;
  String buttonText = "Equip";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CurrentEquip.current,
        builder: ((context, value, child) {
          if (value == widget.name.toLowerCase()) {
            isButtonActive = false;
            buttonText = "Equipped";
          } else {
            isButtonActive = true;
            buttonText = "Equip";
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
                              buttonText = "Equipped";
                              isButtonActive = false;
                            });
                            CurrentEquip.current.value =
                                widget.name.toLowerCase();
                          }
                        : null,
                    child: Text(buttonText))
              ],
            ),
          );
        }));
  }
}
