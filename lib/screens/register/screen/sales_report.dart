import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/screens/register/controller/register_controller.dart';
import 'package:ozone_erp/screens/register/widgets/export_widgets.dart';
import 'package:ozone_erp/utils/utils.dart';

import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../sync/controller/sync_controller.dart';

class SalesReport extends GetView<RegisterController> {
  const SalesReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.put(SyncController()).saveSync(SyncTypes.sale);
        },
        child: GetBuilder<RegisterController>(builder: (controller) {
          return controller.salesItems.isEmpty
              ? const Center(
                  child: Text('No Records Available'),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      RegisterDateSelector(),
                      ListView.builder(
                        itemCount: controller.filteredSalesItems.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            bottom: SizeConstant.percentToHeight(10)),
                        itemBuilder: (context, outerIndex) {
                          return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: SalesReportExpandableList(
                                title:
                                    "Invoice: ${controller.filteredSalesItems[outerIndex].invoice ?? "Nil"} - ${Currency.getById(AppData().getSettings().currency).symbol} ${Utils().roundIfWhole(num.parse(controller.filteredSalesItems[outerIndex].total ?? '0'))}",
                                extendedChild: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: SizeConstant.screenHeight * .01,
                                  ),
                                  itemCount: controller
                                          .filteredSalesItems[outerIndex]
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
                                                  .filteredSalesItems[
                                                      outerIndex]
                                                  .salesitems?[innerIndex]
                                                  .itemId,
                                        )
                                        .toList();
                                    Items? item =
                                        items.isNotEmpty ? items.first : null;
                                    return ListTile(
                                      title: Text(
                                          "ID: ${controller.filteredSalesItems[outerIndex].salesitems?[innerIndex].itemId ?? 'Nil'}"),
                                      subtitle: Text(
                                        "Name: ${item?.name ?? 'Unavailable'}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Text(
                                          "${Currency.getById(AppData().getSettings().currency).symbol} ${controller.filteredSalesItems[outerIndex].salesitems?[innerIndex].total ?? 'Nil'}"),
                                    );
                                  },
                                ),
                                expandedHeight: 70.0 *
                                    (controller.filteredSalesItems[outerIndex]
                                            .salesitems?.length ??
                                        0),
                                salesBody:
                                    controller.filteredSalesItems[outerIndex],
                              ));
                        },
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
