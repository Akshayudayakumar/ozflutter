import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';
import 'package:ozone_erp/services/pdf_services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfController extends GetxController {
  @override
  void onInit() {
    createPdf();
    super.onInit();
  }

  Uint8List? pdfData;
  NewSaleController? salesController = Get.isRegistered<NewSaleController>()
      ? Get.find<NewSaleController>()
      : null;
  NewOrderController? orderController = Get.isRegistered<NewOrderController>()
      ? Get.find<NewOrderController>()
      : null;
  SalesReturnController? salesReturnController =
      Get.isRegistered<SalesReturnController>()
          ? Get.find<SalesReturnController>()
          : null;
  String invoice = Get.arguments['invoice'];

  void getPdf(pw.Document pdf) async {
    pdfData = await pdf.save();
    update();
  }

  String pdfSize = AppData().getPdfSize();
  RxInt pages = 0.obs;
  RxInt currentPage = 0.obs;
  late PDFViewController pdfViewController;

  PdfPageFormat getFormat() {
    switch (pdfSize.toUpperCase()) {
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

  Future<pw.Document> createPdf() async {
    SalesBody body = salesController?.salesBody ??
        orderController?.salesBody ??
        salesReturnController?.salesBodyToReturn ??
        SalesBody();
    final pdf = await PdfServices().generatePdfFromSalesBody(body);
    getPdf(pdf);
    return pdf;
  }

  void pdfSaveView(pw.Document pdf) {
    // Save and print the PDF
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => await pdf.save(),
    );
  }
}
