import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/edit_item_pop_up.dart';
import 'package:ozone_erp/widgets/open_item.dart';

import '../../../constants/constant.dart';
import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../../models/general_details.dart';
import '../../../widgets/solid_button.dart';
import '../controller/new_sale_controller.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewSaleController>(
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SolidButton(
                                    onTap: () {
                                      if (double.parse(item.itemQty ?? '0') <=
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
                                    Text(item.itemQty ?? '0'),
                                    Text('No'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SolidButton(
                                    onTap: () {
                                      final salesItem = controller.salesItems
                                          .firstWhere(
                                              (element) =>
                                                  element.id == item.id,
                                              orElse: () => Items());
                                      if (double.parse(
                                              salesItem.itemQty ?? '0') <=
                                          0) {
                                        Utils().showToast(
                                            'Quantity exceeds item stock quantity');
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
                              '${Currency.getById(AppData().getSettings().currency).symbol} ${Utils().roundWithFixedDecimal(num.parse(item.srate ?? '0'))}',
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
                                  cancel: () => controller.setItemQuantity(
                                      item: item,
                                      quantity: int.parse(item.itemQty ?? '0'),
                                      isEdit: true),
                                  onQuantityChanged: (value) =>
                                      controller.setItemQuantity(
                                          item: item,
                                          isEdit: true,
                                          quantity: value.isNotEmpty
                                              ? int.parse(value)
                                              : 1),
                                  onTotalChanged: (value) {},
                                  save: () {
                                    final salesItem = controller.salesItems
                                        .firstWhere(
                                            (element) => element.id == item.id,
                                            orElse: () => Items());
                                    if (double.parse(salesItem.itemQty!) >=
                                        controller
                                            .selectedQuantity[item.id!]!) {
                                      controller.addedItems[index] =
                                          item.copyWith(
                                              itemQty: controller
                                                  .selectedQuantity[item.id!]
                                                  ?.toString());
                                    }
                                    controller.updateGrandTotal();
                                  }),
                              closedChild: Container(
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
