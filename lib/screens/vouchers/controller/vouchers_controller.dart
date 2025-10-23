import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/database/tables/export_insert.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/voucher_body.dart';

import '../../../Constants/constant.dart';
import '../../../widgets/export_widgets.dart';

class VouchersController extends GetxController {
  List<VoucherBody> paymentVouchers = [];
  List<VoucherBody> receiptVouchers = [];
  List<Customers> customers = [];
  List<Map<String, dynamic>> syncStatus = [];

  Future<void> getSyncStatus() async {
    syncStatus = await VoucherBodySync().getNotSyncedVoucherBodySync();
  }

  bool isNotSynced(String id) {
    return syncStatus.any((element) => element['id'] == id);
  }

  Future<void> getVouchers() async {
    customers = await InsertCustomers().getCustomers();
    paymentVouchers =
        await InsertVouchers().getVoucherByType(VoucherTypes.payment);
    receiptVouchers =
        await InsertVouchers().getVoucherByType(VoucherTypes.receipt);
    await getSyncStatus();
    update();
  }

  Customers getCustomer(String id) {
    Customers cus = customers.firstWhere((element) => element.id == id,
        orElse: () => Customers());
    return cus;
  }

  void showPrintMethod(
      {required String receiptType,
      required VoidCallback printAll,
      required VoidCallback printOnly}) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Print Vouchers'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              SolidButton(
                onTap: printOnly,
                width: double.infinity,
                curveRadius: 8,
                height: 50,
                child: TextWidget(
                  "$receiptType only",
                  color: Colors.white,
                  style: FontConstant.interMediumBold,
                ),
              ),
              SolidButton(
                onTap: printAll,
                width: double.infinity,
                curveRadius: 8,
                height: 50,
                child: TextWidget(
                  "Print All",
                  color: Colors.white,
                  style: FontConstant.interMediumBold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onInit() {
    getVouchers();
    super.onInit();
  }
}
