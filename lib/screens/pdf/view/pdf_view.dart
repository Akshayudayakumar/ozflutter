import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/widgets/print_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/constant.dart';
import '../controller/pdf_controller.dart';

class PdfViewScreen extends StatelessWidget {
  const PdfViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PdfPreviewPage();
  }
}

class PdfPreviewPage extends GetView<PdfController> {
  const PdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        controller.salesController?.addedItems.clear();
        await controller.salesController?.getBillNumbers();
        controller.salesController?.update();
        controller.orderController?.addedItems.clear();
        await controller.orderController?.getBillNumbers();
        controller.orderController?.update();
        controller.salesReturnController?.addedItems.clear();
        controller.salesReturnController?.update();
        controller.update();
        Get.back();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Invoice: ${controller.invoice}'),
            centerTitle: true,
            backgroundColor: AppStyle.primaryColor,
            leading: IconButton(
                onPressed: () async {
                  controller.salesController?.addedItems.clear();
                  await controller.salesController?.getBillNumbers();
                  controller.salesController?.update();
                  controller.orderController?.addedItems.clear();
                  await controller.orderController?.getBillNumbers();
                  controller.orderController?.update();
                  controller.salesReturnController?.addedItems.clear();
                  controller.salesReturnController?.update();
                  controller.update();
                  Get.back();
                },
                icon: const Icon(CupertinoIcons.back)),
          ),
          body: Column(
            children: [
              Obx(
                () {
                  if (controller.pages.value > 1) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (controller.currentPage.value > 0) {
                                controller.pdfViewController
                                    .setPage(controller.currentPage.value - 1);
                                controller.update();
                              }
                            },
                            icon: Icon(CupertinoIcons.arrow_left_circle_fill)),
                        Text('Page: ${controller.currentPage.value + 1}'),
                        IconButton(
                            onPressed: () {
                              if (controller.currentPage.value <
                                  controller.pages.value - 1) {
                                controller.pdfViewController
                                    .setPage(controller.currentPage.value + 1);
                                controller.update();
                              }
                            },
                            icon: Icon(CupertinoIcons.arrow_right_circle_fill)),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              Expanded(
                child: GetBuilder<PdfController>(
                  builder: (ctrl) => ctrl.pdfData == null
                      ? const Center(child: CircularProgressIndicator())
                      : InteractiveViewer(
                          child: PDFView(
                            pdfData: ctrl.pdfData,
                            onRender: (pages) {
                              controller.pages.value = pages ?? 0;
                            },
                            onViewCreated: (ctrl) {
                              controller.pdfViewController = ctrl;
                            },
                            onPageChanged: (page, total) {
                              controller.currentPage.value =
                                  page ?? controller.currentPage.value;
                            },
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Expanded(
                        child: PrintButton(
                      child: const Text(
                        'Print PDF',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        controller.pdfSaveView(await controller.createPdf());
                      },
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: PrintButton(
                      child: const Text(
                        'Thermal Print',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Get.toNamed(RoutesName.printersPreview);
                      },
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: PrintButton(
                      child: const Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        try {
                          final pdf = await controller.createPdf();
                          final directory = await getTemporaryDirectory();
                          //TODO: replace timestamp with invoice number
                          final file = File(
                              '${directory.path}/bill-${DateTime.now().millisecondsSinceEpoch}.pdf');
                          await file.writeAsBytes(await pdf.save());
                          await Share.shareXFiles([XFile(file.path)],
                              text:
                                  'Check out this PDF Generated by Ozone ERP');
                        } catch (e) {
                          Get.showSnackbar(GetSnackBar(
                            title: 'PDF Error',
                            message: 'Error sharing pdf',
                            duration: const Duration(seconds: 2),
                            animationDuration:
                                const Duration(milliseconds: 200),
                          ));
                        }
                      },
                    )),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
