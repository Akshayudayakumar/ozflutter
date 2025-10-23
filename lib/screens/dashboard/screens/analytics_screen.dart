import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';
import 'package:ozone_erp/screens/dashboard/widgets/AnalyticsData/weekly_analytics.dart';
import 'package:ozone_erp/screens/dashboard/widgets/export_widgets.dart';

import '../../../widgets/export_widgets.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: GetBuilder(builder: (DashBoardController controller) {
          if (controller.allSales.isEmpty) {
            return Center(
              child: TextWidget('No Transaction history'),
            );
          }
          return ListView(
            shrinkWrap: true,
            children: [
              const AnalyticsCard(),
              const SizedBox(height: 20),
              Text(
                'Profit in last week',
                style: TextStyle(
                    fontSize: SizeConstant.screenWidth * .07,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '+ ${controller.calculateLastWeekProfitPercentage().round()}%',
                style: TextStyle(
                    fontSize: SizeConstant.screenWidth * .15,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[800]),
              ),
              const WeeklyAnalytics(),
            ],
          );
        }),
      ),
    );
  }
}
