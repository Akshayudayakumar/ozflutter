import 'dart:convert';

import 'package:ozone_erp/data/app_data.dart';
import 'package:ozone_erp/models/device_details.dart' as sp;
import 'package:ozone_erp/models/sale_types.dart';

class SalesBody {
  SalesBody({
    String? invoiceDate,
    String? isTaxincluded,
    String? id,
    String? salesId,
    String? customerId,
    String? cashType,
    String? deliveryDate,
    String? creditEod,
    String? total,
    String? salesman,
    String? route,
    String? vehicle,
    String? area,
    String? refAmount,
    String? taxId,
    String? advance,
    String? other,
    String? freight,
    String? discount,
    String? roundoff,
    String? invoice,
    String? refId,
    String? createdDate,
    String? narration,
    String? salesOrderId,
    String? salesRefType,
    String? createdBy,
    String? type,
    String? billType,
    String? cusname,
    String? cusdetails,
    String? cusemail,
    String? customerAddress,
    String? customerPhone,
    String? subtot,
    String? taxtotal,
    String? latitude,
    String? longitude,
    String? saletype,
    List<SalesItems>? salesitems,
    String? additionalCess,
    String? cess,
    String? tax,
    String? loginUserId,
  }) {
    _invoiceDate = invoiceDate;
    _isTaxincluded = isTaxincluded;
    _id = id;
    _salesId = salesId;
    _customerId = customerId;
    _cashType = cashType;
    _deliveryDate = deliveryDate;
    _creditEod = creditEod;
    _total = total;
    _salesman = salesman;
    _route = route;
    _vehicle = vehicle;
    _area = area;
    _refAmount = refAmount;
    _taxId = taxId;
    _advance = advance;
    _other = other;
    _freight = freight;
    _discount = discount;
    _roundoff = roundoff;
    _invoice = invoice;
    _refId = refId;
    _createdDate = createdDate;
    _narration = narration;
    _salesOrderId = salesOrderId;
    _salesRefType = salesRefType;
    _createdBy = createdBy;
    _type = type;
    _billType = billType;
    _cusname = cusname;
    _cusdetails = cusdetails;
    _cusemail = cusemail;
    _customerAddress = customerAddress;
    _customerPhone = customerPhone;
    _subtot = subtot;
    _taxtotal = taxtotal;
    _latitude = latitude;
    _longitude = longitude;
    _saletype = saletype;
    _salesitems = salesitems;
    _additionalCess = additionalCess;
    _cess = cess;
    _tax = tax;
    _loginUserId = loginUserId;
  }

  factory SalesBody.fromOrder(sp.SalesOrders order) {
    return SalesBody(
      customerId: order.customerId,
      salesId: order.salesId,
      type: SaleTypes.salesOrder,
      longitude: order.longitude,
      latitude: order.latitude,
      total: order.total,
      deliveryDate: order.deliveryDate,
      id: order.salesId,
      additionalCess: order.additionalCess,
      advance: order.advance,
      area: order.area,
      billType: order.billType,
      cashType: order.cashType,
      cess: order.cess,
      createdBy: order.createdBy,
      createdDate: order.createdDate,
      creditEod: order.creditEod,
      cusdetails: order.cusdetails,
      cusemail: order.cusemail,
      cusname: order.cusname,
      discount: order.discount,
      freight: order.freight,
      invoice: order.invoice,
      invoiceDate: order.invoiceDate,
      isTaxincluded:
          (order.taxId != null && order.taxId != '' && order.taxId != '0')
              .toString(),
      loginUserId: AppData().getUserID(),
      narration: order.narration,
      other: order.other,
      refAmount: order.refAmount,
      refId: order.refId,
      roundoff: order.roundoff,
      route: order.route,
      salesman: order.salesman,
      salesOrderId: order.salesId,
      salesRefType: order.salesRef,
      saletype: order.saletype,
      subtot: order.total,
      tax: order.tax,
      taxId: order.taxId,
      vehicle: order.vehicle,
      salesitems: order.salesItems
          ?.map(
            (e) => SalesItems.fromOrder(e),
          )
          .toList(),
    );
  }

