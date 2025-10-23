import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/widgets/solid_button.dart';

import '../data/app_data.dart';
import '../database/tables/export_insert.dart';
import '../models/currency.dart';
import '../models/device_details.dart';
import '../screens/neworder/controller/new_order_controller.dart';
import '../screens/newsale/controller/new_sale_controller.dart';
import '../utils/utils.dart';

class EditItemPopUp extends StatefulWidget {
  final Items item;
  final VoidCallback save;
  final VoidCallback? cancel;
  final void Function(String value) onQuantityChanged;
  final void Function(String value) onTotalChanged;

  const EditItemPopUp({
    super.key,
    required this.item,
    required this.save,
    required this.onQuantityChanged,
    required this.onTotalChanged,
    this.cancel,
  });

  @override
  State<EditItemPopUp> createState() => _EditItemPopUpState();
}

class _EditItemPopUpState extends State<EditItemPopUp> {
  TextEditingController _quantityController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isFirstTap = true;
  bool canEditRate = false;
  String rate = '0';
  Tax tax = Tax();
  List<Unit> units = [];
  Unit unit = Unit();
  String? currentRate = '';

  Future<void> getUnit() async {
    units = await InsertUnit().getUnits();
    unit = units.firstWhere((e) => num.parse(e.unitCount ?? '0') == 1,
        orElse: () => Unit());
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _isFirstTap) {
        _quantityController.selection = TextSelection(
            baseOffset: 0, extentOffset: _quantityController.text.length);
        _isFirstTap = false;
      }
    });
    rate = widget.item.srate ?? '0';
    updateEditRate();
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void updateEditRate() async {
    List<Device> details = await InsertDevice().getDevice();
    Device device = details.first;
    currentRate = widget.item.srate;
    await getRate();
    await getUnit();
    setState(() {
      canEditRate = device.editItemrate == '1';
    });
  }

  Future<void> getTax() async {
    tax = await InsertTax().getTaxById(widget.item.taxId ?? '0');
  }

  num applyTax(num amount) {
    double taxRate = double.tryParse(tax.gst?.toString() ?? '0') ?? 0;
    double cesRate = double.tryParse(tax.cesPercent?.toString() ?? '0') ?? 0;

    if (AppData().getTaxInclude()) {
      // If tax is already included, return the amount as is
      return amount;
    } else {
      // Apply both tax and ces
      double taxAmount = amount * (taxRate / 100);
      double cesAmount = taxAmount * (cesRate / 100);

      return amount + taxAmount + cesAmount;
    }
  }

  Future<void> getRate() async {
    await getTax();
    if (Get.isRegistered<NewSaleController>()) {
      final controller = Get.find<NewSaleController>();
      final customer = controller.selectedCustomer.value;
      String customerRate = customer.cusRate ?? '';
      final bill = controller.billNumber;
      PriceListDetails pList = await InsertPriceListDetails()
          .getPriceListDetailsById(widget.item.priceListId ?? '');
      if (customerRate.isNotEmpty) {
        final itemJson = widget.item.toJson();
        rate = itemJson[customerRate]?.toString() ?? '0';
        // rate = customerRate == 'srate'
        //     ? widget.item.srate ?? '0'
        //     : customerRate == 'prate'
        //         ? widget.item.prate ?? '0'
        //         : customerRate == 'wh_rate'
        //             ? widget.item.whRate ?? '0'
        //             : customerRate == 'mrp'
        //                 ? widget.item.mrp ?? '0'
        //                 : customerRate == 'special_rate'
        //                     ? widget.item.specialRate ?? '0'
        //                     : '0';
      } else if ((controller.selectedCustomer.value.priceList?.isNotEmpty ??
              false) &&
          controller.selectedCustomer.value.priceList != '0') {
        PriceListDetails cusPList = await InsertPriceListDetails()
            .getPriceListDetailsById(
                controller.selectedCustomer.value.priceList!);
        rate = cusPList.salesRate ?? '0';
        discountController.text = cusPList.priceDiscountAmount ?? '0';
        percentageController.text = cusPList.priceDiscount ?? '0';
      } else if (bill.setRate?.isNotEmpty ?? false) {
        String billRate = bill.setRate?.toLowerCase() ?? '';
        final itemJson = widget.item.toJson();
        rate = itemJson[billRate]?.toString() ?? '0';
        // rate = billRate == 'srate'
        //     ? widget.item.srate ?? '0'
        //     : billRate == 'prate'
        //         ? widget.item.prate ?? '0'
        //         : billRate == 'wh_rate'
        //             ? widget.item.whRate ?? '0'
        //             : billRate == 'mrp'
        //                 ? widget.item.mrp ?? '0'
        //                 : billRate == 'special_rate'
        //                     ? widget.item.specialRate ?? '0'
        //                     : '0';
      } else if (pList.salesRate?.isNotEmpty ?? false) {
        rate = pList.salesRate!;
        rate = pList.salesRate!;
        discountController.text = pList.priceDiscountAmount ?? '0';
        percentageController.text = pList.priceDiscount ?? '0';
      } else {
        rate = widget.item.srate ?? '';
      }
    }
    rateController.text = rate;
    discountController.text = widget.item.priceDiscount ?? '0';
    percentageController.text =
        calculatePercentage(widget.item.priceDiscount ?? '0');
    totalController.text = calculateTotal();
  }

  String calculateTotal() {
    return (applyTax(Utils().roundIfWhole(num.parse(rate.isEmpty ? "0" : rate) -
            num.parse(discountController.text.isEmpty
                ? "0"
                : discountController.text))))
        .toString();
  }

  String calculatePercentage(String value) {
    if (value.isNotEmpty) {
      return (Utils()
              .roundIfWhole((double.parse(value) / double.parse(rate)) * 100))
          .toStringAsFixed(2);
    } else {
      return '0';
    }
  }

  String convertToValue(String value) {
    if (value.isNotEmpty) {
      return (Utils()
              .roundIfWhole((double.parse(value) / 100) * double.parse(rate)))
          .toString();
    } else {
      return '0';
    }
  }

  void changeRate(String value) {
    if (canEditRate) {
      setState(() {
        rate = value;
        rateController.text = value;
      });
      totalController.text = calculateTotal();
    }
  }

  @override
  Widget build(BuildContext context) {
    NewOrderController? newOrderController;
    if (Get.isRegistered<NewOrderController>()) {
      newOrderController = Get.find<NewOrderController>();
    }

    _quantityController.text =
        newOrderController?.selectedQuantity[widget.item.id!].toString() ??
            widget.item.itemQty ??
            '1';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name!),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              Wrap(
                spacing: SizeConstant.percentToHeight(2.5),
                runSpacing: 28,
                children: [
                  buildTextEntry(
                      label: 'Quantity',
                      readOnly: false,
                      controller: _quantityController,
                      focus: _focusNode,
                      onChanged: widget.onQuantityChanged,
                      hintText: newOrderController
                              ?.selectedQuantity[widget.item.id!]
                              .toString() ??
                          widget.item.itemQty ??
                          '1'),
                  buildTextEntry(
                      label: 'MRP',
                      hintText: widget.item.mrp ?? '0',
                      initialValue: widget.item.mrp ?? '0',
                      onTap: () => changeRate(widget.item.mrp ?? '0')),
                  buildTextEntry(
                      label: 'WholeSale Price',
                      hintText: widget.item.whRate ?? '0',
                      initialValue: widget.item.whRate ?? '0',
                      onTap: () => changeRate(widget.item.whRate ?? '0')),
                  buildTextEntry(
                      label: 'Special Price',
                      hintText: widget.item.specialRate ?? '0',
                      initialValue: widget.item.specialRate ?? '0',
                      onTap: () => changeRate(widget.item.specialRate ?? '0')),
                  buildTextEntry(
                      controller: rateController,
                      hintText: rate,
                      label: 'Rate'),
                  buildTextEntry(
                    controller: discountController,
                    readOnly: false,
                    label:
                        'Discount ${Currency.getById(AppData().getSettings().currency).symbol}',
                    onChanged: (value) {
                      percentageController.text = calculatePercentage(value);
                      widget.item.priceDiscount = value;
                      totalController.text = calculateTotal();
                    },
                  ),
                  buildTextEntry(
                    controller: percentageController,
                    readOnly: false,
                    label: 'Discount %',
                    onChanged: (value) {
                      discountController.text = convertToValue(value);
                      widget.item.priceDiscount = convertToValue(value);
                      totalController.text = calculateTotal();
                    },
                  ),
                  buildTextEntry(
                    controller: totalController,
                    label: 'Total',
                    hintText: calculateTotal(),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: DropdownMenu(
                        trailingIcon: SizedBox.shrink(),
                        expandedInsets: EdgeInsets.symmetric(horizontal: 12),
                        label: Text('Unit'),
                        textAlign: TextAlign.center,
                        inputDecorationTheme: InputDecorationTheme(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            isDense: true,
                            suffixIconConstraints: const BoxConstraints.expand(
                                width: 0, height: 0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey))),
                        dropdownMenuEntries: units.map(
                          (e) {
                            return DropdownMenuEntry(
                                value: e.unitId, label: e.name!);
                          },
                        ).toList(),
                        initialSelection: unit.unitId,
                        onSelected: (value) {
                          unit = units
                              .firstWhere((element) => element.unitId == value);
                          widget.item.unitId = value;
                        }),
                  ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: Text(
              //       'Quantity',
              //       style: FontConstant().popUpStyle,
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             width: SizeConstant.screenWidth * .36,
              //             child: TextFormField(
              //               controller: _quantityController,
              //               focusNode: _focusNode,
              //               onFieldSubmitted: (value) {
              //                 if (stockTransferController != null) {
              //                   stockTransferController.setItemQuantity(
              //                       item: widget.item,
              //                       quantity: value.isNotEmpty
              //                           ? int.parse(value)
              //                           : 1);
              //                 } else if (newSaleController != null) {
              //                   newSaleController.setItemQuantity(
              //                       item: widget.item,
              //                       quantity: value.isNotEmpty
              //                           ? int.parse(value)
              //                           : 1);
              //                 } else if (newOrderController != null) {
              //                   newOrderController.setItemQuantity(
              //                       item: widget.item,
              //                       quantity: value.isNotEmpty
              //                           ? int.parse(value)
              //                           : 1);
              //                 } else if (salesReturnController != null) {
              //                   salesReturnController.setItemQuantity(
              //                       item: widget.item,
              //                       quantity: value.isNotEmpty
              //                           ? int.parse(value)
              //                           : 1);
              //                 }
              //               },
              //               onChanged: (value) {
              //                 if (stockTransferController != null) {
              //                   stockTransferController.setItemQuantity(
              //                       item: widget.item,
              //                       quantity: value.isNotEmpty
              //                           ? int.parse(value)
              //                           : 1);
              //                 } else if (newSaleController != null) {
              //                   newSaleController.setItemQuantity(
              //                       item: widget.item,
              //                       quantity: value.isNotEmpty
              //                           ? int.parse(value)
              //                           : 1);
              //                 } else if (newOrderController != null) {
              //                   newOrderController.setItemQuantity(
              //                       item: widget.item,
              //                       quantity: value.isNotEmpty
              //                           ? int.parse(value)
              //                           : 1);
              //                 } else if (salesReturnController != null) {
              //                   salesReturnController.setItemQuantity(
              //                       item: widget.item,
              //                       quantity: value.isNotEmpty
              //                           ? int.parse(value)
              //                           : 1);
              //                 }
              //               },
              //               keyboardType: TextInputType.number,
              //               inputFormatters: [
              //                 FilteringTextInputFormatter.digitsOnly
              //               ],
              //               textAlign: TextAlign.center,
              //               decoration: InputDecoration(
              //                 contentPadding: const EdgeInsets.all(8),
              //                 isDense: true,
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: const BorderSide(
              //                         color: AppStyle.radioColor)),
              //               ),
              //             ),
              //           )),
              //     ),
              //   ]),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: Text(
              //       'Unit',
              //       style: FontConstant().popUpStyle,
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //         alignment: Alignment.center,
              //         child: DropdownMenu(
              //             trailingIcon: SizedBox.shrink(),
              //             expandedInsets: EdgeInsets.symmetric(horizontal: 12),
              //             textAlign: TextAlign.center,
              //             inputDecorationTheme: InputDecorationTheme(
              //                 contentPadding:
              //                     const EdgeInsets.symmetric(vertical: 12),
              //                 isDense: true,
              //                 suffixIconConstraints:
              //                     const BoxConstraints.expand(
              //                         width: 0, height: 0),
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: BorderSide(color: Colors.grey))),
              //             dropdownMenuEntries: units.map(
              //               (e) {
              //                 return DropdownMenuEntry(
              //                     value: e.id, label: e.name!);
              //               },
              //             ).toList(),
              //             initialSelection: units.first.id,
              //             onSelected: (value) => unit = units
              //                 .firstWhere((element) => element.id == value)),
              //       ),
              //     ),
              //   ]),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: Text(
              //       'MRP',
              //       style: FontConstant().popUpStyle,
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             width: SizeConstant.screenWidth * .36,
              //             child: TextFormField(
              //               readOnly: true,
              //               onTap: () => changeRate(widget.item.mrp ?? '0'),
              //               initialValue: widget.item.mrp.toString(),
              //               // onFieldSubmitted: (value) =>
              //               //     controller.setItemQuantity(
              //               //         item: item,
              //               //         quantity:
              //               //         value.isNotEmpty ? int.parse(value) : 1),
              //               // onChanged: (value) => controller.setItemQuantity(
              //               //     item: item,
              //               //     quantity:
              //               //     value.isNotEmpty ? int.parse(value) : 1),
              //               keyboardType: TextInputType.number,
              //               inputFormatters: [
              //                 FilteringTextInputFormatter.allow(
              //                     RegExp(r'^\d*\.?\d*'))
              //               ],
              //               textAlign: TextAlign.center,
              //               decoration: InputDecoration(
              //                 contentPadding: const EdgeInsets.all(8),
              //                 isDense: true,
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: const BorderSide(
              //                         color: AppStyle.radioColor)),
              //               ),
              //             ),
              //           )),
              //     ),
              //   ]),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: Text(
              //       'Wholesale Price',
              //       style: FontConstant().popUpStyle,
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             width: SizeConstant.screenWidth * .36,
              //             child: TextFormField(
              //               readOnly: true,
              //               initialValue: widget.item.whRate.toString(),
              //               onTap: () => changeRate(widget.item.whRate ?? '0'),
              //               // onFieldSubmitted: (value) =>
              //               //     controller.setItemQuantity(
              //               //         item: item,
              //               //         quantity:
              //               //         value.isNotEmpty ? int.parse(value) : 1),
              //               // onChanged: (value) => controller.setItemQuantity(
              //               //     item: item,
              //               //     quantity:
              //               //     value.isNotEmpty ? int.parse(value) : 1),
              //               keyboardType: TextInputType.number,
              //               inputFormatters: [
              //                 FilteringTextInputFormatter.allow(
              //                     RegExp(r'^\d*\.?\d*'))
              //               ],
              //               textAlign: TextAlign.center,
              //               decoration: InputDecoration(
              //                 contentPadding: const EdgeInsets.all(8),
              //                 isDense: true,
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: const BorderSide(
              //                         color: AppStyle.radioColor)),
              //               ),
              //             ),
              //           )),
              //     ),
              //   ]),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: Text(
              //       'Special Price',
              //       style: FontConstant().popUpStyle,
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             width: SizeConstant.screenWidth * .36,
              //             child: TextFormField(
              //               readOnly: true,
              //               initialValue: widget.item.specialRate.toString(),
              //               onTap: () =>
              //                   changeRate(widget.item.specialRate ?? '0'),
              //               // onFieldSubmitted: (value) =>
              //               //     controller.setItemQuantity(
              //               //         item: item,
              //               //         quantity:
              //               //         value.isNotEmpty ? int.parse(value) : 1),
              //               // onChanged: (value) => controller.setItemQuantity(
              //               //     item: item,
              //               //     quantity:
              //               //     value.isNotEmpty ? int.parse(value) : 1),
              //               keyboardType: TextInputType.number,
              //               inputFormatters: [
              //                 FilteringTextInputFormatter.allow(
              //                     RegExp(r'^\d*\.?\d*'))
              //               ],
              //               textAlign: TextAlign.center,
              //               decoration: InputDecoration(
              //                 contentPadding: const EdgeInsets.all(8),
              //                 isDense: true,
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: const BorderSide(
              //                         color: AppStyle.radioColor)),
              //               ),
              //             ),
              //           )),
              //     ),
              //   ]),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: Text(
              //       'Rate',
              //       style: FontConstant().popUpStyle,
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             width: SizeConstant.screenWidth * .36,
              //             child: TextFormField(
              //               readOnly: true,
              //               controller: rateController,
              //               // onFieldSubmitted: (value) =>
              //               //     controller.setItemQuantity(
              //               //         item: item,
              //               //         quantity:
              //               //         value.isNotEmpty ? int.parse(value) : 1),
              //               // onChanged: (value) => controller.setItemQuantity(
              //               //     item: item,
              //               //     quantity:
              //               //     value.isNotEmpty ? int.parse(value) : 1),
              //               keyboardType: TextInputType.number,
              //               inputFormatters: [
              //                 // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')
              //               ],
              //               textAlign: TextAlign.center,
              //               decoration: InputDecoration(
              //                 contentPadding: const EdgeInsets.all(8),
              //                 isDense: true,
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: const BorderSide(
              //                         color: AppStyle.radioColor)),
              //               ),
              //             ),
              //           )),
              //     ),
              //   ]),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: Text(
              //       'Discount Amount',
              //       style: FontConstant().popUpStyle,
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             width: SizeConstant.screenWidth * .36,
              //             child: TextFormField(
              //               readOnly: false,
              //               controller: discountController,
              //               // onFieldSubmitted: (value) =>
              //               //     controller.setItemQuantity(
              //               //         item: item,
              //               //         quantity:
              //               //         value.isNotEmpty ? int.parse(value) : 1),
              //               onChanged: (value) {
              //                 percentageController.text =
              //                     calculatePercentage(value);
              //                 totalController.text = calculateTotal();
              //               },
              //               keyboardType: TextInputType.number,
              //               inputFormatters: [
              //                 FilteringTextInputFormatter.allow(
              //                     RegExp(r'^\d*\.?\d*'))
              //               ],
              //               textAlign: TextAlign.center,
              //               decoration: InputDecoration(
              //                 contentPadding: const EdgeInsets.all(8),
              //                 isDense: true,
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: const BorderSide(
              //                         color: AppStyle.radioColor)),
              //               ),
              //             ),
              //           )),
              //     ),
              //   ]),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: FittedBox(
              //       fit: BoxFit.scaleDown,
              //       child: Text(
              //         'Discount Percentage  ',
              //         style: FontConstant().popUpStyle,
              //       ),
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             width: SizeConstant.screenWidth * .36,
              //             child: TextFormField(
              //               readOnly: false,
              //               controller: percentageController,
              //               // onFieldSubmitted: (value) =>
              //               //     controller.setItemQuantity(
              //               //         item: item,
              //               //         quantity:
              //               //         value.isNotEmpty ? int.parse(value) : 1),
              //               onChanged: (value) {
              //                 discountController.text = convertToValue(value);
              //                 totalController.text = calculateTotal();
              //               },
              //               keyboardType: TextInputType.number,
              //               inputFormatters: [
              //                 FilteringTextInputFormatter.allow(
              //                     RegExp(r'^\d*\.?\d*'))
              //               ],
              //               textAlign: TextAlign.center,
              //               decoration: InputDecoration(
              //                 contentPadding: const EdgeInsets.all(8),
              //                 isDense: true,
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: const BorderSide(
              //                         color: AppStyle.radioColor)),
              //               ),
              //             ),
              //           )),
              //     ),
              //   ]),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 18.0),
              //   child: Row(children: [
              //     Expanded(
              //         child: Text(
              //       'Total Amount',
              //       style: FontConstant().popUpStyle,
              //     )),
              //     const Text(':'),
              //     Expanded(
              //       child: Container(
              //           alignment: Alignment.center,
              //           child: SizedBox(
              //             width: SizeConstant.screenWidth * .36,
              //             child: TextFormField(
              //               readOnly: true,
              //               controller: totalController,
              //               // onFieldSubmitted: (value) =>
              //               //     controller.setItemQuantity(
              //               //         item: item,
              //               //         quantity:
              //               //         value.isNotEmpty ? int.parse(value) : 1),
              //               // onChanged: (value) => controller.setItemQuantity(
              //               //     item: item,
              //               //     quantity:
              //               //     value.isNotEmpty ? int.parse(value) : 1),
              //               keyboardType: TextInputType.number,
              //               inputFormatters: [
              //                 FilteringTextInputFormatter.allow(
              //                     RegExp(r'^\d*\.?\d*'))
              //               ],
              //               textAlign: TextAlign.center,
              //               decoration: InputDecoration(
              //                 contentPadding: const EdgeInsets.all(8),
              //                 isDense: true,
              //                 border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide:
              //                         const BorderSide(color: Colors.grey)),
              //                 focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     borderSide: const BorderSide(
              //                         color: AppStyle.radioColor)),
              //               ),
              //             ),
              //           )),
              //     ),
              //   ]),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SolidButton(
                      onTap: () {
                        Get.back();
                        widget.save();
                      },
                      width: SizeConstant.screenWidth * .3,
                      height: 50,
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      )),
                  SolidButton(
                    onTap: () {
                      widget.item.srate = currentRate;
                      widget.cancel?.call();
                      Get.back();
                    },
                    width: SizeConstant.screenWidth * .3,
                    height: 50,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextEntry({
    bool readOnly = true,
    String? label,
    TextEditingController? controller,
    String? initialValue,
    String? hintText,
    VoidCallback? onTap,
    FocusNode? focus,
    Function(String)? onSubmitted,
    Function(String)? onChanged,
  }) {
    return SizedBox(
      width: SizeConstant.screenWidth * .4,
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        initialValue: initialValue,
        onTap: onTap,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        focusNode: focus,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        ],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          isDense: true,
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppStyle.radioColor)),
        ),
      ),
    );
  }
}
