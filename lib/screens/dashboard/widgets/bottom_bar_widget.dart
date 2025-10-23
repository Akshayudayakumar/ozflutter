import 'package:flutter/material.dart';
import 'package:ozone_erp/constants/constant.dart';

class BottomBarWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final List<Widget> items;
  const BottomBarWidget({super.key, this.height, this.width, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: height ?? SizeConstant.screenHeight *.1,
        width: width ?? SizeConstant.screenWidth *.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(height ?? SizeConstant.screenHeight * .1),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 5, offset: Offset(0, 5))]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.map((e) {
            return FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: e);
          },).toList(),
        ),
      ),
    );
  }
}
