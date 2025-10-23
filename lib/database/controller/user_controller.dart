import 'package:get/get.dart';
import 'package:ozone_erp/database/tables/export_insert.dart';
import 'package:ozone_erp/models/user_model.dart';

class UserController extends GetxController {
  UserModel? user;

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  getUser() async {
    user = await InsertUserModel().getUserModel();
    update();
  }
}