import 'package:get/get.dart';
import 'package:ozone_erp/screens/login/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }
}