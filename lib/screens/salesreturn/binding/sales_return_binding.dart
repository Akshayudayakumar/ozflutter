import 'package:get/get.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';

class SalesReturnBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SalesReturnController>(SalesReturnController());
  }
}