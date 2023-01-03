import 'package:flutter/material.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/single_inv_item.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/providers/user_provider.dart';

class WalkerInventory extends StatefulWidget {
  const WalkerInventory({super.key});

  @override
  State<WalkerInventory> createState() => _WalkerInventoryState();
}

class _WalkerInventoryState extends State<WalkerInventory> {
  final currentTrophies = userObject['trophies'];
  final ninja = ArmorIcons().armorIconOne;
  final rogue = ArmorIcons().armorIconTwo;
  final knight = ArmorIcons().armorIconThree;
  final shaman = ArmorIcons().armorIconFour;
  final beach = ArmorIcons().armorIconFive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Inventory"),
          backgroundColor: GlobalStyleVariables.invAppBarColour),
      backgroundColor: GlobalStyleVariables.invBackgroundColour,
      body: GridView.count(
        crossAxisCount: 5,
        children: [],
      ),
    );
  }
}
