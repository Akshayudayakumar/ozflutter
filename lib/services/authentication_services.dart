import 'package:get/get.dart';
import 'package:ozone_erp/data/app_data.dart';

import '../api/api.dart';
import '../controllers/id_controller.dart';

class AuthenticationService {
  static final AuthenticationService _authService = AuthenticationService._();

  factory AuthenticationService() => _authService;

  AuthenticationService._();

  Future<DioResponse> login(
      {required String username, required String password}) async {
    Map<String, String> formData = {
      "password": password,
      "username": username,
      "devid": AppData().getDeviceID()
    };
    return await DioConfig().dioPostCall(
        '${BackEnd.login}/${Get.find<IDController>().companyID}', formData,
        sendProgress: (a, b) {});
  }
}
