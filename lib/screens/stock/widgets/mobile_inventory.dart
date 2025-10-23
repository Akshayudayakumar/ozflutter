import 'package:flutter/material.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/models/currency.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/sales_body.dart';

class MobileInventory extends StatelessWidget {
  final Items? product;
  final SalesBody? order;

  const MobileInventory({super.key, this.product, this.order});

  @override
  Widget build(BuildContext context) {
    if (product == null && order == null) {
      return const Center(child: Text('Error: No input'));
    } else {
      if (product != null && order != null) {
        return const Center(child: Text('Error: Invalid input'));
      } else {
        if (product != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SizedBox(
              width: SizeConstant.screenWidth,
              child: Row(
                children: [
                  // Checkbox(
                  //     activeColor: Colors.blue,
                  //     value: false,
                  //     onChanged: (value) {}),
                  SizedBox(
                    width: SizeConstant.screenWidth * .05,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          product!.name!,
                          maxLines: 3,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                        FittedBox(
                          child: Text(
                            '${product!.itemQty} items • ${Currency.getById(AppData().getSettings().currency).symbol} ${product!.mrp}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          product!.mfgDate.toString().trim(),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                            '${Currency.getById(AppData().getSettings().currency).symbol} ${product!.srate}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConstant.screenWidth * .05,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SizedBox(
              width: SizeConstant.screenWidth,
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
                          style: const TextStyle(color: Colors.black54),
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
          );
        }
      }
    }
  }
}
