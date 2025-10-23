import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/models/sales_body.dart';

import '../../../constants/constant.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/general_details.dart';

class FullStockController extends GetxController {

  /// Adds a scroll listener to the `inventoryController`.
  /// This listener checks if the user has scrolled to the bottom of the list.
  /// If the current scroll position (`inventoryController.position.pixels`)
  /// is greater than or equal to the maximum scroll extent (`inventoryController.position.maxScrollExtent`),
  /// it means the user has reached the end of the scrollable area.
  /// In this case, the `itemLengthIncrease()` function is called to load more items.
  void addScrollListener() {
    inventoryController.addListener(() {
      if (inventoryController.position.pixels >=
          inventoryController.position.maxScrollExtent) {
        itemLengthIncrease();
      }
    });
  }

  /// This method is called when the controller is initialized.
  ///
  /// It performs the following actions:
  /// 1. `addScrollListener()`: Sets up the scroll listener for infinite scrolling.
  /// 2. `getProducts()`: Fetches the initial list of products.
  /// 3. `getSales()`: Fetches the sales data.
  @override
  void onInit() {
    addScrollListener();
    getProducts();
    getSales();
    super.onInit();
  }

  /// This method is called when the controller is disposed (removed from memory).
  ///
  /// It ensures that the `inventoryController` is properly disposed to free up resources
  /// and prevent potential memory leaks.
  @override
  void dispose() {
    inventoryController.dispose();
    super.dispose();
  }

  TextEditingController searchController = TextEditingController();
  ScrollController inventoryController = ScrollController();
  int itemLength = 10;
  List<Items> products = [];
  List<Items> filteredProducts = [];
  List<SalesBody> sales = [];
  int index = 0;
  double lineWidth = 0;
  int screenIndex = 0;
  bool isLower = false;
  // RxDouble salesValue = 0.0.obs;

  /// Increases the `itemLength` by 10 if there are more products to display.
  ///
  /// This function is typically called when the user scrolls to the bottom of the list,
  /// triggering the loading of more items for an "infinite scrolling" effect.
  /// It checks if the current `itemLength` is less than the total number of `products`.
  /// If so, it increments `itemLength` by 10 and calls `update()` to notify listeners (e.g., UI) to rebuild.
  void itemLengthIncrease() {
    if (itemLength < products.length) {
      itemLength += 10;
      update();
    }
  }

  /// Updates the `screenIndex` to the provided `index` and notifies listeners.
  ///
  /// This is likely used to switch between different views or tabs within the stock screen.
  /// After updating `screenIndex`, it calls `update()` to trigger a UI rebuild.
  void updateScreenIndex(int index) {
    screenIndex = index;
    update();
  }

  /// Updates the `lineWidth` after a short delay.
  ///
  /// It waits for 100 milliseconds and then sets `lineWidth` to the width of the screen (`SizeConstant.screenWidth`).
  /// This might be used for layout adjustments or animations that depend on the screen width.
  updateLineWidth() {
    Future.delayed(const Duration(milliseconds: 100), () {
      lineWidth = SizeConstant.screenWidth;
      update();
    });
  }

  /// Sets the current `index` if it's different from the new `index` and notifies listeners.
  ///
  /// This is likely used to track the currently selected item or tab.
  /// It avoids unnecessary updates by only calling `update()` if the index has actually changed.
  void setIndex(int index) {
    if (this.index != index) {
      this.index = index;
      update();
    }
  }

  /// Fetches the list of products from the database.
  ///
  /// It asynchronously retrieves items using `InsertItems().getItems()`.
  /// The fetched items are stored in both `products` (the complete list)
  /// and `filteredProducts` (initially the same as `products`, likely used for search/filtering).
  /// Finally, it calls `update()` to refresh the UI with the new data.
  Future<void> getProducts() async {
    products = await InsertItems().getItems();
    filteredProducts = products;
    update();
  }

  /// Fetches sales data from the database.
  ///
  /// It asynchronously retrieves sales body data using `InsertSalesBody().getSalesBody()`.
  /// The fetched data is stored in the `sales` list.
  /// Finally, it calls `update()` to refresh any UI elements that depend on sales data.
  Future<void> getSales() async {
    sales = await InsertSalesBody().getSalesBody();
    update();
  }

  /// Calculates the total asset value from a list of `Items`.
  ///
  /// It iterates through the provided `items` list. For each item,
  /// it multiplies the item's MRP (Maximum Retail Price) by its quantity.
  /// The sum of these values for all items is returned as the total asset value.
  double calculateAsset(List<Items> items) {
    double sum = 0;
    for (var item in items) {
      sum += (double.parse(item.mrp!) * (double.parse(item.itemQty!)));
    }
    return sum;
  }

}