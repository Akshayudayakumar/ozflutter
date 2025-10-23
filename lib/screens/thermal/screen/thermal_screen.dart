import 'package:flutter/material.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/utils/inch_conversion.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(
    MaterialApp(
      home: ThermalScreen(
        pdf: pw.Document(),
      ),
    ),
  );
}


class ThermalScreen extends StatelessWidget {
  final pw.Document pdf;
  const ThermalScreen({super.key, required this.pdf});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppData().getSettings().thermalPaper ?? '2'} inch View'),
      ),
      body: Center(
        child: Container(
          width: InchConversion().inchesToPixels(context,
              double.parse(AppData().getSettings().thermalPaper ?? '2')),
          height: SizeConstant.screenHeight,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
