import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';

import '../../../constants/constant.dart';
import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../../widgets/solid_button.dart';

class ReturnButton extends GetView<SalesReturnController> {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black38),
          boxShadow: const [
            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 15)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GetBuilder<SalesReturnController>(
              builder: (controller) {
                return Text(
                  '${Currency.getById(AppData().getSettings().currency).symbol} ${controller.addedItems.map((e) => double.parse(e.srate!) * controller.selectedQuantity[e.id!]!).reduce((value, element) => value + element)}',
                  style: FontConstant.inter.copyWith(
                      fontSize: SizeConstant.font20,
                      fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          SolidButton(
            onTap: () {
              controller.returnItems();
            },
            color: AppStyle.radioColor,
            width: 150,
            height: 50,
            child: Text(
              "Return Items",
              style: FontConstant.inter
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
