import 'package:get/get.dart';
import 'package:ozone_erp/screens/settings/controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController());
  }

}