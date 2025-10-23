import 'package:get/get.dart';
import '../controller/add_customer_controller.dart';

class AddCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddCustomerController>(AddCustomerController());
  }
}