import 'package:flutter/material.dart';

class NoOutlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Function(String value)? onChanged;
  final bool autofocus;

  const NoOutlineTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.textStyle,
    this.hintStyle,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      style: textStyle ?? const TextStyle(color: Colors.white),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? const TextStyle(color: Colors.white60),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
