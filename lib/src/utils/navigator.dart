import 'package:flutter/material.dart';
import 'package:test_project/main.dart';

class MyNavigator {
  static var navState = navigatorKey.currentState;

  static pushNamed(String name) {
    navState?.pushNamed(name);
  }

  static pushReplacedNamed(String name) {
    navState?.pushReplacementNamed(name);
  }

  static pushAndRemove(String name, String path) {
    navState?.pushNamedAndRemoveUntil(name, ModalRoute.withName(path));
  }
}
