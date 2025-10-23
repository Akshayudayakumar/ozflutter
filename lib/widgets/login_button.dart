import 'package:flutter/material.dart';
import 'package:ozone_erp/constants/app_style.dart';

class LoginButton extends StatelessWidget {
  final List<Color>? colors;
  final Widget? child;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  const LoginButton({super.key, this.colors, this.child, this.onTap, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: colors ?? [AppStyle.primaryColor, AppStyle.secondaryColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
        ),
        child: child,
      ),
    );
  }
}
