import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/components/custom_menu.dart';
import 'package:ozone_erp/screens/itemwisereport/controller/item_wise_report_controller.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';

class ItemWiseReportScreen extends StatelessWidget {
  const ItemWiseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Item Wise Sales Report'),
      drawer: const CustomMenu(),
      body: const ItemWiseReportView(),
    );
  }
}

class ItemWiseReportView extends GetView<ItemWiseReportController> {
  const ItemWiseReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        body: Column(
          children: [
            // CustomSearchBar(controller: controller.searchController),
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() {
                      int rowIndex = 1;
                      return DataTable(
                        columns: [
                          DataColumn(label: Text('No.')),
                          DataColumn(label: Text('Invoice NO.')),
                          DataColumn(label: Text('Invoice Date.')),
                          DataColumn(label: Text('Customer Name.')),
                          DataColumn(label: Text('Item Name.')),
                          DataColumn(label: Text('Item Qty.')),
                          DataColumn(label: Text('Unit Rate.')),
                          DataColumn(label: Text('Total Price.')),
                        ],
                        rows: controller.salesBody.expand(
                          (body) {
                            return body.salesitems!.map(
                              (salesItem) {
                                final items = controller.items
                                    .where((element) =>
                                        element.id == salesItem.itemId)
                                    .toList();
                                final item =
                                    items.isNotEmpty ? items.first : null;
                                return DataRow(
                                    color: rowIndex % 2 == 0
                                        ? WidgetStateProperty.all(
                                            Colors.blue.shade100)
                                        : WidgetStateProperty.all(
                                            Colors.grey.shade100),
                                    cells: [
                                      DataCell(Text((rowIndex++).toString())),
                                      DataCell(Text(body.invoice ?? '')),
                                      DataCell(Text(body.invoiceDate ?? '')),
                                      DataCell(Text(body.cusname ?? '')),
                                      DataCell(Container(
                                          width: SizeConstant.screenWidth / 2,
                                          child: Text(item?.name ?? ''))),
                                      DataCell(Text(salesItem.quantity ?? '')),
                                      DataCell(Text(salesItem.rate.toString())),
                                      DataCell(Text(Utils()
                                          .roundWithFixedDecimal((salesItem
                                                      .rate ??
                                                  0) *
                                              num.parse(
                                                  salesItem.quantity ?? '0')))),
                                    ]);
                              },
                            );
                          },
                        ).toList(),
                      );
                    })),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
