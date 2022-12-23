import 'package:flutter/material.dart';
import 'package:walkerrr/providers/user_provider.dart';

class WalkerInventory extends StatefulWidget {
  const WalkerInventory({super.key});

  @override
  State<WalkerInventory> createState() => _WalkerInventoryState();
}

class _WalkerInventoryState extends State<WalkerInventory> {
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
      body: Stack(
          children: List<Widget>.empty(growable: true)
            ..add(
              Image.asset(
                "assets/images/shelf.png",
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            )
            ..add(Transform.translate(
                offset: const Offset(0, 100),
                child: Image.asset("assets/images/Egg.png")))
            ..add(Transform.translate(
                offset: const Offset(100, 100),
                child: Image.asset("assets/images/Pancake.png")))
            ..add(Transform.translate(
                offset: const Offset(100, 250),
                child: Image.asset("assets/images/Egg.png")))
            ..add(Transform.translate(
                offset: const Offset(0, 400),
                child: Image.asset("assets/images/Egg.png")))
            ..add(Transform.translate(
                offset: const Offset(0, 550),
                child: Image.asset("assets/images/Egg.png")))
            ..add(Transform.translate(
                offset: const Offset(0, 700),
                child: Image.asset("assets/images/Egg.png")))),
    );
  }
}
