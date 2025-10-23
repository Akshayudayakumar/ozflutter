import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/database/tables/export_insert.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/sale_types.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/models/voucher_body.dart';
import 'package:ozone_erp/screens/dashboard/screens/analytics_screen.dart';
import 'package:ozone_erp/screens/dashboard/screens/sales_details_screen.dart';
import 'package:ozone_erp/screens/dashboard/screens/stock_screen.dart';
import 'package:ozone_erp/utils/date_converter.dart';

enum SelectedType { sales, salesOrder, salesReturn, collection }

class DashBoardController extends GetxController {
  @override
  void onInit() {
    getProducts();
    getSales(true);
    super.onInit();
  }

  void addScrollListener() {
    inventoryController.addListener(() {
      if (inventoryController.position.pixels >=
          inventoryController.position.maxScrollExtent) {
        itemLengthIncrease();
      }
    });
  }

  @override
  void dispose() {
    inventoryController.dispose();
    super.dispose();
  }

  TextEditingController searchController = TextEditingController();
  ScrollController inventoryController = ScrollController();

  List<Items> products = [];
  List<Items> filteredProducts = [];
  List<SalesBody> allSales = [];
  List<SalesBody> everySales = [];
  List<SalesBody> sales = [];
  List<SalesBody> salesOrder = [];
  List<SalesBody> salesReturn = [];
  List<SalesBody> lastMonthSales = [];
  List<SalesBody> lastWeekSales = [];
  List<VoucherBody> paymentVouchers = [];
  List<VoucherBody> receiptVouchers = [];
  int index = 0;
  double lineWidth = 0;
  int screenIndex = 0;
  bool isLower = false;
  RxDouble salesValue = 0.0.obs;
  RxBool showDateChanger = false.obs;
  int itemLength = 10;
  Rx<SelectedType> selectedType = SelectedType.sales.obs;
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void filterByDate() {
    allSales = everySales
        .where(
          (element) =>
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isAfter(startDate.value) &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isBefore(endDate.value),
        )
        .toList();
    sales = allSales
        .where(
          (element) =>
              element.type == SaleTypes.sales &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isAfter(startDate.value) &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isBefore(endDate.value),
        )
        .toList();
    salesReturn = allSales
        .where(
          (element) =>
              element.type == SaleTypes.salesReturn &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isAfter(startDate.value) &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isBefore(endDate.value),
        )
        .toList();
    salesOrder = allSales
        .where(
          (element) =>
              element.type == SaleTypes.salesOrder &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isAfter(startDate.value) &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isBefore(endDate.value),
        )
        .toList();
    calculateValue(allSales
        .where(
          (element) =>
              element.type == getSelectedType() &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isAfter(startDate.value) &&
              DateConverter.parseCustomDateTime(element.createdDate!)
                  .isBefore(endDate.value),
        )
        .toList());
    lastMonthSales = sales
        .where((element) =>
            DateConverter.parseCustomDateTime(element.createdDate!)
                .isAfter(startDate.value) &&
            DateConverter.parseCustomDateTime(element.createdDate!)
                .isBefore(endDate.value))
        .toList();
    lastWeekSales = sales
        .where((element) =>
            DateConverter.parseCustomDateTime(element.createdDate!)
                .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
    calculateCollection();
    update();
  }

  List<Widget> screens = [
    const SalesDetailsScreen(),
    const StockScreen(),
    const AnalyticsScreen(),
    const Scaffold(),
  ];

  void updateScreenIndex(int index) {
    screenIndex = index;
    update();
  }

  updateLineWidth() {
    Future.delayed(const Duration(milliseconds: 100), () {
      lineWidth = SizeConstant.screenWidth;
      update();
    });
  }

  void itemLengthIncrease() {
    if (itemLength < products.length) {
      itemLength += 10;
      update();
    }
  }

  void setIndex(int index) {
    if (this.index != index) {
      this.index = index;
      update();
    }
  }

  void setSelectedType(SelectedType type) {
    selectedType(type);
    getSales();
  }

  Future<void> getProducts() async {
    products = await InsertItems().getItems();
    filteredProducts = products;
    update();
  }

  String getSelectedType() {
    switch (selectedType.value) {
      case SelectedType.sales:
        return 'sales';
      case SelectedType.salesOrder:
        return 'sales-order';
      case SelectedType.salesReturn:
        return 'sales-return';
      case SelectedType.collection:
        return 'collection';
    }
  }

  Future<void> getSales([bool getAll = false]) async {
    if (getAll) {
      everySales = await InsertSalesBody().getSalesBody();
      paymentVouchers =
          await InsertVouchers().getVoucherByType(VoucherTypes.payment);
      receiptVouchers =
          await InsertVouchers().getVoucherByType(VoucherTypes.receipt);
      allSales = everySales;
    }
    sales = allSales
        .where(
          (element) => element.type == 'sales',
        )
        .toList();
    salesReturn = allSales
        .where(
          (element) => element.type == 'sales-return',
        )
        .toList();
    salesOrder = allSales
        .where(
          (element) => element.type == 'sales-order',
        )
        .toList();
    calculateValue(allSales.isEmpty
        ? []
        : allSales
            .where(
              (element) => element.type == getSelectedType(),
            )
            .toList());
    lastMonthSales = sales
        .where(
          (element) => DateConverter.parseCustomDateTime(element.createdDate!)
              .isAfter(DateTime.now().subtract(const Duration(days: 31))),
        )
        .toList();
    lastWeekSales = sales
        .where(
          (element) => DateConverter.parseCustomDateTime(element.createdDate!)
              .isAfter(DateTime.now().subtract(const Duration(days: 8))),
        )
        .toList();
    calculateCollection();
    update();
  }

  Timer? timer;
  calculateValue(List<SalesBody> sales) {
    timer?.cancel();
    timer = null;
    salesValue(0.0);
    double value = 0.0;
    for (var sale in sales) {
      value += double.parse(sale.total ?? '0');
      // for (var item in sale.salesitems ?? <SalesItems>[]) {
      //   value += (double.parse(item.mrp.toString()) *
      //       (double.parse(item.quantity!)));
      // }
    }
    if (selectedType.value == SelectedType.collection) {
      value = collectedAmount.value;
    }
    final Duration _duration =
        Duration(milliseconds: 500); // Total duration for animation
    final Duration _tickDuration =
        Duration(milliseconds: 10); // Duration for each tick
    final totalTicks = _duration.inMilliseconds / _tickDuration.inMilliseconds;
    double increment = value / totalTicks;
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (salesValue.value < value) {
        salesValue.value += increment;
      } else if (salesValue.value == value) {
        timer.cancel();
      }
    });
  }

  double calculateAsset(List<Items> items) {
    double sum = 0;
    for (var item in items) {
      sum += (double.parse(item.mrp!) * (double.parse(item.itemQty!)));
    }
    return sum;
  }

  double calculateProfit() {
    if (lastMonthSales.isEmpty) return 0;
    double profit = 0;
    for (var sale in lastMonthSales) {
      for (var item in sale.salesitems ?? <SalesItems>[]) {
        profit += ((item.mrp!) * (double.parse(item.quantity!))) -
            double.parse(item.discount ?? '0') -
            (double.parse(item.prate.toString()) *
                (double.parse(item.quantity!)));
      }
    }
    return profit;
  }

  double calculateProfitPercentage(double profit) {
    double asset = 0;
    for (var sale in lastMonthSales) {
      for (var item in sale.salesitems ?? <SalesItems>[]) {
        asset += (double.parse(item.rate.toString()) *
            (double.parse(item.quantity!)));
      }
    }
    if (lastMonthSales.isEmpty) return 0;
    return (profit / asset) * 100;
  }

  double calculateLastWeekProfitPercentage() {
    double profit = 0;
    double asset = 0;
    if (lastWeekSales.isEmpty) return 0;
    for (var sale in lastWeekSales) {
      for (var item in sale.salesitems ?? <SalesItems>[]) {
        profit += (item.mrp! * double.parse(item.quantity!)) -
            double.parse(item.discount ?? '0') -
            (double.parse(item.prate.toString()) *
                (double.parse(item.quantity!)));
        asset += (double.parse(item.rate.toString()) *
            (double.parse(item.quantity!)));
      }
    }
    return (profit / asset) * 100;
  }

  Map<int, String> weekDays = {
    DateTime.sunday: 'Sun',
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
    DateTime.saturday: 'Sat',
  };

  Map<String, double> calculateLastWeekProfit() {
    Map<String, double> map = {};
    if (lastWeekSales.isEmpty) return {};
    for (var sale in lastWeekSales) {
      double profit = 0;
      double asset = 0;
      for (var item in sale.salesitems ?? <SalesItems>[]) {
        profit += ((item.mrp!) * (double.parse(item.quantity!))) -
            (double.parse(item.prate.toString()) *
                (double.parse(item.quantity!)));
        asset += (double.parse(item.rate.toString()) *
            (double.parse(item.quantity!)));
      }
      map[weekDays[DateConverter.parseCustomDateTime(sale.createdDate!)
          .weekday]!] = (profit / asset) * 100;
    }
    return map;
  }

  RxDouble collectedAmount = 0.0.obs;
  RxDouble totalCollection = 0.0.obs;

  void calculateCollection() {
    collectedAmount(0.0);
    totalCollection(0.0);
    for (var sale in sales) {
      totalCollection.value += double.parse(sale.total ?? '0');
      if (sale.cashType?.toLowerCase() == 'cash') {
        collectedAmount.value += double.parse(sale.total ?? '0');
      }
    }
    for (var sale in salesReturn) {
      totalCollection.value -= double.parse(sale.total ?? '0');
      if (sale.cashType?.toLowerCase() == 'cash') {
        collectedAmount.value -= double.parse(sale.total ?? '0');
      }
    }
    for (var voucher in paymentVouchers) {
      collectedAmount.value -= double.parse(
          (voucher.amount?.isEmpty ?? true) ? '0' : voucher.amount ?? '0');
    }
    for (var voucher in receiptVouchers) {
      collectedAmount.value += double.parse(
          (voucher.amount?.isEmpty ?? true) ? '0' : voucher.amount ?? '0');
    }
  }
}
