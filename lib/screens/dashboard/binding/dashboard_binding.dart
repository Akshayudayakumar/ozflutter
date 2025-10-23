import 'package:get/get.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';

class DashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashBoardController>(DashBoardController());
  }

}