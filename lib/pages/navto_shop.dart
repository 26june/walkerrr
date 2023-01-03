import 'package:flutter/material.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/single_shopitem.dart';
import 'package:walkerrr/providers/user_provider.dart';

class WalkerShop extends StatefulWidget {
  const WalkerShop({super.key});

  @override
  State<WalkerShop> createState() => _WalkerShopState();
}

class _WalkerShopState extends State<WalkerShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shop'),
            Text('Coins: ${userObject["coins"]}'),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          SingleShopItem(name: "Armor", price: 500, assetName: ArmorIcons().armorIconOne),
          SingleShopItem(name: "Armor", price: 500, assetName: ArmorIcons().armorIconTwo),
          SingleShopItem(name: "Armor", price: 500, assetName: ArmorIcons().armorIconThree),
          SingleShopItem(name: "Armor", price: 500, assetName: ArmorIcons().armorIconFour),
          SingleShopItem(name: "Armor", price: 500, assetName: ArmorIcons().armorIconFive),
        ],
      ),
    );
  }
}
