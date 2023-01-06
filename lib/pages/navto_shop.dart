import 'package:flutter/material.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/single_shopitem.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/providers/user_provider.dart';

class WalkerShop extends StatefulWidget {
  const WalkerShop({super.key});

  @override
  State<WalkerShop> createState() => _WalkerShopState();
}

class _WalkerShopState extends State<WalkerShop> {
  final ninja = ArmorIcons().armorIconOne;
  final rogue = ArmorIcons().armorIconTwo;
  final knight = ArmorIcons().armorIconThree;
  final shaman = ArmorIcons().armorIconFour;
  final beach = ArmorIcons().armorIconFive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalStyleVariables.invAppBarColour,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shop'),
            ValueListenableBuilder(
                valueListenable: CurrentCoins.currentCoins,
                builder: ((context, value, child) {
                  return Text('Coins: $value');
                }))
          ],
        ),
      ),
      backgroundColor: GlobalStyleVariables.invBackgroundColour,
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          SingleShopItem(name: "Ninja", price: 500, assetName: ninja),
          SingleShopItem(name: "Rogue", price: 500, assetName: rogue),
          SingleShopItem(name: "Knight", price: 500, assetName: knight),
          SingleShopItem(name: "Shaman", price: 500, assetName: shaman),
          SingleShopItem(name: "Beach", price: 500, assetName: beach),
        ],
      ),
    );
  }
}
