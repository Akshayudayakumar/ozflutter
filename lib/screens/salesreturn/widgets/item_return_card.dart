import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/sales_body.dart';

import '../../../constants/constant.dart';
import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../../models/general_details.dart';
import '../../../utils/utils.dart';
import '../controller/sales_return_controller.dart';

class ItemReturnCard extends GetView<SalesReturnController> {
  final Items item;
  final SalesItems salesBodyItem;

  const ItemReturnCard({
    super.key,
    required this.item,
    required this.salesBodyItem,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController quantityController =
        TextEditingController(text: salesBodyItem.quantity);
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
                        'Bought Quantity: ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                      Text(
                        salesBodyItem.quantity.toString(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${Currency.getById(AppData().getSettings().currency).symbol} ${salesBodyItem.rate}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child: Text('MFG: ${item.mfgDate}'),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child: Text('EXP: ${item.expDate}'),
                  // ),
                ],
              ),
            )
          ],
        ),
        GetBuilder<SalesReturnController>(
          builder: (controller) {
            return Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Only return this item?'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'You only want to return the selected item? ${item.name}'),
                                TextField(
                                  controller: quantityController,
                                  onChanged: (value) {
                                    if (num.parse(value.trim()) >
                                        num.parse(salesBodyItem.quantity!)) {
                                      Utils().showToast('Quantity exceeds');
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    MaxValueInputFormatter(
                                        double.parse(item.itemQty ?? '0'))
                                  ],
                                  decoration:
                                      InputDecoration(hintText: 'Quantity'),
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    if (num.parse(
                                            quantityController.text.trim()) >
                                        num.parse(salesBodyItem.quantity!)) {
                                      Utils().showToast('Quantity exceeds');
                                      return;
                                    }
                                    controller.returnSingleItem(
                                        salesBodyItem,
                                        int.parse(
                                            quantityController.text.isEmpty
                                                ? '0'
                                                : quantityController.text));
                                    Get.back();
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('No')),
                            ],
                          );
                        });
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: const Text('Return Item')),
                )),
                // if (!controller.addedItems
                //     .any((element) => element.id == item.id))
                //   Expanded(
                //       child: OpenItem(
                //     openChild: AddItemPopUp(
                //         item: item,
                //         onQuantityChanged: (value) {
                //           controller.setItemQuantity(
                //               item: item,
                //               quantity:
                //                   value.isNotEmpty ? int.parse(value) : 1);
                //         },
                //         onTotalChanged: (value) {},
                //         addToCart: () {
                //           controller.addItem(item);
                //         }),
                //     closedChild: Container(
                //         height: 50,
                //         width: double.infinity,
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //             border: Border.all(color: Colors.black12)),
                //         child: const Text('Add to cart')),
                //   )),
              ],
            );
          },
        )
      ],
    );
  }
}
