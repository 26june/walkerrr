import 'package:flutter/material.dart';
import 'package:walkerrr/providers/user_provider.dart';

class ArmorIcons {
  var armorIconZero = Image.asset("assets/armors/static-armor/0.gif");

  var armorIconOne = Image.asset("assets/armors/static-armor/1.gif");

  var armorIconTwo = Image.asset(
    "assets/armors/static-armor/2.gif",
  );

  var armorIconThree = Image.asset("assets/armors/static-armor/3.gif");

  var armorIconFour = Image.asset("assets/armors/static-armor/4.gif");

  var armorIconFive = Image.asset("assets/armors/static-armor/5.gif");

  getIcon(String name) {
    switch (name) {
      case "basic":
        return armorIconZero;
      case "ninja":
        return armorIconOne;
      case "rogue":
        return armorIconTwo;
      case "knight":
        return armorIconThree;
      case "shaman":
        return armorIconFour;
      case "beach":
        return armorIconFive;
    }
  }
}

class IdleArmorIcons {
  var idleArmorIconZero =
      Image.asset("assets/armors/idle-armor/0.png", scale: 0.5);

  var idleArmorIconOne =
      Image.asset("assets/armors/idle-armor/1.png", scale: 0.5);

  var idleArmorIconTwo =
      Image.asset("assets/armors/idle-armor/2.png", scale: 0.5);

  var idleArmorIconThree =
      Image.asset("assets/armors/idle-armor/3.png", scale: 0.5);

  var idleArmorIconFour =
      Image.asset("assets/armors/idle-armor/4.png", scale: 0.5);

  var idleArmorIconFive =
      Image.asset("assets/armors/idle-armor/5.png", scale: 0.5);

  getIdleSprite(String name) {
    switch (name) {
      case "basic":
        return idleArmorIconZero;
      case "ninja":
        return idleArmorIconOne;
      case "rogue":
        return idleArmorIconTwo;
      case "knight":
        return idleArmorIconThree;
      case "shaman":
        return idleArmorIconFour;
      case "beach":
        return idleArmorIconFive;
    }
  }
}

class WalkingArmorIcons {
  var walkingArmorIconZero =
      Image.asset("assets/armors/walking-armor/0.gif", scale: 0.5);

  var walkingArmorIconOne =
      Image.asset("assets/armors/walking-armor/1.gif", scale: 0.5);

  var walkingArmorIconTwo =
      Image.asset("assets/armors/walking-armor/2.gif", scale: 0.5);

  var walkingArmorIconThree =
      Image.asset("assets/armors/walking-armor/3.gif", scale: 0.5);

  var walkingArmorIconFour =
      Image.asset("assets/armors/walking-armor/4.gif", scale: 0.5);

  var walkingArmorIconFive =
      Image.asset("assets/armors/walking-armor/5.gif", scale: 0.5);

  getWalkingSprite(name) {
    switch (name) {
      case "basic":
        return walkingArmorIconZero;
      case "ninja":
        return walkingArmorIconOne;
      case "rogue":
        return walkingArmorIconTwo;
      case "knight":
        return walkingArmorIconThree;
      case "shaman":
        return walkingArmorIconFour;
      case "beach":
        return walkingArmorIconFive;
    }
  }
}

class CurrentEquip {
  static ValueNotifier<String> current =
      ValueNotifier(userObject['equippedArmour'].toLowerCase());
}

class CurrentSteps {
  static ValueNotifier<int> currentSteps = ValueNotifier(0);
}

class CurrentCoins {
  static ValueNotifier<int> currentCoins = ValueNotifier(100);
}
