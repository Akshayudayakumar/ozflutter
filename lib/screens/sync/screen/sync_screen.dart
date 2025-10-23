import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/components/custom_menu.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/screens/sync/controller/sync_controller.dart';
import 'package:ozone_erp/screens/sync/widgets/export_widgets.dart';

import '../../../widgets/pop/pop_blocker.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Sync'),
      drawer: const CustomMenu(),
      body: SyncView(),
    );
  }
}

class SyncView extends GetView<SyncController> {
  const SyncView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConstant.screenWidth * .03),
          child: Center(
            child: SingleChildScrollView(
              child: GetBuilder(
                builder: (SyncController controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SyncRow(
                        title: 'Voucher Sync',
                        date: controller.syncDate[SyncTypes.voucher],
                        sync: () {
                          controller.saveSync(SyncTypes.voucher);
                        },
                        errorMessage: controller.errorMap[SyncTypes.voucher] ?? '',
                        rotating:
                            controller.syncingKeys.contains(SyncTypes.voucher),
                      ),
                      SyncRow(
                          title: 'Sale Sync',
                          date: controller.syncDate[SyncTypes.sale],
                          sync: () {
                            controller.saveSync(SyncTypes.sale);
                          },
                          errorMessage: controller.errorMap[SyncTypes.sale] ?? '',
                          rotating:
                              controller.syncingKeys.contains(SyncTypes.sale)),
                      SyncRow(
                          title: 'Order Sync',
                          date: controller.syncDate[SyncTypes.order],
                          sync: () {
                            controller.saveSync(SyncTypes.order);
                          },
                          errorMessage: controller.errorMap[SyncTypes.order] ?? '',
                          rotating:
                              controller.syncingKeys.contains(SyncTypes.order)),
                      SyncRow(
                          title: 'Sales Return Sync',
                          date: controller.syncDate[SyncTypes.salesReturn],
                          sync: () {
                            controller.saveSync(SyncTypes.salesReturn);
                          },
                          errorMessage:
                              controller.errorMap[SyncTypes.salesReturn] ?? '',
                          rotating: controller.syncingKeys
                              .contains(SyncTypes.salesReturn)),
                      SyncRow(
                          title: 'Item Stock Update',
                          date: controller.syncDate[SyncTypes.itemStock],
                          sync: () {
                            controller.saveSync(SyncTypes.itemStock);
                          },
                          errorMessage:
                              controller.errorMap[SyncTypes.itemStock] ?? '',
                          rotating: controller.syncingKeys
                              .contains(SyncTypes.itemStock)),
                      SyncRow(
                          title: 'Details Refresh',
                          date: controller.syncDate[SyncTypes.details],
                          sync: () {
                            controller.saveSync(SyncTypes.details);
                          },
                          errorMessage:
                              controller.errorMap[SyncTypes.details] ?? '',
                          rotating:
                              controller.syncingKeys.contains(SyncTypes.details)),
                      SyncRow(
                          title: 'Device Details',
                          date: controller.syncDate[SyncTypes.device],
                          sync: () {
                            controller.saveSync(SyncTypes.device);
                          },
                          errorMessage: controller.errorMap[SyncTypes.device] ?? '',
                          rotating:
                              controller.syncingKeys.contains(SyncTypes.device)),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
