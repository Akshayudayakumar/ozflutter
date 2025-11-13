import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final double curveRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;


  const ShadowBox({
    super.key,
    this.height,
    this.width,
    this.child,
    this.curveRadius = 12,
    this.padding,
    this.margin,
    this.border
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(curveRadius),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(100),
            spreadRadius: 0.2,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
