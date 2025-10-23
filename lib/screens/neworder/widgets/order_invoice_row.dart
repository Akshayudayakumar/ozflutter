import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';

import '../../../constants/constant.dart';
import '../../../widgets/payment_dropdown.dart';

class OrderInvoiceRow extends StatelessWidget {
  const OrderInvoiceRow({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewOrderController>(builder: (controller) {
      String invoice =
          '${controller.billNumber.preffix ?? ''}${controller.billNumber.seperator ?? ''}${controller.billNumber.startnumber ?? ''}${controller.billNumber.seperator ?? ''}${controller.billNumber.suffix ?? ''}'
              .trim();
      return Column(
        children: [
          SizedBox(
            width: SizeConstant.screenWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConstant.screenWidth * .04,
                  ),
                  Text('Invoice No: $invoice'),
                  SizedBox(
                    width: SizeConstant.screenWidth * .04,
                  ),
                  Radio(
                      value: 'Cash',
                      activeColor: AppStyle.radioColor,
                      groupValue: controller.radioValue,
                      onChanged: (value) {
                        controller.updateRadioValue(value!);
                      }),
                  const Text('Cash'),
                  Radio(
                      value: 'Credit',
                      activeColor: AppStyle.radioColor,
                      groupValue: controller.radioValue,
                      onChanged: (value) {
                        controller.updateRadioValue(value!);
                      }),
                  const Text('Credit'),
                  Radio(
                      value: 'Bank',
                      activeColor: AppStyle.radioColor,
                      groupValue: controller.radioValue,
                      onChanged: (value) {
                        controller.updateRadioValue(value!);
                      }),
                  const Text('Bank'),
                  SizedBox(
                    width: SizeConstant.screenWidth * .04,
                  ),
                ],
              ),
            ),
          ),
          if (controller.radioValue == 'Bank')
            PaymentDropdown(
              paymentMethod: controller.paymentMethod,
              onSelected: (value) {
                controller.paymentMethod = value!;
                controller.update();
              },
              transactionController: controller.transactionController,
              bankNameController: controller.bankNameController,
            )
        ],
      );
    });
  }
}
