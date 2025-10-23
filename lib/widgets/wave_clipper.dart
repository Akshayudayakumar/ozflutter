import 'package:flutter/material.dart';

class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.75, size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.95, size.width, size.height * 0.85);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
