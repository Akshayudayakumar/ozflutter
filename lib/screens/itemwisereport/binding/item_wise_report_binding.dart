import 'package:get/get.dart';
import 'package:ozone_erp/screens/itemwisereport/controller/item_wise_report_controller.dart';

class ItemWiseReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItemWiseReportController>(ItemWiseReportController());
  }
}