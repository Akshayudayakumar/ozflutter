import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/database/tables/deviceDetails/insert_company_settings.dart';
import 'package:ozone_erp/services/pdf_services.dart';
import 'package:ozone_erp/widgets/action_widget.dart';
import 'package:pdf/widgets.dart' as pw;

import '../Constants/constant.dart';

class ShowPdf extends StatefulWidget {
  final String title;
  final pw.Document pdf;
  const ShowPdf({super.key, this.title = 'PDF', required this.pdf});

  @override
  State<ShowPdf> createState() => _ShowPdfState();
}

class _ShowPdfState extends State<ShowPdf> {
  Uint8List? pdfData;
  late PDFViewController controller;
  int pages = 0;
  int currentPage = 0;

  @override
  void initState() {
    getPdfData();
    super.initState();
  }

  getPdfData() async {
    pdfData = await widget.pdf.save();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: AppStyle.primaryColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppStyle.primaryColor,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppStyle.primaryColor,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(CupertinoIcons.back)),
        ),
        body: pdfData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  if (pages > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (currentPage > 0) {
                                controller.setPage(currentPage - 1);
                              }
                            },
                            icon: Icon(CupertinoIcons.arrow_left_circle_fill)),
                        Text('Page: ${currentPage + 1} / $pages'),
                        IconButton(
                            onPressed: () {
                              if (currentPage < pages - 1) {
                                controller.setPage(currentPage + 1);
                              }
                            },
                            icon: Icon(CupertinoIcons.arrow_right_circle_fill)),
                      ],
                    ),
                  Expanded(
                    child: InteractiveViewer(
                      child: PDFView(
                        pdfData: pdfData,
                        onRender: (pages) {
                          setState(() {
                            this.pages = pages!;
                          });
                        },
                        onViewCreated: (controller) {
                          this.controller = controller;
                        },
                        onPageChanged: (page, total) {
                          setState(() {
                            currentPage = page!;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionWidget(
                          color: AppStyle.radioColor,
                          onTap: () {
                            PdfServices().pdfSaveView(widget.pdf);
                          },
                          icon: Icons.print,
                        ),
                        ActionWidget(
                          color: Colors.redAccent,
                          onTap: () async {
                            try {
                              final companySettings =
                                  (await InsertCompanySettings()
                                      .getCompanySettings())[0];
                              await PdfServices().sharePDF(
                                  pdf: widget.pdf,
                                  fileName:
                                      'Stocks-${companySettings.name ?? ""}');
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },
                          icon: Icons.share,
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
