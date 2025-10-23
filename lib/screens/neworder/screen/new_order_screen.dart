import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/sync/controller/sync_controller.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';

import '../../../components/export_components.dart';
import '../../../constants/constant.dart';
import '../controller/new_order_controller.dart';
import '../widgets/export_order_widgets.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Sales Order',
        whiteIcon: true,
        sync: () async {
          await Get.put(SyncController()).saveSync(SyncTypes.order);
          final controller = Get.find<NewOrderController>();
          await controller.getItems();
          await controller.getUnits();
          await controller.getCategories();
        },
        refresh: () async {
          final controller = Get.find<NewOrderController>();
          await controller.getItems();
          await controller.getUnits();
          await controller.getCategories();
        },
      ),
      drawer: const CustomMenu(),
      body: GetBuilder<NewOrderController>(
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
                    ? const NewOrderView()
                    : const OrderItemsView(),
              ),
              Obx(
                () {
                  return controller.ordering.value.isEmpty
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
                                  Text(controller.ordering.value),
                                ],
                              )),
                        );
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar:
          GetBuilder<NewOrderController>(builder: (controller) {
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
            selectedItemColor: AppStyle.primaryColor,
            currentIndex: controller.screenIndex,
            onTap: (value) {
              controller.updateScreenIndex(value);
            });
      }),
    );
  }
}

class NewOrderView extends GetView<NewOrderController> {
  const NewOrderView({super.key});

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
                  const OrderInvoiceRow(),
                  const OrderCustomerSelectorRow(),
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: OrdersSearchBar(),
                  ),
                  const OrdersFilterTypes(),
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
                  const Expanded(child: FilterOrdersList()),
                  SizedBox(
                    height: SizeConstant.screenHeight * .04,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderItemsView extends GetView<NewOrderController> {
  const OrderItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.addedItems.isEmpty
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
                children: [
                  const OrderInvoiceRow(),
                  SizedBox(
                    height: SizeConstant.screenHeight * .01,
                  ),
                  const OrderCustomerSelectorRow(),
                  const Divider(
                    color: Colors.black,
                    thickness: .3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Expanded(child: OrderItemsList()),
                  SizedBox(
                    height: SizeConstant.screenHeight * .01,
                  ),
                  const OrderButtonsRow(),
                  SizedBox(
                    height: SizeConstant.screenHeight * .04,
                  )
                ],
              ),
            ),
    );
  }
}
