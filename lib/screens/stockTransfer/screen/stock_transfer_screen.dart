import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/components/custom_menu.dart';
import 'package:ozone_erp/screens/stockTransfer/controller/stock_transfer_controller.dart';
import 'package:ozone_erp/screens/stockTransfer/widgets/export_widgets.dart';
import 'package:ozone_erp/services/pdf_services.dart';
import 'package:ozone_erp/widgets/action_widget.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';
import 'package:ozone_erp/widgets/show_pdf.dart';
import '../../../constants/constant.dart';

class StockTransferScreen extends StatelessWidget {
  const StockTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The top app bar of the screen.
      appBar: customAppBar(
          // Displays the title 'Stock List'.
          title: 'Stock List',
          // Sets the app bar icons (like the back arrow) to white.
          whiteIcon: true,
          // Defines the action for the refresh button. It finds the
          // StockTransferController and calls its `getItems` method to reload data.
          refresh: () async {
            final controller = Get.find<StockTransferController>();
            await controller.getItems();
          },
          // Defines the action for the sync button. It calls the controller's
          // `updateStock` method, likely to synchronize local data with a server.
          sync: () async {
            final controller = Get.find<StockTransferController>();
            await controller.updateStock();
          }),
      // A standard navigation drawer.
      drawer: const CustomMenu(),
      // The main content of the screen, managed by a GetBuilder.
      // This builder listens for changes in StockTransferController and rebuilds
      // the body when the controller's state is updated.
      body: GetBuilder<StockTransferController>(
        builder: (controller) {
          // PageTransitionSwitcher animates the transition between two screens (views).
          // It uses a SharedAxisTransition for a horizontal slide effect.
          // The direction of the animation is determined by the screen index.
          return PageTransitionSwitcher(
            reverse: controller.screenIndex == 0,
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
            // This ternary operator decides which view to display based on the
            // `screenIndex` from the controller.
            // If index is 0, it shows the list of all stock items (StockTransferView).
            // If index is 1, it shows the items added to the cart (StocksView).
            child: controller.screenIndex == 0
                ? const StockTransferView()
                : const StocksView(),
          );
        },
      ),
      // A floating action button for printing.
      floatingActionButton: ActionWidget(
        color: AppStyle.radioColor,
        // When tapped, it generates a PDF of the stock list using PdfServices
        // and navigates to a new screen (ShowPdf) to display it.
        onTap: () async {
          final pdf = await PdfServices().generateStockPdf();
          Get.to(() => ShowPdf(
                title: 'Stock.pdf',
                pdf: pdf,
              ));
        },
        icon: Icons.print,
        iconSize: 24,
      ),
      // The following `bottomNavigationBar` is commented out.
      // It was likely intended to allow users to switch between the 'Items' list
      // (StockTransferView) and the 'Cart' (StocksView). This functionality is now
      // handled by the `PageTransitionSwitcher` in the body, which switches
      // views based on `controller.screenIndex` without a visible navigation bar.
      //
      // bottomNavigationBar:
      //     // `GetBuilder` rebuilds the navigation bar when the controller's state changes.
      //     GetBuilder<StockTransferController>(builder: (controller) {
      //   return BottomNavigationBar(
      //       // Defines the items (tabs) for the navigation bar.
      //       items: [
      //         // First Item: 'Items' (for the stock list)
      //         BottomNavigationBarItem(
      //             icon: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: SizedBox(
      //                 height: 25,
      //                 width: 25,
      //                 // The icon's color changes based on whether this tab is selected.
      //                 child: Image.asset(
      //                   AssetConstant.product,
      //                   color: controller.screenIndex == 0
      //                       ? AppStyle.primaryColor // Selected color
      //                       : Colors.black38,       // Unselected color
      //                 ),
      //               ),
      //             ),
      //             label: 'Items'),
      //
      //         // Second Item: 'Cart' (for the items to be transferred)
      //         BottomNavigationBarItem(
      //             icon: Stack( // Stack is used to overlay a badge on the icon.
      //               alignment: Alignment.topRight,
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: SizedBox(
      //                     height: 25,
      //                     width: 25,
      //                     // The icon's color changes based on selection.
      //                     child: Image.asset(
      //                       AssetConstant.transfer,
      //                       color: controller.screenIndex == 1
      //                           ? AppStyle.primaryColor // Selected color
      //                           : Colors.black38,       // Unselected color
      //                     ),
      //                   ),
      //                 ),
      //                 // This condition shows a badge if there are items in the cart.
      //                 if (controller.addedItems.isNotEmpty)
      //                   CircleAvatar(
      //                     backgroundColor: Colors.red,
      //                     radius: 10,
      //                     // The badge displays the number of items in the cart.
      //                     child: Text(
      //                       controller.addedItems.length.toString(),
      //                       style: const TextStyle(
      //                           color: Colors.white, fontSize: 14),
      //                     ),
      //                   )
      //               ],
      //             ),
      //             label: 'Cart'),
      //       ],
      //       // Sets the color for the selected item's label and icon.
      //       selectedItemColor: AppStyle.primaryColor,
      //       // `currentIndex` determines which tab is currently active.
      //       currentIndex: controller.screenIndex,
      //       // `onTap` is called when a user taps a navigation bar item.
      //       onTap: (value) {
      //         // It calls a method in the controller to update the screen index,
      //         // which triggers the `PageTransitionSwitcher` to change the view.
      //         controller.updateScreenIndex(value);
      //       });
      // }),
    );
  }
}

class StockTransferView extends GetView<StockTransferController> {
  const StockTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.getItems();
            await Future.delayed(const Duration(seconds: 1));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConstant.screenHeight * .01,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: StockSearchBar(),
              ),
              const StockFilterTypes(),
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
                                  color: AppStyle.primaryColor),
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
              const Expanded(child: FilterStockList()),
              SizedBox(
                height: SizeConstant.screenHeight * .04,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StocksView extends GetView<StockTransferController> {
  const StocksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body of the StocksView is determined by a conditional (ternary) operator.
      // It checks if the `addedItems` list in the `StockTransferController` is empty.
      body: controller.addedItems.isEmpty
          // If `addedItems` is empty, it displays a `Center` widget with a message.
          ? const Center(
              child: Text('Please add some items to cart'),
            )
          // If `addedItems` is not empty, it displays a `Column` containing the cart contents.
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The `Expanded` widget takes up all available vertical space.
                // It contains `CartStockList`, which is a custom widget responsible for
                // displaying the list of items that have been added to the cart for transfer.
                const Expanded(child: CartStockList()),
                // `GetBuilder` listens for changes in the `StockTransferController`.
                // It rebuilds its `builder` function's contents whenever the controller updates.
                // This is useful for conditionally showing/hiding UI elements.
                GetBuilder<StockTransferController>(
                  builder: (controller) {
                    // This inner condition checks again if the cart is not empty.
                    // While it seems redundant given the outer check, it ensures the button
                    // only appears if there are items, providing an extra layer of safety
                    // within the scope of this specific `GetBuilder`.
                    return controller.addedItems.isNotEmpty
                        // If there are items, it shows the `AddStockButton` widget,
                        // which likely handles the final submission of the stock transfer.
                        ? const AddStockButton()
                        // If the cart is empty (an unlikely state here, but handled for completeness),
                        // it renders an empty `SizedBox`, effectively showing nothing.
                        : const SizedBox();
                  },
                ),
              ],
            ),
    );
  }
}
