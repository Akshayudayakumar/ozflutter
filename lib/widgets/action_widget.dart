import 'package:flutter/material.dart';

class ActionWidget extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final Widget? child;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final double iconSize;
  final double padding;
  final int opacity;
  final Color? iconColor;
  const ActionWidget({
    super.key,
    required this.color,
    this.icon,
    this.onTap,
    this.height,
    this.width,
    this.child,
    this.iconSize = 30,
    this.padding = 15,
    this.opacity = 20, this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        height: height,
        width: width,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(opacity * 2),
            border: Border.all(color: color)),
        child: child ??
            Icon(
              icon,
              color: color,
              size: iconSize,
            ),
      ),
    );
  }
}
