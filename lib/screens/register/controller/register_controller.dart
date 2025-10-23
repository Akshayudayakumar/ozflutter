import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/database/tables/deviceDetails/insert_sales_orders.dart';
import 'package:ozone_erp/database/tables/payment/insert_payment.dart';
import 'package:ozone_erp/database/tables/syncStatus/sales_body_sync.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/payment_model.dart';
import 'package:ozone_erp/models/sales_body.dart';

import '../../../database/tables/generalDetails/insert_items.dart';
import '../../../database/tables/salesBody/insert_sales_body.dart';
import '../../../utils/date_converter.dart';

class RegisterController extends GetxController {
  //init Function
  @override
  void onInit() {
    getAllItems();
    getSalesBody();
    super.onInit();
  }

  //Basic Variables
  RxBool showDate = false.obs;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  //List variables
  List<SalesBody> salesBody = [];
  List<SalesBody> salesItems = [];
  List<SalesBody> filteredSalesItems = [];
  List<SalesBody> orderItems = [];
  List<SalesBody> filteredOrderItems = [];
  List<Items> allItems = [];
  List<Map<String, dynamic>> syncStatus = [];
  List<SalesBody> salesReturnItems = [];
  List<SalesBody> filteredSalesReturnItems = [];
  List<SalesOrders> salesOrders = [];
  RxList<PaymentModel> payments = <PaymentModel>[].obs;

  //Get Functions

  Future<void> getSalesBody() async {
    salesBody = await InsertSalesBody().getSalesBody();
    syncStatus = await SalesBodySync().getSalesBodySync();
    await getSalesOrders();
    for (var item in salesBody) {
      Map<String, dynamic>? sync =
          await SalesBodySync().getSalesBodySyncById(item.id!);
      if (sync == null) {
        await SalesBodySync().insertSalesBodySync(id: item.id!, status: 0);
      }
    }
    await getPayments();
    getSalesItems();
    getOrderItems();
    getSalesReturnItems();
    update();
  }

  Map<String, dynamic>? getSyncStatusById(String id) {
    final items = syncStatus.where((element) => element['id'] == id).toList();
    return items.isEmpty ? null : items.first;
  }

  void getSalesItems() {
    final body = salesBody.where((element) => element.type == 'sales').toList();
    salesItems = body.reversed.toList();
    filteredSalesItems = salesItems;
    update();
  }

  void getOrderItems() {
    final body =
        salesBody.where((element) => element.type == 'sales-order').toList();
    orderItems = body.reversed.toList();
    filteredOrderItems = orderItems;
    update();
  }

  void getSalesReturnItems() {
    final body =
        salesBody.where((element) => element.type == 'sales-return').toList();
    salesReturnItems = body.reversed.toList();
    filteredSalesReturnItems = salesReturnItems;
    update();
  }

  Future<void> getAllItems() async {
    allItems = await InsertItems().getItems();
    update();
  }

  Future<void> getSalesOrders() async {
    salesOrders = await InsertSalesOrders().getSalesOrders();
  }

  Future<void> getPayments() async {
    payments.value = await InsertPayment().getPayments();
  }

//Update Functions

//Other Functions

  filterSalesItemsByDate() {
    filteredSalesItems = salesItems.where((element) {
      final date = DateConverter.parseCustomDateTime(element.createdDate!);
      return (date.isAfter(startDate!) ||
              (date.day == startDate!.day &&
                  date.month == startDate!.month &&
                  date.year == startDate!.year)) &&
          (date.isBefore(endDate!) ||
              (date.day == endDate!.day &&
                  date.month == endDate!.month &&
                  date.year == endDate!.year));
    }).toList();
    filteredOrderItems = orderItems.where((element) {
      final date = DateConverter.parseCustomDateTime(element.createdDate!);
      return (date.isAfter(startDate!) ||
              (date.day == startDate!.day &&
                  date.month == startDate!.month &&
                  date.year == startDate!.year)) &&
          (date.isBefore(endDate!) ||
              (date.day == endDate!.day &&
                  date.month == endDate!.month &&
                  date.year == endDate!.year));
    }).toList();
    filteredSalesReturnItems = salesReturnItems.where((element) {
      final date = DateConverter.parseCustomDateTime(element.createdDate!);
      return (date.isAfter(startDate!) ||
              (date.day == startDate!.day &&
                  date.month == startDate!.month &&
                  date.year == startDate!.year)) &&
          (date.isBefore(endDate!) ||
              (date.day == endDate!.day &&
                  date.month == endDate!.month &&
                  date.year == endDate!.year));
    }).toList();
    update();
  }

  // Edit Screen Functionality
}
