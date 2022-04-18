import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_v1/constants.dart';

class AddProductsTextField extends StatelessWidget {
  final String lableTextForTextField;
  final Function onChangeFunction;
  final TextEditingController controller;
  final TextInputType textInputType;
  final int maxLines;
  final bool editable;
  final bool obscureText;
  final String errorText;
  final List<TextInputFormatter> inputFormat;

  AddProductsTextField({
    this.lableTextForTextField,
    this.onChangeFunction,
    this.controller,
    this.textInputType,
    this.maxLines,
    this.editable = true,
    this.obscureText = false,
    this.errorText,
    this.inputFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      elevation: 10,
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
      child: TextField(
        enabled: editable,
        maxLines: maxLines,
        onChanged: onChangeFunction,
        style: kAddProductTextFieldStyle,
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscureText,
        inputFormatters: inputFormat,
        decoration: InputDecoration(
          errorText: errorText,
          errorBorder: kAddProductTextFieldErrorBorder,
          filled: true,
          fillColor: Color(0xFFE2E3E3),
          labelText: lableTextForTextField,
          labelStyle: kAddProductTextFieldLableStyle,
          contentPadding: EdgeInsets.all(10),
          border: kAddProductTextFieldBorder,
          focusedBorder: kAddProductTextFieldFocusedBorder,
        ),
      ),
    );
  }
}
