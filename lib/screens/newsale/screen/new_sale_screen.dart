import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import 'package:ozone_erp/screens/newsale/widget/item_filter_types.dart';
import 'package:ozone_erp/screens/sync/controller/sync_controller.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';

import '../../../components/export_components.dart';
import '../../../constants/constant.dart';
import '../widget/export_sales_widgets.dart';

class NewSaleScreen extends StatelessWidget {
  const NewSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Sales Bill',
        sync: () async {
          await Get.put(SyncController()).saveSync('sale');
          final controller = Get.find<NewSaleController>();
          await controller.getItems();
          await controller.getUnits();
          await controller.getCategories();
        },
        refresh: () async {
          final controller = Get.find<NewSaleController>();
          await controller.getItems();
          await controller.getUnits();
          await controller.getCategories();
        },
      ),
      drawer: const CustomMenu(),
      body: GetBuilder<NewSaleController>(
        builder: (controller) {
          return Stack(
            children: [
              PageTransitionSwitcher(
                reverse: controller.screenIndex == 0,
                transitionBuilder:
                    (child, primaryAnimation, secondaryAnimation) {
                  return SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                child: controller.screenIndex == 0
                    ? const NewSaleView()
                    : const ItemsView(),
              ),
              Obx(
                    () {
                  return controller.selling.value.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                    height: SizeConstant.screenHeight,
                    width: SizeConstant.screenWidth,
                    color: Colors.black38,
                    alignment: Alignment.center,
                    child: Container(
                        height: SizeConstant.screenHeight * .1,
                        width: SizeConstant.screenWidth * .8,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(controller.selling.value),
                          ],
                        )),
                  );
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: GetBuilder<NewSaleController>(builder: (controller) {
        return BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: Image.asset(
                        AssetConstant.product,
                        color: controller.screenIndex == 0
                            ? AppStyle.primaryColor
                            : Colors.black38,
                      ),
                    ),
                  ),
                  label: 'Items'),
              BottomNavigationBarItem(
                  icon: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(CupertinoIcons.cart),
                      ),
                      if (controller.addedItems.isNotEmpty)
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                          child: Text(
                            controller.addedItems.length.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        )
                    ],
                  ),
                  label: 'Cart'),
            ],
            currentIndex: controller.screenIndex,
            selectedItemColor: AppStyle.primaryColor,
            onTap: (value) {
              controller.updateScreenIndex(value);
            });
      }),
    );
  }
}

class NewSaleView extends GetView<NewSaleController> {
  const NewSaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !controller.focusNode.hasFocus,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        controller.focusNode.unfocus();
      },
      child: PopBlocker(
        canPop: controller.bodyJson != null,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await controller.getItems();
                await controller.getUnits();
                await controller.getCategories();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConstant.screenHeight * .01,
                  ),
                  const InvoiceRow(),
                  const CustomerSelectorRow(),
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: ItemsSearchBar(),
                  ),
                  const ItemFilterTypes(),
                  Obx(
                        () {
                      return controller.sortValue.value.isEmpty
                          ? const SizedBox.shrink()
                          : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 12),
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: AppStyle.radioColor),
                            child: Text(
                              controller.sortValue.value,
                              style: const TextStyle(color: Colors.white),
                            )),
                      );
                    },
                  ),
                  Obx(
                        () {
                      return controller.filterValue.value.isEmpty
                          ? const SizedBox.shrink()
                          : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 12),
                        alignment: Alignment.centerRight,
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: AppStyle.radioColor),
                            child: Text(
                              controller.filterValue.value,
                              style: const TextStyle(color: Colors.white),
                            )),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Expanded(child: FilterItemsList()),
                  SizedBox(
                    height: SizeConstant.screenHeight * .04,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemsView extends GetView<NewSaleController> {
  const ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !controller.focusNode.hasFocus,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        controller.focusNode.unfocus();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Obx(
                () => controller.addedItems.isEmpty
                ? const Center(
              child: Text('Please add some items to cart'),
            )
                : RefreshIndicator(
              onRefresh: () async {
                await controller.getItems();
                await controller.getUnits();
                await controller.getCategories();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: SizeConstant.screenHeight * .01,
                children: [
                  const InvoiceRow(),
                  const CustomerSelectorRow(),
                  const Divider(
                    color: Colors.black,
                    thickness: .3,
                  ),
                  const Expanded(child: CartItemsList()),
                  const TotalDetails(),
                  const SalesButtonsRow(),
                  SizedBox(
                    height: SizeConstant.screenHeight * .02,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}