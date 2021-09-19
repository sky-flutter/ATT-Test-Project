import 'package:flutter/material.dart';
import 'package:test_project/imports.dart';
import 'package:test_project/src/theme/style.dart';

import 'border.dart';

typedef OnFocusListener = Function(bool hasFocus);

// ignore: must_be_immutable
class MyTextFieldPrefixSuffix extends StatefulWidget {
  String hint;
  Widget? prefix;
  Widget? suffix;
  Color focusedColor;
  Color outlineColor;
  EdgeInsets? margin, padding;
  TextInputType keyboardType;
  TextCapitalization textCap;
  OnFocusListener? onFocusListener;
  TextEditingController? controller;
  Function()? onEditingComplete;
  Function(String)? onChanged;
  bool isObscureText;

  MyTextFieldPrefixSuffix(
      {this.focusedColor = Colors.white,
      this.outlineColor = Colors.white,
      this.hint = "",
      this.margin,
      this.controller,
      this.onFocusListener,
      this.onChanged,
      this.textCap = TextCapitalization.words,
      this.onEditingComplete,
      this.padding,
      this.suffix,
      this.isObscureText = false,
      this.prefix,
      this.keyboardType = TextInputType.text});

  @override
  _MyTextFieldPrefixSuffixState createState() => _MyTextFieldPrefixSuffixState();
}

class _MyTextFieldPrefixSuffixState extends State<MyTextFieldPrefixSuffix> {
  var border = MyBorder.transparentTextFieldBorder();
  var isFocused = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      isFocused = _focusNode.hasFocus;
      setState(() {});
      if (widget.onFocusListener != null) {
        widget.onFocusListener?.call(isFocused);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var container = Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: MyBorder.commonBorderRadius(),
          boxShadow: [
            BoxShadow(
              color: isFocused ? widget.focusedColor.withOpacity(.1) : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ],
          border: Border.all(color: isFocused ? widget.focusedColor : widget.outlineColor, width: 1)),
      child: Row(
        children: [
          if (widget.prefix != null) widget.prefix!,
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              keyboardType: widget.keyboardType,
              textCapitalization: widget.textCap,
              obscureText: widget.isObscureText,
              decoration: InputDecoration(
                border: border,
                focusedErrorBorder: border,
                focusedBorder: border,
                enabledBorder: border,
                hintText: widget.hint,
                labelStyle: Style.normal.copyWith(fontSize: 24, color: widget.focusedColor),
                hintStyle: Style.normal.copyWith(fontSize: 14),
              ),
            ),
          ),
          if (widget.suffix != null) widget.suffix!
        ],
      ),
    );

    return container;
  }
}
