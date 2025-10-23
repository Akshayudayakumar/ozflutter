import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/Constants/asset_constant.dart';
import 'package:ozone_erp/screens/splash/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AssetConstant.logo),
      ),
    );
  }
}
