import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';
import 'package:ozone_erp/screens/dashboard/widgets/export_widgets.dart';
import 'package:ozone_erp/screens/dashboard/widgets/sales_report_circle.dart';
import 'package:ozone_erp/screens/register/screen/detailed_report_screen.dart';
import 'package:ozone_erp/utils/format_comma.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/app_data.dart';
import '../../../models/currency.dart';
import '../../../models/sales_body.dart';
import '../../../widgets/export_widgets.dart';

class SalesDetailsScreen extends StatelessWidget {
  const SalesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (DashBoardController controller) {
        int salesLength = controller.sales.length;
        int salesOrderLength = controller.salesOrder.length;
        int salesReturnLength = controller.salesReturn.length;
        if (controller.allSales.isEmpty) {
          return Column(
            children: [
              SizedBox(
                height: SizeConstant.screenHeight * .02,
              ),
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: controller.showDateChanger.value
                      ? SizeConstant.percentToHeight(10)
                      : 0,
                  child: PickDate(),
                ),
              ),
              Expanded(
                child: Center(
                  child: TextWidget('No Transaction history'),
                ),
              ),
            ],
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.showDateChanger(true);
            controller.startDate.value = DateTime(2000);
            controller.endDate.value = DateTime.now();
            await controller.getProducts();
            await controller.getSales(true);
            await Future.delayed(const Duration(seconds: 2));
          },
          color: AppStyle.primaryColor,
          child: Scaffold(
            body: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: SizeConstant.screenHeight * .02,
                ),
                Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: controller.showDateChanger.value
                        ? SizeConstant.percentToHeight(10)
                        : 0,
                    child: PickDate(),
                  ),
                ),
                Obx(
                  () {
                    return SalesReportCircle(
                      colors: [
                        AppStyle.allColors[22],
                        AppStyle.primaryColor,
                        AppStyle.allColors[11]
                      ],
                      values: [
                        salesLength.toDouble(),
                        salesOrderLength.toDouble(),
                        salesReturnLength.toDouble(),
                      ],
                      height: SizeConstant.screenHeight * .4,
                      width: SizeConstant.screenWidth,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller
                                  .getSelectedType()
                                  .split('-')
                                  .join(' ')
                                  .capitalize!,
                              style: FontConstant.inter.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${Currency.getById(AppData().getSettings().currency).symbol} ${formatIndianDouble(controller.salesValue.value.round())}",
                              style: FontConstant.inter.copyWith(
                                fontSize: SizeConstant.screenWidth / 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: values(
                            color: AppStyle.allColors[22],
                            stock: calculatePercentage(
                                    salesLength, controller.allSales.length)
                                .round(),
                            type: SelectedType.sales,
                            title: 'Sales'),
                      ),
                      Expanded(
                        child: values(
                            color: AppStyle.primaryColor,
                            stock: calculatePercentage(salesOrderLength,
                                    controller.allSales.length)
                                .round(),
                            type: SelectedType.salesOrder,
                            title: 'Sales Order'),
                      ),
                      Expanded(
                        child: values(
                            color: AppStyle.allColors[11],
                            stock: calculatePercentage(salesReturnLength,
                                    controller.allSales.length)
                                .round(),
                            type: SelectedType.salesReturn,
                            title: 'Sales Return'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => values(
                              color: Colors.red,
                              stock: calculatePercentage(
                                      controller.collectedAmount.value.round(),
                                      controller.totalCollection.value.round())
                                  .round(),
                              title: 'Collection',
                              type: SelectedType.collection),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                const Divider(),
                Obx(() {
                  if (controller.selectedType.value ==
                      SelectedType.collection) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent ${controller.getSelectedType().split('-').join(' ').capitalize}",
                          style: FontConstant.inter.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RoutesName.register);
                          },
                          child: Text(
                            "View All",
                            style: FontConstant.inter.copyWith(
                                color: AppStyle.primaryColor, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Obx(
                  () {
                    if (controller.selectedType.value ==
                        SelectedType.collection) {
                      return const SizedBox();
                    }
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return salesRow(
                              salesBody:
                                  (controller.selectedType == SelectedType.sales
                                      ? controller.sales
                                      : controller.selectedType ==
                                              SelectedType.salesOrder
                                          ? controller.salesOrder
                                          : controller.salesReturn)[index]);
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount:
                            (controller.selectedType == SelectedType.sales
                                        ? controller.sales.length
                                        : controller.selectedType ==
                                                SelectedType.salesOrder
                                            ? controller.salesOrder.length
                                            : controller.salesReturn.length) >
                                    4
                                ? 4
                                : controller.selectedType == SelectedType.sales
                                    ? controller.sales.length
                                    : controller.selectedType ==
                                            SelectedType.salesOrder
                                        ? controller.salesOrder.length
                                        : controller.salesReturn.length);
                  },
                ),
                SizedBox(
                  height: SizeConstant.screenHeight * .2,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget values({
    required Color color,
    required int stock,
    required String title,
    SelectedType? type,
  }) {
    final controller = Get.find<DashBoardController>();
    bool selected = controller.selectedType.value == type;
    return InkWell(
      onTap: () {
        if (type != null) {
          controller.setSelectedType(type);
        }
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConstant.screenWidth * .02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title',
              style: TextStyle(
                  color: selected ? Colors.black : Colors.black54,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '$stock %',
              style: TextStyle(
                  fontWeight: selected ? FontWeight.w900 : FontWeight.bold,
                  fontSize: 22),
            ),
            const SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                Container(
                  height: 10,
                  width: SizeConstant.screenWidth / 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 10,
                  width: max(10, SizeConstant.screenWidth * (stock / 100) / 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  double calculatePercentage(int num, int total) {
    if (total == 0) {
      return 0;
    }
    return (num / total) * 100;
  }

  Widget salesRow({required SalesBody salesBody}) {
    return ListTile(
      leading: ActionWidget(
        color: AppStyle.primaryColor,
        child: Image.asset(
          AssetConstant.shopping,
          color: AppStyle.primaryColor,
        ),
        onTap: () async {
          try {
            if ((salesBody.latitude?.isNotEmpty ?? false) &&
                (salesBody.longitude?.isNotEmpty ?? false)) {
              final url = Uri.parse(
                  "https://www.google.com/maps/search/?api=1&query=${salesBody.latitude},${salesBody.longitude}");
              await launchUrl(url);
            }
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },
      ),
      title: Text(salesBody.cusname ?? 'Customer Name'),
      onTap: () => Get.to(() => DetailedReportScreen(salesBody: salesBody)),
      subtitle: Text(
          '${salesBody.salesitems?.length.toString() ?? 'No'} ${salesBody.salesitems?.length == 1 ? 'Item' : 'Items'}'),
    );
  }
}
