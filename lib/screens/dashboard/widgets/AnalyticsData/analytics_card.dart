import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/constant.dart';
import '../../../../data/app_data.dart';
import '../../../../models/currency.dart';
import '../../../../utils/format_comma.dart';
import '../../controller/dashboard_controller.dart';
import '../export_widgets.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (DashBoardController controller) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
            height: SizeConstant.screenHeight * .3,
            width: SizeConstant.screenWidth,
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.percent,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Profit',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        '+ ${controller.calculateProfitPercentage(controller.calculateProfit()).round()} %',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    )
                  ],
                ),
                Text(
                  '${Currency.getById(AppData().getSettings().currency).symbol} ${formatIndianDouble(controller.calculateProfit(), false)}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConstant.screenWidth * .15,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w800),
                ),
                Expanded(child: const AnalyticCurveChart()),
              ],
            )),
      );
    });
  }
}
