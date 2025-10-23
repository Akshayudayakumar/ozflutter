import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/database/tables/transaction/return_log_txn.dart';
import 'package:ozone_erp/models/sale_types.dart';
import 'package:ozone_erp/models/sales_body.dart' as sales_body;

import '../../../components/change_url_alert.dart';
import '../../../data/app_data.dart';
import '../../../database/controller/user_controller.dart';
import '../../../database/tables/export_insert.dart';
import '../../../models/device_details.dart';
import '../../../models/general_details.dart';
import '../../../models/payment_model.dart';
import '../../../models/return_log.dart';
import '../../../routes/routes_class.dart';
import '../../../services/location_services.dart';
import '../../../services/sales_service.dart';
import '../../../utils/common_calculations.dart';
import '../../../utils/utils.dart';

class SalesReturnController extends GetxController {
  @override
  void onInit() {
    getUnits();
    getSalesBody();
    Get.put<UserController>(UserController());
    InsertPriceListDetails().getPriceListDetails();
    payableAmount.addListener(_updateWidth);
    Future.delayed(const Duration(milliseconds: 5000), () {
      firstTime(false);
    });
    super.onInit();
  }

  @override
  void dispose() {
    payableAmount.removeListener(_updateWidth);
    super.dispose();
  }

  var selectedCustomer = Customers().obs;
  RxString emptyMessage = ''.obs;

  TextEditingController itemController = TextEditingController();
  FocusNode focusNode = FocusNode();
  TextEditingController quantityController = TextEditingController();
  TextEditingController payableAmount = TextEditingController(text: '0.0');
  TextEditingController discountController = TextEditingController(text: '0');
  TextEditingController invoiceController = TextEditingController();
  TextEditingController transactionController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  double textFieldWidth = 25; // Initial width
  List<Billnumber> billNumbers = [];
  String paymentMethod = 'upi';
  Billnumber billNumber = Billnumber();
  List<Billnumber> salesBills = [];
  int screenIndex = 0;
  RxString returning = ''.obs;
  List<Unit> units = [];
  List<sales_body.SalesBody> salesBody = [];
  sales_body.SalesBody? salesBodyToReturn;
  List<Items> itemsToReturn = [];
  List<Items> searchItems = [];
  Map<String, int> selectedQuantity = {};
  Map<String?, ReturnLog> returnLogs = {};
  List<Customers> allCustomers = [];
  Unit unit = Unit();
  sales_body.SalesBody returnSalesBody = sales_body.SalesBody();
  RxBool firstTime = true.obs;

  getSalesBody() async {
    salesBody = await InsertSalesBody().getSalesBody();
    await getBillNumbers();
    await getCustomers();
    update();
  }

  void searchItem(String query) {
    searchItems = itemsToReturn
        .where((item) =>
            item.name!.toLowerCase().contains(query.trim().toLowerCase()))
        .toList();
    update();
  }

  Future<void> getCustomers() async {
    allCustomers = await InsertCustomers().getCustomers();
  }

  Customers getCustomerById(String id) {
    return allCustomers.firstWhere((customer) => customer.id == id,
        orElse: () => Customers());
  }

  Future<void> sendSMS(double amount) async {
    if (AppData().getSettings().sendSMS ?? false) {
      //TODO: send sms feature implement
      String invoiceNumber =
          '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
              .trim();
      DateTime now = DateTime.now();
      String formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      String message =
          'Return Processed\nDear ${selectedCustomer.value.name}, your return request has been processed.\nInvoice: $invoiceNumber | Refund: ${amount.toStringAsFixed(2)} | Date: $formattedDate - ${AppData().getCompanyName()}';
      await Utils.sendSMS(
          phone: selectedCustomer.value.phone ??
              selectedCustomer.value.contactNumber ??
              '',
          message: message);
    }
  }

