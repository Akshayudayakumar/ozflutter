import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/neworder/widgets/loading_widget.dart';
import 'package:ozone_erp/screens/neworder/widgets/order_total_details.dart';
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
          title: 'SALES ORDER',
          whiteIcon: true,
          sync: () async{
            final syncController = Get.find<SyncController>();
            await syncController.saveSync(SyncTypes.order);
            await Get.find<NewOrderController>().refreshAllData();
          },
          refresh: () => Get.find<NewOrderController>().refreshAllData()
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
              Obx(() => LoadingWidget(
                  isLoading: controller.ordering.value.isNotEmpty,
                  message: controller.ordering.value)),
            ],
          );
        },
      ),
      bottomNavigationBar:
      GetBuilder<NewOrderController>(builder: (controller) {
        return BottomNavigationBar(
            selectedFontSize: 15,
            unselectedFontSize: 12,
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
                  icon: Badge(
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        left: 8.0,
                        right: 12.0, // To avoid badge overlapping the icon
                      ),
                      child:
                      const Icon(CupertinoIcons.cart, size: 22),
                    ),
                  ),
                  label: 'Cart'),
            ],
            selectedItemColor: AppStyle.primaryColor,
            currentIndex: controller.screenIndex,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.black54,
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
              onRefresh: controller.refreshAllData,
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
    return PopBlocker(
      canPop: controller.bodyJson != null,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: PopScope(
          canPop: !controller.focusNode.hasFocus,
          onPopInvoked: (didpop) {
            if (didpop) {
              return;
            }
            controller.focusNode.unfocus();
          },
          child: Scaffold(
            body: controller.addedItems.isEmpty
                ? const Center(
              child: const Text('Please add some items to cart'),):

            RefreshIndicator(
              onRefresh: controller.refreshAllData,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  OrderTotalDetails(),
                  const OrderButtonsRow(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
