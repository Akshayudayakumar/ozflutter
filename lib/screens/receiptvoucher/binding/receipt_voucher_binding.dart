import 'package:get/get.dart';

import '../controller/receipt_voucher_controller.dart';

class ReceiptVoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ReceiptVoucherController>(ReceiptVoucherController());
  }
}