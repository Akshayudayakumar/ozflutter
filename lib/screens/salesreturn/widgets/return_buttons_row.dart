import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';

import '../../../widgets/print_button.dart';

class ReturnButtonsRow extends GetView<SalesReturnController> {
  const ReturnButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PrintButton(
          onTap: () {
            controller.confirmNewSale();
          },
          width: SizeConstant.screenWidth * .3,
          child: const Text(
            'Clear',
            style: TextStyle(color: Colors.white),
          ),
        ),
        // PrintButton(
        //   onTap: () {
        //     if (controller.addedItems.isNotEmpty) {
        //       if (controller.payableAmount.text.isNotEmpty &&
        //           !RegExpressions.zeroRegex
        //               .hasMatch(controller.payableAmount.text)) {
        //         if (AppData().getUpiID().isNotEmpty) {
        //           Get.toNamed(RoutesName.pdfView, arguments: {'invoice': ''});
        //         } else {
        //           controller.setUpiId();
        //         }
        //       } else {
        //         Utils().showToast('Payable Amount cannot be zero');
        //       }
        //     } else {
        //       Utils().showToast('Please add items');
        //     }
        //   },
        //   width: SizeConstant.screenWidth * .3,
        //   child: const Text(
        //     'Save & Print',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
      ],
    );
  }
}
