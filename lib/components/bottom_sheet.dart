import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';

void showFilterBottomSheet([Widget? child]) {
  showModalBottomSheet(context: Get.context!, backgroundColor : Colors.transparent, builder: (context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        height: SizeConstant.screenHeight * .3,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: child,
      ),
    );
  },);
}