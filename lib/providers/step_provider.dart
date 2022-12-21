import 'package:flutter/material.dart';

int globalSteps = 0;

class StepsContext {
  updateGlobalSteps(newGlobalSteps) {
    globalSteps = newGlobalSteps;
  }
}
