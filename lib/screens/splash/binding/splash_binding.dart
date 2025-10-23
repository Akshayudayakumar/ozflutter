import 'package:get/get.dart';
import 'package:ozone_erp/screens/splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}
