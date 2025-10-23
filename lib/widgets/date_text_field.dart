import 'package:flutter/material.dart';

class DateTextField extends StatelessWidget {
  final TextEditingController controller;
  final Color color;
  final VoidCallback onTap;
  final String hintText;

  const DateTextField(
      {super.key,
      required this.controller,
      required this.color,
      required this.onTap,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      readOnly: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color),
        ),
      ),
    );
  }
}
