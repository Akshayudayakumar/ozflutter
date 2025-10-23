import 'package:get/get.dart';
import 'package:ozone_erp/screens/customers/controller/customers_controller.dart';

class CustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomersController>(CustomersController());
  }

}