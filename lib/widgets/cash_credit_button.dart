import 'package:flutter/material.dart';

class CashCreditButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double? curve;
  final Color? color;

  const CashCreditButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.height,
      this.width, this.curve, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: height,
          width: width ?? 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(curve ?? 20),
            border: Border.all(color: Colors.white),
            color: color ?? Colors.white24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}
