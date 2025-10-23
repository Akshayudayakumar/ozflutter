import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';

import '../../../routes/routes_class.dart';
import '../../../widgets/shadow_box.dart';

class OrderCustomerSelectorRow extends GetView<NewOrderController> {
  const OrderCustomerSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          SizedBox(
            width: SizeConstant.screenWidth * .05,
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesName.selectCustomer);
                },
                child: ShadowBox(
                  height: 40,
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: Text(controller.selectedCustomer.value.name ??
                          'Select Customer')),
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: ShadowBox(
                height: 40,
                child: GetBuilder(builder: (NewOrderController controller) {
                  return DropdownMenu(
                      inputDecorationTheme: InputDecorationTheme(
                          border: InputBorder.none,
                          isCollapsed: true,
                          isDense: true,
                          suffixIconConstraints:
                              BoxConstraints.expand(width: 0.0)),
                      expandedInsets: EdgeInsets.all(4),
                      textAlign: TextAlign.center,
                      trailingIcon: SizedBox.shrink(),
                      initialSelection: controller.salesBills.isEmpty
                          ? null
                          : controller.salesBills.first.id,
                      dropdownMenuEntries: controller.salesBills.map(
                        (e) {
                          return DropdownMenuEntry(
                              value: e.id, label: e.type ?? 'Bill Type');
                        },
                      ).toList(),
                      onSelected: (value) {
                        controller.updateBillType(value ?? '');
                      });
                }),
              ),
            ),
          ),
          SizedBox(
            width: SizeConstant.screenWidth * .05,
          )
        ],
      ),
    );
  }
}
