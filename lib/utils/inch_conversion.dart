import 'package:flutter/material.dart';

class InchConversion {
  Size getScreenSizeInInches(BuildContext context) {
    final double pixelRatio = View.of(context).devicePixelRatio;
    final double widthPixels = MediaQuery.of(context).size.width * pixelRatio;
    final double heightPixels = MediaQuery.of(context).size.height * pixelRatio;

    // Get exact DPI using FlutterView
    final double dpi =
        View.of(context).physicalSize.width / MediaQuery.of(context).size.width;

    final double widthInInches = widthPixels / dpi;
    final double heightInInches = heightPixels / dpi;

    return Size(widthInInches, heightInInches);
  }

  double mmToPixels(BuildContext context, double mm) {
    final double dpi =
        View.of(context).physicalSize.width / MediaQuery.of(context).size.width;
    final double mmPerInch = 25.4; // 1 inch = 25.4 mm
    return (mm / mmPerInch) * dpi; // Convert mm to pixels
  }

  double mmToInches(double mm) {
    return mm / 25.4; // Convert mm to inches
  }

  double inchesToPixels(BuildContext context, double inches) {
    final double dpi =
        View.of(context).physicalSize.width / MediaQuery.of(context).size.width;
    return inches * dpi; // Convert inches to pixels
  }
}
