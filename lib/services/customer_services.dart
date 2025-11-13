import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/services/location_services.dart';

import '../api/backend.dart';
import '../api/dio_config.dart';
import '../controllers/id_controller.dart';
import '../data/app_data.dart';

part '../repositories/customer_repository.dart';

class CustomerServices {
  static final CustomerServices _customerServices = CustomerServices._();

  factory CustomerServices() => _customerServices;

  CustomerServices._();

  Future<DioResponse> addCustomer({
    required String name,
    required String phone,
    required String address,
    required String gstNo,
    required String area,
    required String priceList,
    required String type,
    String? id,
    double? latitudeValue,
    double? longitudeValue,
    required String customerRate,
    required String remarks
  }) async {
    String latitude = '';
    String longitude = '';

    if (latitudeValue == null || longitudeValue == null) {
      final locationResult = await LocationRepository().getLocation();

      await locationResult.fold((data) {
        latitude = data.latitude.toString();
        longitude = data.longitude.toString();
      }, (error) {
        print('Error getting location: $error');
      });
    } else {
      latitude = latitudeValue.toString();
      longitude = longitudeValue.toString();
    }
    Map<String, String> formData = {
      "name": name,
      "phone": phone,
      "address": address,
      r"gstno": gstNo,
      r"devid": AppData().getDeviceID(),
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'area': area,
      'price_list': priceList,
      'customer_rate': customerRate,
      'remarks': remarks,
    };
    print('customer: $formData');
    if (id != null) {
      formData['id'] = id;
    }
    return await DioConfig().dioPostCall(
        '${BackEnd.customerReg}/${Get.find<IDController>().companyID}',
        formData);
  }
}
