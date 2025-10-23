import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';

import '../../../routes/routes_class.dart';
import '../../../widgets/shadow_box.dart';

class ReturnCustomerSelectorRow extends GetView<SalesReturnController> {
  const ReturnCustomerSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        children: [
          SizedBox(
            width: SizeConstant.screenWidth * .05,
          ),
          Expanded(
            flex: 3,
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
                      child: Text(
                          controller.selectedCustomer.value.name ??
                              'Select Customer')),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, top: 8.0, bottom: 8.0),
              child: ShadowBox(
                height: 40,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(
                        controller.selectedCustomer.value.priceList ??
                            'Price List')),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, top: 8.0, bottom: 8.0),
              child: ShadowBox(
                height: 40,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(
                      controller.selectedCustomer.value
                          .creditAmountExceed ??
                          'Outstanding',
                      style: TextStyle(
                          fontSize: controller.selectedCustomer.value
                              .creditAmountExceed ==
                              null
                              ? 12
                              : null),
                    )),
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
