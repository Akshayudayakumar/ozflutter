import 'package:flutter/material.dart';


class FilterWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? child;
  final double height;
  final double? width;
  final double curveRadius;
  final double padding;
  final Color? color;

  const FilterWidget({
    super.key,
    this.onTap,
    this.child,
    this.height = 40,
    this.width,
    this.curveRadius = 8,
    this.padding = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          width: width,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding * 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(curveRadius),
            color: color ?? Colors.white,
            border: Border.all(color: Colors.black12),
          ),
          child: child,
        ),
      ),
    );
  }
}
