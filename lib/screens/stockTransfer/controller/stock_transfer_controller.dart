import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/change_url_alert.dart';
import 'package:ozone_erp/screens/sync/controller/sync_controller.dart';
import 'package:ozone_erp/utils/utils.dart';

import '../../../constants/constant.dart';
import '../../../database/controller/user_controller.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/device_details.dart';
import '../../../models/general_details.dart';

class StockTransferController extends GetxController {

  void onInit() {
    super.onInit();
    loadData();
  }

    Future<void> loadData() async{
      try {
        isLoading(true);
        await getItems();
        await getUnits();
        await getCategories();
        Get.put<UserController>(UserController());
        await InsertPriceListDetails().getPriceListDetails();
      } catch (e) {
        print(e.toString());
      } finally {
        isLoading(false);
      }
  }

  //basic variables
  int screenIndex = 0;
  Map<String, int> selectedQuantity = {};
  RxBool clearPrevious = false.obs;
  RxString sortValue = ''.obs;
  RxString filterValue = ''.obs;
  RxBool isLoading = false.obs;
  Unit unit = Unit();

  //TextControllers
  TextEditingController itemController = TextEditingController();

  //Lists initializer
  List<Unit> units = [];
  List<Items> salesItems = [];
  List<Items> addedItems = [];
  List<Items> searchItems = [];
  List<int> filterIndex = [];
  List<Category> categories = [];
  List<String> brands = [];

  List sortList = [
    {
      'value': 'name',
      'label': 'Name',
      'icon': Image.asset(
        AssetConstant.sortAZ,
        color: Colors.black38,
      )
    },
    {
      'value': 'srate',
      'label': 'Sales Rate',
      'icon': const Icon(Icons.currency_rupee)
    },
    {
      'value': 'quantity',
      'label': 'Quantity',
      'icon': const Icon(Icons.numbers)
    },
    {'value': 'mrp', 'label': 'MRP', 'icon': const Icon(Icons.currency_rupee)},
    {
      'value': 'category',
      'label': 'Category',
      'icon': const Icon(Icons.category)
    },
    {'value': 'type', 'label': 'Type', 'icon': const Icon(Icons.type_specimen)},
    {
      'value': 'brand',
      'label': 'Brand',
      'icon': Image.asset(
        AssetConstant.brand,
        color: Colors.black38,
      )
    },
    {
      'value': 'mfg',
      'label': 'Manufacturing date',
      'icon': const Icon(Icons.date_range)
    },
    {
      'value': 'exp',
      'label': 'Expiry Date',
      'icon': const Icon(Icons.date_range)
    },
  ];
  List reverseSortList = [
    {
      'value': 'name',
      'label': 'Name',
      'icon': Image.asset(
        AssetConstant.sortZA,
        color: Colors.black38,
      )
    },
    {
      'value': 'srate',
      'label': 'Sales Rate',
      'icon': const Icon(Icons.currency_rupee)
    },
    {
      'value': 'quantity',
      'label': 'Quantity',
      'icon': const Icon(Icons.numbers)
    },
    {'value': 'mrp', 'label': 'MRP', 'icon': const Icon(Icons.currency_rupee)},
    {
      'value': 'category',
      'label': 'Category',
      'icon': const Icon(Icons.category)
    },
    {'value': 'type', 'label': 'Type', 'icon': const Icon(Icons.type_specimen)},
    {
      'value': 'brand',
      'label': 'Brand',
      'icon': Image.asset(
        AssetConstant.brand,
        color: Colors.black38,
      )
    },
    {
      'value': 'mfg',
      'label': 'Manufacturing date',
      'icon': const Icon(Icons.date_range)
    },
    {
      'value': 'exp',
      'label': 'Expiry Date',
      'icon': const Icon(Icons.date_range)
    },
  ];

  //get Functions
  getUnits() async {
    units = await InsertUnit().getUnits();
    unit = units.first;
    update();
  }

  getCategories() async {
    categories = await InsertCategory().getCategory();
    update();
  }

