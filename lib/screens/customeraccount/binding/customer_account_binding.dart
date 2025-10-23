import 'package:get/get.dart';

import '../controller/customer_account_controller.dart';

class CustomerAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomerAccountController>(CustomerAccountController());
  }
}