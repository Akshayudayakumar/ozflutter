import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/models/currency.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import 'package:ozone_erp/utils/utils.dart';

class TotalDetails extends GetView<NewSaleController> {
  const TotalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        width: SizeConstant.screenWidth,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bill Discount: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  GetBuilder<NewSaleController>(
                    builder: (controller) {
                      return SizedBox(
                        width: 30,
                        child: TextField(
                          controller: controller.discountController,
                          onChanged: (value) {
                            controller.updateGrandTotal();
                          },
                          textAlign: TextAlign.end,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              hintText: '0',
                              isDense: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none),
                          style: const TextStyle(fontSize: 18),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      );
                    },
                  ),
                  const Text('%')
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Received Amount: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      GetBuilder<NewSaleController>(
                        builder: (controller) {
                          return SizedBox(
                            width: controller.textFieldWidth,
                            child: TextField(
                              controller: controller.payableAmount,
                              decoration: const InputDecoration(
                                  hintText: '0.0',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none),
                              style: const TextStyle(fontSize: 18),
                              keyboardType: TextInputType.number,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Grand Total: ${Currency.getById(AppData().getSettings().currency).symbol}${Utils().roundWithFixedDecimal(controller.grandTotal.value)}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
