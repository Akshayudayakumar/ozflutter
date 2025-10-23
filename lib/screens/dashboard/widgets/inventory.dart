import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';

import 'mobile_inventory.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final controller = Get.find<DashBoardController>();

  @override
  void initState() {
    controller.addScrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (DashBoardController controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 40,
              width: SizeConstant.screenWidth,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(5)),
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
                      child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "PRODUCT",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black.withAlpha(130)),
                    ),
                  )),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "PACKED",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black.withAlpha(130)),
                      ),
                    ),
                  ),
                  Expanded(
                      child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "SALES RATE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black.withAlpha(130)),
                      textAlign: TextAlign.end,
                    ),
                  )),
                  SizedBox(
                    width: SizeConstant.screenWidth * .05,
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.only(bottom: SizeConstant.screenHeight * .15),
            shrinkWrap: true,
            itemCount: controller.itemLength < controller.products.length
                ? controller.itemLength
                : controller.products.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return MobileInventory(
                product: controller.products[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
