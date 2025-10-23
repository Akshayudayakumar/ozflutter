import 'package:flutter/material.dart';
import 'package:ozone_erp/Constants/constant.dart';

class NeedleDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a Paint object to define how to draw on the canvas.
    final Paint paint = Paint()
      // A shader is used to fill shapes with gradients, images, or other patterns.
      // Here, we are creating a linear gradient shader.
      ..shader = LinearGradient(
        // The `colors` property defines the colors used in the gradient.
        // The gradient will transition from the first color, through the middle, to the last.
        // In this case: radioColor -> secondaryColor -> radioColor.
        colors: [
          AppStyle.radioColor,
          AppStyle.secondaryColor,
          AppStyle.radioColor,
        ],
        // `begin` sets the starting point of the gradient. Alignment.centerLeft means
        // the gradient starts at the middle of the left edge.
        begin: Alignment.centerLeft,
        // `end` sets the ending point of the gradient. Alignment.centerRight means
        // the gradient ends at the middle of the right edge, creating a horizontal effect.
        end: Alignment.centerRight,
        // `createShader` generates the Shader object. It needs a `Rect` (rectangle)
        // to know the bounds within which the gradient should be drawn.
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path path = Path()
      ..moveTo(0, size.height / 2) // Starting point on the left
      ..lineTo(size.width * 0.25, 0) // Left sharp point
      ..lineTo(size.width * 0.75, 0) // Right sharp point
      ..lineTo(size.width, size.height / 2); // Ending point on the right

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
