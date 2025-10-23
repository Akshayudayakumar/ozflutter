import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/stockTransfer/controller/stock_transfer_controller.dart';

import '../../../constants/constant.dart';
import '../../../data/app_data.dart';
import '../../../models/currency.dart';

class CartStockList extends StatelessWidget {
  const CartStockList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockTransferController>(
      builder: (controller) {
        return Container(
          alignment: Alignment.topCenter,
          child: ListView.separated(
            itemCount: controller.addedItems.length,
            padding:
                EdgeInsets.symmetric(vertical: SizeConstant.screenHeight * .04),
            separatorBuilder: (context, index) => const SizedBox(
              height: 30,
            ),
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = controller.addedItems[index];
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: SizeConstant.screenWidth * .35,
                          height: SizeConstant.screenWidth * .35,
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            AssetConstant.logo,
                            fit: BoxFit.contain,
                          )),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name ?? '',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Qty: ',
                                  style: TextStyle(
                                      color: AppStyle.primaryColor,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                    width: 50,
                                    child: TextFormField(
                                      initialValue: controller
                                          .selectedQuantity[item.id!]
                                          .toString(),
                                      onFieldSubmitted: (value) =>
                                          controller.setItemQuantity(
                                              item: item,
                                              quantity: value.isNotEmpty
                                                  ? int.parse(value)
                                                  : 1),
                                      onChanged: (value) =>
                                          controller.setItemQuantity(
                                              item: item,
                                              quantity: value.isNotEmpty
                                                  ? int.parse(value)
                                                  : 1),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          isDense: true),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${Currency.getById(AppData().getSettings().currency).symbol} ${item.srate}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                controller.removeItem(item);
                              },
                              child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.black12)),
                                  child: const Text('Remove')))),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.black12)),
                                  child: const Text('Edit')))),
                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
