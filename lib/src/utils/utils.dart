import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_project/imports.dart';

var actualScreenWidth = window.physicalSize.width / window.devicePixelRatio;
var actualScreenHeight = window.physicalSize.height / window.devicePixelRatio;
var textScale = actualScreenWidth / (actualScreenWidth < 600 ? 414 : 600);

var isTablet = actualScreenWidth > 600;

String generateRandomColor() {
  int length = 6;
  String chars = '0123456789ABCDEF';
  String hex = '#';
  while (length-- > 0) hex += chars[(Random().nextInt(16)) | 0];
  return hex;
}

Color colorFromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

showSnackBar(message, {color: Colors.red}) {
  ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(
    content: MyText(
      message,
      color: Colors.white,
      fontSize: 12,
      maxLines: 5,
      fontWeight: FontWeight.normal,
    ),
  ));
}

double rWidth(double percentage) {
  return actualScreenWidth * (percentage / 100);
}

double rHeight(double percentage) {
  return actualScreenHeight * (percentage / 100);
}

checkNullString(String str) {
  return str != null && str != '' ? str : '';
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
