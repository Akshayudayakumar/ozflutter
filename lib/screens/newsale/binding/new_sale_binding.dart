import 'package:get/get.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';

class NewSaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NewSaleController>(NewSaleController());
  }

}