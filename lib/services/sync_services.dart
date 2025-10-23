import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/api/api.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/models/stock_update.dart';

import '../controllers/id_controller.dart';

part '../repositories/sync_repository.dart';

// The `SyncServices` class handles API calls related to device synchronization,
// fetching details, and registering the device.
class SyncServices {
  // This creates a single, private, static instance of `SyncServices`.
  // The `_` makes it a private constructor, meaning it can only be called from within this file.
  static final SyncServices _syncService = SyncServices._();

  // This is a factory constructor. When you call `SyncServices()`, it doesn't create a new instance.
  // Instead, it always returns the single `_syncService` instance created above.
  // This pattern is known as the Singleton pattern, ensuring there's only one instance of `SyncServices` in the entire app.
  factory SyncServices() => _syncService;

  // This is the private constructor. It's named with a `_` to prevent creating new instances
  // from outside this class, enforcing the Singleton pattern.
  SyncServices._();

  // This asynchronous method fetches device-specific details from the backend.
  Future<DioResponse> fetchDeviceDetails({required String userId}) async {
    Map<String, String> formData = {}; // Initialize an empty map for the request body.
    // Retrieve the unique device ID using a helper class.
    final deviceId = AppData().getDeviceID();
    // Conditionally build the request payload.
    // If a `userId` is provided, include both the device ID and the user ID.
    if (userId.isNotEmpty) {
      formData = {"devid": deviceId, "login_user_id": userId};
    } else {
      // Otherwise, only include the device ID.
      formData = {"devid": deviceId};
    }
    // Make a POST request using a configured Dio instance (`DioConfig`).
    // The URL is constructed using a base path (`BackEnd.deviceDetails`) and the current company ID.
    return await DioConfig().dioPostCall(
        '${BackEnd.deviceDetails}/${Get.find<IDController>().companyID}',
        formData);
  }

  Future<DioResponse> fetchGeneralDetails() async {
    Map<String, String> formData = {"devid": AppData().getDeviceID()};
    return await DioConfig().dioPostCall(
        '${BackEnd.generalDetails}/${Get.find<IDController>().companyID}',
        formData);
  }

  Future<DioResponse> fetchStock() async {
    DateTime now = DateTime.now();
    String date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    Map<String, String> formData = {
      "devid": AppData().getDeviceID(),
      "date": date,
    };
    return await DioConfig().dioPostCall(
        '${BackEnd.updateStock}/${Get.find<IDController>().companyID}',
        formData);
  }

  Future<DioResponse> registerDevice() async {
    final device = await AppData().storeDeviceId();
    Map<String, String> formData = {"devid": device ?? ''};
    return await DioConfig().dioPostCall(
        '${BackEnd.deviceRegister}/${Get.find<IDController>().companyID}',
        formData);
  }
}