  SalesBody.fromJson(dynamic json) {
    _invoiceDate = json['invoice_date'];
    _isTaxincluded = json['is_taxincluded'];
    _id = json['id'];
    _salesId = json['sales_id'];
    _customerId = json['customer_id'];
    _cashType = json['cash_type'];
    _deliveryDate = json['delivery_date'];
    _creditEod = json['credit_eod'];
    _total = json['total'];
    _salesman = json['salesman'];
    _route = json['route'];
    _vehicle = json['vehicle'];
    _area = json['area'];
    _refAmount = json['ref_amount'];
    _taxId = json['tax_id'];
    _advance = json['advance'];
    _other = json['other'];
    _freight = json['freight'];
    _discount = json['discount'];
    _roundoff = json['roundoff'];
    _invoice = json['invoice'];
    _refId = json['ref_id'];
    _createdDate = json['created_date'];
    _narration = json['narration'];
    _salesOrderId = json['sales_order_id'];
    _salesRefType = json['sales_ref_type'];
    _createdBy = json['created_by'];
    _type = json['type'];
    _billType = json['bill_type'];
    _cusname = json['cusname'];
    _cusdetails = json['cusdetails'];
    _cusemail = json['cusemail'];
    _customerAddress = json['customer_address'];
    _customerPhone = json['customer_phone'];
    _subtot = json['subtot'];
    _taxtotal = json['taxtotal'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _saletype = json['saletype'];
    if (json['salesitems'] != null) {
      _salesitems = [];
      var salesItemsData = json['salesitems'];

      // If salesitems is a string, decode it
      if (salesItemsData is String) {
        salesItemsData = jsonDecode(salesItemsData);
      }

      // Iterate over the salesitems and map them to SalesItems objects
      if (salesItemsData is List) {
        salesItemsData.forEach((v) {
          _salesitems?.add(SalesItems.fromJson(v));
        });
      }
    }
    _additionalCess = json['additional_cess'];
    _cess = json['cess'];
    _tax = json['tax'];
    _loginUserId = json['login_user_id'];
  }

  String? _invoiceDate;
  String? _isTaxincluded;
  String? _id;
  String? _salesId;
  String? _customerId;
  String? _cashType;
  String? _deliveryDate;
  String? _creditEod;
  String? _total;
  String? _salesman;
  String? _route;
  String? _vehicle;
  String? _area;
  String? _refAmount;
  String? _taxId;
  String? _advance;
  String? _other;
  String? _freight;
  String? _discount;
  String? _roundoff;
  String? _invoice;
  String? _refId;
  String? _createdDate;
  String? _narration;
  String? _salesOrderId;
  String? _salesRefType;
  String? _createdBy;
  String? _type;
  String? _billType;
  String? _cusname;
  String? _cusdetails;
  String? _cusemail;
  String? _customerAddress;
  String? _customerPhone;
  String? _subtot;
  String? _taxtotal;
  String? _latitude;
  String? _longitude;
  String? _saletype;
  List<SalesItems>? _salesitems;
  String? _additionalCess;
  String? _cess;
  String? _tax;
  String? _loginUserId;

  SalesBody copyWith({
    String? invoiceDate,
    String? isTaxincluded,
    String? id,
    String? salesId,
    String? customerId,
    String? cashType,
    String? deliveryDate,
    String? creditEod,
    String? total,
    String? salesman,
    String? route,
    String? vehicle,
    String? area,
    String? refAmount,
    String? taxId,
    String? advance,
    String? other,
    String? freight,
    String? discount,
    String? roundoff,
    String? invoice,
    String? refId,
    String? createdDate,
    String? narration,
    String? salesOrderId,
    String? salesRefType,
    String? createdBy,
    String? type,
    String? billType,
    String? cusname,
    String? cusdetails,
    String? cusemail,
    String? customerAddress,
    String? customerPhone,
    String? subtot,
    String? taxtotal,
    String? latitude,
    String? longitude,
    String? saletype,
    List<SalesItems>? salesitems,
    String? additionalCess,
    String? cess,
    String? tax,
    String? loginUserId,
  }) =>
      SalesBody(
        invoiceDate: invoiceDate ?? _invoiceDate,
        isTaxincluded: isTaxincluded ?? _isTaxincluded,
        id: id ?? _id,
        salesId: salesId ?? _salesId,
        customerId: customerId ?? _customerId,
        cashType: cashType ?? _cashType,
        deliveryDate: deliveryDate ?? _deliveryDate,
        creditEod: creditEod ?? _creditEod,
        total: total ?? _total,
        salesman: salesman ?? _salesman,
        route: route ?? _route,
        vehicle: vehicle ?? _vehicle,
        area: area ?? _area,
        refAmount: refAmount ?? _refAmount,
        taxId: taxId ?? _taxId,
        advance: advance ?? _advance,
        other: other ?? _other,
        freight: freight ?? _freight,
        discount: discount ?? _discount,
        roundoff: roundoff ?? _roundoff,
        invoice: invoice ?? _invoice,
        refId: refId ?? _refId,
        createdDate: createdDate ?? _createdDate,
        narration: narration ?? _narration,
        salesOrderId: salesOrderId ?? _salesOrderId,
        salesRefType: salesRefType ?? _salesRefType,
        createdBy: createdBy ?? _createdBy,
        type: type ?? _type,
        billType: billType ?? _billType,
        cusname: cusname ?? _cusname,
        cusdetails: cusdetails ?? _cusdetails,
        cusemail: cusemail ?? _cusemail,
        customerAddress: customerAddress ?? _customerAddress,
        customerPhone: customerPhone ?? _customerPhone,
        subtot: subtot ?? _subtot,
        taxtotal: taxtotal ?? _taxtotal,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        saletype: saletype ?? _saletype,
        salesitems: salesitems ?? _salesitems,
        additionalCess: additionalCess ?? _additionalCess,
        cess: cess ?? _cess,
        tax: tax ?? _tax,
        loginUserId: loginUserId ?? _loginUserId,
      );

  String? get invoiceDate => _invoiceDate;

  String? get isTaxincluded => _isTaxincluded;

  String? get id => _id;

  String? get salesId => _salesId;

  String? get customerId => _customerId;

  String? get cashType => _cashType;

  String? get deliveryDate => _deliveryDate;

  String? get creditEod => _creditEod;

  String? get total => _total;

  String? get salesman => _salesman;

  String? get route => _route;

  String? get vehicle => _vehicle;

  String? get area => _area;

  String? get refAmount => _refAmount;

  String? get taxId => _taxId;

  String? get advance => _advance;

  String? get other => _other;

  String? get freight => _freight;

  String? get discount => _discount;

  String? get roundoff => _roundoff;

  String? get invoice => _invoice;

  String? get refId => _refId;

  String? get createdDate => _createdDate;

  String? get narration => _narration;

  String? get salesOrderId => _salesOrderId;

  String? get salesRefType => _salesRefType;

  String? get createdBy => _createdBy;

  String? get type => _type;

  String? get billType => _billType;

  String? get cusname => _cusname;

  String? get cusdetails => _cusdetails;

  String? get cusemail => _cusemail;

  String? get customerAddress => _customerAddress;

  String? get customerPhone => _customerPhone;

  String? get subtot => _subtot;

  String? get taxtotal => _taxtotal;

  String? get latitude => _latitude;

  String? get longitude => _longitude;

  String? get saletype => _saletype;

  List<SalesItems>? get salesitems => _salesitems;

  String? get additionalCess => _additionalCess;

  String? get cess => _cess;

  String? get tax => _tax;

  String? get loginUserId => _loginUserId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['invoice_date'] = _invoiceDate;
    map['is_taxincluded'] = _isTaxincluded;
    map['id'] = _id;
    map['sales_id'] = _salesId;
    map['customer_id'] = _customerId;
    map['cash_type'] = _cashType;
    map['delivery_date'] = _deliveryDate;
    map['credit_eod'] = _creditEod;
    map['total'] = _total;
    map['salesman'] = _salesman;
    map['route'] = _route;
    map['vehicle'] = _vehicle;
    map['area'] = _area;
    map['ref_amount'] = _refAmount;
    map['tax_id'] = _taxId;
    map['advance'] = _advance;
    map['other'] = _other;
    map['freight'] = _freight;
    map['discount'] = _discount;
    map['roundoff'] = _roundoff;
    map['invoice'] = _invoice;
    map['ref_id'] = _refId;
    map['created_date'] = _createdDate;
    map['narration'] = _narration;
    map['sales_order_id'] = _salesOrderId;
    map['sales_ref_type'] = _salesRefType;
    map['created_by'] = _createdBy;
    map['type'] = _type;
    map['bill_type'] = _billType;
    map['cusname'] = _cusname;
    map['cusdetails'] = _cusdetails;
    map['cusemail'] = _cusemail;
    map['customer_address'] = _customerAddress;
    map['customer_phone'] = _customerPhone;
    map['subtot'] = _subtot;
    map['taxtotal'] = _taxtotal;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['saletype'] = _saletype;
    if (_salesitems != null) {
      map['salesitems'] = _salesitems?.map((v) => v.toJson()).toList();
    }
    map['additional_cess'] = _additionalCess;
    map['cess'] = _cess;
    map['tax'] = _tax;
    map['login_user_id'] = _loginUserId;
    return map;
  }
}

