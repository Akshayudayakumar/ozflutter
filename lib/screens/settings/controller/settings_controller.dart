import 'package:get/get.dart';
import 'package:ozone_erp/models/menu_item.dart';
import 'package:ozone_erp/models/settings_model.dart';
import 'package:ozone_erp/routes/routes_class.dart';

import '../../../components/menu_controller.dart';
import '../../../data/app_data.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/currency.dart';

class SettingsController extends GetxController {
  List<MenuItem> items = [];
  List<MenuItem> disabledCategories = [];
  bool multipleRate = false;
  bool taxView = false;
  bool cesView = false;
  bool returnMode = false;
  bool balanceView = false;
  bool addressView = false;
  bool currentStockView = false;
  bool sendSMS = false;
  bool syncOnSave = false;
  bool redeem = false;
  bool itemRepeat = false;
  bool billDiscount = false;
  bool collectionAmount = false;
  bool printPreview = false;
  bool printMRP = false;
  bool printHSN = false;
  String selectedSim = 'sim1';
  String cashType = 'Cash';
  String thermalPaper = '2';
  String billFormat = 'basic';
  String editDialog = 'basic';
  String pdfSize = 'A4';
  String currency = '2';
  String defaultQuantity = '1';
  String incrementQuantity = '1';
  late bool freeQuantity;
  List<Currency> currencies = [
    Currency(
      id: '1',
      code: 'USD',
      symbol: '\$',
      name: 'US Dollar',
    ),
    Currency(
      id: '2',
      code: 'INR',
      symbol: '₹',
      name: 'Indian Rupees',
    ),
    Currency(
      id: '3',
      code: 'EUR',
      symbol: '€',
      name: 'Euro',
    ),
    Currency(
        id: '4',
        code: 'AED',
        symbol: 'د.إ',
        name: 'United Arab Emirates Dirham'),
    Currency(
      id: '5',
      code: 'SAR',
      symbol: '﷼',
      name: 'Saudi Riyal',
    ),
  ];

  SettingsModel settings = AppData().getSettings();

  void saveSettings() {
    final setting = settings.copyWith(
      multipleRate: multipleRate,
      taxView: taxView,
      cesView: cesView,
      returnMode: returnMode,
      balanceView: balanceView,
      addressView: addressView,
      currentStockView: currentStockView,
      sendSMS: sendSMS,
      syncOnSave: syncOnSave,
      redeem: redeem,
      itemRepeat: itemRepeat,
      billDiscount: billDiscount,
      collectionAmount: collectionAmount,
      printPreview: printPreview,
      printMRP: printMRP,
      printHSN: printHSN,
      selectedSim: selectedSim,
      cashType: cashType,
      thermalPaper: thermalPaper,
      billFormat: billFormat,
      editDialog: editDialog,
      pdfSize: pdfSize,
      currency: currency,
      defaultQty: defaultQuantity,
      incrementQty: incrementQuantity,
    );
    AppData().storeSettings(setting);
  }

  void getSettings() {
    multipleRate = settings.multipleRate ?? multipleRate;
    taxView = settings.taxView ?? taxView;
    cesView = settings.cesView ?? cesView;
    returnMode = settings.returnMode ?? returnMode;
    balanceView = settings.balanceView ?? balanceView;
    addressView = settings.addressView ?? addressView;
    currentStockView = settings.currentStockView ?? currentStockView;
    sendSMS = settings.sendSMS ?? sendSMS;
    syncOnSave = settings.syncOnSave ?? syncOnSave;
    redeem = settings.redeem ?? redeem;
    itemRepeat = settings.itemRepeat ?? itemRepeat;
    billDiscount = settings.billDiscount ?? billDiscount;
    collectionAmount = settings.collectionAmount ?? collectionAmount;
    printPreview = settings.printPreview ?? printPreview;
    printMRP = settings.printMRP ?? printMRP;
    printHSN = settings.printHSN ?? printHSN;
    selectedSim = settings.selectedSim ?? selectedSim;
    cashType = settings.cashType ?? cashType;
    thermalPaper = settings.thermalPaper ?? thermalPaper;
    billFormat = settings.billFormat ?? billFormat;
    editDialog = settings.editDialog ?? editDialog;
    pdfSize = settings.pdfSize ?? pdfSize;
    currency = settings.currency ?? currency;
    defaultQuantity = settings.defaultQty ?? defaultQuantity;
    incrementQuantity = settings.incrementQty ?? incrementQuantity;
    update();
  }

  getItems() async {
    items = await InsertMenuItem().getMenuItem();
    items = items
        .where((element) =>
            element.route != RoutesName.settings &&
            element.route != RoutesName.login)
        .toList();
    disabledCategories = items
        .where(
            (element) => AppData().getDisabledMenuItems().contains(element.id))
        .toList();
    update();
  }

  addDisableCategories(MenuItem item) {
    if (disabledCategories.contains(item)) {
      disabledCategories.remove(item);
    } else {
      disabledCategories.add(item);
    }
    update();
  }

  updateDisabledCategories() {
    AppData()
        .storeDisabledMenuItems(disabledCategories.map((e) => e.id).toList());
    Get.delete<CustomMenuController>();
    Get.put<CustomMenuController>(CustomMenuController());
    update();
  }

  @override
  void onClose() {
    saveSettings();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    getItems();
    getSettings();
    freeQuantity = AppData().getFreeQuantity();
  }
}
