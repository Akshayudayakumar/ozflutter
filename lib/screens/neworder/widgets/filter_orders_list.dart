import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';
import '../../../utils/utils.dart';
import '../../../widgets/item_card.dart';
import '../../../widgets/loader/item_card_loader.dart';

class FilterOrdersList extends GetView<NewOrderController> {
  const FilterOrdersList({super.key});

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
          : GetBuilder<NewOrderController>(builder: (ctrl) {
        return ListView.separated(
          itemCount: ctrl.searchItems.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            Items item = ctrl.searchItems[index];
            return ItemCard(
              item: item,
              onQuantityChanged: (value) {
                ctrl.setItemQuantity(
                    item: item,
                    quantity: value.isNotEmpty ? int.parse(value) : 1);
              },
              onTotalChanged: (value) {},
              addToCart: () {
                if (double.parse(item.itemQty!) >=
                    ctrl.selectedQuantity[item.id!]!) {
                  if (ctrl.addedItems
                      .any((element) => element.id == item.id)) {
                    Utils().showToast('Item already in the cart');
                  } else {
                    ctrl.addItem(item);
                  }
                }
              },
              openCart: ctrl.selectedCustomer.value.id != null &&
                  !ctrl.addedItems.any(
                        (element) => element.id == item.id,
                  ),
              preventMessage: ctrl.selectedCustomer.value.id == null
                  ? 'Please Select a Customer'
                  : 'Item already in the cart',
            );
          },
        );
      });
    });
  }
}
