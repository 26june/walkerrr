import 'package:flutter/material.dart';
import 'package:walkerrr/common/styling_variables.dart';

class SingleInventoryItem extends StatefulWidget {
  const SingleInventoryItem({super.key, required this.asset});

  final String asset;

  @override
  State<SingleInventoryItem> createState() => _SingleInventoryItemState();
}

class _SingleInventoryItemState extends State<SingleInventoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      // color: GlobalStyleVariables.invItemBackGroundColour,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: GlobalStyleVariables.invItemBorderColour, width: 5),
        color: GlobalStyleVariables.invItemBackGroundColour
        
      ),

      child: Image.asset(widget.asset),
    );
  }
}
