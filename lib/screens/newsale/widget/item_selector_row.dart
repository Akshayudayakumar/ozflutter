import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import '../../../widgets/shadow_box.dart';
import '../../../widgets/solid_button.dart';

class ItemSelectorRow extends GetView<NewSaleController> {
  const ItemSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.itemController.text =
          controller.selectedItem.value.name ?? '';
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 5, top: 8),
                child: Column(
                  children: [
                    const Text(
                      'Item',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ShadowBox(
                      height: 35,
                      width: double.infinity,
                      curveRadius: 5,
                      child: controller.selectedCustomer.value.id ==
                          null
                          ? Container(
                          alignment: Alignment.center,
                          child:
                          const Text('Select Customer first'))
                          : TypeAheadField(
                        controller: controller.itemController,
                        focusNode: controller.focusNode,
                        itemBuilder: (context, value) {
                          return ListTile(
                            title: Text(value.name!),
                          );
                        },
                        builder:
                            (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            style:
                            const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Add Item',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              disabledBorder:
                              OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10),
                            ),
                          );
                        },
                        onSelected: (value) {
                          controller.selectItem(value);
                          controller.quantityController.text =
                          '1';
                        },
                        suggestionsCallback: (search) {
                          return controller.salesItems
                              .where((item) => item.name!
                              .toLowerCase()
                              .contains(search
                              .trim()
                              .toLowerCase()))
                              .toList();
                        },
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 3,
              child: Padding(
                padding:
                const EdgeInsets.only(left: 5, right: 5, top: 8),
                child: Column(
                  children: [
                    const Text(
                      'Qty',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ShadowBox(
                        height: 35,
                        curveRadius: 5,
                        child: controller.selectedItem.value.id ==
                            null
                            ? Container()
                            : TextField(
                            controller:
                            controller.quantityController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10),
                            ))),
                  ],
                ),
              )),
          const Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, left: 5, right: 5),
                child: Column(
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ShadowBox(
                      height: 35,
                      curveRadius: 5,
                    ),
                  ],
                ),
              )),
          Padding(
            padding:
            const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: SolidButton(
              onTap: () {
                if (controller.selectedItem.value.id != null) {
                  if (controller.addedItems.any((element) =>
                  element.id ==
                      controller.selectedItem.value.id)) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Item Exists'),
                        content: const Text(
                            'Item Already exist in the list. You want to change its quantity?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                controller.clearSelectedItem();
                                Navigator.pop(context);
                              },
                              child: const Text('No')),
                          TextButton(
                              onPressed: () {
                                final item = controller.addedItems
                                    .firstWhere((item) =>
                                item.id ==
                                    controller
                                        .selectedItem.value.id);
                                controller.setItemQuantity(
                                    item: item,
                                    quantity: int.parse(controller
                                        .quantityController.text));
                                controller.clearSelectedItem();
                                Navigator.pop(context);
                              },
                              child: const Text('Yes')),
                        ],
                      ),
                    );
                  } else {
                    controller.addItem(controller.selectedItem.value);
                    controller.itemController.clear();
                    controller.focusNode.unfocus();
                  }
                }
              },
              height: 40,
              width: 50,
              curveRadius: 8,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      );
    });
  }
}
