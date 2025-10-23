import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/api/api.dart';
import 'package:ozone_erp/models/voucher_body.dart';

import '../controllers/id_controller.dart';

part '../repositories/voucher_repository.dart';

class VoucherServices {
  static final VoucherServices _voucherServices = VoucherServices._();

  factory VoucherServices() => _voucherServices;

  VoucherServices._();

  Future<DioResponse> createPaymentVoucher(VoucherBody details) async {
    Map<String, dynamic> form = details.toJson();
    List<Map<String, dynamic>> data = [form];
    return await DioConfig().dioPostCall(
        '${BackEnd.createPayment}/${Get.find<IDController>().companyID}', data);
  }
}
