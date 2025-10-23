import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';
import 'package:ozone_erp/screens/salesreturn/widgets/export_return_widgets.dart';

class ReturnItemsList extends StatelessWidget {
  const ReturnItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesReturnController>(
      builder: (controller) {
        return Container(
          alignment: Alignment.topCenter,
          child: ListView.separated(
            itemCount: controller.salesBodyToReturn?.salesitems?.length ?? 0,
            separatorBuilder: (context, index) => const SizedBox(
              height: 30,
            ),
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = controller.itemsToReturn[index];
              final salesItem =
                  controller.salesBodyToReturn!.salesitems?[index] ??
                      SalesItems();
              return ItemReturnCard(
                item: item,
                salesBodyItem: salesItem,
              );
            },
          ),
        );
      },
    );
  }
}
