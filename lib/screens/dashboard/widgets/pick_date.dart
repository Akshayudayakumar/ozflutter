import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';

class PickDate extends StatelessWidget {
  const PickDate({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (DashBoardController controller) {
      return GestureDetector(
        onTap: () async {
          final startDate = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              helpText: 'SELECT START DATE',
              initialDate: DateTime.now());
          if (startDate != null) {
            final endDate = await showDatePicker(
                context: context,
                firstDate: startDate,
                helpText: 'SELECT END DATE',
                lastDate: DateTime.now(),
                initialDate: DateTime.now());
            controller.startDate.value = startDate;
            controller.endDate.value =
                endDate?.copyWith(hour: 23, minute: 59, second: 59) ??
                    controller.endDate.value;
            controller.filterByDate();
          }
        },
        child: Container(
          margin: EdgeInsets.all(18),
          padding: EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return TextWidget(
                  controller.formatDate(controller.startDate.value),
                  color: Colors.white,
                );
              }),
              TextWidget(
                '-',
                color: Colors.white,
              ),
              Obx(() {
                return TextWidget(
                  controller.formatDate(controller.endDate.value),
                  color: Colors.white,
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
