import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/database/tables/transaction/txn_operations.dart';
import 'package:ozone_erp/models/sale_types.dart';
import 'package:ozone_erp/models/sales_body.dart' as sales_body;
import 'package:ozone_erp/models/settings_model.dart';

import '../../../data/app_data.dart';
import '../../../database/controller/user_controller.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/device_details.dart';
import '../../../models/general_details.dart';
import '../../../models/payment_model.dart';
import '../../../services/location_services.dart';
import '../../../services/sales_service.dart';
import '../../../utils/common_calculations.dart';
import '../../../utils/utils.dart';

class NewOrderController extends GetxController {
//Initialize controller
  @override
  void onInit() {
    loading(false);
    getItems();
    getUnits();
    getCategories();
    Get.put<UserController>(UserController());
    InsertPriceListDetails().getPriceListDetails();
    payableAmount.addListener(_updateWidth);
    super.onInit();
  }

  //dispose controller
  @override
  void dispose() {
    payableAmount.removeListener(_updateWidth);
    super.dispose();
  }

  //basic variables
  int screenIndex = 0;
  var selectedCustomer = Customers().obs;
  double textFieldWidth = 25; // Initial width
  String radioValue = AppData().getSettings().cashType ?? 'Cash';
  String paymentMethod = 'upi';

  // String gstType = 'included';
  Rx<Items> selectedItem = Items().obs;
  RxDouble grandTotal = 0.0.obs;
  Map<String, int> selectedQuantity = {};
  RxBool loading = false.obs;
  RxString ordering = ''.obs;
  RxString sortValue = ''.obs;
  RxString filterValue = ''.obs;
  Unit unit = Unit();
  sales_body.SalesBody? salesBody;
  PriceList priceList = PriceList();

  //TextControllers
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController payableAmount = TextEditingController(text: '0.0');
  TextEditingController discountController = TextEditingController(text: '0');
  TextEditingController transactionController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  //Lists initializer
  List<Unit> units = [];
  List<Items> salesItems = [];
  List<Items> addedItems = [];
  List<Items> searchItems = [];
  List<int> filterIndex = [];
  List<String> brands = [];
  List<Category> categories = [];
  List<Billnumber> billNumbers = [];
  Billnumber billNumber = Billnumber();
  List<Billnumber> salesBills = [];
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
      'value': r'srate',
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
      'value': r'srate',
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

  //focus nodes
  FocusNode focusNode = FocusNode();

  //get Functions
  Future<void> getUnits() async {
    units = await InsertUnit().getUnits();
    unit = units.first;
    update();
  }

  Future<void> getAllTax() async {
    taxes = await InsertTax().getTax();
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
    payableAmount.text = grandTotal.value.toStringAsFixed(2);
    update();
  }

  Future<void> getItems() async {
    loading.value = true;
    salesItems = await InsertItems().getItems();
    salesItems.sort((b, a) => (a.itemQty?.compareTo(b.itemQty ?? '') ?? 0));
    searchItems = salesItems;
    brands = salesItems.map((e) => e.brandId!).toSet().toList();
    await getBillNumbers();
    await getAllTax();
    loading.value = false;
    update();
  }

  Future<void> getBillNumbers() async {
    billNumbers = await InsertBillNumber().getBillNumber();
    billNumber = billNumbers.firstWhere(
        (element) => element.transaction == BillNumberTypes.order,
        orElse: () => Billnumber());
    salesBills.addAll([billNumber]);
    update();
  }

  int getQuantity(String id) {
    return selectedQuantity[id] ?? 0;
  }

  String getInvoice() {
    return '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
        .trim();
  }

  //update functions
  updateScreenIndex(int value) {
    screenIndex = value;
    update();
  }

  void updateRadioValue(String value) {
    radioValue = value;
    update();
  }

