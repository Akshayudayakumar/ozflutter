import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/models/sale_types.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/services/pdf_services.dart';
import 'package:ozone_erp/utils/common_calculations.dart';
import 'package:ozone_erp/widgets/action_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/app_data.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/device_details.dart';
import '../../../models/general_details.dart';
import '../../../models/sales_body.dart';
import '../../../utils/utils.dart';

class DetailedReportScreen extends StatefulWidget {
  final SalesBody salesBody;

  const DetailedReportScreen({super.key, required this.salesBody});

  @override
  State<DetailedReportScreen> createState() => _DetailedReportScreenState();
}

class _DetailedReportScreenState extends State<DetailedReportScreen> {
  late CompanySettings companySettings;
  late List<Items> allItems;
  late List<Unit> units;
  late List<Tax> taxes;
  late Customers customer;
  bool valuesInit = false;
  pw.Document? pdf;

  Future<void> getPdfData() async {
    companySettings = (await InsertCompanySettings().getCompanySettings())[0];
    allItems = await InsertItems().getItems();
    units = await InsertUnit().getUnits();
    taxes = await InsertTax().getTax();
    customer = await InsertCustomers()
        .getCustomerById(widget.salesBody.customerId ?? '');
    pdf = await PdfServices().generatePdfFromSalesBody(widget.salesBody);
    setState(() {
      valuesInit = true;
    });
  }

  Tax getTaxById(String? id) {
    return taxes.firstWhere((element) => element.gstid == id,
        orElse: () => Tax());
  }

