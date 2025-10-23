import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/stockTransfer/controller/stock_transfer_controller.dart';

import '../../../Constants/app_style.dart';
import '../../../widgets/shadow_box.dart';

class StockSearchBar extends GetView<StockTransferController> {
  const StockSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      height: 50,
      width: double.infinity,
      curveRadius: 5,
      child: TextField(
        controller: controller.itemController,
        style: const TextStyle(fontSize: 15, letterSpacing: 0.5),
        onChanged: (value) {
          controller.searchItem(value);
        },
        decoration: const InputDecoration(
          hintText: 'Search Item',
          suffixIcon: Icon(Icons.search,color: AppStyle.primaryColor),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          // border: OutlineInputBorder(
          //   borderSide: BorderSide.none
          //       color: Colors.transparent),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //       color: Colors.transparent),
          // ),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //       color: Colors.transparent),
          // ),
          // errorBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //       color: Colors.transparent),
          // ),
          // disabledBorder:
          // OutlineInputBorder(
          //   borderSide: BorderSide(
          //       color: Colors.transparent),
          // ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        ),
      ),
    );
  }
}
