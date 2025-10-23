import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/controllers/id_controller.dart';
import 'package:ozone_erp/database/controller/db_controller.dart';
import 'package:ozone_erp/database/db_functions.dart';
import 'package:ozone_erp/models/user_model.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/services/sync_services.dart';

import '../../../api/api.dart';
import '../../../data/app_data.dart';
import '../../../models/device_details.dart';
import '../../../services/authentication_services.dart';
import '../../../utils/utils.dart';

class LoginController extends GetxController {
  var isLogging = false.obs;
  var syncing = false.obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  RxBool isSecurePassword = true.obs;

  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          isSecurePassword.value = !isSecurePassword.value;
        },
        icon: Icon(isSecurePassword.value
            ? CupertinoIcons.eye_slash
            : CupertinoIcons.eye));
  }

  UserModel? user;

  Future<bool> initialRegistration() async {
    final result = await SyncRepository().registerDevice();
    return result.fold((data) async {
      DioResponse dioResponse = await SyncServices()
          .fetchDeviceDetails(userId: AppData().getUserID());
      if (dioResponse.hasError) {
        Utils().showToast(
            dioResponse.response?.data['message'] ?? 'Something went wrong');
        return false;
      }
      final deviceDetails = DeviceDetails.fromJson(dioResponse.response!.data);
      if (deviceDetails.result?.device?.billId == '0') {
        Utils().closableAlert(
          title: 'Device not configured',
          context: Get.context!,
          content:
              'Please configure your device before proceeding. Your device ID: ${AppData().getDeviceID()}',
        );
        return false;
      }
      return true;
    }, (error) {
      Utils().showToast(error);
      return false;
    });
  }

  @override
  void onInit() {
    isLogging.value = false;
    syncing(false);
    initialRegistration();
    super.onInit();
  }

  Future<bool> getCurrentData(String? id) async {
    String currentUserID = AppData().getUserID();
    if (currentUserID.isEmpty) return false;
    if (currentUserID == id) {
      Get.offNamedUntil(
        RoutesName.dashboard,
        (route) => false,
      );
      AppData().storeIsLoggedIn(true);
      return true;
    }
    bool clearData = await showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text('Another user already logged in'),
              content: Text(
                  'There is an another user logged in to the app. Logging in as new user will clear all existing data. Make sure to take backup before logging to save data.'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await AppData().clearData();
                      await DBFunctions().deleteDatabaseFile();
                      Get.back(result: false);
                    },
                    child: Text('Continue')),
                TextButton(
                    onPressed: () {
                      Get.back(result: true);
                    },
                    child: Text('Cancel')),
              ],
            );
          },
        ) ??
        false;
    AppData().storeIsLoggedIn(clearData);
    return clearData;
  }

  login() async {
    Utils.unfocus();
    Utils.hideKeyboard();
    if (!loginFormKey.currentState!.validate()) {
      Utils().cancelToast();
      isLogging.value = false;
      Utils().showToast('Please_check_your_details'.tr);
      return;
    }
    loginFormKey.currentState?.save();
    isLogging.value = true;
    AppData().storeCompanyID(idController.text.trim());
    Get.find<IDController>().companyID.value = idController.text.trim();
    bool deviceRegistered = await initialRegistration();
    if (!deviceRegistered) {
      isLogging.value = false;
      return;
    }
    DioResponse dioResponse = await AuthenticationService().login(
        username: userNameController.text.trim(),
        password: passwordController.text);
    if (dioResponse.hasError) {
      Utils().cancelToast();
      isLogging.value = false;
      Utils().showToast(dioResponse.dioError.response?.data['message'] ??
          'something_error'.tr);
      return;
    }
    bool success = dioResponse.response!.data['status'];
    if (!success) {
      isLogging.value = false;
      Utils().showToast(
          dioResponse.response?.data['message'] ?? 'Something went wrong');
      return;
    }
    if (dioResponse.response?.data['result'] == null) {
      isLogging.value = false;
      Utils().showToast(
          dioResponse.response?.data['message'] ?? 'Something went wrong');
      return;
    }
    user = UserModel.fromJson(dioResponse.response!.data['result']);
    if (user == null) {
      isLogging.value = false;
      return;
    }
    if (await getCurrentData(user?.id)) {
      isLogging.value = false;
      return;
    }
    isLogging.value = false;
    AppData().storeUserName(user?.userName ?? '');
    AppData().storeUserEmail(user?.userEmail ?? '');
    AppData().storeUserPhone(user?.userMobile ?? '');
    AppData().storeAddress(user?.userAddress ?? '');
    AppData().storeUserID(user?.id ?? '');
    AppData().storePassword(passwordController.text.trim());
    AppData().storeUser(user!.toJson());
    AppData().storeIsLoggedIn(true);
    if (AppData().getFirstTimeLaunching()) {
      List<String> disabledCategories = [
        '0',
        '1',
        '2',
        '3',
        '4',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13'
      ];
      AppData().storeDisabledMenuItems(disabledCategories);
      AppData().storeFirstTimeLaunching();
    }
    Get.put<DBController>(DBController());
    syncing.value = true;
  }
}
