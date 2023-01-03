// ignore_for_file: constant_identifier_names

import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

class GlobalStyleVariables {
  static const secondaryColour = Color(0xffff6347);
  static const backgroundColour = Color.fromARGB(255, 255, 114, 89);

  //Inventory Page
  static const invAppBarColour = Color(0xffb06946);
  static const invBackgroundColour = Color(0xff875035);
  static const invItemBackGroundColour = Color(0xffb06946);
  static const invItemBorderColour = Color(0xff4f2d1d);

  static const iconBorderColour = Color(0xff40211e);
  static const iconFillColour = Color(0xffce4643);
}

class CustomIcons {
  CustomIcons._();

  static const _kFontFam = 'CustomIcons';
  static const String? _kFontPkg = null;

  static const IconData icon_add =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData icon_x =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
