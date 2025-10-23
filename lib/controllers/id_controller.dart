import 'package:get/get.dart';
import 'package:ozone_erp/data/app_data.dart';

class IDController extends GetxController {
  RxString companyID = AppData().getCompanyID().obs;
}
