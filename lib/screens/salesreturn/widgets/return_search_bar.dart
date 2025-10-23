import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';

import '../../../widgets/shadow_box.dart';

class ReturnSearchBar extends GetView<SalesReturnController> {
  const ReturnSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      height: 50,
      width: double.infinity,
      curveRadius: 5,
      child: TextField(
        controller: controller.itemController,
        focusNode: controller.focusNode,
        style:
        const TextStyle(fontSize: 14),
        onChanged: (value) {
          controller.searchItem(value);
        },
        decoration: const InputDecoration(
          hintText: 'Search Item',
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.transparent),
          ),
          disabledBorder:
          OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.transparent),
          ),
          contentPadding:
          EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10),
        ),
      ),
    );
  }
}
