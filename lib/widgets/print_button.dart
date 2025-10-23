import 'package:flutter/material.dart';

import '../constants/constant.dart';

class PrintButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  const PrintButton({super.key, this.child, this.onTap, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: height ?? 50,
          width: width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [AppStyle.primaryColor, AppStyle.secondaryColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
