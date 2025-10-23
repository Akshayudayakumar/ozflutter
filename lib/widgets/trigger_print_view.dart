import 'package:flutter/material.dart';
import 'package:ozone_erp/widgets/show_pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../Constants/constant.dart';
import '../screens/exports/export_screens.dart';

class TriggerPrintView extends StatefulWidget {
  final pw.Document pdf;
  const TriggerPrintView({super.key, required this.pdf});

  @override
  State<TriggerPrintView> createState() => _TriggerPrintViewState();
}

class _TriggerPrintViewState extends State<TriggerPrintView> {
  bool isPdf = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isPdf
          ? ShowPdf(pdf: widget.pdf)
          : ThermalScreen(
              pdf: widget.pdf,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isPdf = !isPdf;
          });
        },
        backgroundColor: AppStyle.floatingActionColor,
        child: Image.asset(
          AssetConstant.magnifyingGlass,
          width: 25,
          height: 25,
          color: AppStyle.radioColor,
        ),
      ),
    );
  }
}