class SalesItems {
  SalesItems({
    String? itemId,
    num? godown,
    String? unitId,
    String? baseUnitId,
    num? mrp,
    num? rate,
    String? taxId,
    String? discount,
    String? total,
    String? published,
    String? itmCesId,
    String? itmCesName,
    num? itmCesPer,
    num? itmRawCess,
    String? ces,
    String? quantity,
    String? prate,
    num? cesAmt,
    String? tax,
  }) {
    _itemId = itemId;
    _godown = godown;
    _unitId = unitId;
    _baseUnitId = baseUnitId;
    _mrp = mrp;
    _rate = rate;
    _taxId = taxId;
    _discount = discount;
    _total = total;
    _published = published;
    _itmCesId = itmCesId;
    _itmCesName = itmCesName;
    _itmCesPer = itmCesPer;
    _itmRawCess = itmRawCess;
    _ces = ces;
    _quantity = quantity;
    _prate = prate;
    _cesAmt = cesAmt;
    _tax = tax;
  }

  factory SalesItems.fromOrder(sp.SalesItems item) {
    return SalesItems(
      taxId: item.taxId,
      tax: item.tax,
      discount: item.discount,
      total: item.total,
      quantity: item.quantity,
      baseUnitId: item.baseUnitId,
      ces: item.ces,
      cesAmt: num.tryParse(item.cesAmt ?? ''),
      godown: num.tryParse(item.godown ?? ''),
      itemId: item.salItmsId,
      itmCesId: item.itmCesId,
      itmCesName: item.itmCesName,
      itmCesPer: num.tryParse(item.itmCesPer ?? ''),
      itmRawCess: num.tryParse(item.itmRawCes ?? ''),
      mrp: num.tryParse(item.mrp ?? ''),
      prate: item.marPurRate,
      published: item.published,
      rate: num.tryParse(item.rate ?? ''),
      unitId: item.unitId,
    );
  }

