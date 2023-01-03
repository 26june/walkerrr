import 'package:flutter/material.dart';

class SingleShopItem extends StatefulWidget {
  const SingleShopItem(
      {super.key,
      required this.name,
      required this.price,
      required this.assetName});

  final String name;
  final Widget assetName;
  final int price;

  @override
  State<SingleShopItem> createState() => _SingleShopItemState();
}

class _SingleShopItemState extends State<SingleShopItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey,
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        widget.assetName,
        const SizedBox(
          height: 10,
        ),
        Text(widget.name),
        Text("Price: ${widget.price} Coins"),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(onPressed: () {}, child: const Text("Buy"))
      ]),
    );
  }
}
