import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';

import '../../../constants/constant.dart';
import '../../../widgets/export_widgets.dart';

class ReturnInvoiceRow extends StatelessWidget {
  const ReturnInvoiceRow({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesReturnController>(builder: (controller) {
      return Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                SizedBox(
                  width: SizeConstant.screenWidth * .04,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Invoice No:'),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: controller.invoiceController,
                        onSubmitted: (value) {
                          controller.itemByInvoice(value);
                        },
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    )
                  ],
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
                  width: SizeConstant.percentToWidth(4),
                ),
              ],
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
