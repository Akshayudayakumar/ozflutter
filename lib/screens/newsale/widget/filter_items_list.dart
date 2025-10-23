import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import 'package:ozone_erp/widgets/item_card.dart';
import 'package:ozone_erp/widgets/loader/item_card_loader.dart';

import '../../../components/change_url_alert.dart';

class FilterItemsList extends GetView<NewSaleController> {
  const FilterItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.loading.value
          ? ListView.separated(
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return const ItemCardLoader();
              },
            )
          : GetBuilder<NewSaleController>(
              builder: (ctrl) {
                return ctrl.salesItems.isEmpty
                    ? const Center(
                        child: Text('Please add items to stock to sell!'),
                      )
                    : ListView.separated(
                        itemCount: ctrl.searchItems.length,
                        controller: ctrl.scrollController,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          Items item = ctrl.searchItems[index];
                          return ItemCard(
                            item: item,
                            newSaleController: ctrl,
                            onTotalChanged: (value) {},
                            onQuantityChanged: (value) {
                              final salesItem = ctrl.salesItems.firstWhere(
                                (element) => element.id == item.id,
                                orElse: () => Items(),
                              );
                              if ((value.isEmpty ? 1 : int.parse(value)) >
                                  double.parse(salesItem.itemQty ?? '0')) {
                                showAlert(
                                  context: Get.context!,
                                  title: 'Quantity exceeds',
                                  content:
                                      'Quantity exceeds items stock quantity.',
                                );
                              }
                            },
                            openCart: ctrl.selectedCustomer.value.id != null,
                            preventMessage: 'Please select a customer',
                            addToCart: () {
                            
                            },
                          );
                        },
                      );
              },
            );
    });
  }
}
