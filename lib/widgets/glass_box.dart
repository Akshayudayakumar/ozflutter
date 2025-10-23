import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final double curveRadius;
  final double? height;
  final double? width;
  final Widget child;
  const GlassBox({super.key, this.curveRadius = 12, this.height, this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(curveRadius),
      child: Container(
        height: height,
        width: width,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(curveRadius),
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter)),
            ),
            child
          ],
        ),
      ),
    );
  }
}
