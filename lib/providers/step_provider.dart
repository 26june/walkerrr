import 'package:flutter/material.dart';

class StepsData with ChangeNotifier {
  String _steps = "0";

  String get steps => _steps;

  void setSteps(steps) {
    _steps = steps;
  }
}
