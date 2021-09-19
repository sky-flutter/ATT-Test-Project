import 'package:test_project/imports.dart';

import 'border.dart';

class MyTextField extends StatelessWidget {
  String hint;
  Widget? prefix;
  Widget? suffix;
  Color focusedColor;
  Color outlineColor;
  TextInputType keyboardType;
  bool isObscureText;
  late OutlineInputBorder border, focusedErrorBorder, focusedBorder;

  MyTextField(
      {this.focusedColor = Colors.white,
      this.outlineColor = Colors.white,
      this.hint = "",
      this.suffix,
      this.isObscureText = false,
      this.prefix,
      this.keyboardType = TextInputType.text}) {
    border = OutlineInputBorder(
        borderRadius: MyBorder.commonBorderRadius(), borderSide: BorderSide(color: outlineColor, width: 1));

    focusedBorder = border.copyWith(borderSide: BorderSide(color: focusedColor, width: 1.5));

    focusedErrorBorder = focusedBorder.copyWith(borderSide: BorderSide(color: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: isObscureText,
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        focusedErrorBorder: focusedErrorBorder,
        hintText: hint,
        suffix: suffix,
        labelStyle: Style.normal.copyWith(color: focusedColor),
        hintStyle: Style.normal,
        prefix: prefix,
      ),
    );
  }
}