  void _updateWidth() {
    final text = payableAmount.text;

    // Use TextPainter to calculate text width
    final textPainter = TextPainter(
      text: TextSpan(
        text: text.isEmpty ? '0.0' : text, // To avoid 0 width
        style: const TextStyle(fontSize: 16), // Match the TextField's style
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textFieldWidth = textPainter.size.width >= 50
        ? 50
        : textPainter.size.width + 5; // Add padding
    update();
  }

  // void updateGstType(String value) {
  //   gstType = value;
  //   updateGrandTotal();
  //   update();
  // }

  void updateBillType(String id) {
    billNumber = billNumbers.firstWhere((element) => element.id == id,
        orElse: () => Billnumber());
    update();
  }

  Tax getTaxById(String id) {
    final tax =
        taxes.firstWhere((element) => element.gstid == id, orElse: () => Tax());
    return tax;
  }

  void updateGrandTotal() {
    if (addedItems.isEmpty) {
      grandTotal.value = 0.0;
      return;
    }
    grandTotal.value = 0.0;
    grandTotal.value = addedItems.map((e) {
      double value = CommonCalculations.calculateTotalRate(
              rate:
                  (double.parse(e.srate ?? '0') * (selectedQuantity[e.id] ?? 0))
                      .toString(),
              discount: e.priceDiscount ?? '0',
              tax: getTaxById(e.taxId ?? ''))
          .toDouble();
      return value;
    }).reduce((value, element) => value + element);
    // if (gstType == 'excluded') {
    //   grandTotal.value += grandTotal.value *
    //       (double.parse(selectedCustomer.value.gst != null &&
    //                   selectedCustomer.value.gst!.isNotEmpty
    //               ? selectedCustomer.value.gst!
    //               : '0') /
    //           100);
    // }
    grandTotal.value -=
        grandTotal.value * (double.parse(discountController.text) / 100);
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

  Future<void> sendSMS() async {
    if (AppData().getSettings().sendSMS ?? false) {
      //TODO: send sms feature implement
      String invoiceNumber =
          '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
              .trim();
      DateTime now = DateTime.now();
      String formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      String message =
          'Order Received\nHi ${selectedCustomer.value.name}, we have received your order.\nOrder No: $invoiceNumber | Amount: ${grandTotal.value.toStringAsFixed(2)} | Delivery: $formattedDate\nThank you! - ${AppData().getCompanyName()}';
      await Utils.sendSMS(
          phone: selectedCustomer.value.phone ??
              selectedCustomer.value.contactNumber ??
              '',
          message: message);
    }
  }

  Future<bool> updateSalesBody() async {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    final save = await savePayment(now.millisecondsSinceEpoch.toString());
    if (save == SavePayment.abort) return false;
    ordering('Getting invoice');
    String invoiceNumber =
        '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
            .trim();
    ordering('Calculating tax');
    double taxTotal = 0.0;
    if (!AppData().getTaxInclude()) {
      for (var item in addedItems) {
        // Calculate the difference between MRP and sale price
        double mrp = double.parse(item.mrp ?? '0');
        double sRate = double.parse(item.srate ?? '0');
        double discountOrTaxAmount = mrp - sRate;
        taxTotal += discountOrTaxAmount;
      }
    }
    ordering('Getting Location');
    final positionResult = await LocationRepository().getLocation();
    Position? position;
    positionResult.fold((data) {
      position = data;
    }, (error) {});
    ordering('Registering Items');
    salesBody = sales_body.SalesBody(
        id: now.millisecondsSinceEpoch.toString(),
        type: SaleTypes.salesOrder,
        customerId: selectedCustomer.value.id,
        customerAddress: selectedCustomer.value.addressLine1,
        discount: discountController.text.trim().isNotEmpty
            ? double.parse(discountController.text.trim()).toString()
            : 0.0.toString(),
        additionalCess: '0',
        cess: '0',
        roundoff: '0',
        invoiceDate: formattedDate,
        isTaxincluded: 'true',
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
        taxId: '0',
        advance: '0',
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
        billType: '0',
        cusname: selectedCustomer.value.name ?? '',
        cusemail: selectedCustomer.value.email ?? '',
        cusdetails: selectedCustomer.value.details ?? '',
        customerPhone: selectedCustomer.value.phone ?? '',
        subtot: grandTotal.value.toString(),
        tax: '0',
        latitude: position?.latitude.toString() ?? '',
        longitude: position?.longitude.toString() ?? '',
        saletype: 'b2c',
        salesitems: addedItems.map((e) {
          return sales_body.SalesItems(
              tax: e.taxId,
              total: e.srate,
              quantity: selectedQuantity[e.id!].toString(),
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
              godown: double.parse(e.godownId ?? '0'),
              itmCesPer: double.parse(e.cesPercent ?? '0'),
              itmRawCess: double.parse(e.cessId!),
              mrp: double.parse(e.mrp!),
              rate: double.parse(e.srate!));
        }).toList(),
        loginUserId: AppData().getUser().id ?? '',
        taxtotal: taxTotal.toString());
    ordering('Saving changes');
    // await InsertSalesBody().insertSalesBody(salesBody!);
    // await SalesBodySync().insertSalesBodySync(id: salesBody!.id!, status: 0);
    // await InsertBillNumber().updateBillNumber(
    //   billNumber.copyWith(
    //     startnumber: (double.parse(billNumber.startnumber ?? '0') + 1)
    //         .round()
    //         .toString(),
    //   ),
    // );
    await TxnOperations().createNewOrder(
      salesBody: salesBody!,
      billNumber: billNumber.copyWith(
        startnumber: (double.parse(billNumber.startnumber ?? '0') + 1)
            .round()
            .toString(),
      ),
    );
    await sendSMS();
    if (AppData().getSettings().syncOnSave ?? false) {
      //TODO: Send data to server
      ordering('Uploading to server');
      final result = await SalesRepository().createSales(salesBody!);
      await result.fold((data) async {
        await SalesBodySync()
            .updateSalesBodySync(id: salesBody?.id ?? '', status: 1);
      }, (error) {});
    }
    ordering('');
    update();
    return true;
  }

  //other functions
  void selectCustomer(Customers customer) async {
    selectedCustomer.value = customer;
    update();
  }

  void selectItem(Items item) {
    selectedItem.value = item;
  }

  SettingsModel settings = AppData().getSettings();

  void incrementItemQuantity(Items item) {
    int incrementQuantity = (settings.incrementQty?.isEmpty ?? true)
        ? 1
        : int.parse(settings.incrementQty ?? '1');
    selectedQuantity[item.id!] =
        (selectedQuantity[item.id!] ?? 0) + incrementQuantity;
    updateGrandTotal();
    update();
  }

  void decrementItemQuantity(Items item) {
    int incrementQuantity = (settings.incrementQty?.isEmpty ?? true)
        ? 1
        : int.parse(settings.incrementQty ?? '1');
    if ((selectedQuantity[item.id!] ?? 0) < incrementQuantity) {
      selectedQuantity[item.id!] = 1;
    } else {
      selectedQuantity[item.id!] =
          (selectedQuantity[item.id!] ?? 0) - incrementQuantity;
    }
    updateGrandTotal();
    update();
  }

  void setItemQuantity({required Items item, required int quantity}) {
    selectedQuantity[item.id!] = quantity;
    updateGrandTotal();
    update();
  }

  void addItem(Items item) {
    if (selectedQuantity[item.id!] == null) {
      selectedQuantity.addAll({item.id!: 1});
    }
    addedItems.add(item);
    updateGrandTotal();
    clearSelectedItem();
    update();
  }

  void removeItem(Items item) {
    addedItems.remove(item);
    selectedQuantity.remove(item.id);
    updateGrandTotal();
    update();
  }

  void searchItem(String query) {
    searchItems = salesItems
        .where((item) =>
            item.name!.toLowerCase().contains(query.trim().toLowerCase()))
        .toList();
    update();
  }

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
    // gstType = 'included';
    radioValue = 'Cash';
    grandTotal(0.0);
    update();
  }
}
