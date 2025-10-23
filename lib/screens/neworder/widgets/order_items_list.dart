import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';
import 'package:ozone_erp/widgets/open_item.dart';

import '../../../constants/constant.dart';
import '../../../models/currency.dart';
import '../../../utils/utils.dart';
import '../../../widgets/edit_item_pop_up.dart';
import '../../../widgets/solid_button.dart';

class OrderItemsList extends StatelessWidget {
  const OrderItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewOrderController>(
      builder: (controller) {
        return Container(
          alignment: Alignment.topCenter,
          child: ListView.separated(
            itemCount: controller.addedItems.length,
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
                            if (!RegExpressions.zeroRegex
                                .hasMatch(item.priceDiscount!))
                              Text(
                                'Special Discount: ${item.priceDiscount}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppStyle.radioColor),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SolidButton(
                                    onTap: () {
                                      if (controller
                                              .selectedQuantity[item.id!]! <=
                                          1) {
                                        controller.removeItem(item);
                                      } else {
                                        controller.decrementItemQuantity(item);
                                      }
                                    },
                                    height: 25,
                                    width: 25,
                                    curveRadius: 3,
                                    color: Colors.grey[700],
                                    child: const Icon(
                                      Icons.remove,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(controller.selectedQuantity[item.id!]
                                        .toString()),
                                    Text('No'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SolidButton(
                                    onTap: () {
                                      final settings = AppData().getSettings();
                                      int incrementQuantity =
                                          (settings.incrementQty?.isEmpty ??
                                                  true)
                                              ? 1
                                              : int.parse(
                                                  settings.incrementQty ?? '1');
                                      if (double.parse(item.itemQty!) <=
                                          (controller
                                                  .selectedQuantity[item.id!]! +
                                              incrementQuantity -
                                              1)) {
                                        if (item.itemQty ==
                                            controller.selectedQuantity[item.id]
                                                .toString()) {
                                          Utils().showToast(
                                              'Quantity exceeds item stock quantity');
                                        } else {
                                          controller
                                                  .selectedQuantity[item.id!] =
                                              int.parse(item.itemQty ?? '0');
                                          controller.update();
                                        }
                                      } else {
                                        controller.incrementItemQuantity(item);
                                      }
                                    },
                                    height: 25,
                                    width: 25,
                                    curveRadius: 3,
                                    color: Colors.grey[700],
                                    child: const Icon(
                                      Icons.add,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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
                          child: OpenItem(
                        openChild: EditItemPopUp(
                          item: item,
                          save: () {
                            if (double.parse(item.itemQty!) >=
                                controller.selectedQuantity[item.id!]!) {}
                          },
                          onQuantityChanged: (value) =>
                              controller.setItemQuantity(
                                  item: item,
                                  quantity:
                                      value.isNotEmpty ? int.parse(value) : 1),
                          onTotalChanged: (v) {},
                        ),
                        closedChild: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                            child: const Text('Edit')),
                      )),
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
