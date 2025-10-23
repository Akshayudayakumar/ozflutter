import 'package:get/get.dart';
import 'package:ozone_erp/screens/register/controller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }
}