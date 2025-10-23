import 'package:flutter/material.dart';
import 'package:ozone_erp/Constants/constant.dart';

class OpacityFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final int opacity;
  final Widget? child;
  const OpacityFloatingButton({
    super.key,
    required this.onPressed,
    this.color = AppStyle.radioColor,
    this.opacity = 100,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color.withAlpha(opacity * 2),
      elevation: 0,
      foregroundColor: color,
      child: child,
    );
  }
}