  SalesItems.fromJson(dynamic json) {
    _itemId = json['item_id'];
    _godown = json['godown'];
    _unitId = json['unit_id'];
    _baseUnitId = json['base_unit_id'];
    _mrp = json['mrp'];
    _rate = json['rate'];
    _taxId = json['tax_id'];
    _discount = json['discount'];
    _total = json['total'];
    _published = json['published'];
    _itmCesId = json['itm_ces_id'];
    _itmCesName = json['itm_ces_name'];
    _itmCesPer = json['itm_ces_per'];
    _itmRawCess = json['itm_raw_cess'];
    _ces = json['ces'];
    _quantity = json['quantity'];
    _prate = json['prate'];
    _cesAmt = json['ces_amt'];
    _tax = json['tax'];
  }

  String? _itemId;
  num? _godown;
  String? _unitId;
  String? _baseUnitId;
  num? _mrp;
  num? _rate;
  String? _taxId;
  String? _discount;
  String? _total;
  String? _published;
  String? _itmCesId;
  String? _itmCesName;
  num? _itmCesPer;
  num? _itmRawCess;
  String? _ces;
  String? _quantity;
  String? _prate;
  num? _cesAmt;
  String? _tax;

  SalesItems copyWith({
    String? itemId,
    num? godown,
    String? unitId,
    String? baseUnitId,
    num? mrp,
    num? rate,
    String? taxId,
    String? discount,
    String? total,
    String? published,
    String? itmCesId,
    String? itmCesName,
    num? itmCesPer,
    num? itmRawCess,
    String? ces,
    String? quantity,
    String? prate,
    num? cesAmt,
    String? tax,
  }) =>
      SalesItems(
        itemId: itemId ?? _itemId,
        godown: godown ?? _godown,
        unitId: unitId ?? _unitId,
        baseUnitId: baseUnitId ?? _baseUnitId,
        mrp: mrp ?? _mrp,
        rate: rate ?? _rate,
        taxId: taxId ?? _taxId,
        discount: discount ?? _discount,
        total: total ?? _total,
        published: published ?? _published,
        itmCesId: itmCesId ?? _itmCesId,
        itmCesName: itmCesName ?? _itmCesName,
        itmCesPer: itmCesPer ?? _itmCesPer,
        itmRawCess: itmRawCess ?? _itmRawCess,
        ces: ces ?? _ces,
        quantity: quantity ?? _quantity,
        prate: prate ?? _prate,
        cesAmt: cesAmt ?? _cesAmt,
        tax: tax ?? _tax,
      );

