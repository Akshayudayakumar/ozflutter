import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/database/tables/transaction/txn_operations.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/models/payment_model.dart';
import 'package:ozone_erp/models/sale_types.dart';
import 'package:ozone_erp/models/sales_body.dart' as sales_body;
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/services/location_services.dart';
import 'package:ozone_erp/utils/common_calculations.dart';
import '../../../components/change_url_alert.dart';
import '../../../database/controller/user_controller.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/device_details.dart';
import '../../../models/settings_model.dart';
import '../../../models/voucher_body.dart';
import '../../../services/sales_service.dart';
import '../../../services/voucher_services.dart';
import '../../../utils/utils.dart';

class NewSaleController extends GetxController
    with GetSingleTickerProviderStateMixin {

  @override
  void onInit() {
    // This is the initialization method for the NewSaleController, which is part of the GetX lifecycle.
    // It's called automatically when the controller is first created and allocated to memory.

    // Sets the 'loading' reactive variable to false, indicating that no data loading is in progress.
    loading(false);
    // Sets the 'selling' reactive variable to an empty string, clearing any status message related to the sale process.
    selling('');
    // Asynchronously fetches all available item/product data from the local database.
    getItems();
    // Asynchronously fetches all available measurement units (e.g., kg, pcs) from the local database.
    getUnits();
    // Asynchronously fetches all available product categories from the local database.
    getCategories();
    // Initializes and registers an instance of UserController with GetX for dependency management, making it accessible throughout the app.
    Get.put<UserController>(UserController());
    // Fetches price list details from the local database.
    InsertPriceListDetails().getPriceListDetails();
    // Adds a listener to the 'payableAmount' text controller to call the '_updateWidth' method whenever its content changes. This is likely for dynamically adjusting the UI.
    payableAmount.addListener(_updateWidth);
    // Adds a listener to the 'scrollController' to call '_updateItemLength' when scrolling occurs, used for implementing infinite scrolling or lazy loading of items.
    scrollController.addListener(_updateItemLength);
    // Loads any previously saved shopping cart data (items, quantities, customer) from local storage, allowing the user's session to be restored.
    loadCartFromStorage();
    // Calls the onInit method of the parent class (GetxController) to ensure its initialization logic is also executed.
    super.onInit();
  }


  @override
  void dispose() {
    payableAmount.removeListener(_updateWidth);
    scrollController.removeListener(_updateItemLength);
    super.dispose();
  }

  @override
  void onClose() {
    payableAmount.removeListener(_updateWidth);
    scrollController.removeListener(_updateItemLength);
    super.onClose();
  }

 
  int screenIndex = 0;
  var selectedCustomer = Customers().obs;
  double textFieldWidth = 25; // Initial width
  String radioValue = AppData().getSettings().cashType ?? 'Cash';
  String paymentMethod = 'upi';
  bool gstType = AppData().getTaxInclude();
  Rx<Items> selectedItem = Items().obs;
  RxDouble grandTotal = 0.0.obs;
  Map<String, int> selectedQuantity = {};
  Map<String, int> realQuantity = {};
  Map<String, double> discount = {};
  RxBool loading = false.obs;
  RxBool clearing = false.obs;
  RxString selling = ''.obs;
  RxString sortValue = ''.obs;
  RxString filterValue = ''.obs;
  String? bodyInvoice;
  Unit unit = Unit();
  sales_body.SalesBody? salesBody;
  List<Billnumber> billNumbers = [];
  Billnumber billNumber = Billnumber();
  List<Billnumber> salesBills = [];
  PriceList priceList = PriceList();
  int showItems = 10;
  SettingsModel settings = AppData().getSettings();
  Map<String, dynamic>? bodyJson = Get.arguments;

  
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController payableAmount = TextEditingController(text: '0.0');
  TextEditingController discountController = TextEditingController(text: '0');
  TextEditingController transactionController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  
  ScrollController scrollController = ScrollController();

  
  List<Unit> units = [];
  List<Items> salesItems = [];
  RxList<Items> addedItems = <Items>[].obs;
  List<Items> searchItems = [];
  List<int> filterIndex = [];
  List<String> brands = [];
  List<Category> categories = [];
  List<Tax> taxes = [];

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

  FocusNode focusNode = FocusNode();

 
  Future<void> getUnits() async {
    units = await InsertUnit().getUnits();
    unit = units.first;
    update();
  }

  Future<void> getCategories() async {
    categories = await InsertCategory().getCategory();
    update();
  }

  Unit getUnitById(String id) {
    final unit = units.firstWhere((element) => element.unitId == id,
        orElse: () => Unit());
    return unit;
  }

  void getPayableAmount() {
    payableAmount.text = Utils().roundWithFixedDecimal(grandTotal.value);
    update();
  }

  Future<void> getItems() async {
    try {
      loading(true);

    
      salesItems = await InsertItems().getItems();

      
      salesItems.sort((b, a) => (a.itemQty ?? '').compareTo(b.itemQty ?? ''));

      
      searchItems = salesItems;

      
      brands = salesItems.map((e) => e.brandId!).toSet().toList();

      for (var item in salesItems) {
        realQuantity[item.id ?? '0'] = int.parse(item.itemQty ?? '0');
      }
      await getBillNumbers();
      await getAllTax();
      await bodyToItems();
    } catch (e) {
     
      print('Error fetching items: $e');
    } finally {
      
      if (Get.isRegistered<NewSaleController>()) {
        loading(false);
        update();
      }
    }
  }

  Future<void> getBillNumbers() async {
    billNumbers = await InsertBillNumber().getBillNumber();
    billNumber = billNumbers.firstWhere(
        (element) => element.transaction == 'sales',
        orElse: () => Billnumber());
    salesBills.addAll([billNumber]);
    update();
  }

  Future<void> getAllTax() async {
    taxes = await InsertTax().getTax();
  }

  Tax getTaxById(String id) {
    final tax =
        taxes.firstWhere((element) => element.gstid == id, orElse: () => Tax());
    return tax;
  }

  Future<void> bodyToItems() async {
    if (bodyJson == null) return;
    sales_body.SalesBody body = sales_body.SalesBody.fromJson(bodyJson!);
    bodyInvoice = body.invoice;
    radioValue = body.cashType ?? radioValue;
    selectedCustomer.value =
        await InsertCustomers().getCustomerById(body.customerId ?? '');
    addedItems.value = List.generate(
      body.salesitems?.length ?? 0,
      (index) {
        final item = salesItems.firstWhere(
            (element) => element.id == body.salesitems?[index].itemId,
            orElse: () => Items());
        final salesItem = body.salesitems?[index];
        return item.copyWith(
            srate: salesItem?.rate?.toString(), itemQty: salesItem?.quantity);
      },
    );
    updateGrandTotal();
  }

  
  updateScreenIndex(int value) {
    screenIndex = value;
    update();
  }

  void updateBillType(String id) {
    billNumber = billNumbers.firstWhere((element) => element.id == id,
        orElse: () => Billnumber());
    update();
  }

  void updateRadioValue(String value) {
    radioValue = value;
    update();
  }

  void _updateWidth() {
    final text = payableAmount.text;

    
    final textPainter = TextPainter(
      text: TextSpan(
        text: text.isEmpty ? '0.0' : text, 
        style: const TextStyle(fontSize: 16), 
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textFieldWidth = textPainter.size.width >= 50
        ? 50
        : textPainter.size.width + 5;
    update();
  }

  void _updateItemLength() {
    if (showItems < searchItems.length) {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        showItems += 10;
      }
    }
  }

  void updateGstType(bool value) {
    gstType = value;
    updateGrandTotal();
    update();
  }

  void updateGrandTotal() {
    if (addedItems.isEmpty) {
      grandTotal.value = 0.0;
      return;
    }
    grandTotal.value = 0.0;
    grandTotal.value = addedItems
        .map((e) => CommonCalculations.calculateTotalRate(
                rate: (double.parse(e.srate ?? '0') *
                        double.parse(e.itemQty ?? '0'))
                    .toString(),
                discount: e.priceDiscount ?? '0',
                tax: getTaxById(e.taxId ?? ''))
            .toDouble())
        .reduce((value, element) => value + element);
   
    getPayableAmount();
  }

  updateFilterSelection(int index) {
    filterIndex.contains(index)
        ? filterIndex.remove(index)
        : filterIndex.add(index);
    update();
  }

  String incrementInvoiceNumber(String currentInvoice) {
    final prefix = currentInvoice.replaceAll(RegExp(r'[0-9]'), '');
    final numberPart =
        int.parse(currentInvoice.replaceAll(RegExp(r'[^0-9]'), ''));
    final incrementedNumber = numberPart + 1;

    return '$prefix$incrementedNumber';
  }

  Future<void> sendSMS(DateTime now) async {
    if (settings.sendSMS ?? false) {
     
      String invoiceNumber =
          '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
              .trim();
      String formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      String message =
          'Invoice Confirmed\nThank you, ${selectedCustomer.value.name}! Your purchase is successful.\nInvoice: $invoiceNumber | Amount: ${grandTotal.value.toStringAsFixed(2)} | Date: $formattedDate\n${AppData().getCompanyName()}';
      selling('Sending SMS');
      await Utils.sendSMS(
          phone: selectedCustomer.value.phone ??
              selectedCustomer.value.contactNumber ??
              '',
          message: message);
    }
  }

  sales_body.SalesBody itemToSalesBody(String? taxTotal, [Position? position]) {
    final body = sales_body.SalesBody.fromJson(bodyJson!);
    return body.copyWith(
      cashType: radioValue,
      latitude: position?.latitude.toString() ?? '',
      longitude: position?.longitude.toString() ?? '',
      total: grandTotal.value.toString(),
      taxtotal: taxTotal,
      customerAddress: selectedCustomer.value.addressLine1,
      customerPhone: selectedCustomer.value.phone,
      salesitems: addedItems.map((e) {
        return sales_body.SalesItems(
            tax: e.taxId,
            total:
                (double.parse(e.srate ?? '0') * double.parse(e.itemQty ?? '0'))
                    .toString(),
            quantity: e.itemQty,
            baseUnitId: e.unitId,
            ces: e.cessId ?? '0',
            cesAmt: double.parse(e.cesPercent ?? '0'),
            discount: e.priceDiscount,
            itemId: e.id,
            itmCesId: e.cesId,
            itmCesName: e.cesName ?? '',
            prate: e.prate,
            published: e.published,
            taxId: e.taxId,
            unitId: e.unitId,
            godown: double.parse(e.godown ?? '0'),
            itmCesPer: double.parse(e.cesPercent ?? '0'),
            itmRawCess: double.parse(e.cessId!),
            mrp: double.parse(e.mrp!),
            rate: double.parse(e.srate!));
      }).toList(),
    );
  }

  Future<bool> updateSalesBody() async {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    final save = await savePayment(now.millisecondsSinceEpoch.toString());
    if (save == SavePayment.abort) return false;
    selling('Getting Invoice');
    String invoiceNumber =
        '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
            .trim();
    Tax tax = await InsertTax().getTaxById(addedItems.first.taxId ?? '1');
    selling('Calculating tax');
    double taxTotal = 0.0;
    if (!AppData().getTaxInclude()) {
      for (var item in addedItems) {
      
        double mrp = double.parse(item.mrp ?? '0');
        double sRate = double.parse(item.srate ?? '0');
        double discountOrTaxAmount = mrp - sRate;
        taxTotal += discountOrTaxAmount;
      }
    }
    selling('Getting Location');
    final positionResult = await LocationRepository().getLocation();
    Position? position;
    positionResult.fold((data) {
      position = data;
    }, (error) {});
    selling('Registering Items');
    final device = await InsertDevice().getSingleDevice();
    if (bodyJson != null) {
      salesBody = itemToSalesBody(taxTotal.toString(), position);
      await InsertSalesBody().updateSalesBody(salesBody!);
      for (var item in salesBody?.salesitems ?? <sales_body.SalesItems>[]) {
        final salesItem = salesItems.firstWhereOrNull(
          (element) => element.id == item.itemId,
        );
        await InsertItemStock().setStockItemQuantity(
          itemId: item.itemId ?? '',
          quantity: int.parse(salesItem?.itemQty ?? '0'),
        );
      }
      selling('Saving changes');
      await SalesBodySync().updateSalesBodySync(id: salesBody!.id!, status: 0);
      await sendSMS(now);
      if (settings.syncOnSave ?? false) {
   
        selling('Uploading to server');
        final result = await SalesRepository().createSales(salesBody!);
        await result.fold((data) async {
          await SalesBodySync()
              .updateSalesBodySync(id: salesBody?.id ?? '', status: 1);
        }, (error) {});
      }
      selling('');
      update();

      return true;
    }
    salesBody = sales_body.SalesBody(
        id: now.millisecondsSinceEpoch.toString(),
        type: SaleTypes.sales,
        customerId: selectedCustomer.value.id,
        customerAddress: selectedCustomer.value.addressLine1,
        discount: discountController.text.trim().isNotEmpty
            ? double.parse(discountController.text.trim()).toString()
            : 0.0.toString(),
        additionalCess: '0',
        cess: '0',
        roundoff: '0',
        invoiceDate: formattedDate,
        isTaxincluded: gstType.toString(),
        salesId: '0',
        cashType: radioValue,
        deliveryDate: formattedDate,
        creditEod: formattedDate,
        total: grandTotal.value.toString(),
        salesman: AppData().getUser().userName ?? '',
        route: '',
        vehicle: '',
        area: selectedCustomer.value.area ?? '',
        refAmount: '0',
        taxId: addedItems.first.taxId ?? '1',
        advance: payableAmount.text.trim(),
        other: '0',
        freight: '0',
        invoice: invoiceNumber,
        refId: '0',
        createdDate:
            '$formattedDate ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
        narration: '0',
        salesOrderId: '0',
        salesRefType: '0',
        createdBy: AppData().getUser().id ?? '',
        billType: device.salesBilltype,
        cusname: selectedCustomer.value.name ?? '',
        cusemail: selectedCustomer.value.email ?? '',
        cusdetails: selectedCustomer.value.details ?? '',
        customerPhone: selectedCustomer.value.phone ?? '',
        subtot: grandTotal.value.toString(),
        tax: tax.gstid ?? '0',
        latitude: position?.latitude.toString() ?? '',
        longitude: position?.longitude.toString() ?? '',
        saletype: 'b2c',
        salesitems: addedItems.map((e) {
          return sales_body.SalesItems(
              tax: e.taxId,
              total: (double.parse(e.srate ?? '0') *
                      double.parse(e.itemQty ?? '0'))
                  .toString(),
              quantity: e.itemQty,
              baseUnitId: e.unitId,
              ces: e.cessId ?? '0',
              cesAmt: double.parse(e.cesPercent ?? '0'),
              discount: e.priceDiscount,
              itemId: e.id,
              itmCesId: e.cesId,
              itmCesName: e.cesName ?? '',
              prate: e.prate,
              published: e.published,
              taxId: e.taxId,
              unitId: e.unitId,
              godown: num.parse(e.godownId ?? '0'),
              itmCesPer: num.parse(e.cesPercent ?? '0'),
              itmRawCess: num.parse(e.cessId!),
              mrp: num.parse(e.mrp!),
              rate: num.parse(e.srate!));
        }).toList(),
        loginUserId: AppData().getUserID(),
        taxtotal: taxTotal.toString());
  
    selling('Saving changes');
    
    await TxnOperations().createNewSale(
        salesBody: salesBody!,
        salesItems: salesBody!.salesitems!,
        billNumber: billNumber.copyWith(
            startnumber: (double.parse(billNumber.startnumber ?? '0') + 1)
                .round()
                .toString()));
    await sendSMS(now);
    if (double.parse(payableAmount.text.trim()) < grandTotal.value ||
        radioValue.toLowerCase() == 'credit') {
      await createVoucher(
          date: now,
          amount: radioValue.toLowerCase() == 'credit'
              ? grandTotal.value.toString()
              : (grandTotal.value - double.parse(payableAmount.text.trim()))
                  .toString(),
          latitude: position?.latitude.toString() ?? '',
          longitude: position?.longitude.toString() ?? '',
          narration: salesBody?.narration ?? '');
    }
    if (settings.syncOnSave ?? false) {
    
      selling('Uploading to server');
      final result = await SalesRepository().createSales(salesBody!);
      await result.fold((data) async {
        await SalesBodySync()
            .updateSalesBodySync(id: salesBody?.id ?? '', status: 1);
      }, (error) {});
    }
    selling('');
    update();
    return true;
  }

  Future<void> selectCustomer(Customers customer) async {
    selectedCustomer.value = customer;
    priceList =
        await InsertPriceList().getPriceListById(customer.priceList ?? '');
    saveCartToStorage();
    update();
  }

  void selectItem(Items item) {
    selectedItem.value = item;
  }

  void incrementItemQuantity(Items item) {
    int incrementQuantity = (settings.incrementQty?.isEmpty ?? true)
        ? 1
        : int.parse(settings.incrementQty ?? '1');
    final salesItem = salesItems.firstWhere((element) => element.id == item.id,
        orElse: () => Items());
    if (double.parse(salesItem.itemQty ?? '0') <= (incrementQuantity - 1)) {
      showAlert(
          context: Get.context!,
          title: 'Quantity exceeds',
          content:
              'Quantity exceeds items stock quantity. Saving this will only set the quantity as ${item.itemQty}');
    } else {
      item.itemQty = (double.parse(item.itemQty ?? '0') + incrementQuantity)
          .round()
          .toString();
      salesItem.itemQty =
          (double.parse(salesItem.itemQty ?? '0') - incrementQuantity)
              .round()
              .toString();
    }
    updateGrandTotal();
    
    saveCartToStorage();
    update();
  }

  void decrementItemQuantity(Items item) {
    int incrementQuantity = (settings.incrementQty?.isEmpty ?? true)
        ? 1
        : int.parse(settings.incrementQty ?? '1');
    final salesItem = salesItems.firstWhere((element) => element.id == item.id,
        orElse: () => Items());
    if (double.parse(item.itemQty ?? '0') > (incrementQuantity - 1)) {
      item.itemQty = (double.parse(item.itemQty ?? '0') - incrementQuantity)
          .round()
          .toString();
      salesItem.itemQty =
          (double.parse(salesItem.itemQty ?? '0') + incrementQuantity)
              .round()
              .toString();
    } else if (double.parse(item.itemQty ?? '0') > 0) {
      item.itemQty = '1';
    }
    // if ((selectedQuantity[item.id!] ?? 0 + 1) > double.parse(item.itemQty!)) {
    //   showAlert(
    //       context: Get.context!,
    //       title: 'Quantity exceeds',
    //       content:
    //           'Quantity exceeds items stock quantity. Saving this will only set the quantity as ${selectedQuantity[item.id!]}');
    // } else {
    //
    // }
    updateGrandTotal();
    saveCartToStorage();
    update();
  }

  void setItemQuantity(
      {required Items item, required int quantity, bool isEdit = false}) {
    final salesItem = salesItems.firstWhere((element) => element.id == item.id,
        orElse: () => Items());
    if (quantity >
        (double.parse(salesItem.itemQty ?? '0') +
            double.parse(item.itemQty ?? '0'))) {
      showAlert(
          context: Get.context!,
          title: 'Quantity exceeds',
          content:
              'Quantity exceeds items stock quantity. Saving this will only set the quantity as ${selectedQuantity[item.id!]}');
    } else {
      selectedQuantity[item.id!] = quantity;
      if (isEdit) {
        int changeQuantity = 0;
        changeQuantity += realQuantity[salesItem.id ?? '0'] ?? 0;
        List<Items> changeItems = addedItems
            .where(
              (e) => e.id == item.id,
            )
            .toList();
        for (var item in changeItems) {
          changeQuantity -= double.parse(item.itemQty ?? '0').round();
        }
        salesItem.itemQty =
            (changeQuantity + int.parse(item.itemQty ?? '0') - quantity)
                .toString();
      }
    }
    updateGrandTotal();
    update();
  }

  void addItem(Items item) {
    if (selectedQuantity[item.id!] == null) {
      selectedQuantity.addAll({item.id!: 1});
    }
    salesItems
        .firstWhere((element) => element.id == item.id, orElse: () => Items())
        .itemQty = (int.parse(salesItems
                    .firstWhere((element) => element.id == item.id,
                        orElse: () => Items())
                    .itemQty ??
                '0') -
            int.parse(item.itemQty ?? '0'))
        .toString();
    addedItems.add(item);
    updateGrandTotal();
    clearSelectedItem();
   
    saveCartToStorage();
    update();
  }

  void removeItem(Items item) {
    addedItems.remove(item);
    salesItems
        .firstWhere((element) => element.id == item.id, orElse: () => Items())
        .itemQty = (int.parse(salesItems
                    .firstWhere((element) => element.id == item.id,
                        orElse: () => Items())
                    .itemQty ??
                '0') +
            int.parse(item.itemQty ?? '0'))
        .toString();
    selectedQuantity.remove(item.id);
    updateGrandTotal();
    
    saveCartToStorage();
    update();
  }

  void searchItem(String query) {
    if (query.isEmpty) {
      searchItems = salesItems;
    } else {
      searchItems = salesItems
          .where((item) =>
              item.name?.toLowerCase().contains(query.trim().toLowerCase()) ??
              false)
          .toList();
    }
    update();
  }

  String getInvoice() {
    return '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
        .trim();
  }

  void setUpiId() {
    TextEditingController upiIdController = TextEditingController();
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Set UPI ID'),
        content: TextField(
          controller: upiIdController,
          decoration: const InputDecoration(
            labelText: 'UPI ID',
            hintText: 'Enter UPI ID to receive Payment',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () async {
                if (RegExpressions.upiRegex
                        .hasMatch(upiIdController.text.trim()) &&
                    !upiIdController.text.trim().contains('.com')) {
                  AppData().storeUpiID(upiIdController.text.trim());
                  Get.back();
                  await updateSalesBody();
                  Get.toNamed(RoutesName.pdfView,
                      arguments: {'invoice': getInvoice()});
                } else {
                  Utils().showToast('Enter valid UPI ID');
                }
              },
              child: const Text('Set')),
        ],
      ),
    );
  }

  Future<void> createVoucher(
      {String latitude = '',
      String longitude = '',
      required String amount,
      required DateTime date,
      required String narration}) async {
    selling('Creating Voucher');
    final voucherBill = await InsertBillNumber()
        .getBillNumberByType(BillNumberTypes.quickPayment);
    String invoiceNumber =
        '${voucherBill.preffix ?? ''}${voucherBill.seperator ?? ''}${voucherBill.startnumber ?? ''}${voucherBill.seperator ?? ''}${voucherBill.suffix ?? ''}'
            .trim();
    String time = '${date.day}-${date.month}-${date.year}';
    VoucherBody body = VoucherBody(
      aeging: [],
      amount: amount,
      billType: voucherBill.id,
      createdBy: AppData().getUserID(),
      date: time,
      latitude: latitude,
      longitude: longitude,
      narration: narration,
      toid: selectedCustomer.value.id,
      type: VoucherTypes.payment,
      vid: invoiceNumber,
      voucherId: '0',
      loginUserId: AppData().getUserID(),
    );

    // await InsertVouchers().insertVouchers(body);
    // await InsertBillNumber().updateBillNumber(voucherBill.copyWith(
    //     startnumber: (double.parse(voucherBill.startnumber ?? '0') + 1)
    //         .round()
    //         .toString()));
    // await VoucherBodySync().insertVoucherBodySync(id: invoiceNumber, status: 0);
    await TxnOperations().createNewSaleVoucher(
        voucher: body,
        billNumber: voucherBill.copyWith(
            startnumber: (double.parse(voucherBill.startnumber ?? '0') + 1)
                .round()
                .toString()));

    if (AppData().getSettings().syncOnSave ?? false) {
      final result = await VoucherRepository().createPaymentVoucher(body);
      result.fold((data) async {
        await VoucherBodySync()
            .updateVoucherBodySync(id: invoiceNumber, status: 1);
      }, (error) {});
    }
  }

  // Future<void> revertStock() async {
  //   clearing(true);
  //   await InsertItemStock().revertItemStock(salesItems);
  //   addedItems.clear();
  //   salesItems.clear();
  //   clearing(false);
  //   update();
  // }

  void clearSelectedItem() {
    selectedItem(Items());
    quantityController.clear();
    itemController.clear();
    update();
  }

  confirmNewSale() {
    if (selectedCustomer.value.name != null || addedItems.isNotEmpty) {
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                    'Your current sales will not be saved!. And will lose all data.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        clearSales();
                        Get.back();
                      },
                      child: const Text('Clear')),
                ],
              ));
    }
  }

  List<String> getHintText(String type) {
    switch (type) {
      case 'upi':
        return ['Transaction ID', 'UPI ID / Phone Number'];
      case 'net_banking':
        return ['Transaction ID', 'Transaction site'];
      case 'bank_transfer':
        return ['Transaction ID', 'Bank name'];
      case 'cheque':
        return ['Cheque Number', 'Bank name'];
      default:
        return ['', ''];
    }
  }

  Future<SavePayment> savePayment(String salesId) async {
    if (radioValue != 'Bank') return SavePayment.skip;
    if (transactionController.text.trim().isEmpty) {
      Utils().showToast('Enter ${getHintText(paymentMethod)[0]}');
      return SavePayment.abort;
    }
    if (bankNameController.text.trim().isEmpty) {
      Utils().showToast('Enter ${getHintText(paymentMethod)[1]}');
      return SavePayment.abort;
    }
    PaymentModel payment = PaymentModel(
        type: paymentMethod,
        bankName: bankNameController.text.trim(),
        transactionId: transactionController.text.trim(),
        salesId: salesId,
        value: payableAmount.text.trim(),
        customerId: selectedCustomer.value.id);
    await InsertPayment().insertPayment(payment);
    return SavePayment.save;
  }

  clearSales() {
    addedItems.clear();
    selectedQuantity.clear();
    selectedCustomer(Customers());
    selectedItem(Items());
    radioValue = 'Cash';
    grandTotal(0.0);
   
    AppData().clearCartData();
    update();
  }

  void saveCartToStorage() {
    try {
    
      List<Map<String, dynamic>> itemsJson =
          addedItems.map((item) => item.toJson()).toList();

     
      AppData().storeCartItems(itemsJson);

    
      AppData().storeCartQuantities(selectedQuantity);

     
      if (selectedCustomer.value.name != null) {
        AppData().storeCartCustomer(selectedCustomer.value.toJson());
      }
    } catch (e) {
      print('Error saving cart to storage: $e');
    }
  }

  // void saveCartToStorage() {
  //   try {
  //     // Convert Items to JSON
  //     List<Map<String, dynamic>> itemsJson =
  //         addedItems.map((item) => item.toJson()).toList();

  //     // Save cart items
  //     AppData().storeCartItems(itemsJson);

  //     // Save selected quantities
  //     AppData().storeCartQuantities(selectedQuantity);

  //     // Save selected customer
  //     if (selectedCustomer.value.name != null) {
  //       AppData().storeCartCustomer(selectedCustomer.value.toJson());
  //     }
  //   } catch (e) {
  //     print('Error saving cart to storage: $e');
  //   }
  // }

  void loadCartFromStorage() {
    try {
    
      List<Map<String, dynamic>> savedItems = AppData().getCartItems();
      if (savedItems.isNotEmpty) {
        addedItems.value =
            savedItems.map((json) => Items.fromJson(json)).toList();
      }

      
      selectedQuantity = AppData().getCartQuantities();

     
      Map<String, dynamic>? customerJson = AppData().getCartCustomer();
      if (customerJson != null) {
        selectedCustomer.value = Customers.fromJson(customerJson);
      }

     
      if (addedItems.isNotEmpty) {
        updateGrandTotal();
      }
    } catch (e) {
      print('Error loading cart from storage: $e');
    }
  }
}
