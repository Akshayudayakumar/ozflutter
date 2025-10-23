import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/api/api.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/models/sales_response.dart';

import '../controllers/id_controller.dart';

part '../repositories/sales_repository.dart';

class SalesServices {
  static final SalesServices _salesServices = SalesServices._();

  factory SalesServices() => _salesServices;

  SalesServices._();

  Future<DioResponse> createSales(SalesBody sales) async {
    List<Map<String, dynamic>> data = [
      sales.copyWith(id: '0', salesId: '0').toJson()
    ];
    return await DioConfig().dioPostCall(
        '${BackEnd.createSales}/${Get.find<IDController>().companyID}', data);
  }
}
