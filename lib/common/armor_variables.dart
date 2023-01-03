import 'package:flutter/material.dart';

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
  var idleArmorIconZero = Image.asset("assets/armors/idle-armor/0.png");

  var idleArmorIconOne = Image.asset("assets/armors/idle-armor/1.png");

  var idleArmorIconTwo = Image.asset("assets/armors/idle-armor/2.png");

  var idleArmorIconThree = Image.asset("assets/armors/idle-armor/3.png");

  var idleArmorIconFour = Image.asset("assets/armors/idle-armor/4.png");

  var idleArmorIconFive = Image.asset("assets/armors/idle-armor/5.png");
}

class WalkingArmorIcons {
  var walkingArmorIconZero = Image.asset("assets/armors/walking-armor/0.gif");

  var walkingArmorIconOne = Image.asset("assets/armors/walking-armor/1.gif");

  var walkingArmorIconTwo = Image.asset("assets/armors/walking-armor/2.gif");

  var walkingArmorIconThree = Image.asset("assets/armors/walking-armor/3.gif");

  var walkingArmorIconFour = Image.asset("assets/armors/walking-armor/4.gif");

  var walkingArmorIconFive = Image.asset("assets/armors/walking-armor/5.gif");
}
