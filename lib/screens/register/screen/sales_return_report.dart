import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/register/controller/register_controller.dart';
import 'package:ozone_erp/screens/register/widgets/export_widgets.dart';

import '../../../Constants/constant.dart';
import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../../models/general_details.dart';
import '../../../utils/utils.dart';
import '../../sync/controller/sync_controller.dart';

class SalesReturnReport extends GetView<RegisterController> {
  const SalesReturnReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.put(SyncController()).saveSync(SyncTypes.salesReturn);
        },
        child: GetBuilder<RegisterController>(builder: (controller) {
          return controller.salesReturnItems.isEmpty
              ? const Center(
                  child: Text('No Records Available'),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      RegisterDateSelector(),
                      ListView.builder(
                        itemCount: controller.filteredSalesReturnItems.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            bottom: SizeConstant.percentToHeight(10)),
                        itemBuilder: (context, outerIndex) {
                          return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: SalesReportExpandableList(
                                title:
                                    "Invoice: ${controller.filteredSalesReturnItems[outerIndex].invoice ?? "Nil"} - ${Currency.getById(AppData().getSettings().currency).symbol} ${Utils().roundIfWhole(num.parse(controller.filteredSalesReturnItems[outerIndex].total ?? '0'))}",
                                extendedChild: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: SizeConstant.screenHeight * .01,
                                  ),
                                  itemCount: controller
                                          .filteredSalesReturnItems[outerIndex]
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
                                                  .filteredSalesReturnItems[
                                                      outerIndex]
                                                  .salesitems?[innerIndex]
                                                  .itemId,
                                        )
                                        .toList();
                                    Items? item =
                                        items.isNotEmpty ? items.first : null;
                                    return ListTile(
                                      title: Text(
                                          "ID: ${controller.filteredSalesReturnItems[outerIndex].salesitems?[innerIndex].itemId ?? 'Nil'}"),
                                      subtitle: Text(
                                        "Name: ${item?.name ?? 'Unavailable'}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Text(
                                          "${Currency.getById(AppData().getSettings().currency).symbol} ${controller.filteredSalesReturnItems[outerIndex].salesitems?[innerIndex].total ?? 'Nil'}"),
                                    );
                                  },
                                ),
                                expandedHeight: 70.0 *
                                    (controller
                                            .filteredSalesReturnItems[
                                                outerIndex]
                                            .salesitems
                                            ?.length ??
                                        0),
                                salesBody: controller
                                    .filteredSalesReturnItems[outerIndex],
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
