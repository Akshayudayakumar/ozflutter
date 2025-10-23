import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ozone_erp/data/app_data.dart';

import 'app/app.dart';
import 'components/menu_controller.dart';
import 'connection/connection.dart';
import 'constants/constant.dart';
import 'controllers/id_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 1000));

  // Specifies the set of orientations the application interface can be displayed in.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
   // DeviceOrientation.landscapeLeft,
  //  DeviceOrientation.landscapeRight
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: AppStyle.whiteColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppStyle.whiteColor,
        systemNavigationBarIconBrightness: Brightness.dark),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

  // Application internet connectivity check.
  Connection.configureConnectivityStream();

  //Initialize GetStorage
  await GetStorage.init();

  if (AppData().getDeviceID().isEmpty) {
    await AppData().storeDeviceId();
  }

  //Initialize Menu
  Get.put<CustomMenuController>(CustomMenuController());
  Get.put<IDController>(IDController());

  //runs app
  runApp(const MyApp());
}
