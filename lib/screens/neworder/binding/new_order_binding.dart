import 'package:get/get.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';

class NewOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NewOrderController>(NewOrderController());
  }

}