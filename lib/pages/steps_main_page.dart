import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
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

    return MaterialApp(
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
            icon: Icons.add,
            activeIcon: Icons.close,
            spacing: 3,
            openCloseDial: isDialOpen,
            renderOverlay: false,
            closeManually: false,
            spaceBetweenChildren: 4,
            children: [
              SpeedDialChild(
                child: Icon(Icons.business_center),
                label: "Inventory",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WalkerInventory()));
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.shopping_cart),
                label: "Shop",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WalkerShop()));
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Steps taken:',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  steps,
                  style: const TextStyle(fontSize: 60),
                ),
                const Divider(
                  height: 100,
                  thickness: 0,
                  color: Colors.white,
                ),
                const Text(
                  'Pedestrian status:',
                  style: TextStyle(fontSize: 30),
                ),
                Image.asset(status == "walking" ? "assets/images/__Run.gif" : "assets/images/__Idle.gif", scale: 0.5,),
                Center(
                  child: Text(
                    status,
                    style: status == 'walking' || status == 'stopped'
                        ? const TextStyle(fontSize: 30)
                        : const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                )
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
