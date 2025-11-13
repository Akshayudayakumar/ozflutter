import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/bottom_sheet.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';
import 'package:ozone_erp/services/filter_services.dart';

import '../../../constants/constant.dart';
import '../../newsale/widget/filter_widget.dart';

class OrdersFilterTypes extends StatelessWidget {
  const OrdersFilterTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GetBuilder<NewOrderController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FilterWidget(
                    onTap: () {
                      showFilterBottomSheet(ListView(shrinkWrap: true, children: [
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            child: const Text(
                              "Low to high",
                              style: TextStyle(
                                  color: AppStyle.radioColor, fontSize: 16),
                            )),
                        ...controller.sortList.map(
                              (e) {
                            return ListTile(
                                leading: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: e['icon'],
                                ),
                                title: Text(e['label']),
                                onTap: () {
                                  controller.sortValue.value = FilterServices()
                                      .sortItems(
                                      items: controller.searchItems,
                                      value: e['value']);
                                  controller.filterValue('');
                                  controller.update();
                                  Get.back();
                                });
                          },
                        ),
                        const Divider(),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            child: const Text(
                              "High to Low",
                              style: TextStyle(
                                  color: AppStyle.radioColor, fontSize: 16),
                            )),
                        ...controller.reverseSortList.map(
                              (e) {
                            return ListTile(
                                leading: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: e['icon'],
                                ),
                                title: Text(e['label']),
                                onTap: () {
                                  controller.sortValue.value = FilterServices()
                                      .reverseSortItems(
                                      items: controller.searchItems,
                                      value: e['value']);
                                  controller.filterValue('');
                                  controller.update();
                                  Get.back();
                                });
                          },
                        )
                      ]));
                      // controller.updateFilterSelection(0);
                    },
                    color: controller.filterIndex.contains(0)
                        ? AppStyle.primaryColor
                        : null,
                    child: const Text('Sort by'),
                  ),
                ),
                FilterWidget(
                  onTap: () {
                    showFilterBottomSheet(ListView(children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          'Filter by Category',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListTile(
                        title: const Text('All'),
                        onTap: () {
                          controller.searchItems = controller.salesItems;
                          controller.sortValue('');
                          controller.filterValue('');
                          controller.update();
                          Get.back();
                        },
                      ),
                      ...controller.categories.map(
                            (e) {
                          return ListTile(
                            title: Text(e.name!),
                            onTap: () {
                              controller.searchItems = FilterServices()
                                  .filterByCategory(
                                  items: controller.salesItems,
                                  value: e.id!);
                              controller
                                  .filterValue('Filter: Category (${e.name!})');
                              controller.sortValue('');
                              controller.update();
                              Get.back();
                            },
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          'Filter by Brand',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ...controller.brands.map(
                            (e) {
                          return ListTile(
                            title: Text(e == '0' ? 'All' : e),
                            onTap: () {
                              controller.searchItems = FilterServices()
                                  .filterByBrand(
                                  items: controller.salesItems, value: e);
                              controller.filterValue(
                                  'Filter: Brand (${e == '0' ? 'All' : e})');
                              controller.sortValue('');
                              controller.update();
                              Get.back();
                            },
                          );
                        },
                      )
                    ]));
                    // controller.updateFilterSelection(1);
                  },
                  color: controller.filterIndex.contains(1)
                      ? AppStyle.primaryColor
                      : null,
                  child: const Text('Filter'),
                ),
              ],
            );
          },
        ));
  }
}
