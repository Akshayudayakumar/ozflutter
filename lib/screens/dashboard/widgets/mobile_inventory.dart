import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/screens/register/screen/detailed_report_screen.dart';

import '../../../data/app_data.dart';
import '../../../models/currency.dart';

class MobileInventory extends StatelessWidget {
  final Items? product;
  final SalesBody? order;

  const MobileInventory({super.key, this.product, this.order});

  @override
  Widget build(BuildContext context) {
    return product == null && order == null
        ? const Center(child: Text('Error: No input'))
        : product != null && order != null
            ? const Center(child: Text('Error: Invalid input'))
            : product != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: GestureDetector(
                      onTap: () => Get.toNamed(RoutesName.stockTransfer),
                      child: Container(
                        width: SizeConstant.screenWidth,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            // Checkbox(
                            //     activeColor: Colors.blue,
                            //     value: isSelected,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         isSelected = value!;
                            //       });
                            //     }),
                            SizedBox(
                              width: SizeConstant.screenWidth * .05,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product!.name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '${product!.itemQty} items • ${Currency.getById(AppData().getSettings().currency).symbol} ${product!.mrp}',
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                product!.mfgDate.toString().trim(),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                  '${Currency.getById(AppData().getSettings().currency).symbol} ${product!.srate}',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black)),
                            ),
                            SizedBox(
                              width: SizeConstant.screenWidth * .05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: GestureDetector(
                      onTap: () =>
                          Get.to(() => DetailedReportScreen(salesBody: order!)),
                      child: Container(
                        width: SizeConstant.screenWidth,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            // Checkbox(
                            //     activeColor: Colors.blue,
                            //     value: isSelected,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         isSelected = value!;
                            //       });
                            //     }),
                            SizedBox(
                              width: SizeConstant.screenWidth * .05,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order!.id!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '${order!.salesitems!.length} items • ${Currency.getById(AppData().getSettings().currency).symbol} ${order!.total}',
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order!.createdDate
                                    .toString()
                                    .trim()
                                    .split(' ')
                                    .join('\n'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                order!.cusname ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            SizedBox(
                              width: SizeConstant.screenWidth * .05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
  }
}
