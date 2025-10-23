import 'dart:math';
import 'package:flutter/material.dart';

degreeToAngle(double degree) {
  return degree * pi / 180;
}

class SalesPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> values;
  final Animation<double> animation;

  SalesPainter({required this.colors, required this.values, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    drawArc(canvas, size);
  }

  void drawArc(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final total = values.fold(0, (sum, value) => sum + value.round());
    double startAngle = -pi / 2; // Start from the top

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * pi * animation.value;
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
