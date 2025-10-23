import 'package:ozone_erp/Constants/constant.dart';

String formatIndianDouble(num number, [bool showDecimal = true]) {
  // Split the number into whole and decimal parts
  String numberString = number.toString();
  List<String> parts = numberString.split('.');

  // Format the integer part
  String integerPart = parts[0];
  String formattedInteger = formatIndianInteger(integerPart);

  // If there's a decimal part, append it
  if (parts.length > 1 && showDecimal) {
    String decimalPart = parts[1];
    if (RegExpressions.zeroRegex.hasMatch(decimalPart)) {
      return formattedInteger;
    }
    return '$formattedInteger.$decimalPart';
  }

  return formattedInteger;
}

String formatIndianInteger(String integerPart) {
  int length = integerPart.length;

  if (length <= 3) {
    return integerPart; // No formatting needed
  }

  // Split into parts
  String lastThreeDigits = integerPart.substring(length - 3);
  String remainingDigits = integerPart.substring(0, length - 3);

  // Group the remaining digits in pairs
  StringBuffer formattedNumber = StringBuffer();
  for (int i = remainingDigits.length - 1; i >= 0; i--) {
    formattedNumber.write(remainingDigits[i]);
    // Add a comma after every two digits
    if ((remainingDigits.length - i) % 2 == 0 && i != 0) {
      formattedNumber.write(',');
    }
  }

  // Reverse the remaining digits and add the last three
  String finalFormattedInteger =
      formattedNumber.toString().split('').reversed.join();
  return '$finalFormattedInteger,$lastThreeDigits';
}
