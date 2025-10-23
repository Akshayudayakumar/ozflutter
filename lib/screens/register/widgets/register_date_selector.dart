import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/register/controller/register_controller.dart';

import '../../../Constants/constant.dart';
import '../../../utils/date_converter.dart';
import '../../../widgets/export_widgets.dart';

class RegisterDateSelector extends StatelessWidget {
  const RegisterDateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (RegisterController controller) {
      return Column(
        children: [
          SizedBox(
            height: SizeConstant.screenHeight * .03,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                "From Date",
                textAlign: TextAlign.center,
              )),
              Expanded(
                  child: Text(
                "To Date",
                textAlign: TextAlign.center,
              )),
            ],
          ),
          SizedBox(
            height: SizeConstant.screenHeight * .01,
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: DateTextField(
                    controller: controller.fromDateController,
                    color: AppStyle.primaryColor,
                    onTap: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateConverter.parseCustomDateTime(
                              controller.filteredSalesItems.last.createdDate!),
                          lastDate: controller.endDate ?? now);
                      if (pickedDate != null) {
                        controller.startDate = pickedDate;
                        controller.fromDateController.text =
                            '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                        if (controller.startDate != null &&
                            controller.endDate != null &&
                            controller.startDate!
                                .isBefore(controller.endDate!)) {
                          controller.filterSalesItemsByDate();
                        }
                        controller.update();
                      }
                    },
                    hintText: 'From Date'),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: DateTextField(
                    controller: controller.toDateController,
                    color: AppStyle.primaryColor,
                    onTap: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                          context: context,
                          firstDate: controller.startDate ??
                              DateConverter.parseCustomDateTime(controller
                                  .filteredSalesItems.last.createdDate!),
                          lastDate: now);
                      if (pickedDate != null) {
                        controller.endDate = pickedDate;
                        controller.toDateController.text =
                            '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                        if (controller.startDate != null &&
                            controller.endDate != null &&
                            controller.endDate!
                                .isAfter(controller.startDate!)) {
                          controller.filterSalesItemsByDate();
                        }
                        controller.update();
                      }
                    },
                    hintText: 'To Date'),
              )),
            ],
          ),
          if (controller.fromDateController.text.isNotEmpty ||
              controller.toDateController.text.isNotEmpty)
            TextButton(
                onPressed: () async {
                  controller.fromDateController.clear();
                  controller.toDateController.clear();
                  controller.startDate = null;
                  controller.endDate = null;
                  controller.getSalesItems();
                  controller.update();
                },
                child: Text('Clear Date')),
        ],
      );
    });
  }
}
