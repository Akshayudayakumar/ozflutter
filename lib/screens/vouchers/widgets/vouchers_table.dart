import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/models/voucher_body.dart';
import 'package:ozone_erp/screens/vouchers/controller/vouchers_controller.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';

class VouchersTable extends StatelessWidget {
  final List<VoucherBody> vouchers;
  final String Function(String id) getCustomer;
  const VouchersTable(
      {super.key, required this.vouchers, required this.getCustomer});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            headingRowColor:
                WidgetStatePropertyAll(AppStyle.secondaryColor.withAlpha(50)),
            columns: [
              DataColumn(label: Text('Voucher No.')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Account')),
              DataColumn(label: Text('Narration')),
              DataColumn(label: Text('Amount')),
            ],
            rows: vouchers.map(
              (voucher) {
                bool notSynced = Get.find<VouchersController>()
                    .isNotSynced(voucher.vid ?? '');
                return DataRow(
                  color: notSynced
                      ? WidgetStatePropertyAll(Colors.red.withAlpha(30))
                      : null,
                  cells: [
                    DataCell(GestureDetector(
                        onTap: () => showPrintDialog(context),
                        child: Text(voucher.vid ?? ''))),
                    DataCell(GestureDetector(
                        onTap: () => showPrintDialog(context),
                        child: Text(voucher.date ?? ''))),
                    DataCell(GestureDetector(
                        onTap: () => showPrintDialog(context),
                        child: Text(getCustomer(voucher.toid ?? '')))),
                    DataCell(GestureDetector(
                        onTap: () => showPrintDialog(context),
                        child: Text(voucher.narration ?? ''))),
                    DataCell(GestureDetector(
                        onTap: () => showPrintDialog(context),
                        child: Text(voucher.amount ?? ''))),
                  ],
                );
              },
            ).toList()),
      ),
    );
  }

  void showPrintDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Print Voucher'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                SolidButton(
                  width: double.infinity,
                  curveRadius: 8,
                  height: 50,
                  child: TextWidget(
                    "PDF",
                    color: Colors.white,
                    style: FontConstant.interMediumBold,
                  ),
                ),
                SolidButton(
                  width: double.infinity,
                  curveRadius: 8,
                  height: 50,
                  child: TextWidget(
                    "Thermal",
                    color: Colors.white,
                    style: FontConstant.interMediumBold,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
