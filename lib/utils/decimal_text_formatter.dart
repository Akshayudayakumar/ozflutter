import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Regular expression to match only digits and a single optional decimal point
    final RegExp regex = RegExp(r'^\d*\.?\d*$');

    // If the new value matches the regex, accept the input; otherwise, return the old value
    if (regex.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}