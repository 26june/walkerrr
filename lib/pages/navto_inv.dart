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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CurrentEquip.current,
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
                title: const Text("Inventory"),
                backgroundColor: GlobalStyleVariables.invAppBarColour),
            backgroundColor: GlobalStyleVariables.invBackgroundColour,
            body: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                currentTrophies.length,
                (index) => SingleInventoryItem(
                    name: currentTrophies[index]['name'],
                    asset: ArmorIcons()
                        .getIcon(currentTrophies[index]['name'].toLowerCase())),
              ),
            ),
          );
        });
  }
}
