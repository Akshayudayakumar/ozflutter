import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';

import '../../../routes/routes_class.dart';
import '../../../utils/utils.dart';
import '../../../widgets/print_button.dart';

class OrderButtonsRow extends GetView<NewOrderController> {
  const OrderButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.white);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: PrintButton(
            onTap: () {
              controller.confirmNewSale();
            },
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'New Order',
                style: style,
              ),
            ),
          ),
        ),
        Expanded(
          child: PrintButton(
            onTap: () {
              Get.toNamed(RoutesName.register);
            },
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Register',
                style: style,
              ),
            ),
          ),
        ),
        GetBuilder<NewOrderController>(
          builder: (controller) {
            return controller.radioValue == 'Credit'
                ? Expanded(
                    child: PrintButton(
                    onTap: () {
                      Get.toNamed(RoutesName.paymentVoucher, arguments: true);
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text(
                        'Receipt',
                        style: style,
                      ),
                    ),
                  ))
                : Container();
          },
        ),
        Expanded(
          child: PrintButton(
            onTap: () async {
              if (controller.addedItems.isEmpty) {
                Utils().showToast('Please add items');
                return;
              }
              if (controller.selectedCustomer.value.id == null) {
                Utils().showToast('Please Select Customer');
                return;
              }
              if (controller.payableAmount.text.isEmpty ||
                  RegExpressions.zeroRegex
                      .hasMatch(controller.payableAmount.text)) {
                Utils().showToast('Payable Amount cannot be zero');
                return;
              }
              if (!await controller.updateSalesBody()) {
                return;
              }
              Get.toNamed(RoutesName.pdfView,
                  arguments: {'invoice': controller.getInvoice()});
              // if (controller.addedItems.isNotEmpty &&
              //     controller.selectedCustomer.value.id != null) {
              //   if (controller.payableAmount.text.isNotEmpty &&
              //       !RegExpressions.zeroRegex
              //           .hasMatch(controller.payableAmount.text)) {
              //     await controller.updateSalesBody();
              //     Get.toNamed(RoutesName.pdfView,
              //         arguments: {'invoice': controller.getInvoice()});
              //   } else {
              //     Utils().showToast('Payable Amount cannot be zero');
              //   }
              // } else {
              //   Utils().showToast(controller.addedItems.isEmpty
              //       ? 'Please add items'
              //       : 'Please Select Customer');
              // }
            },
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Save & Print',
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
