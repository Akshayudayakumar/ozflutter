import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/stockTransfer/controller/stock_transfer_controller.dart';

import '../../../widgets/item_card.dart';
import '../../../widgets/loader/item_card_loader.dart';

class FilterStockList extends GetView<StockTransferController> {
  const FilterStockList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoading.value
          ? ListView.separated(
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return const ItemCardLoader();
              },
            )
          : GetBuilder<StockTransferController>(builder: (ctrl) {
              return ListView.separated(
                itemCount: ctrl.searchItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ItemCard(
                    item: ctrl.searchItems[index],
                    onTotalChanged: (value) {},
                    onQuantityChanged: (value) {},
                    addToCart: () {},
                    stockTransferController: StockTransferController(),
                    openCart: !controller.addedItems.any(
                      (element) => element.id == ctrl.searchItems[index].id,
                    ),
                    preventMessage: 'Item already in the cart',
                  );
                },
              );
            });
    });
  }
}
