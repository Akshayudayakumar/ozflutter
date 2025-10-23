import 'dart:io';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/database/tables/export_insert.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/models/voucher_body.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/show_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/general_details.dart';
import '../utils/common_calculations.dart';

class PdfServices {
  // This defines a singleton pattern for the PdfServices class.
  // A singleton ensures that only one instance of a class is ever created.

  // 1. `_pdfServices` is a private, static, and final variable. It holds the single
  //    instance of the PdfServices class. It's initialized immediately using the
  //    private constructor `PdfServices._()`.
  static final PdfServices _pdfServices = PdfServices._();

  // 2. This is a factory constructor. When you call `PdfServices()`, instead of
  //    creating a new instance, it always returns the single, pre-existing
  //    `_pdfServices` instance. This is the core of the singleton pattern.
  factory PdfServices() => _pdfServices;

  // 3. `PdfServices._()` is a private, named constructor. Making it private
  //    (by starting with an underscore) prevents other parts of the app from
  //    creating new instances of PdfServices using `PdfServices._()`.
  PdfServices._();

  // This method generates a PDF document for a sales transaction.
  Future<pw.Document> generatePdfFromSalesBody(SalesBody body) async {
    // Creates a new, empty PDF document object.
    final pdf = pw.Document();
    // Asynchronously fetches company settings (like name, address, GST number)
    // from the database. It assumes `getCompanySettings()` returns a list and
    // takes the first element.
    final companySettings =
        (await InsertCompanySettings().getCompanySettings())[0];
    final allItems = await InsertItems().getItems();
    final units = await InsertUnit().getUnits();
    final customer =
        await InsertCustomers().getCustomerById(body.customerId ?? '');
    final taxes = await InsertTax().getTax();
    pdf.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.all(18),
        pageFormat: getFormat(),
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        header: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                companySettings.name ?? 'Unavailable',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(companySettings.address ?? 'Unavailable'),
              pw.Text('MOB: ${companySettings.phone ?? 'Unavailable'}'),
              pw.Text('GST No : ${companySettings.tin ?? 'Nil'}'),
              pw.SizedBox(height: 20),
              pw.Text(
                body.type == 'sales'
                    ? 'TAX INVOICE'
                    : body.type == 'sales-order'
                        ? 'SALES ORDER'
                        : 'SALES RETURN',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('To'),
                      pw.Text('${body.cusname}'),
                      pw.Text('${customer.tin ?? ''}'),
                      pw.Text('${body.customerAddress} ${body.cusdetails}'),
                      pw.Text('Phone : ${body.customerPhone ?? 'N/A'}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('INV NO: ${body.invoice}'),
                      pw.Text('Date : ${body.invoiceDate}'),
                      pw.Text('Salesman : ${AppData().getUserName()}'),
                      pw.Text('Prepared by : ${AppData().getUserName()}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(
                  color: PdfColors.grey600,
                  thickness: 1,
                  indent: 28,
                  endIndent: 28),
              pw.SizedBox(height: 20),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 10),
              color: PdfColors.grey300,
              child: pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1),
                  5: const pw.FlexColumnWidth(1),
                  6: const pw.FlexColumnWidth(1),
                  7: const pw.FlexColumnWidth(1),
                  8: const pw.FlexColumnWidth(1),
                  9: const pw.FlexColumnWidth(1),
                  10: const pw.FlexColumnWidth(1),
                  11: const pw.FlexColumnWidth(1),
                  12: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                        color: PdfColors.grey300), // No borders
                    children: [
                      pw.Text('SNo',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Item',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('HSN',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Qty',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Unit',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('MRP',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Rate',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('DIS',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('AMT',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('GST',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text(r'SGST',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text(r'CGST',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                    ],
                  )
                ],
              ),
            ),

            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              // Light border for cleaner look
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(3), // Wider for "Item" column
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
                4: const pw.FlexColumnWidth(1),
                5: const pw.FlexColumnWidth(1),
                6: const pw.FlexColumnWidth(1),
                7: const pw.FlexColumnWidth(1),
                8: const pw.FlexColumnWidth(1),
                9: const pw.FlexColumnWidth(1),
                10: const pw.FlexColumnWidth(1),
                11: const pw.FlexColumnWidth(1),
                12: const pw.FlexColumnWidth(1),
              },
              children: List.generate(body.salesitems?.length ?? 0, (index) {
                final salesItem = body.salesitems?[index];
                final salesItems = allItems
                    .where((element) => element.id == salesItem?.itemId)
                    .toList();
                final item = salesItems.isNotEmpty ? salesItems[0] : Items();
                final unit = units.firstWhere(
                  (element) => element.unitId == salesItem?.unitId,
                  orElse: () => Unit(),
                );
                final tax = taxes.firstWhere(
                    (element) => element.gstid == item.taxId,
                    orElse: () => Tax());
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      // Padding around each cell
                      child: pw.Text((index + 1).toString()),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(item.name ?? 'Item'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(item.hsncodename ?? 'HSN'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('${salesItem?.quantity ?? '0'}'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(unit.name ?? 'Unit'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(item.mrp ?? '0'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(salesItem?.rate?.toString() ?? '0'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(double.parse(salesItem?.discount ?? '0')
                          .toStringAsFixed(2)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(Utils().roundWithFixedDecimal(
                          double.parse(item.mrp ?? '0') *
                              double.parse(salesItem?.quantity ?? '0'))),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(tax.gst ?? '0'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(tax.sgst ?? '0'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(tax.cgst ?? '0'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(body.total ?? ''),
                    ),
                  ],
                );
              }),
            ),

            pw.SizedBox(height: 20),
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data:
                  'upi://pay?pa=${companySettings.comsetAccountNo}@${companySettings.comsetIfsccode}&pn=${companySettings.name}&tn=${body.narration}&am=${body.total}&cu=INR',
              width: 100,
              height: 100,
            ),
            pw.SizedBox(height: 20),
            // Footer Section without borders
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(), // No borders
                  children: [
                    pw.Text(
                        'Amount in Words : ${NumberToWord().convert('en-in', double.parse(body.total ?? '0').toInt()).capitalizeFirst} Only'),
                    pw.Text(''),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text('Before Tax : ${CommonCalculations.beforeAndAfterTax(body.salesitems?.map(
                              (e) =>
                                  (e.rate ?? 0) *
                                  double.parse(e.quantity ?? '0'),
                            ).reduce((value, element) => value + element).toString() ?? '0', taxes.firstWhere(
                          (element) =>
                              element.gstid == body.salesitems?.first.taxId,
                        ))[CommonCalculations.before]}'),
                    pw.Text('GST : ${CommonCalculations.beforeAndAfterTax(body.salesitems?.map(
                              (e) =>
                                  (e.rate ?? 0) *
                                  double.parse(e.quantity ?? '0'),
                            ).reduce((value, element) => value + element).toString() ?? '0', taxes.firstWhere(
                          (element) =>
                              element.gstid == body.salesitems?.first.taxId,
                        ))[CommonCalculations.isolate]}'),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text('Cess : ${body.cess ?? '0'}'),
                    pw.Text('Round Off : ${CommonCalculations.beforeAndAfterTax(body.salesitems?.map(
                              (e) =>
                                  (e.rate ?? 0) *
                                  double.parse(e.quantity ?? '0'),
                            ).reduce((value, element) => value + element).toString() ?? '0', taxes.firstWhere(
                          (element) =>
                              element.gstid == body.salesitems?.first.taxId,
                        ))[CommonCalculations.roundOff]}'),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text('Bill Total : ${body.total ?? '0'}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(''),
                  ],
                ),
              ],
            ),
          ];
        }));
    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: getFormat(),
    //     margin: const pw.EdgeInsets.all(18),
    //     build: (pw.Context context) {
    //       return pw.Column(
    //         children: [
    //           pw.Text(
    //             companySettings.name ?? 'Unavailable',
    //             style:
    //                 pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
    //           ),
    //           pw.Text(companySettings.address ?? 'Unavailable'),
    //           pw.Text('MOB: ${companySettings.phone ?? 'Unavailable'}'),
    //           pw.Text('GST No : ${companySettings.tin ?? 'Nil'}'),
    //           pw.SizedBox(height: 20),
    //           pw.Text(
    //             body.type == 'sales'
    //                 ? 'TAX INVOICE'
    //                 : body.type == 'sales-order'
    //                     ? 'SALES ORDER'
    //                     : 'SALES RETURN',
    //             style:
    //                 pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
    //           ),
    //           pw.SizedBox(height: 10),
    //           pw.Row(
    //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //             children: [
    //               pw.Column(
    //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
    //                 children: [
    //                   pw.Text('To'),
    //                   pw.Text('${body.cusname}'),
    //                   pw.Text('${customer.tin ?? ''}'),
    //                   pw.Text('${body.customerAddress} ${body.cusdetails}'),
    //                   pw.Text('Phone : ${body.customerPhone ?? 'N/A'}'),
    //                 ],
    //               ),
    //               pw.Column(
    //                 crossAxisAlignment: pw.CrossAxisAlignment.end,
    //                 children: [
    //                   pw.Text('INV NO: ${body.invoice}'),
    //                   pw.Text('Date : ${body.invoiceDate}'),
    //                   pw.Text('Salesman : ${AppData().getUserName()}'),
    //                   pw.Text('Prepared by : ${AppData().getUserName()}'),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           pw.SizedBox(height: 20),
    //           // Header Section without borders
    //           pw.Container(
    //             padding: const pw.EdgeInsets.symmetric(vertical: 10),
    //             color: PdfColors.grey300,
    //             child: pw.Table(
    //               columnWidths: {
    //                 0: const pw.FlexColumnWidth(1),
    //                 1: const pw.FlexColumnWidth(3),
    //                 2: const pw.FlexColumnWidth(1),
    //                 3: const pw.FlexColumnWidth(1),
    //                 4: const pw.FlexColumnWidth(1),
    //                 5: const pw.FlexColumnWidth(1),
    //                 6: const pw.FlexColumnWidth(1),
    //                 7: const pw.FlexColumnWidth(1),
    //                 8: const pw.FlexColumnWidth(1),
    //                 9: const pw.FlexColumnWidth(1),
    //                 10: const pw.FlexColumnWidth(1),
    //                 11: const pw.FlexColumnWidth(1),
    //                 12: const pw.FlexColumnWidth(1),
    //               },
    //               children: [
    //                 pw.TableRow(
    //                   decoration: const pw.BoxDecoration(
    //                       color: PdfColors.grey300), // No borders
    //                   children: [
    //                     pw.Text('SNo',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('Item',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('HSN',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('Qty',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('Unit',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('MRP',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('Rate',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('DIS',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('AMT',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('GST',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text(r'SGST',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text(r'CGST',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                     pw.Text('Total',
    //                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                         textAlign: pw.TextAlign.center),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //           // Content Section with borders
    //           pw.Table(
    //             border: pw.TableBorder.all(width: 0.5),
    //             // Light border for cleaner look
    //             columnWidths: {
    //               0: const pw.FlexColumnWidth(1),
    //               1: const pw.FlexColumnWidth(3), // Wider for "Item" column
    //               2: const pw.FlexColumnWidth(1),
    //               3: const pw.FlexColumnWidth(1),
    //               4: const pw.FlexColumnWidth(1),
    //               5: const pw.FlexColumnWidth(1),
    //               6: const pw.FlexColumnWidth(1),
    //               7: const pw.FlexColumnWidth(1),
    //               8: const pw.FlexColumnWidth(1),
    //               9: const pw.FlexColumnWidth(1),
    //               10: const pw.FlexColumnWidth(1),
    //               11: const pw.FlexColumnWidth(1),
    //               12: const pw.FlexColumnWidth(1),
    //             },
    //             children: List.generate(body.salesitems?.length ?? 0, (index) {
    //               final salesItem = body.salesitems?[index];
    //               final salesItems = allItems
    //                   .where((element) => element.id == salesItem?.itemId)
    //                   .toList();
    //               final item = salesItems.isNotEmpty ? salesItems[0] : Items();
    //               final unit = units.firstWhere(
    //                 (element) => element.unitId == salesItem?.unitId,
    //               );
    //               final tax = taxes.firstWhere(
    //                   (element) => element.gstid == item.taxId,
    //                   orElse: () => Tax());
    //               return pw.TableRow(
    //                 children: [
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     // Padding around each cell
    //                     child: pw.Text((index + 1).toString()),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(item.name ?? 'Item'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(item.hsncode ?? 'HSN'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text('${salesItem?.quantity ?? '0'}'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(unit.name ?? 'Unit'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(item.mrp ?? '0'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(salesItem?.rate?.toString() ?? '0'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(salesItem?.discount ?? '0'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(Utils().roundWithFixedDecimal(
    //                         double.parse(item.mrp ?? '0') *
    //                             double.parse(salesItem?.quantity ?? '0'))),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(tax.gst ?? '0'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(tax.sgst ?? '0'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(tax.cgst ?? '0'),
    //                   ),
    //                   pw.Padding(
    //                     padding: const pw.EdgeInsets.all(4),
    //                     child: pw.Text(body.total ?? ''),
    //                   ),
    //                 ],
    //               );
    //             }),
    //           ),
    //           pw.SizedBox(height: 20),
    //           pw.BarcodeWidget(
    //             barcode: pw.Barcode.qrCode(),
    //             data:
    //                 'upi://pay?pa=${companySettings.comsetAccountNo}@${companySettings.comsetIfsccode}&pn=${companySettings.name}&tn=${body.narration}&am=${body.total}&cu=INR',
    //             width: 100,
    //             height: 100,
    //           ),
    //           pw.SizedBox(height: 20),
    //           // Footer Section without borders
    //           pw.Table(
    //             columnWidths: {
    //               0: const pw.FlexColumnWidth(1),
    //               1: const pw.FlexColumnWidth(1),
    //             },
    //             children: [
    //               pw.TableRow(
    //                 decoration: const pw.BoxDecoration(), // No borders
    //                 children: [
    //                   pw.Text(
    //                       'Amount in Words : ${NumberToWord().convert('en-in', double.parse(body.total ?? '0').toInt()).capitalizeFirst} Only'),
    //                   pw.Text(''),
    //                 ],
    //               ),
    //               pw.TableRow(
    //                 children: [
    //                   pw.Text('Before Tax : ${CommonCalculations.beforeAndAfterTax(body.salesitems?.map(
    //                             (e) =>
    //                                 (e.rate ?? 0) *
    //                                 double.parse(e.quantity ?? '0'),
    //                           ).reduce((value, element) => value + element).toString() ?? '0', taxes.firstWhere(
    //                         (element) =>
    //                             element.gstid == body.salesitems?.first.taxId,
    //                       ))[CommonCalculations.before]}'),
    //                   pw.Text('GST : ${CommonCalculations.beforeAndAfterTax(body.salesitems?.map(
    //                             (e) =>
    //                                 (e.rate ?? 0) *
    //                                 double.parse(e.quantity ?? '0'),
    //                           ).reduce((value, element) => value + element).toString() ?? '0', taxes.firstWhere(
    //                         (element) =>
    //                             element.gstid == body.salesitems?.first.taxId,
    //                       ))[CommonCalculations.isolate]}'),
    //                 ],
    //               ),
    //               pw.TableRow(
    //                 children: [
    //                   pw.Text('Cess : ${body.cess ?? '0'}'),
    //                   pw.Text('Round Off : ${body.roundoff ?? '0'}'),
    //                 ],
    //               ),
    //               pw.TableRow(
    //                 children: [
    //                   pw.Text('Bill Total : ${body.total ?? '0'}',
    //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    //                   pw.Text(''),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ],
    //       );
    //     },
    //   ),
    // );
    return pdf;
  }

  Future<void> printSalesBody(SalesBody body) async {
    final pdf = await generatePdfFromSalesBody(body);
    pdfSaveView(pdf);
  }

  Future<void> printVouchers(
    List<VoucherBody> vouchers,
    String Function(String id) getCustomer,
  ) async {
    final pdf = pw.Document();
    final companySettings =
        (await InsertCompanySettings().getCompanySettings())[0];
    pdf.addPage(pw.MultiPage(
      pageFormat: getFormat(),
      margin: pw.EdgeInsets.all(18),
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      maxPages: (vouchers.length / 4).round(),
      header: (pw.Context context) {
        return pw.Container(
          width: double.infinity,
          alignment: pw.Alignment.center,
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  companySettings.name ?? 'Unavailable',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(companySettings.address ?? 'Unavailable'),
                pw.Text('MOB: ${companySettings.phone ?? 'Unavailable'}'),
                pw.Text('GST No : ${companySettings.tin ?? 'Nil'}'),
                pw.SizedBox(height: 20),
              ]),
        );
      },
      build: (pw.Context context) {
        return [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            color: PdfColors.grey300,
            child: pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(3),
                4: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300), // No borders
                  children: [
                    pw.Text('VNo',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                    pw.Text('Date',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                    pw.Text('Account',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                    pw.Text('Narration',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                    pw.Text('Amount',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                  ],
                ),
              ],
            ),
          ),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            // Light border for cleaner look
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(3),
              4: const pw.FlexColumnWidth(1),
            },
            children: List.generate(vouchers.length, (index) {
              final voucher = vouchers[index];
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    // Padding around each cell
                    child: pw.Text(voucher.vid ?? '$index'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(voucher.date ?? ''),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(getCustomer(voucher.toid ?? '')),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(voucher.narration ?? ''),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('${voucher.amount ?? '0'}'),
                  ),
                ],
              );
            }),
          ),
          pw.SizedBox(height: 20),
        ];
      },
    ));
    // pdf.addPage(pw.Page(
    //     pageFormat: getFormat(),
    //     margin: pw.EdgeInsets.all(18),
    //     build: (pw.Context context) {
    //       return pw.Column(children: [
    //         pw.Text(
    //           companySettings.name ?? 'Unavailable',
    //           style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
    //         ),
    //         pw.Text(companySettings.address ?? 'Unavailable'),
    //         pw.Text('MOB: ${companySettings.phone ?? 'Unavailable'}'),
    //         pw.Text('GST No : ${companySettings.tin ?? 'Nil'}'),
    //         pw.SizedBox(height: 20),
    //         pw.Container(
    //           padding: const pw.EdgeInsets.symmetric(vertical: 10),
    //           color: PdfColors.grey300,
    //           child: pw.Table(
    //             columnWidths: {
    //               0: const pw.FlexColumnWidth(1),
    //               1: const pw.FlexColumnWidth(1),
    //               2: const pw.FlexColumnWidth(2),
    //               3: const pw.FlexColumnWidth(3),
    //               4: const pw.FlexColumnWidth(1),
    //             },
    //             children: [
    //               pw.TableRow(
    //                 decoration: const pw.BoxDecoration(
    //                     color: PdfColors.grey300), // No borders
    //                 children: [
    //                   pw.Text('VNo',
    //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                       textAlign: pw.TextAlign.center),
    //                   pw.Text('Date',
    //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                       textAlign: pw.TextAlign.center),
    //                   pw.Text('Account',
    //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                       textAlign: pw.TextAlign.center),
    //                   pw.Text('Narration',
    //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                       textAlign: pw.TextAlign.center),
    //                   pw.Text('Amount',
    //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //                       textAlign: pw.TextAlign.center),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         pw.Table(
    //           border: pw.TableBorder.all(width: 0.5),
    //           // Light border for cleaner look
    //           columnWidths: {
    //             0: const pw.FlexColumnWidth(1),
    //             1: const pw.FlexColumnWidth(1),
    //             2: const pw.FlexColumnWidth(2),
    //             3: const pw.FlexColumnWidth(3),
    //             4: const pw.FlexColumnWidth(1),
    //           },
    //           children: List.generate(vouchers.length, (index) {
    //             final voucher = vouchers[index];
    //             return pw.TableRow(
    //               children: [
    //                 pw.Padding(
    //                   padding: const pw.EdgeInsets.all(4),
    //                   // Padding around each cell
    //                   child: pw.Text(voucher.vid ?? '$index'),
    //                 ),
    //                 pw.Padding(
    //                   padding: const pw.EdgeInsets.all(4),
    //                   child: pw.Text(voucher.date ?? ''),
    //                 ),
    //                 pw.Padding(
    //                   padding: const pw.EdgeInsets.all(4),
    //                   child: pw.Text(getCustomer(voucher.toid ?? '')),
    //                 ),
    //                 pw.Padding(
    //                   padding: const pw.EdgeInsets.all(4),
    //                   child: pw.Text(voucher.narration ?? ''),
    //                 ),
    //                 pw.Padding(
    //                   padding: const pw.EdgeInsets.all(4),
    //                   child: pw.Text(
    //                       '${Currency.getById(AppData().getSettings().currency).symbol} ${voucher.amount ?? '0'}'),
    //                 ),
    //               ],
    //             );
    //           }),
    //         ),
    //         pw.SizedBox(height: 20),
    //       ]);
    //     }));
    Get.to(() => ShowPdf(
          pdf: pdf,
          title: 'Vouchers.pdf',
        ));
    // pdfSaveView(pdf);
  }

  PdfPageFormat getFormat() {
    switch (AppData().getPdfSize().toUpperCase()) {
      case 'A4':
        return PdfPageFormat.a4;
      case 'A5':
        return PdfPageFormat.a5;
      case 'A3':
        return PdfPageFormat.a3;
      case 'A6':
        return PdfPageFormat.a6;
      default:
        return PdfPageFormat.a4;
    }
  }

  void pdfSaveView(pw.Document pdf) {
    // Save and print the PDF
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => await pdf.save(),
    );
  }

  Future<pw.Document> generateStockPdf() async {
    pw.Document pdf = pw.Document();
    final items = await InsertItems().getItems();
    items.sort((a, b) {
      final aNumber = a.id?.padLeft(10, '0');
      final bNumber = b.id?.padLeft(10, '0');
      return aNumber?.compareTo(bNumber ?? '0') ?? 0;
    });
    final companySettings =
        (await InsertCompanySettings().getCompanySettings())[0];
    pdf.addPage(
      pw.MultiPage(
        pageFormat: getFormat(),
        margin: const pw.EdgeInsets.all(18),
        maxPages: (items.length / 2).round(),
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
                pw.Text(
                  companySettings.name ?? 'Unavailable',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(companySettings.address ?? 'Unavailable'),
                pw.Text('MOB: ${companySettings.phone ?? 'Unavailable'}'),
                pw.Text('GST No : ${companySettings.tin ?? 'Nil'}'),
                pw.SizedBox(height: 20),
                pw.Padding(
                  padding: pw.EdgeInsets.all(20),
                  child: pw.Text(
                    'STOCK DETAILS',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
            // pw.Container(
            //   padding: const pw.EdgeInsets.symmetric(vertical: 10),
            //   color: PdfColors.grey300,
            //   child: pw.Table(
            //     columnWidths: {
            //       0: const pw.FlexColumnWidth(1),
            //       1: const pw.FlexColumnWidth(1),
            //       2: const pw.FlexColumnWidth(3),
            //       3: const pw.FlexColumnWidth(1),
            //       4: const pw.FlexColumnWidth(1),
            //     },
            //     children: [
            //       pw.TableRow(
            //         decoration: const pw.BoxDecoration(
            //             color: PdfColors.grey300), // No borders
            //         children: [
            //           pw.Text('SNo',
            //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //               textAlign: pw.TextAlign.center),
            //           pw.Text('ID',
            //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //               textAlign: pw.TextAlign.center),
            //           pw.Text('Item',
            //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //               textAlign: pw.TextAlign.center),
            //           pw.Text('C.STK',
            //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //               textAlign: pw.TextAlign.center),
            //           pw.Text('MRP',
            //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //               textAlign: pw.TextAlign.center),
            //           pw.Text('SRATE',
            //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //               textAlign: pw.TextAlign.center),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            pw.TableHelper.fromTextArray(
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(3),
                3: const pw.FlexColumnWidth(1),
                4: const pw.FlexColumnWidth(1),
              },
              cellAlignment: pw.Alignment.center,
              headers: ['SNo', 'ID', 'Item', 'C.STK', 'MRP', 'SRATE'],
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              headerPadding: pw.EdgeInsets.all(12),
              cellPadding: pw.EdgeInsets.all(4),
              data: List.generate(
                items.length,
                (index) {
                  Items item = items[index];
                  return [
                    (index + 1).toString(),
                    item.id ?? 'id',
                    item.name ?? 'Item',
                    item.itemQty ?? '0',
                    item.mrp ?? '0',
                    item.srate ?? '0'
                  ];
                },
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('For ${companySettings.name}')
          ];
        },
      ),
    );
    return pdf;
  }

  Future<void> sharePDF(
      {required pw.Document pdf,
      required String fileName,
      String? text}) async {
    final directory = await getTemporaryDirectory();
    //TODO: replace timestamp with invoice number
    final file = File('${directory.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: text);
  }

  Future<pw.Document> generateRegisterPdf(List<SalesBody> sales) async {
    final pdf = pw.Document();
    final companySettings =
        (await InsertCompanySettings().getCompanySettings())[0];
    pdf.addPage(pw.MultiPage(
      pageFormat: getFormat(),
      margin: pw.EdgeInsets.all(18),
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      maxPages: (sales.length / 4).round(),
      header: (pw.Context context) {
        return pw.Container(
          width: double.infinity,
          alignment: pw.Alignment.center,
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  companySettings.name ?? 'Unavailable',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(companySettings.address ?? 'Unavailable'),
                pw.Text('MOB: ${companySettings.phone ?? 'Unavailable'}'),
                pw.Text('GST No : ${companySettings.tin ?? 'Nil'}'),
                pw.SizedBox(height: 20),
              ]),
        );
      },
      build: (pw.Context context) {
        return [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            color: PdfColors.grey300,
            child: pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(3),
                3: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300), // No borders
                  children: [
                    pw.Text('Invoice No.',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                    pw.Text('Invoice Date',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                    pw.Text('Customer',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                    pw.Text('Total',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                  ],
                )
              ],
            ),
          ),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            // Light border for cleaner look
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(3),
              3: const pw.FlexColumnWidth(1),
            },
            children: List.generate(sales.length, (index) {
              final sale = sales[index];
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    // Padding around each cell
                    child: pw.Text(sale.invoice ?? '',
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(sale.invoiceDate ?? '',
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(sale.cusname ?? '',
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(sale.total ?? '0',
                        textAlign: pw.TextAlign.center),
                  ),
                ],
              );
            }),
          ),
          pw.SizedBox(height: 20),
          pw.Text('For ${companySettings.name}')
        ];
      },
    ));
    return pdf;
  }
}
