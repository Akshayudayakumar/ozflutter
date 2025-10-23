import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/login/controller/login_controller.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';

import '../../../constants/constant.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<LoginController>(LoginController());
    return Scaffold(
      // appBar: customAppBar(
      //     title: 'OZONE ERP',
      //     color: Colors.grey.shade100,
      //     centerTitle: true,
      //     style: FontConstant.inter.copyWith(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 22,
      //     ),
      //     statusIconBrightness: Brightness.dark,
      //     actions: [
      //       PopupMenuButton(
      //         icon: Icon(
      //           Icons.more_vert,
      //           color: Colors.black,
      //         ),
      //         itemBuilder: (context) => [
      //           PopupMenuItem(
      //             child: const Text('Change Url'),
      //             onTap: () {
      //               changeUrlAlert(
      //                 context: context,
      //                 size: MediaQuery.of(context).size,
      //               );
      //             },
      //           )
      //         ],
      //       )
      //     ]),
      body: Stack(
        children: [
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: ClipPath(
          //     clipper: WavyClipper(),
          //     child: Container(
          //       height: 200,
          //       decoration: const BoxDecoration(
          //         gradient: LinearGradient(
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //           colors: [Color(0xFF0072B5), Color(0xFF68BCEB)],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(AssetConstant.clipper),
          ),
          const LoginView(),
          Obx(() {
            return controller.syncing.value
                ? Container(
                    height: SizeConstant.screenHeight,
                    width: SizeConstant.screenWidth,
                    alignment: Alignment.center,
                    color: Colors.black38,
                    child: Container(
                        height: SizeConstant.screenHeight * .1,
                        width: SizeConstant.screenWidth * .8,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Fetching data...'),
                          ],
                        )),
                  )
                : const SizedBox.shrink();
          })
        ],
      ),
    );
  }
}

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // Main container for the login view
      body: Container(
        width: double.infinity,
        height: SizeConstant.screenHeight,
        alignment: Alignment.center,
        // Allow scrolling if content overflows
        child: SingleChildScrollView(
          // Vertical arrangement of login elements
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding around the login form container
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConstant.screenHeight * .05),
                  width: SizeConstant.screenWidth,
                  child: Column(
                    children: [
                      // Container for the logo
                      Container(
                          padding: const EdgeInsets.all(35),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(0, 5),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16)),
                          child: Image.asset(AssetConstant.logo)),
                      SizedBox(
                        height: SizeConstant.screenHeight * .02,
                      ),
                      // Login form
                      Form(
                          key: controller.loginFormKey,
                          child: Column(
                            children: [
                              // Company ID text field
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  controller: controller.idController,
                                  validator: Utils.validateEmpty,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: Icon(
                                        Icons.quick_contacts_mail_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      hintText: 'Company ID'),
                                ),
                              ),
                              // Username text field
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  controller: controller.userNameController,
                                  validator: Utils.validateEmpty,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.person),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      hintText: 'Username'),
                                ),
                              ),
                              SizedBox(
                                height: SizeConstant.screenHeight * .01,
                              ),
                              // Password text field
                              Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Obx(
                                    () => TextFormField(
                                      controller: controller.passwordController,
                                      obscureText:
                                          controller.isSecurePassword.value,
                                      validator: Utils.validateEmpty,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          suffixIcon:
                                              controller.togglePassword(),
                                          prefixIcon:
                                              const Icon(Icons.password),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          hintText: 'Password'),
                                    ),
                                  )),
                            ],
                          )),
                      SizedBox(
                        height: SizeConstant.screenHeight * .02,
                      ),
                      // Login button
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Obx(
                          () => LoginButton(
                            onTap: () {
                              if (!controller.isLogging.value) {
                                controller.login();
                              }
                            },
                            colors: controller.isLogging.value
                                ? [Colors.grey[600]!, Colors.grey[600]!]
                                : null,
                            child: Text(
                              controller.isLogging.value
                                  ? 'Please wait...'
                                  : 'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
