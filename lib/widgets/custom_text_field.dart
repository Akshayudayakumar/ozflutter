import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? type;
  final int minLines;
  final int maxLines;
  final String? labelText;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextStyle? hintStyle;
  final Color labelColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value)? validator;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final bool hideText;
  final EdgeInsetsGeometry? padding;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.readOnly = false,
      this.minLines = 1,
      this.maxLines = 5,
      this.padding,
      this.focusNode,
      this.inputFormatters,
      this.onTap,
      this.hintStyle,
      this.labelColor = Colors.brown,
      this.prefixIcon,
      this.textInputType,
      this.suffixIcon,
      this.hideText = false,
      this.type,
      this.validator,
      this.labelText,
      this.textCapitalization});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(18.0),
      child: TextFormField(
        maxLines: hideText ? 1 : maxLines,
        minLines: minLines,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        onTap: onTap,
        readOnly: readOnly,
        focusNode: focusNode,
        controller: controller,
        validator: validator,
        cursorColor: AppStyle.radioColor,
        obscureText: hideText,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: hintText,
          hintMaxLines: 1,
          labelText: labelText,
          labelStyle: TextStyle(color: labelColor),
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppStyle.radioColor)),
        ),
      ),
    );
  }
}
