import 'package:get/get.dart';
import 'package:ozone_erp/screens/stockTransfer/controller/stock_transfer_controller.dart';

class StockTransferBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StockTransferController>(StockTransferController());
  }

}