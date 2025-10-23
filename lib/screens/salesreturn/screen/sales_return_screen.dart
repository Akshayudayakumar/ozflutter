import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';
import 'package:ozone_erp/screens/salesreturn/widgets/return_search_bar.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';

import '../../../components/custom_app_bar.dart';
import '../../../components/custom_menu.dart';
import '../widgets/export_return_widgets.dart';

class SalesReturnScreen extends StatelessWidget {
  const SalesReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(title: 'Sales Return', whiteIcon: true),
      drawer: const CustomMenu(),
      body: GetBuilder<SalesReturnController>(
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
                    ? const SalesReturnView()
                    : const ReturnCartView(),
              ),
              Obx(
                () {
                  return controller.returning.value.isEmpty
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
                                  Text(controller.returning.value),
                                ],
                              )),
                        );
                },
              ),
            ],
          );
        },
      ),
      // bottomNavigationBar:
      //     GetBuilder<SalesReturnController>(builder: (controller) {
      //   return BottomNavigationBar(
      //       items: [
      //         BottomNavigationBarItem(
      //             icon: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: SizedBox(
      //                 height: 25,
      //                 width: 25,
      //                 child: Image.asset(
      //                   AssetConstant.product,
      //                   color: controller.screenIndex == 0
      //                       ? AppStyle.primaryColor
      //                       : Colors.black38,
      //                 ),
      //               ),
      //             ),
      //             label: 'Items'),
      //         BottomNavigationBarItem(
      //             icon: Stack(
      //               alignment: Alignment.topRight,
      //               children: [
      //                 const Padding(
      //                   padding: EdgeInsets.all(8.0),
      //                   child: Icon(CupertinoIcons.cart),
      //                 ),
      //                 if (controller.addedItems.isNotEmpty)
      //                   CircleAvatar(
      //                     backgroundColor: Colors.red,
      //                     radius: 10,
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
      //       currentIndex: controller.screenIndex,
      //       selectedItemColor: AppStyle.primaryColor,
      //       onTap: (value) {
      //         controller.screenIndex = value;
      //         controller.update();
      //       });
      // }),
    );
  }
}

class SalesReturnView extends GetView<SalesReturnController> {
  const SalesReturnView({super.key});

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
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReturnInvoiceRow(),
                    Obx(
                      () {
                        if (controller.firstTime.value) {
                          return const Text('    Type invoice here to filter');
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    SizedBox(
                      height: SizeConstant.screenHeight * .01,
                    ),
                    GetBuilder<SalesReturnController>(
                      builder: (controller) {
                        return controller.itemsToReturn.isEmpty
                            ? const SizedBox.shrink()
                            : const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: ReturnSearchBar(),
                              );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(child: Obx(
                      () {
                        return controller.emptyMessage.value.isEmpty
                            ? const ReturnItemsList()
                            : Center(
                                child: Text(
                                controller.emptyMessage.value,
                                textAlign: TextAlign.center,
                              ));
                      },
                    )),
                    GetBuilder<SalesReturnController>(
                      builder: (controller) {
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.only(
                                bottom: SizeConstant.screenHeight * .03),
                            alignment: Alignment.bottomCenter,
                            curve: Curves.easeInOut,
                            height: controller.itemsToReturn.isEmpty
                                ? 0
                                : SizeConstant.screenHeight * .1,
                            child: const ReturnButtonsRow());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReturnCartView extends GetView<SalesReturnController> {
  const ReturnCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.addedItems.isEmpty
          ? const Center(
              child: Text('Please add some items to cart'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: ReturnCartList()),
                GetBuilder<SalesReturnController>(
                  builder: (controller) {
                    return controller.addedItems.isNotEmpty
                        ? const ReturnButton()
                        : const SizedBox();
                  },
                ),
              ],
            ),
    );
  }
}
