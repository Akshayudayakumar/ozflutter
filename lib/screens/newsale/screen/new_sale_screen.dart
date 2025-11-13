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
        title: 'SALES BILL',
        sync: () async {
          final syncController = Get.find<SyncController>();
          await syncController.saveSync(SyncTypes.sale);
          await Get.find<NewSaleController>().refreshAllData();
        },
        refresh: () => Get.find<NewSaleController>().refreshAllData(),
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
            selectedFontSize: 15,
            unselectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 25,width: 25,
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
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Badge(
                    label: Obx(() => Text(
                      controller.addedItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                    backgroundColor: Colors.red,
                    isLabelVisible: controller.addedItems.isNotEmpty,
                    child: const Icon(CupertinoIcons.cart, size: 22),
                  ),
                ),
                label: 'Cart',
              ),
            ],
            currentIndex: controller.screenIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppStyle.primaryColor,
            unselectedItemColor: Colors.black54,
            iconSize: 23,
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
    return PopBlocker(
      canPop: controller.bodyJson != null,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
          canPop: !controller.focusNode.hasFocus,
          onPopInvoked: (didPop) {
            if (didPop) return;
            controller.focusNode.unfocus();
          },
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: controller.refreshAllData,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConstant.screenHeight * 0.01,
                  ),
                  const InvoiceRow(),
                  const CustomerSelectorRow(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 18),
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
    return PopBlocker(
      canPop: controller.bodyJson != null,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
          canPop: !controller.focusNode.hasFocus,
          onPopInvoked: (didPop) {
            if (didPop) return
              controller.focusNode.unfocus();
          },
          child: Scaffold(
            body: Obx(
                  () => controller.addedItems.isEmpty
                  ? const Center(
                child: Text('Please add some items to cart'),
              )
                  : RefreshIndicator(
                onRefresh: controller.refreshAllData,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: SizeConstant.screenHeight * .01,
                  children: [
                    const InvoiceRow(),
                    const CustomerSelectorRow(),
                    const Divider(
                      color: Colors.black,
                      thickness: .2,
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
      ),
    );
  }
}