  @override
  void initState() {
    getPdfData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(
          title: "Invoice No: ${widget.salesBody.invoice}", centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: !valuesInit
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Text(
                    companySettings.name ?? 'Unavailable',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(companySettings.address ?? 'Unavailable'),
                  Text('MOB: ${companySettings.phone ?? 'Unavailable'}'),
                  Text('GST No : ${companySettings.tin ?? 'Nil'}'),
                  SizedBox(height: 20),
                  Text(
                    widget.salesBody.type == 'sales'
                        ? 'TAX INVOICE'
                        : widget.salesBody.type == 'sales-order'
                            ? 'SALES ORDER'
                            : 'SALES RETURN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('To'),
                            Text('${widget.salesBody.cusname}'),
                            Text(
                                '${widget.salesBody.customerAddress} ${widget.salesBody.cusdetails}'),
                            Text(
                                'Phone : ${widget.salesBody.customerPhone ?? 'N/A'}'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('INV NO: ${widget.salesBody.invoice}'),
                            Text('Date : ${widget.salesBody.invoiceDate}'),
                            Text('Salesman : ${AppData().getUserName()}'),
                            Text('Prepared by : ${AppData().getUserName()}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Header Section without borders
                  Expanded(
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.grey.shade300,
                          ),
                          dataRowMaxHeight: 100,
                          columns: [
                            DataColumn(
                              label: Text('SNo',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('Item',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('HSN',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('Qty',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('Unit',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('MRP',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('Rate',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('DIS',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('AMT',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('GST',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text(r'SGST',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text(r'CGST',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: Text('Total',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                          rows: List.generate(
                              widget.salesBody.salesitems?.length ?? 0,
                              (index) {
                            final salesItem =
                                widget.salesBody.salesitems?[index];
                            final salesItems = allItems
                                .where((element) =>
                                    element.id == salesItem?.itemId)
                                .toList();
                            final item =
                                salesItems.isNotEmpty ? salesItems[0] : Items();
                            final unit = units.firstWhere(
                                (element) =>
                                    element.unitId == salesItem?.baseUnitId,
                                orElse: () => Unit());
                            return DataRow(
                              cells: [
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    // Padding around each cell
                                    child: Text((index + 1).toString()),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    width: SizeConstant.percentToWidth(40),
                                    child: Text(item.name ?? 'Item'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(item.hsncodename ?? 'HSN'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        Text('${salesItem?.quantity ?? '0'}'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(unit.name ?? 'Unit'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(item.mrp ?? '0'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                        salesItem?.rate?.toString() ?? '0'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(Utils().roundWithFixedDecimal(
                                        num.parse(salesItem?.discount ?? '0'))),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(Utils().roundWithFixedDecimal(
                                        double.parse(item.mrp ?? '0') *
                                            double.parse(
                                                salesItem?.quantity ?? '0'))),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        Text(getTaxById(item.taxId).gst ?? '0'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                        getTaxById(item.taxId).sgst ?? '0'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                        getTaxById(item.taxId).cgst ?? '0'),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(Utils().roundWithFixedDecimal(
                                        num.parse(
                                            widget.salesBody.total ?? '0'))),
                                  ),
                                ),
                              ],
                            );
                          }),
                          // columnWidths: {
                          //   0: const FlexColumnWidth(1),
                          //   1: const FlexColumnWidth(3),
                          //   2: const FlexColumnWidth(1),
                          //   3: const FlexColumnWidth(1),
                          //   4: const FlexColumnWidth(1),
                          //   5: const FlexColumnWidth(1),
                          //   6: const FlexColumnWidth(1),
                          //   7: const FlexColumnWidth(1),
                          //   8: const FlexColumnWidth(1),
                          //   9: const FlexColumnWidth(1),
                          //   10: const FlexColumnWidth(1),
                          //   11: const FlexColumnWidth(1),
                          //   12: const FlexColumnWidth(1),
                          // },
                          // children: [
                          //   TableRow(
                          //     decoration:
                          //         BoxDecoration(color: Colors.grey.shade300),
                          //     children: [
                          //       Text('SNo',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('Item',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('HSN',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('Qty',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('Unit',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('MRP',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('Rate',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('DIS',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('AMT',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('GST',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text(r'SGST',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text(r'CGST',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //       Text('Total',
                          //           style: TextStyle(fontWeight: FontWeight.bold),
                          //           textAlign: TextAlign.center),
                          //     ],
                          //   )
                          // ],
                        ),
                      ),
                    ),
                  ),
                  // Content Section with borders
                  // Table(
                  //   border: TableBorder.all(width: 0.5),
                  //   // Light border for cleaner look
                  //   columnWidths: {
                  //     0: const FlexColumnWidth(1),
                  //     1: const FlexColumnWidth(3),
                  //     2: const FlexColumnWidth(1),
                  //     3: const FlexColumnWidth(1),
                  //     4: const FlexColumnWidth(1),
                  //     5: const FlexColumnWidth(1),
                  //     6: const FlexColumnWidth(1),
                  //     7: const FlexColumnWidth(1),
                  //     8: const FlexColumnWidth(1),
                  //     9: const FlexColumnWidth(1),
                  //     10: const FlexColumnWidth(1),
                  //     11: const FlexColumnWidth(1),
                  //     12: const FlexColumnWidth(1),
                  //   },
                  //   children: List.generate(
                  //       widget.salesBody.salesitems?.length ?? 0, (index) {
                  //     final salesItem = widget.salesBody.salesitems?[index];
                  //     final salesItems = allItems
                  //         .where((element) => element.id == salesItem?.itemId)
                  //         .toList();
                  //     final item =
                  //         salesItems.isNotEmpty ? salesItems[0] : Items();
                  //     final itemUnits = units
                  //         .where((element) => element.unitId == item.unitId)
                  //         .toList();
                  //     final unit = itemUnits.isNotEmpty ? itemUnits[0] : Unit();
                  //     return TableRow(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           // Padding around each cell
                  //           child: Text((index + 1).toString()),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text(item.name ?? 'Item'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text(item.hsncode ?? 'HSN'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text('${salesItem?.quantity ?? '0'}'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text(unit.name ?? 'Unit'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text(item.mrp ?? '0'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text(salesItem?.rate?.toString() ?? '0'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text((double.parse(item.mrp ?? '0') -
                  //                   (salesItem?.rate ?? 0))
                  //               .toString()),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text(Utils().roundWithFixedDecimal(
                  //               double.parse(item.mrp ?? '0') *
                  //                   double.parse(salesItem?.quantity ?? '0'))),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text(customer.gst ?? '0'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text('448.10'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text('448.10'),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4),
                  //           child: Text(widget.salesBody.total ?? ''),
                  //         ),
                  //       ],
                  //     );
                  //   }),
                  // ),
                  // SizedBox(height: 20),
                  // SizedBox(height: 20),
                  // // Footer Section without borders
                  SizedBox(
                    height: SizeConstant.percentToHeight(2),
                  ),
                  Table(
                    columnWidths: {
                      0: const FlexColumnWidth(1),
                      1: const FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(), // No borders
                        children: [
                          Text(
                              'Amount in Words : ${NumberToWord().convert('en-in', double.parse(widget.salesBody.total ?? '0').toInt()).capitalizeFirst} Only'),
                          Text(''),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('Before Tax : ${CommonCalculations.beforeAndAfterTax(widget.salesBody.salesitems?.map(
                                (e) =>
                                    (e.rate ?? 0) *
                                    double.parse(e.quantity ?? '0'),
                              ).reduce((value, element) => value + element).toString() ?? '0', getTaxById(widget.salesBody.salesitems?.first.taxId ?? ''))[CommonCalculations.before]}'),
                          Text('GST : ${CommonCalculations.beforeAndAfterTax(widget.salesBody.salesitems?.map(
                                (e) =>
                                    (e.rate ?? 0) *
                                    double.parse(e.quantity ?? '0'),
                              ).reduce((value, element) => value + element).toString() ?? '0', getTaxById(widget.salesBody.salesitems?.first.taxId ?? ''))[CommonCalculations.isolate]}'),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('Cess : ${widget.salesBody.cess ?? '0'}'),
                          Text('Round Off : ${CommonCalculations.beforeAndAfterTax(widget.salesBody.salesitems?.map(
                                (e) =>
                                    (e.rate ?? 0) *
                                    double.parse(e.quantity ?? '0'),
                              ).reduce((value, element) => value + element).toString() ?? '0', getTaxById(widget.salesBody.salesitems?.first.taxId ?? ''))[CommonCalculations.roundOff]}'),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('Bill Total : ${widget.salesBody.total ?? '0'}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(''),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConstant.percentToWidth(2)),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 12,
                        children: [
                          if ((widget.salesBody.latitude?.isNotEmpty ??
                                  false) &&
                              (widget.salesBody.longitude?.isNotEmpty ?? false))
                            ActionWidget(
                              color: Colors.red,
                              icon: CupertinoIcons.location_solid,
                              onTap: () async {
                                try {
                                  String url =
                                      'https://www.google.com/maps/search/?api=1&query=${widget.salesBody.latitude},${widget.salesBody.longitude}';
                                  await launchUrl(Uri.parse(url));
                                } catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                }
                              },
                            ),
                          ActionWidget(
                            color: Colors.blue,
                            icon: Icons.print,
                            onTap: () async => await PdfServices()
                                .printSalesBody(widget.salesBody),
                          ),
                          ActionWidget(
                            color: Colors.red,
                            icon: Icons.share,
                            onTap: () async {
                              final pdf = await PdfServices()
                                  .generatePdfFromSalesBody(widget.salesBody);
                              final directory = await getTemporaryDirectory();
                              //TODO: replace timestamp with invoice number
                              final file = File(
                                  '${directory.path}/bill-${DateTime.now().millisecondsSinceEpoch}.pdf');
                              await file.writeAsBytes(await pdf.save());
                              await Share.shareXFiles([XFile(file.path)],
                                  text: widget.salesBody.narration);
                            },
                          ),
                          if (widget.salesBody.type == SaleTypes.salesOrder)
                            ActionWidget(
                              color: Colors.green,
                              icon: Icons.send,
                              onTap: () => Get.toNamed(RoutesName.newSale,
                                  arguments: widget.salesBody
                                      .copyWith(type: SaleTypes.sales)
                                      .toJson()),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
