import 'package:get/get.dart';
import 'package:ozone_erp/screens/thermal/controller/thermal_controller.dart';

class ThermalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThermalController());
  }
}