  /// Retrieves a [Unit] object based on its [id].
  ///
  /// It searches through the `units` list. If a [Unit] with the matching [id] is found,
  /// that [Unit] is returned. Otherwise, a new empty [Unit] object is returned.
  Unit getUnitById(String id) {
    final unit =
        units.firstWhere((element) => element.id == id, orElse: () => Unit());
    return unit;
  }

  getItems() async {
    // Sets the loading state to true, indicating that data fetching is in progress.
    isLoading(true);

    // Asynchronously fetches the list of sales items from the database
    // using the `InsertItems().getItems()` method.
    salesItems = await InsertItems().getItems();

    // The following line is commented out. If uncommented, it would filter
    // the `salesItems` list to include only items where `itemQty` is not '0'.
    // salesItems = salesItems.where((element) => element.itemQty != '0').toList();

    // Sorts the `salesItems` list. The sorting logic compares `itemQty` in descending order.
    salesItems.sort((b, a) => (a.itemQty?.compareTo(b.itemQty ?? '0') ?? 0));
    // Initializes `searchItems` with the full list of `salesItems`. This list is likely used for search functionality.
    searchItems = salesItems;
    brands = salesItems.map((e) => e.brandId ?? '').toSet().toList();
    isLoading(false);
    update();
  }

  int getQuantity(String id) {
    return selectedQuantity[id] ?? 0;
  }

  //update functions
  updateScreenIndex(int value) {
    screenIndex = value;
    update();
  }

  updateFilterSelection(int index) {
    filterIndex.contains(index)
        ? filterIndex.remove(index)
        : filterIndex.add(index);
    update();
  }

  updatePreviousCheck(bool value) {
    clearPrevious(value);
  }

  //other functions

  void setItemQuantity({required Items item, required int quantity}) {
    if (quantity > double.parse(item.itemQty!)) {
      showAlert(
          context: Get.context!,
          title: 'Quantity exceeds',
          content:
              'Quantity exceeds items stock quantity. Saving this will only set the quantity as ${selectedQuantity[item.id!]}');
    } else {
      selectedQuantity[item.id!] = quantity;
    }
    update();
  }

  void addItem(Items item) {
    if (addedItems.contains(item)) {
      Utils().showToast('Item already in the cart');
    } else {
      if (selectedQuantity[item.id!] == null) {
        selectedQuantity.addAll({item.id!: 1});
      }
      addedItems.add(item);
    }
    update();
  }

  Future<void> updateStock() async {
    await Get.put(SyncController()).saveSync(SyncTypes.itemStock);
    getItems();
  }

  // void addToStock() async {
  //   if (clearPrevious.value) {
  //     await InsertItemStock().insertItemStock(addedItems, clearPrevious.value);
  //     await InsertItemStock().updateStockQuantity(selectedQuantity);
  //   } else {
  //     for (var item in addedItems) {
  //       final stockItems = await InsertItemStock().getItemStock();
  //       if (stockItems.any((element) => element.id == item.id)) {
  //         await InsertItemStock().updateStockItemQuantity(
  //             itemId: item.id ?? '', quantity: selectedQuantity[item.id!]!);
  //       } else {
  //         await InsertItemStock().insertItemStock([item], clearPrevious.value);
  //         await InsertItemStock().updateStockQuantity(selectedQuantity);
  //       }
  //     }
  //   }
  //   for (var item in addedItems) {
  //     item.itemQty =
  //         (double.parse(item.itemQty!) - (selectedQuantity[item.id!] ?? 0))
  //             .round()
  //             .toString();
  //     await InsertItems().updateItem(item);
  //   }
  //   clearStocks();
  //   update();
  // }

  void removeItem(Items item) {
    addedItems.remove(item);
    selectedQuantity.remove(item.id);
    update();
  }

  void searchItem(String query) {
    searchItems = salesItems
        .where((item) =>
            item.name!.toLowerCase().contains(query.trim().toLowerCase()))
        .toList();
    update();
  }

  clearStocks() {
    addedItems.clear();
    selectedQuantity.clear();
    update();
  }
}
