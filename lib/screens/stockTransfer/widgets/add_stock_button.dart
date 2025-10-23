import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/stockTransfer/controller/stock_transfer_controller.dart';
import 'package:ozone_erp/widgets/solid_button.dart';

import '../../../data/app_data.dart';
import '../../../models/currency.dart';

class AddStockButton extends GetView<StockTransferController> {
  const AddStockButton({super.key});

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GetBuilder<StockTransferController>(
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
              Obx(
                () {
                  return Row(
                    children: [
                      Checkbox(
                        value: controller.clearPrevious.value,
                        onChanged: (value) {
                          controller.updatePreviousCheck(value ?? false);
                        },
                      ),
                      const Text('Clear Previous Stock')
                    ],
                  );
                },
              )
            ],
          ),
          SolidButton(
            onTap: () {
              // controller.addToStock();
            },
            color: AppStyle.radioColor,
            width: 150,
            height: 50,
            child: Text(
              "Add to Stock",
              style: FontConstant.inter
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
