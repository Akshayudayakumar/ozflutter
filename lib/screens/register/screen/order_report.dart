import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/screens/register/controller/register_controller.dart';
import 'package:ozone_erp/screens/register/widgets/export_widgets.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';

import '../../../constants/constant.dart';
import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../../models/general_details.dart';
import '../../sync/controller/sync_controller.dart';

class OrderReport extends GetView<RegisterController> {
  const OrderReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.put(SyncController()).saveSync(SyncTypes.order);
        },
        child: GetBuilder<RegisterController>(builder: (controller) {
          return controller.orderItems.isEmpty && controller.salesOrders.isEmpty
              ? const Center(
                  child: Text('No Records Available'),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RegisterDateSelector(),
                      ListView.builder(
                        itemCount: controller.filteredOrderItems.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, outerIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SalesReportExpandableList(
                              title:
                                  "Invoice: ${controller.filteredOrderItems[outerIndex].invoice ?? "Nil"} - ${Currency.getById(AppData().getSettings().currency).symbol} ${Utils().roundWithFixedDecimal(num.parse(controller.filteredOrderItems[outerIndex].total ?? '0'))}",
                              extendedChild: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: SizeConstant.screenHeight * .01,
                                ),
                                itemCount: controller
                                        .filteredOrderItems[outerIndex]
                                        .salesitems
                                        ?.length ??
                                    0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, innerIndex) {
                                  final items = controller.allItems
                                      .where(
                                        (element) =>
                                            element.id ==
                                            controller
                                                .filteredOrderItems[outerIndex]
                                                .salesitems![innerIndex]
                                                .itemId,
                                      )
                                      .toList();
                                  Items? item =
                                      items.isNotEmpty ? items.first : null;
                                  return ListTile(
                                    title: Text(
                                        "ID: ${controller.filteredOrderItems[outerIndex].salesitems![innerIndex].itemId ?? 'Nil'}"),
                                    subtitle: Text(
                                      "Name: ${item?.name ?? 'Unavailable'}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                        "${Currency.getById(AppData().getSettings().currency).symbol} ${controller.filteredOrderItems[outerIndex].salesitems![innerIndex].total ?? 'Nil'}"),
                                  );
                                },
                              ),
                              expandedHeight: 70.0 *
                                  (controller.filteredOrderItems[outerIndex]
                                          .salesitems?.length ??
                                      0),
                              salesBody:
                                  controller.filteredOrderItems[outerIndex],
                            ),
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextWidget(
                          'Assigned Orders',
                          style: FontConstant.interLargeBold,
                        ),
                      ),
                      ListView.builder(
                        itemCount: controller.salesOrders.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, outerIndex) {
                          final order = controller.salesOrders[outerIndex];
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SalesReportExpandableList(
                              showEdit: false,
                              title:
                                  "Invoice: ${order.invoice ?? "Nil"} - ${Currency.getById(AppData().getSettings().currency).symbol} ${Utils().roundWithFixedDecimal(num.parse(order.total ?? '0'))}",
                              extendedChild: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: SizeConstant.screenHeight * .01,
                                ),
                                itemCount: controller.salesOrders[outerIndex]
                                        .salesItems?.length ??
                                    0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, innerIndex) {
                                  final items = controller.allItems
                                      .where(
                                        (element) =>
                                            element.id ==
                                            controller
                                                .salesOrders[outerIndex]
                                                .salesItems?[innerIndex]
                                                .salItmsId,
                                      )
                                      .toList();
                                  Items? item =
                                      items.isNotEmpty ? items.first : null;
                                  final salesItem = controller
                                      .salesOrders[outerIndex]
                                      .salesItems?[innerIndex];
                                  return ListTile(
                                    title: Text(
                                        "ID: ${salesItem?.itemId ?? 'Nil'}"),
                                    subtitle: Text(
                                      "Name: ${item?.name ?? 'Unavailable'}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                        "${Currency.getById(AppData().getSettings().currency).symbol} ${salesItem?.total ?? 'Nil'}"),
                                  );
                                },
                              ),
                              expandedHeight: 70.0 *
                                  (controller.salesOrders[outerIndex].salesItems
                                          ?.length ??
                                      0),
                              salesBody: SalesBody.fromOrder(
                                  controller.salesOrders[outerIndex]),
                            ),
                          );
                        },
                      ),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   padding: EdgeInsets.only(
                      //       bottom: SizeConstant.percentToHeight(10)),
                      //   itemBuilder: (context, index) {
                      //     final order = controller.salesOrders[index];
                      //     return Padding(
                      //       padding: const EdgeInsets.all(18.0),
                      //       child: SalesOrdersExpandableList(
                      //           title:
                      //               'Invoice: ${order.invoice ?? "Nil"} - ${Currency.getById(AppData().getSettings().currency).symbol} ${Utils().roundWithFixedDecimal(num.parse(order.total ?? '0'))}',
                      //           salesBody: order),
                      //     );
                      //   },
                      //   itemCount: controller.salesOrders.length,
                      // )
                      SizedBox(
                        height: SizeConstant.percentToHeight(10),
                      )
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
