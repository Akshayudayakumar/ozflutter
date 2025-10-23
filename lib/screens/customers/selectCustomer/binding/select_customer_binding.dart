import 'package:get/get.dart';
import 'package:ozone_erp/screens/customers/selectCustomer/controller/select_customer_controller.dart';

class SelectCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SelectCustomersController>(SelectCustomersController());
  }
}