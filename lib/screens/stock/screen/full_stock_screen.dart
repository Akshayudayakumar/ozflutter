import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/components/custom_menu.dart';
import 'package:ozone_erp/screens/stock/controller/full_stock_controller.dart';
import 'package:ozone_erp/screens/sync/controller/sync_controller.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';

import '../../../constants/constant.dart';
import '../widgets/export_widgets.dart';

class FullStockScreen extends StatelessWidget {
  const FullStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The Scaffold widget provides the basic structure for a visual interface.
    // It includes common elements like an AppBar, Drawer, and Body.
    return Scaffold(
      // The customAppBar widget is used to display the app bar.
      // It takes a title and functions for refresh and sync actions.
      appBar: customAppBar(
          title: 'Stocks',
          // The refresh function is called when the refresh button in the app bar is pressed.
          // It finds the FullStockController and calls its getProducts and getSales methods
          // to refresh the product and sales data.
          refresh: () async {
            final controller = Get.find<FullStockController>();
            await controller.getProducts();
            await controller.getSales();
          },
          // The sync function is called when the sync button in the app bar is pressed.
          // It initiates a sync operation for item stock and then refreshes the product and sales data.
          sync: () async {
            Get.put(SyncController()).saveSync(SyncTypes.itemStock);
            final controller = Get.find<FullStockController>();
            await controller.getProducts();
            await controller.getSales();
          }),
      drawer: const CustomMenu(),
      // The body of the Scaffold is set to the FullStockView widget.
      // This widget is responsible for displaying the main content of the screen.
      body: const FullStockView(),
    );
  }
}

class FullStockView extends GetView<FullStockController> {
  const FullStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.getProducts();
            await controller.getSales();
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
              controller: controller.inventoryController,
              child: GetBuilder(
                builder: (FullStockController controller) {
                  return Column(
                    children: [
                      CustomSearchBar(
                        controller: controller.searchController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            controller.filteredProducts = controller.products;
                            controller.update();
                            return;
                          }
                          controller.filteredProducts = controller.products
                              .where((element) =>
                                  (element.name?.contains(controller
                                          .searchController.text
                                          .trim()) ??
                                      false) ||
                                  element.id!.contains(
                                      controller.searchController.text.trim()))
                              .toList();
                          controller.update();
                        },
                      ),
                      if (controller.searchController.text.isEmpty)
                        const TotalAssetValue(),
                      if (controller.searchController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.setIndex(0);
                                },
                                child: AnimatedSwitcher(
                                  duration: 300.ms,
                                  transitionBuilder: (child, animation) =>
                                      FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                  child: controller.index == 0
                                      ? StylishContainer(
                                          key: const ValueKey('1'),
                                          text: 'Inventory',
                                        )
                                      : AnimatedDefaultTextStyle(
                                          key: const ValueKey('2'),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: const Text(
                                            'Inventory',
                                          )),
                                ),
                              ),
                              SizedBox(
                                width: SizeConstant.screenWidth * .1,
                              ),
                              InkWell(
                                onTap: () {
                                  controller.setIndex(1);
                                },
                                child: AnimatedSwitcher(
                                  duration: 300.ms,
                                  transitionBuilder: (child, animation) =>
                                      FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                  child: controller.index == 1
                                      ? StylishContainer(
                                          key: const ValueKey('1'),
                                          text: 'Orders',
                                        )
                                      : AnimatedDefaultTextStyle(
                                          key: const ValueKey('2'),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: const Text(
                                            'Orders',
                                          )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (controller.searchController.text.isEmpty)
                        const Divider(),
                      if (controller.searchController.text.isEmpty)
                        PageTransitionSwitcher(
                          reverse: controller.index == 0,
                          transitionBuilder:
                              (child, primaryAnimation, secondaryAnimation) =>
                                  SharedAxisTransition(
                            animation: primaryAnimation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.horizontal,
                            child: child,
                          ),
                          child: controller.index == 0
                              ? const Inventory()
                              : const Stocks(),
                        ),
                      if (controller.searchController.text.isNotEmpty)
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MobileInventory(
                                product: controller.filteredProducts[index],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: controller.filteredProducts.length)
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
