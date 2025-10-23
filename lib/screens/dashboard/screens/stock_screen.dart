import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';
import '../widgets/export_widgets.dart';

class StockScreen extends GetView<DashBoardController> {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          controller: controller.inventoryController,
        child: GetBuilder(builder: (DashBoardController controller) {
          return Column(
            children: [
              CustomSearchBar(
                controller: controller.searchController,
                onChanged: (value) {
                  controller.filteredProducts = controller.products
                      .where((element) =>
                  (element.name?.contains(
                      controller.searchController.text.trim()) ??
                      false) ||
                      element.id!
                          .contains(controller.searchController.text.trim()))
                      .toList();
                },
              ),
              if (controller.searchController.text.isEmpty) const TotalAssetValue(),
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
                              duration: const Duration(milliseconds: 300),
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
                              duration: const Duration(milliseconds: 300),
                              child: const Text(
                                'Orders',
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.searchController.text.isEmpty) const Divider(),
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
                  child: controller.index == 0 ? const Inventory() : const Stocks(),
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
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: controller.filteredProducts.length)
            ],
          );
        },)
      ),
    );
  }
}
