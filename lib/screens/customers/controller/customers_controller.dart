import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/database/tables/export_insert.dart';
import 'package:ozone_erp/models/device_details.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/services/customer_services.dart';

class CustomersController extends GetxController {
  RxBool isSearching = false.obs;

  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> dropKey = GlobalKey<FormState>();

  @override
  void onInit() {
    getCustomers();
    getAreas();
    super.onInit();
  }

  void search() {
    isSearching.value = !isSearching.value;
  }

  List<Customers> customers = [];

  List<Customers> filteredCustomers = [];

  Future<void> updateCustomerLocation({
    required Customers customer,
    required double latitude,
    required double longitude,
  }) async {
    final updateCustomer = customer.copyWith(
        latitude: latitude.toString(), longitude: longitude.toString());
    await InsertCustomers().updateCustomer(updateCustomer);
    CustomerRepository().addCustomer(
        id: customer.id,
        name: customer.name ?? '',
        phone: customer.phone ?? '',
        address: customer.addressLine1 ?? '',
        gstNo: customer.gst ?? '',
        area: customer.area ?? '',
        priceList: customer.priceList ?? '',
        type: customer.type ?? '',
        customerRate: customer.customerRate ?? '',
        latitude: latitude,
        longitude: longitude,
        remarks: customer.remarks ?? '');
  }

  Future<void> getCustomers() async {
    customers = await InsertCustomers().getCustomers();
    final noNameCustomers = customers
        .where(
          (element) => element.name?.isEmpty ?? false,
    )
        .toList();
    final nameCustomers = customers
        .where(
          (element) => element.name?.isNotEmpty ?? false,
    )
        .toList();
    nameCustomers.sort((a, b) => (a.name?.compareTo(b.name ?? '') ?? 0));
    customers = [...nameCustomers, ...noNameCustomers];
    filteredCustomers = customers;
    update();
  }

  List<Area> areas = [];

  getAreas() async {
    areas = await InsertArea().getArea();
    update();
  }

  filterByArea(String area) {
    if (area == '-1') {
      filteredCustomers = customers;
    } else {
      filteredCustomers =
          customers.where((element) => element.area == area).toList();
    }
    update();
  }

  filterCustomers(String value) {
    String query = value.toLowerCase();
    if (value.isEmpty) {
      filteredCustomers = customers;
      return;
    }
    filteredCustomers = customers
        .where(
          (customer) =>
      (customer.name?.toLowerCase().contains(query) ?? false) ||
          (customer.id?.toLowerCase().contains(query) ?? false) ||
          (customer.branch?.toLowerCase().contains(query) ?? false) ||
          (customer.details?.toLowerCase().contains(query) ?? false) ||
          (customer.email?.toLowerCase().contains(query) ?? false) ||
          (customer.area?.toLowerCase().contains(query) ?? false) ||
          (customer.contactNumber?.toLowerCase().contains(query) ??
              false) ||
          (customer.contactPerson?.toLowerCase().contains(query) ??
              false) ||
          (customer.district?.toLowerCase().contains(query) ?? false) ||
          (customer.phone?.toLowerCase().contains(query) ?? false) ||
          (customer.pincode?.toLowerCase().contains(query) ?? false),
    )
        .toList();
    update();
  }
}
