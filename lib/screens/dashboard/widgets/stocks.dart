import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';

import 'mobile_inventory.dart';

class Stocks extends StatelessWidget {
  const Stocks({super.key});

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
                            child: Text(
                          "ORDER",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black.withAlpha(130)),
                        )),
                        Expanded(
                          child: Text(
                            "CREATED",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black.withAlpha(130)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                            child: Text(
                          "CUSTOMER",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black.withAlpha(130)),
                          textAlign: TextAlign.end,
                        )),
                        SizedBox(
                          width: SizeConstant.screenWidth * .05,
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.allSales.length,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(),
                  padding:
                      EdgeInsets.only(bottom: SizeConstant.screenHeight * .15),
                  itemBuilder: (context, index) {
                    return MobileInventory(
                      order: controller.allSales[index],
                    );
                  },
                ),
              ],
            ));
  }
}
