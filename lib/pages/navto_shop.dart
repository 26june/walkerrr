import 'package:flutter/material.dart';
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
        children: const [
          SingleShopItem(name: "Pizza", price: 100, assetName: "Pizza"),
          SingleShopItem(name: "Egg", price: 200, assetName: "Egg"),
          SingleShopItem(name: "Pancake", price: 200, assetName: "Pancake"),
          SingleShopItem(name: "Sandwich", price: 200, assetName: "Sandwich"),
          SingleShopItem(name: "Sushi", price: 200, assetName: "Sushi"),
        ],
      ),
    );
  }
}
