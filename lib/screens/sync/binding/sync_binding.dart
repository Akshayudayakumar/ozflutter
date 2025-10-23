import 'package:get/get.dart';
import 'package:ozone_erp/screens/sync/controller/sync_controller.dart';

class SyncBinding extends Bindings {
  @override
  void dependencies() {
   Get.put<SyncController>(SyncController());
  }
}