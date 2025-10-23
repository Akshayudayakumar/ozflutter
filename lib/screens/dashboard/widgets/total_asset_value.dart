import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';

import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../../utils/format_comma.dart';
import 'export_widgets.dart';

class TotalAssetValue extends StatelessWidget {
  const TotalAssetValue({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (DashBoardController controller) {
        final products = controller.products;
        return SizedBox(
          height: SizeConstant.screenHeight * .25,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: SizeConstant.screenHeight * .03,
                      backgroundColor:
                          AppStyle.floatingActionColor.withAlpha(140),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 2,
                                )),
                            child: Icon(
                              Icons.currency_rupee,
                              color: Colors.blueAccent,
                              size: SizeConstant.screenWidth * .05,
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL ASSET VALUE',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Text(
                          '${Currency.getById(AppData().getSettings().currency).symbol} ${formatIndianDouble(controller.calculateAsset(products))}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                        ),
                      ],
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                  child: Divider(),
                ),
                const ProductOverview()
              ],
            ),
          ),
        );
      },
    );
  }
}
