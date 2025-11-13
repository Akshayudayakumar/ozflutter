import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/database/tables/transaction/txn_operations.dart';
import 'package:ozone_erp/models/sale_types.dart';
import 'package:ozone_erp/models/sales_body.dart' as sales_body;
import 'package:ozone_erp/models/settings_model.dart';
import 'package:ozone_erp/models/voucher_body.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/screens/sync/controller/sync_controller.dart';
import 'package:ozone_erp/services/voucher_services.dart';
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

  @override
  void onInit() {
    super.onInit();
    getArgumentsData();
    loading(false);
    ordering('');
    getItems();
    getUnits();
    getCategories();
    Get.put<UserController>(UserController());
    InsertPriceListDetails().getPriceListDetails();
    payableAmount.addListener(_updateWidth);
    scrollController.addListener(_updateItemLength);
    loadCartFromStorage();
  }

  Future<void>refreshAllData({bool runSync = false}) async{
    if(runSync){
      final syncController = Get.find<SyncController>();
      await syncController.saveSync(SyncTypes.order);
    }
    await Future.wait([
      getItems(),
      getUnits(),
      getCategories()
    ]);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  //dispose controller
  @override
  void dispose() {
    payableAmount.removeListener(_updateWidth);
    scrollController.removeListener(_updateItemLength);
    super.dispose();
  }

  @override
  void onClose(){
    payableAmount.removeListener(_updateWidth);
    scrollController.removeListener(_updateItemLength);
    super.onClose();
  }

  //basic variables
  int screenIndex = 0;
  Rx<Customers> selectedCustomer = Customers().obs;
  double textFieldWidth = 25; // Initial width
  String radioValue = AppData().getSettings().cashType ?? 'Cash';
  String paymentMethod = 'upi';
  bool gstType = AppData().getTaxInclude();
  Rx<Items> selectedItem = Items().obs;
  Rx<Customers> addedCustomer = Customers().obs;
  RxDouble grandTotal = 0.0.obs;
  Map<String, int> selectedQuantity = {};
  Map<String, int> realQuantity = {};
  Map<String, double> discount = {};
  RxBool loading = false.obs;
  RxBool clearing = false.obs;
  RxBool customerLoading = false.obs;
  RxBool isDetailsVisible = false.obs;
  RxString ordering = ''.obs;
  RxString sortValue = ''.obs;
  RxString filterValue = ''.obs;
  Unit unit = Unit();
  sales_body.SalesBody? salesBody;
  PriceList priceList = PriceList();
  String? bodyInvoice;
  int showItems = 10;
  SettingsModel settings = AppData().getSettings();
  Map<String,dynamic>? bodyJson = Get.arguments;

  //TextControllers
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController payableAmount = TextEditingController(text: '0.0');
  TextEditingController discountController = TextEditingController(text: '0');
  TextEditingController transactionController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();

  ScrollController scrollController = ScrollController();

  //Lists initializer
  List<Unit> units = [];
  List<Items> salesItems = [];
  RxList<Items> addedItems = <Items>[].obs;
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
//get argument data
  Future<void> getArgumentsData() async {
    if (Get.arguments != null && Get.arguments is Customers) {
      selectedCustomer.value = Get.arguments;
    }
    update();
  }

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
    try {
      loading(true);
      salesItems = await InsertItems().getItems();
      salesItems.sort((b, a) => (a.itemQty?.compareTo(b.itemQty ?? '') ?? 0));
      searchItems = salesItems;
      brands = salesItems.map((e) => e.brandId!).toSet().toList();

      for (var item in salesItems) {
        realQuantity[item.id!] = int.parse(item.itemQty ?? '0');
      }
      await getBillNumbers();
      await getAllTax();
      await bodyToItems();
    } catch (e) {
      Utils().showToast(e.toString());
    }
    finally {
      if (Get.isRegistered<NewOrderController>()) {
        loading(false);
        update();
      }
    }
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

  void updateGstType(bool value) {
    gstType = value;
    updateGrandTotal();
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

  Future<void> sendSMS(DateTime now) async {
    if (settings.sendSMS ?? false) {
      String invoiceNumber =
      '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
          .trim();
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

    await sendSMS(now);

    if (AppData().getSettings().syncOnSave ?? false) {

      //Send data to server
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
    priceList =
    await InsertPriceList().getPriceListById(customer.priceList ?? '');
    saveCartToStorage();
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
  void selectItem(Items item) {
    selectedItem.value = item;
  }

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
    ordering('Creating Voucher');
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
    AppData().clearCartData();
    update();
  }

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
