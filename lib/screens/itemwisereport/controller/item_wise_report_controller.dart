import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/sales_body.dart';
import '../../../database/tables/export_insert.dart';

class ItemWiseReportController extends GetxController {

  TextEditingController searchController = TextEditingController();
  RxList<SalesBody> salesBody = <SalesBody>[].obs;
  RxList<Items> items = <Items>[].obs;
  RxList<SalesBody> filteredSalesBody = <SalesBody>[].obs;

  @override
  void onInit() {
    getSalesBody();
    super.onInit();
  }

  getSalesBody() async {
    salesBody.value = await InsertSalesBody().getSalesBodyByType('sales');
    items.value = await InsertItems().getItems();
    initList();
    update();
  }

  initList() {
    filteredSalesBody.clear();
    for(var body in salesBody) {
      for(var item in body.salesitems ?? <SalesItems>[]) {
        filteredSalesBody.add(body);
      }
    }
  }


  void search(String query) {

  }
}