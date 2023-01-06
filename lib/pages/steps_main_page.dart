import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/pages/navto_inv.dart';
import 'package:walkerrr/pages/navto_shop.dart';
import 'package:walkerrr/providers/step_provider.dart' as global;
import 'package:walkerrr/providers/user_provider.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class MainPedometer extends StatefulWidget {
  const MainPedometer({super.key});

  @override
  State<MainPedometer> createState() => MainPedometerState();
}

class MainPedometerState extends State<MainPedometer>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String status = '?', steps = '?';
  bool stepsInitialized = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      steps = event.steps.toString();
      global.StepsContext().updateGlobalSteps(event.steps);

      if (stepsInitialized == false) {
        stepsInitialized = true;
      } else {
        CurrentSteps.currentSteps.value++;
      }
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      status = 'Pedestrian Status not available';
    });
    print(status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      steps = 'Step Count not available';
    });
  }

  getCurrentlyEquipped() {
    print("getting");
    return userObject['equippedArmour'].toLowerCase();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  //Floating Action Button Variables
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final currentlyEquipped = getCurrentlyEquipped();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          }
          return true;
        },
        child: Scaffold(
          floatingActionButton: SpeedDial(
            icon: CustomIcons.icon_add,
            activeIcon: CustomIcons.icon_x,
            foregroundColor: GlobalStyleVariables.iconBorderColour,
            backgroundColor: Colors.white,
            spacing: 3,
            openCloseDial: isDialOpen,
            renderOverlay: false,
            closeManually: false,
            spaceBetweenChildren: 4,
            children: [
              SpeedDialChild(
                child: Image.asset(
                  "assets/images/icon_BackPack.png",
                  height: 24,
                  fit: BoxFit.cover,
                ),
                label: "Inventory",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalkerInventory()));
                },
              ),
              SpeedDialChild(
                child: Image.asset(
                  "assets/images/icon_Cart.png",
                  height: 24,
                  fit: BoxFit.cover,
                ),
                label: "Shop",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalkerShop()));
                },
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Steps taken:',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                ValueListenableBuilder(
                    valueListenable: CurrentSteps.currentSteps,
                    builder: ((context, value, child) {
                      print(value);
                      return Text(
                        value.toString(),
                        style:
                            const TextStyle(fontSize: 48, color: Colors.white),
                      );
                    })),

                const SizedBox(
                  height: 50,
                ),
                // Image.asset(
                //   status == "walking"
                //       ? "assets/images/__Run.gif"
                //       : "assets/images/__Idle.gif",
                //   scale: 0.5,
                // ),

                ValueListenableBuilder(
                    valueListenable: CurrentEquip.current,
                    builder: (context, value, child) {
                      return status == "walking"
                          ? SizedBox(
                              height: 300,
                              width: double.infinity,
                              child:
                                  WalkingArmorIcons().getWalkingSprite(value),
                            )
                          : SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: IdleArmorIcons().getIdleSprite(value));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
