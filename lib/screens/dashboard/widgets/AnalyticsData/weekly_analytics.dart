import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';

class WeeklyAnalytics extends StatelessWidget {
  const WeeklyAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (DashBoardController controller) {
      return SizedBox(
        height: SizeConstant.screenHeight * .3,
        width: SizeConstant.screenWidth,
        child: Row(
          children: [
            Expanded(
              child: bottle(
                  color: Colors.green,
                  percentage: controller.calculateLastWeekProfit()['Mon'] ?? 0,
                  day: 'Mon'),
            ),
            Expanded(
              child: bottle(
                  color: Colors.green,
                  percentage: controller.calculateLastWeekProfit()['Tue'] ?? 0,
                  day: 'Tue'),
            ),
            Expanded(
              child: bottle(
                  color: Colors.green,
                  percentage: controller.calculateLastWeekProfit()['Wed'] ?? 0,
                  day: 'Wed'),
            ),
            Expanded(
              child: bottle(
                  color: Colors.green,
                  percentage: controller.calculateLastWeekProfit()['Thu'] ?? 0,
                  day: 'Thu'),
            ),
            Expanded(
              child: bottle(
                  color: Colors.green,
                  percentage: controller.calculateLastWeekProfit()['Fri'] ?? 0,
                  day: 'Fri'),
            ),
            Expanded(
              child: bottle(
                  color: Colors.green,
                  percentage: controller.calculateLastWeekProfit()['Sat'] ?? 0,
                  day: 'Sat'),
            ),
            Expanded(
              child: bottle(
                  color: Colors.green,
                  percentage: controller.calculateLastWeekProfit()['Sun'] ?? 0,
                  day: 'Sun'),
            ),
          ],
        ),
      );
    });
  }

  Widget bottle(
      {required Color color, required double percentage, required String day}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: SizeConstant.screenHeight * .2,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Container(
                height: (SizeConstant.screenHeight * .2) * (percentage / 100),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                      topLeft: percentage == 100
                          ? Radius.circular(15)
                          : Radius.circular(0),
                      topRight: percentage == 100
                          ? Radius.circular(15)
                          : Radius.circular(0),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            day,
            style: FontConstant.interSmall
                .copyWith(fontSize: SizeConstant.percentToWidth(2.8)),
          ),
        ],
      ),
    );
  }
}
