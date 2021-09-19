import 'package:test_project/imports.dart';

class MyBorder{
  static transparentTextFieldBorder(){
    return OutlineInputBorder(
      borderSide: BorderSide(width: 0,color: Colors.transparent)
    );
  }
  static commonBorderRadius(){
    return BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
        topRight: Radius.circular(30));
  }
}