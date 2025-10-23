import 'package:flutter/material.dart';

import '../constants/constant.dart';

class SolidButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double curveRadius;
  final VoidCallback? onTap;

  const SolidButton({
    super.key,
    this.height,
    this.width,
    this.child,
    this.curveRadius = 12,
    this.color,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? AppStyle.primaryColor,
          borderRadius: BorderRadius.circular(curveRadius),
        ),
        child: child,
      ),
    );
  }
}