  itemByInvoice(String value) async {
    if (value.isEmpty) {
      emptyMessage('');
      salesBodyToReturn = null;
      itemsToReturn = [];
      update();
      return;
    }
    emptyMessage('');
    salesBodyToReturn = null;
    itemsToReturn = [];
    bool listNotSelected = false;
    final result = await InsertSalesBody().getSalesBodyByInvoice(value);
    await result.fold((list) async {
      await showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text('Fetched more than one invoice, Select one'),
              content: SizedBox(
                height: SizeConstant.percentToHeight(40),
                width: SizeConstant.screenWidth,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list[index].invoice ?? ''),
                      subtitle: Text(
                          '${(list[index].salesitems?.length ?? 0) > 1 ? '${list[index].salesitems?.length} Items' : '${list[index].salesitems?.length} Item'}'),
                      onTap: () {
                        salesBodyToReturn = list[index];
                        Get.back();
                      },
                    );
                  },
                  itemCount: list.length,
                ),
              ),
            );
          });
      if (salesBodyToReturn == null) {
        listNotSelected = true;
      }
    }, (item) {
      salesBodyToReturn = item;
    });
    final items = await InsertItems().getItems();
    if (salesBodyToReturn != null) {
      itemsToReturn = salesBodyToReturn?.salesitems?.map(
            (e) {
              selectedQuantity[e.itemId!] = int.parse(e.quantity!);
              return items.firstWhere(
                (element) => element.id == e.itemId,
              );
            },
          ).toList() ??
          [];
    } else {
      itemsToReturn = [];
    }
    if (itemsToReturn.isNotEmpty) {
      emptyMessage('');
    } else {
      if (listNotSelected) {
        emptyMessage('No Items Selected');
      } else {
        emptyMessage(
            'No Items Found with Provided Invoice Number, Please check invoice number or sync with server');
      }
    }
    if (salesBodyToReturn != null) {
      invoiceController.text = salesBodyToReturn!.invoice ?? '';
      selectedCustomer.value =
          getCustomerById(salesBodyToReturn!.customerId ?? '');
      await createReturnLog();
      alterAsLog();
    }
    update();
  }

  Future<void> createReturnLog() async {
    for (var item in salesBodyToReturn!.salesitems!) {
      final log = await ReturnLogTxn().getReturnLog(
          salesId: salesBodyToReturn!.salesId,
          itemId: item.itemId,
          invoice: salesBodyToReturn!.invoice);
      if (log != null) {
        returnLogs[item.itemId] = log;
      } else {
        ReturnLog createdLog = ReturnLog(
          itemId: item.itemId,
          invoice: salesBodyToReturn!.invoice,
          createdDate: DateTime.now().millisecondsSinceEpoch.toString(),
          salesId: salesBodyToReturn!.salesId,
          returnQuantity: 0,
          saleQuantity: int.tryParse(item.quantity ?? '0') ?? 0,
        );
        await ReturnLogTxn().insertReturnLog(createdLog);
        returnLogs[item.itemId] = createdLog;
      }
    }
  }

  void alterAsLog() {
    for (int i = 0; i < salesBodyToReturn!.salesitems!.length; i++) {
      final item = salesBodyToReturn!.salesitems![i];
      final log = returnLogs[item.itemId];
      if (log != null) {
        salesBodyToReturn!.salesitems![i].quantity =
            (log.saleQuantity! - log.returnQuantity!).toString();
      }
    }
    final zeroItems = salesBodyToReturn!.salesitems!.where(
      (element) => element.quantity == '0',
    );
    itemsToReturn.removeWhere(
      (element) => zeroItems.any((item) => item.itemId == element.id),
    );
    salesBodyToReturn!.salesitems!.removeWhere(
      (element) => element.quantity == '0',
    );
    if ((salesBodyToReturn?.salesitems?.isEmpty ?? true) &&
        emptyMessage.isEmpty) {
      emptyMessage('All the items in the invoice were already returned');
    }
    update();
  }

  getUnits() async {
    units = await InsertUnit().getUnits();
    unit = units.first;
    update();
  }

  Unit getUnitById(String id) {
    final unit =
        units.firstWhere((element) => element.id == id, orElse: () => Unit());
    return unit;
  }

  Future<void> getBillNumbers() async {
    billNumbers = await InsertBillNumber().getBillNumber();
    billNumber = billNumbers.firstWhere(
        (element) => element.transaction == BillNumberTypes.salesReturn,
        orElse: () => Billnumber());
    salesBills.addAll([billNumber]);
    update();
  }

  void updateBillType(String id) {
    billNumber = billNumbers.firstWhere((element) => element.id == id,
        orElse: () => Billnumber());
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

  void selectCustomer(Customers customer) async {
    selectedCustomer.value = customer;
    update();
  }

  String radioValue = AppData().getSettings().cashType ?? 'Cash';

  // void updateGstType(String value) {
  //   gstType = value;
  //   updateGrandTotal();
  //   update();
  // }

  // void getPriceType() {
  //   print(selectedCustomer.value.priceList);
  // }

  List<Items> addedItems = [];

  Rx<Items> selectedItem = Items().obs;

  void selectItem(Items item) {
    selectedItem.value = item;
  }

  void changeSelectedItemQuantity(int quantity) {
    selectedItem.value.itemQty = quantity.toString();
    update();
  }

  void incrementItemQuantity(Items item, [int? quantity]) {
    final salesItem = salesBodyToReturn?.salesitems
        ?.firstWhereOrNull((element) => element.itemId == item.id);
    if (salesItem != null) {
      int itemQty = int.parse(salesItem.quantity!);
      if (itemQty < (quantity ?? 1)) {
        showAlert(
            context: Get.context!,
            title: 'Quantity exceeds',
            content:
                'Quantity exceeds items bought quantity. Saving this will only set the quantity as ${selectedQuantity[item.id!]}');
      } else {
        int qty = selectedQuantity[item.id!] ?? 0;
        qty += quantity ?? 1;
        selectedQuantity[item.id!] = qty;
      }
    }
    updateGrandTotal();
    update();
  }

  Future<bool> returnSingleItem(
      sales_body.SalesItems item, int quantity) async {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    final save = await savePayment(now.millisecondsSinceEpoch.toString());
    if (save == SavePayment.abort) return false;
    returning('Getting Invoice');
    String invoiceNumber =
        '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
            .trim();
    returning('Getting location');
    Position? position;
    final positionResult = await LocationRepository().getLocation();
    positionResult.fold((data) {
      position = data;
    }, (error) {});
    returning('Registering items');
    double taxTotal = 0.0;
    if (!AppData().getTaxInclude()) {
      num mrp = item.mrp ?? 0;
      num sRate = item.rate ?? 0;
      num discountOrTaxAmount = mrp - sRate;
      taxTotal += discountOrTaxAmount;
    }
    Tax tax = await InsertTax().getTaxById(item.taxId ?? '');
    String totalRate = CommonCalculations.calculateTotalRate(
            rate: ((item.rate ?? 0) * quantity).toString(),
            discount: item.discount ?? '0',
            tax: tax)
        .toString();
    returnSalesBody = sales_body.SalesBody(
        id: now.millisecondsSinceEpoch.toString(),
        type: 'sales-return',
        customerId: salesBodyToReturn!.customerId,
        customerAddress: salesBodyToReturn!.customerAddress,
        discount: salesBodyToReturn!.discount,
        additionalCess: salesBodyToReturn!.additionalCess,
        cess: salesBodyToReturn!.cess,
        roundoff: salesBodyToReturn!.roundoff,
        invoiceDate: formattedDate,
        isTaxincluded: salesBodyToReturn!.isTaxincluded,
        salesId: now.millisecondsSinceEpoch.toString(),
        cashType: radioValue,
        deliveryDate: formattedDate,
        creditEod: formattedDate,
        total: totalRate,
        salesman: AppData().getUser().userName ?? '',
        route: '',
        vehicle: '',
        area: salesBodyToReturn!.area,
        refAmount: salesBodyToReturn!.refAmount,
        taxId: salesBodyToReturn!.taxId,
        advance: salesBodyToReturn!.advance,
        other: salesBodyToReturn!.other,
        freight: salesBodyToReturn!.freight,
        invoice: invoiceNumber,
        refId: salesBodyToReturn!.refId,
        createdDate:
            '$formattedDate ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
        narration: salesBodyToReturn!.narration,
        salesOrderId: salesBodyToReturn!.salesOrderId,
        salesRefType: salesBodyToReturn!.salesRefType,
        createdBy: AppData().getUser().id ?? '',
        billType: salesBodyToReturn!.billType,
        cusname: salesBodyToReturn!.cusname,
        cusemail: salesBodyToReturn!.cusemail,
        cusdetails: salesBodyToReturn!.cusdetails,
        customerPhone: salesBodyToReturn!.customerPhone,
        subtot: ((item.rate ?? 0) * quantity).toString(),
        tax: item.tax,
        latitude: position?.latitude.toString(),
        longitude: position?.longitude.toString(),
        saletype: salesBodyToReturn!.saletype,
        salesitems: [
          item.copyWith(
              quantity: quantity.toString(),
              total: (quantity * (item.rate ?? 0)).toString())
        ],
        loginUserId: AppData().getUser().id ?? '',
        taxtotal: taxTotal.toString());
    returning('Saving Changes');
    await InsertSalesBody().insertSalesBody(returnSalesBody);
    await InsertItemStock().updateStockItemQuantity(
      itemId: item.itemId ?? '',
      quantity: quantity,
    );
    await ReturnLogTxn().updateReturnQuantity(
        salesId: salesBodyToReturn!.salesId,
        itemId: item.itemId,
        invoice: salesBodyToReturn!.invoice,
        quantity: returnLogs[item.itemId]!.saleQuantity! -
            (returnLogs[item.itemId]!.saleQuantity! -
                quantity -
                returnLogs[item.itemId]!.returnQuantity!));
    await InsertBillNumber().updateBillNumber(billNumber.copyWith(
        startnumber: (double.parse(billNumber.startnumber ?? '0') + 1)
            .round()
            .toString()));
    await SalesBodySync()
        .insertSalesBodySync(id: returnSalesBody.id ?? '', status: 0);
    await sendSMS(double.parse(returnSalesBody.total ?? '0'));
    if (AppData().getSettings().syncOnSave ?? false) {
      returning('Uploading to server');
      //TODO: Send data to server
      final result = await SalesRepository().createSales(returnSalesBody);
      await result.fold((data) async {
        await SalesBodySync()
            .updateSalesBodySync(id: returnSalesBody.id ?? '', status: 1);
      }, (error) {});
    }
    returning('Saving other items');
    final saleItem = itemsToReturn.firstWhere(
        (element) => element.id == item.itemId,
        orElse: () => Items());
    if (quantity.toString() == item.quantity) {
      itemsToReturn.remove(saleItem);
      salesBodyToReturn?.salesitems?.remove(item);
    } else {
      saleItem.itemQty =
          (int.parse(saleItem.itemQty ?? '0') - quantity).toString();
      final bodyItem = returnSalesBody.salesitems?.firstWhere(
          (element) => element.itemId == item.itemId,
          orElse: () => sales_body.SalesItems());
      salesBodyToReturn = salesBodyToReturn?.copyWith(
          salesitems: salesBodyToReturn!.salesitems!.map((e) {
        if (e.itemId == item.itemId &&
            e.quantity == item.quantity &&
            e.rate == item.rate) {
          return bodyItem!.copyWith(
              quantity: (int.parse(e.quantity ?? '0') - quantity).toString());
        } else {
          return e;
        }
      }).toList());
    }
    // await InsertSalesBody().updateSalesBody(salesBodyToReturn!);
    returning('');
    update();
    return true;
  }

  returnItems() async {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    Position? position;
    final positionResult = await LocationRepository().getLocation();
    String invoiceNumber =
        '${billNumber.preffix ?? ''}${billNumber.seperator ?? ''}${billNumber.startnumber ?? ''}${billNumber.seperator ?? ''}${billNumber.suffix ?? ''}'
            .trim();
    positionResult.fold((data) {
      position = data;
    }, (error) {});
    returnSalesBody = sales_body.SalesBody(
        id: now.millisecondsSinceEpoch.toString(),
        type: SaleTypes.salesReturn,
        customerId: salesBodyToReturn!.customerId,
        customerAddress: salesBodyToReturn!.customerAddress,
        discount: salesBodyToReturn!.discount,
        additionalCess: salesBodyToReturn!.additionalCess,
        cess: salesBodyToReturn!.cess,
        roundoff: salesBodyToReturn!.roundoff,
        invoiceDate: formattedDate,
        isTaxincluded: salesBodyToReturn!.isTaxincluded,
        salesId: '0',
        cashType: radioValue,
        deliveryDate: formattedDate,
        creditEod: formattedDate,
        total: grandTotal.value.toString(),
        salesman: AppData().getUser().userName ?? '',
        route: '',
        vehicle: '',
        area: salesBodyToReturn!.area,
        refAmount: salesBodyToReturn!.refAmount,
        taxId: salesBodyToReturn!.taxId,
        advance: salesBodyToReturn!.advance,
        other: salesBodyToReturn!.other,
        freight: salesBodyToReturn!.freight,
        invoice: invoiceNumber,
        refId: salesBodyToReturn!.refId,
        createdDate:
            '$formattedDate ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
        narration: salesBodyToReturn!.narration,
        salesOrderId: salesBodyToReturn!.salesOrderId,
        salesRefType: salesBodyToReturn!.salesRefType,
        createdBy: AppData().getUser().id ?? '',
        billType: salesBodyToReturn!.billType,
        cusname: salesBodyToReturn!.cusname,
        cusemail: salesBodyToReturn!.cusemail,
        cusdetails: salesBodyToReturn!.cusdetails,
        customerPhone: salesBodyToReturn!.customerPhone,
        subtot: grandTotal.value.toString(),
        tax: salesBodyToReturn!.tax,
        latitude: position?.latitude.toString(),
        longitude: position?.longitude.toString(),
        saletype: salesBodyToReturn!.saletype,
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
              godown: double.parse(e.godown ?? '0'),
              itmCesPer: double.parse(e.cesPercent ?? '0'),
              itmRawCess: double.parse(e.cessId!),
              mrp: double.parse(e.mrp!),
              rate: double.parse(e.srate!));
        }).toList(),
        loginUserId: AppData().getUser().id ?? '',
        taxtotal: '0');
    await InsertSalesBody().insertSalesBody(returnSalesBody);
    for (var item in returnSalesBody.salesitems ?? <sales_body.SalesItems>[]) {
      await InsertItemStock().updateStockItemQuantity(
        itemId: item.itemId ?? '',
        quantity: int.tryParse(item.quantity ?? '0') ?? 0,
      );
    }
    await InsertBillNumber().updateBillNumber(billNumber.copyWith(
        startnumber: (double.parse(billNumber.startnumber ?? '0') + 1)
            .round()
            .toString()));
    await sendSMS(double.parse(returnSalesBody.total ?? '0'));
    if (AppData().getSettings().syncOnSave ?? false) {
      //TODO: Send data to server
      final result = await SalesRepository().createSales(returnSalesBody);
      result.fold((data) async {
        await SalesBodySync()
            .updateSalesBodySync(id: returnSalesBody.id ?? '', status: 1);
      }, (error) {});
    }
    clearSales();
    update();
  }

  void decrementItemQuantity(Items item) {
    int qty = selectedQuantity[item.id!] ?? 0;
    qty -= 1;
    selectedQuantity[item.id!] = qty;
    updateGrandTotal();
    update();
  }

  void setItemQuantity({required Items item, required int quantity}) {
    final salesItem = salesBodyToReturn?.salesitems
        ?.firstWhereOrNull((element) => element.itemId == item.id);
    if (salesItem != null) {
      int itemQty = int.parse(salesItem.quantity!);
      if (itemQty < quantity) {
        showAlert(
            context: Get.context!,
            title: 'Quantity exceeds',
            content:
                'Quantity exceeds items bought quantity. Saving this will only set the quantity as ${selectedQuantity[item.id!]}');
      } else {
        selectedQuantity[item.id!] = quantity;
      }
    }
    updateGrandTotal();
    update();
  }

  void addItem(Items item) {
    addedItems.add(item);
    updateGrandTotal();
    clearSelectedItem();
    update();
  }

  void removeItem(Items item) {
    addedItems.remove(item);
    updateGrandTotal();
    update();
  }

  RxDouble grandTotal = 0.0.obs;

  void updateGrandTotal() {
    if (addedItems.isNotEmpty) {
      grandTotal.value = 0.0;
      grandTotal.value = addedItems
          .map((e) => double.parse(e.mrp!) * selectedQuantity[e.id!]!)
          .reduce((value, element) => value + element);
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
  }

  void getPayableAmount() {
    payableAmount.text = grandTotal.value.toStringAsFixed(2);
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
                  Get.toNamed(RoutesName.pdfView, arguments: {'invoice': ''});
                } else {
                  Utils().showToast('Enter valid UPI ID');
                }
              },
              child: const Text('Set')),
        ],
      ),
    );
  }

  void updateRadioValue(String value) {
    radioValue = value;
    update();
  }

  void clearSelectedItem() {
    selectedItem(Items());
    quantityController.clear();
    itemController.clear();
    update();
  }

  confirmNewSale() {
    if (salesBodyToReturn != null) {
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                    'Your current data will not be saved!. And will lose all unsaved data.'),
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
    discountController.clear();
    payableAmount.clear();
    quantityController.clear();
    itemController.clear();
    itemsToReturn.clear();
    salesBody.clear();
    selectedCustomer(Customers());
    selectedItem(Items());
    // gstType = 'included';
    radioValue = 'Cash';
    grandTotal(0.0);
    update();
  }
}

class MaxValueInputFormatter extends TextInputFormatter {
  final double maxValue;
  final String errorMessage;

  MaxValueInputFormatter(this.maxValue,
      [this.errorMessage = 'Quantity exceeds']);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final double? newNumber = double.tryParse(newValue.text);
    if (newNumber == null || newNumber > maxValue) {
      Utils().cancelToast();
      Utils().showToast(errorMessage);
      return oldValue;
    }
    return newValue;
  }
}