  String? get itemId => _itemId;

  num? get godown => _godown;

  String? get unitId => _unitId;

  String? get baseUnitId => _baseUnitId;

  num? get mrp => _mrp;

  num? get rate => _rate;

  String? get taxId => _taxId;

  String? get discount => _discount;

  String? get total => _total;

  String? get published => _published;

  String? get itmCesId => _itmCesId;

  String? get itmCesName => _itmCesName;

  num? get itmCesPer => _itmCesPer;

  num? get itmRawCess => _itmRawCess;

  String? get ces => _ces;

  String? get quantity => _quantity;

  String? get prate => _prate;

  num? get cesAmt => _cesAmt;

  String? get tax => _tax;

  set quantity(String? quantity) => _quantity = quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['item_id'] = _itemId;
    map['godown'] = _godown;
    map['unit_id'] = _unitId;
    map['base_unit_id'] = _baseUnitId;
    map['mrp'] = _mrp;
    map['rate'] = _rate;
    map['tax_id'] = _taxId;
    map['discount'] = _discount;
    map['total'] = _total;
    map['published'] = _published;
    map['itm_ces_id'] = _itmCesId;
    map['itm_ces_name'] = _itmCesName;
    map['itm_ces_per'] = _itmCesPer;
    map['itm_raw_cess'] = _itmRawCess;
    map['ces'] = _ces;
    map['quantity'] = _quantity;
    map['prate'] = _prate;
    map['ces_amt'] = _cesAmt;
    map['tax'] = _tax;
    return map;
  }
}
