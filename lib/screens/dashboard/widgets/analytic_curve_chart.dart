import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';

class AnalyticCurveChart extends StatelessWidget {
  const AnalyticCurveChart({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (DashBoardController controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(controller.lastMonthSales.length, (index) {
                    return FlSpot(index.toDouble(), double.parse(controller.lastMonthSales[index].total!));
                  },),

                  // [
                  //   FlSpot(0, 1),
                  //   FlSpot(1, 2.5),
                  //   FlSpot(2, 1.8),
                  //   FlSpot(3, 3),
                  //   FlSpot(4, 2.2),
                  //   FlSpot(5, 4),
                  //   FlSpot(6, 3.5),
                  // ],
                  isCurved: true,
                  color: Colors.yellow,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
