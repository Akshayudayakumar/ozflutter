import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/voucher_body.dart';

import '../../../database/tables/export_insert.dart';
import '../../../models/customer_acc_model.dart';

class CustomerAccountController extends GetxController {
  List<CustomerAccModel> customerAccList = [];
  List<CustomerAccModel> fullCustomerAccList = [];
  TextEditingController controller = TextEditingController();
  List<VoucherBody> vouchersList = [];
  List<Customers> customers = [];

  @override
  void onInit() {
    getVouchers();
    super.onInit();
  }

  Future<void> getVouchers() async {
    vouchersList = await InsertVouchers().getAllVouchers();
    await getCustomers();
  }

  Future<void> getCustomers() async {
    customers = await InsertCustomers().getCustomers();
    getCusAcc();
  }

  void getCusAcc() {
    customerAccList = [];
    for (var customer in customers) {
      calculateAccount(customer);
    }
    fullCustomerAccList = customerAccList;
    update();
  }

  void calculateAccount(Customers customer) {
    final customerVouchers = vouchersList.where((v) => v.toid == customer.id);

    if (customerVouchers.isEmpty) return; // Skip customers with no transactions

    double paymentTotal = customerVouchers.fold(
        0,
        (sum, v) => v.type == VoucherTypes.payment
            ? sum + (double.tryParse(v.amount ?? '0') ?? 0)
            : sum);

    double receiptTotal = customerVouchers.fold(
        0,
        (sum, v) => v.type == VoucherTypes.receipt
            ? sum + (double.tryParse(v.amount ?? '0') ?? 0)
            : sum);

    customerAccList.add(CustomerAccModel(
      id: customer.id,
      name: customer.name,
      credit: receiptTotal.toStringAsFixed(2),
      debit: paymentTotal.toStringAsFixed(2),
      balance: getBalance(paymentTotal, receiptTotal),
    ));
  }

  String getBalance(double paymentTotal, double receiptTotal) {
    double amount = receiptTotal - paymentTotal;
    if (amount > 0)
      return '${amount.toStringAsFixed(2)} Cr'; // Customer has an advance (credit)
    if (amount < 0)
      return '${amount.abs().toStringAsFixed(2)} Dr'; // Customer still owes money (debit)
    return '0'; // No outstanding balance
  }

  void search(String value) {
    String query = value.toLowerCase();
    if (value.isEmpty) {
      customerAccList = fullCustomerAccList;
      update();
      return;
    }
    customerAccList = fullCustomerAccList
        .where(
          (element) =>
              (element.name?.toLowerCase().contains(query) ?? false) ||
              (element.debit?.toLowerCase().contains(query) ?? false) ||
              (element.credit?.toLowerCase().contains(query) ?? false) ||
              (element.balance?.toLowerCase().contains(query) ?? false) ||
              (element.id?.toLowerCase().contains(query) ?? false),
        )
        .toList();
    update();
  }
}
