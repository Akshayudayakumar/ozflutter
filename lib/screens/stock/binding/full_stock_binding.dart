import 'package:get/get.dart';
import 'package:ozone_erp/screens/stock/controller/full_stock_controller.dart';

class FullStockBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FullStockController>(FullStockController());
  }
}