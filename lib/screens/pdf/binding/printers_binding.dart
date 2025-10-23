import 'package:get/get.dart';
import 'package:ozone_erp/screens/pdf/controller/printers_controller.dart';

class PrintersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PrintersController>(PrintersController());
  }
}