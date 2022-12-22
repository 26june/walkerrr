import 'package:flutter/material.dart';
import 'package:walkerrr/common/single_shopitem.dart';

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
        title: Text("Shop"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
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