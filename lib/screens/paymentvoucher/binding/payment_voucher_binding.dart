import 'package:get/get.dart';
import 'package:ozone_erp/screens/paymentvoucher/controller/payment_voucher_controller.dart';

class PaymentVoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PaymentVoucherController>(PaymentVoucherController());
  }
}
