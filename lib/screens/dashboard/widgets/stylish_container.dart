import 'package:flutter/material.dart';
import 'package:ozone_erp/constants/constant.dart';

class StylishContainer extends StatelessWidget {
  final String text;
  final double horizontalPadding;

  const StylishContainer(
      {super.key, required this.text, this.horizontalPadding = 15});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: horizontalPadding),
      decoration: BoxDecoration(
          color: AppStyle.primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(5),
          )),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
