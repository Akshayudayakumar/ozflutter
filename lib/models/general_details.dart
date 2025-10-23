class GeneralDetails {
  GeneralDetails({
    bool? status,
    Result? result,
    String? message,
  }) {
    _status = status;
    _result = result;
    _message = message;
  }

  GeneralDetails.fromJson(dynamic json) {
    _status = json['status'];
    _result = json['result'] != null ? Result.fromJson(json['result']) : null;
    _message = json['message'];
  }
  bool? _status;
  Result? _result;
  String? _message;
  GeneralDetails copyWith({
    bool? status,
    Result? result,
    String? message,
  }) =>
      GeneralDetails(
        status: status ?? _status,
        result: result ?? _result,
        message: message ?? _message,
      );
  bool? get status => _status;
  Result? get result => _result;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_result != null) {
      map['result'] = _result?.toJson();
    }
    map['message'] = _message;
    return map;
  }
}

class Result {
  Result({
    List<Items>? items,
    List<Customers>? customers,
    List<PriceListDetails>? priceListDetails,
    List<PriceList>? priceList,
  }) {
    _items = items;
    _customers = customers;
    _priceListDetails = priceListDetails;
    _priceList = priceList;
  }

  Result.fromJson(dynamic json) {
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    if (json['customers'] != null) {
      _customers = [];
      json['customers'].forEach((v) {
        _customers?.add(Customers.fromJson(v));
      });
    }
    if (json['price_list_details'] != null) {
      _priceListDetails = [];
      json['price_list_details'].forEach((v) {
        _priceListDetails?.add(PriceListDetails.fromJson(v));
      });
    }
    if (json['price_list'] != null) {
      _priceList = [];
      json['price_list'].forEach((v) {
        _priceList?.add(PriceList.fromJson(v));
      });
    }
  }
  List<Items>? _items;
  List<Customers>? _customers;
  List<PriceListDetails>? _priceListDetails;
  List<PriceList>? _priceList;
  Result copyWith({
    List<Items>? items,
    List<Customers>? customers,
    List<PriceListDetails>? priceListDetails,
    List<PriceList>? priceList,
  }) =>
      Result(
        items: items ?? _items,
        customers: customers ?? _customers,
        priceListDetails: priceListDetails ?? _priceListDetails,
        priceList: priceList ?? _priceList,
      );
  List<Items>? get items => _items;
  List<Customers>? get customers => _customers;
  List<PriceListDetails>? get priceListDetails => _priceListDetails;
  List<PriceList>? get priceList => _priceList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    if (_customers != null) {
      map['customers'] = _customers?.map((v) => v.toJson()).toList();
    }
    if (_priceListDetails != null) {
      map['price_list_details'] =
          _priceListDetails?.map((v) => v.toJson()).toList();
    }
    if (_priceList != null) {
      map['price_list'] = _priceList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PriceList {
  PriceList({
    String? id,
    String? priceList,
    String? note,
    String? published,
  }) {
    _id = id;
    _priceList = priceList;
    _note = note;
    _published = published;
  }

  PriceList.fromJson(dynamic json) {
    _id = json['id'];
    _priceList = json['price_list'];
    _note = json['note'];
    _published = json['published'];
  }
  String? _id;
  String? _priceList;
  String? _note;
  String? _published;
  PriceList copyWith({
    String? id,
    String? priceList,
    String? note,
    String? published,
  }) =>
      PriceList(
        id: id ?? _id,
        priceList: priceList ?? _priceList,
        note: note ?? _note,
        published: published ?? _published,
      );
  String? get id => _id;
  String? get priceList => _priceList;
  String? get note => _note;
  String? get published => _published;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['price_list'] = _priceList;
    map['note'] = _note;
    map['published'] = _published;
    return map;
  }
}

class PriceListDetails {
  PriceListDetails({
    String? id,
    String? priceList,
    String? note,
    String? published,
    String? priceListId,
    String? itemId,
    String? batch,
    String? salesRate,
    String? priceDiscount,
    String? priceDiscountAmount,
  }) {
    _id = id;
    _priceList = priceList;
    _note = note;
    _published = published;
    _priceListId = priceListId;
    _itemId = itemId;
    _batch = batch;
    _salesRate = salesRate;
    _priceDiscount = priceDiscount;
    _priceDiscountAmount = priceDiscountAmount;
  }

  PriceListDetails.fromJson(dynamic json) {
    _id = json['id'];
    _priceList = json['price_list'];
    _note = json['note'];
    _published = json['published'];
    _priceListId = json['price_list_id'];
    _itemId = json['item_id'];
    _batch = json['batch'];
    _salesRate = json['sales_rate'];
    _priceDiscount = json['price_discount'];
    _priceDiscountAmount = json['price_discount_amount'];
  }
  String? _id;
  String? _priceList;
  String? _note;
  String? _published;
  String? _priceListId;
  String? _itemId;
  String? _batch;
  String? _salesRate;
  String? _priceDiscount;
  String? _priceDiscountAmount;
  PriceListDetails copyWith({
    String? id,
    String? priceList,
    String? note,
    String? published,
    String? priceListId,
    String? itemId,
    String? batch,
    String? salesRate,
    String? priceDiscount,
    String? priceDiscountAmount,
  }) =>
      PriceListDetails(
        id: id ?? _id,
        priceList: priceList ?? _priceList,
        note: note ?? _note,
        published: published ?? _published,
        priceListId: priceListId ?? _priceListId,
        itemId: itemId ?? _itemId,
        batch: batch ?? _batch,
        salesRate: salesRate ?? _salesRate,
        priceDiscount: priceDiscount ?? _priceDiscount,
        priceDiscountAmount: priceDiscountAmount ?? _priceDiscountAmount,
      );
  String? get id => _id;
  String? get priceList => _priceList;
  String? get note => _note;
  String? get published => _published;
  String? get priceListId => _priceListId;
  String? get itemId => _itemId;
  String? get batch => _batch;
  String? get salesRate => _salesRate;
  String? get priceDiscount => _priceDiscount;
  String? get priceDiscountAmount => _priceDiscountAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['price_list'] = _priceList;
    map['note'] = _note;
    map['published'] = _published;
    map['price_list_id'] = _priceListId;
    map['item_id'] = _itemId;
    map['batch'] = _batch;
    map['sales_rate'] = _salesRate;
    map['price_discount'] = _priceDiscount;
    map['price_discount_amount'] = _priceDiscountAmount;
    return map;
  }
}

class Customers{
  Customers({
    String? id,
    String? leadRefId,
    String? supplierMainId,
    String? name,
    String? code,
    String? longitude,
    String? latitude,
    String? phone,
    String? totalPoints,
    String? redeemedPoints,
    String? cusAgent,
    String? cusSalesman,
    String? cusRate,
    String? contactPerson,
    String? contactNumber,
    String? tin,
    String? cst,
    String? gst,
    String? district,
    String? branch,
    String? customerType,
    String? email,
    String? password,
    String? addressLine1,
    String? addressLine2,
    String? details,
    String? type,
    String? listedInSupplier,
    String? published,
    String? creditPeriod,
    String? creditPeriodExceed,
    String? creditAmount,
    String? creditAmountExceed,
    String? bank,
    String? accountNo,
    String? ifscCode,
    String? area,
    String? route,
    String? location,
    String? priceList,
    String? updatedate,
    dynamic nameLan,
    dynamic addressLine1Lan,
    dynamic addressLine2Lan,
    String? pincode,
    String? isActive,
  }) {
    _id = id;
    _leadRefId = leadRefId;
    _supplierMainId = supplierMainId;
    _name = name;
    _code = code;
    _longitude = longitude;
    _latitude = latitude;
    _phone = phone;
    _totalPoints = totalPoints;
    _redeemedPoints = redeemedPoints;
    _cusAgent = cusAgent;
    _cusSalesman = cusSalesman;
    _cusRate = cusRate;
    _contactPerson = contactPerson;
    _contactNumber = contactNumber;
    _tin = tin;
    _cst = cst;
    _gst = gst;
    _district = district;
    _branch = branch;
    _customerType = customerType;
    _email = email;
    _password = password;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _details = details;
    _type = type;
    _listedInSupplier = listedInSupplier;
    _published = published;
    _creditPeriod = creditPeriod;
    _creditPeriodExceed = creditPeriodExceed;
    _creditAmount = creditAmount;
    _creditAmountExceed = creditAmountExceed;
    _bank = bank;
    _accountNo = accountNo;
    _ifscCode = ifscCode;
    _area = area;
    _route = route;
    _location = location;
    _priceList = priceList;
    _updatedate = updatedate;
    _nameLan = nameLan;
    _addressLine1Lan = addressLine1Lan;
    _addressLine2Lan = addressLine2Lan;
    _pincode = pincode;
    _isActive = isActive;
  }

  Customers.fromJson(dynamic json) {
    _id = json['id'];
    _leadRefId = json['lead_ref_id'];
    _supplierMainId = json['supplier_main_id'];
    _name = json['name'];
    _code = json['code'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _phone = json['phone'];
    _totalPoints = json['total_points'];
    _redeemedPoints = json['redeemed_points'];
    _cusAgent = json['cus_agent'];
    _cusSalesman = json['cus_salesman'];
    _cusRate = json['cus_rate'];
    _contactPerson = json['contact_person'];
    _contactNumber = json['contact_number'];
    _tin = json['tin'];
    _cst = json['cst'];
    _gst = json['gst'];
    _district = json['district'];
    _branch = json['branch'];
    _customerType = json['customer_type'];
    _email = json['email'];
    _password = json['password'];
    _addressLine1 = json['address_line1'];
    _addressLine2 = json['address_line2'];
    _details = json['details'];
    _type = json['type'];
    _listedInSupplier = json['listed_in_supplier'];
    _published = json['published'];
    _creditPeriod = json['credit_period'];
    _creditPeriodExceed = json['credit_period_exceed'];
    _creditAmount = json['credit_amount'];
    _creditAmountExceed = json['credit_amount_exceed'];
    _bank = json['bank'];
    _accountNo = json['account_no'];
    _ifscCode = json['ifsc_code'];
    _area = json['area'];
    _route = json['route'];
    _location = json['location'];
    _priceList = json['price_list'];
    _updatedate = json['updatedate'];
    _nameLan = json['name_lan'];
    _addressLine1Lan = json['address_line1_lan'];
    _addressLine2Lan = json['address_line2_lan'];
    _pincode = json['pincode'];
    _isActive = json['is_active'];
  }
  String? _id;
  String? _leadRefId;
  String? _supplierMainId;
  String? _name;
  String? _code;
  String? _longitude;
  String? _latitude;
  String? _phone;
  String? _totalPoints;
  String? _redeemedPoints;
  String? _cusAgent;
  String? _cusSalesman;
  String? _cusRate;
  String? _contactPerson;
  String? _contactNumber;
  String? _tin;
  String? _cst;
  String? _gst;
  String? _district;
  String? _branch;
  String? _customerType;
  String? _email;
  String? _password;
  String? _addressLine1;
  String? _addressLine2;
  String? _details;
  String? _type;
  String? _listedInSupplier;
  String? _published;
  String? _creditPeriod;
  String? _creditPeriodExceed;
  String? _creditAmount;
  String? _creditAmountExceed;
  String? _bank;
  String? _accountNo;
  String? _ifscCode;
  String? _area;
  String? _route;
  String? _location;
  String? _priceList;
  String? _updatedate;
  dynamic _nameLan;
  dynamic _addressLine1Lan;
  dynamic _addressLine2Lan;
  String? _pincode;
  String? _isActive;
  Customers copyWith({
    String? id,
    String? leadRefId,
    String? supplierMainId,
    String? name,
    String? code,
    String? longitude,
    String? latitude,
    String? phone,
    String? totalPoints,
    String? redeemedPoints,
    String? cusAgent,
    String? cusSalesman,
    String? cusRate,
    String? contactPerson,
    String? contactNumber,
    String? tin,
    String? cst,
    String? gst,
    String? district,
    String? branch,
    String? customerType,
    String? email,
    String? password,
    String? addressLine1,
    String? addressLine2,
    String? details,
    String? type,
    String? listedInSupplier,
    String? published,
    String? creditPeriod,
    String? creditPeriodExceed,
    String? creditAmount,
    String? creditAmountExceed,
    String? bank,
    String? accountNo,
    String? ifscCode,
    String? area,
    String? route,
    String? location,
    String? priceList,
    String? updatedate,
    dynamic nameLan,
    dynamic addressLine1Lan,
    dynamic addressLine2Lan,
    String? pincode,
    String? isActive,
  }) =>
      Customers(
        id: id ?? _id,
        leadRefId: leadRefId ?? _leadRefId,
        supplierMainId: supplierMainId ?? _supplierMainId,
        name: name ?? _name,
        code: code ?? _code,
        longitude: longitude ?? _longitude,
        latitude: latitude ?? _latitude,
        phone: phone ?? _phone,
        totalPoints: totalPoints ?? _totalPoints,
        redeemedPoints: redeemedPoints ?? _redeemedPoints,
        cusAgent: cusAgent ?? _cusAgent,
        cusSalesman: cusSalesman ?? _cusSalesman,
        cusRate: cusRate ?? _cusRate,
        contactPerson: contactPerson ?? _contactPerson,
        contactNumber: contactNumber ?? _contactNumber,
        tin: tin ?? _tin,
        cst: cst ?? _cst,
        gst: gst ?? _gst,
        district: district ?? _district,
        branch: branch ?? _branch,
        customerType: customerType ?? _customerType,
        email: email ?? _email,
        password: password ?? _password,
        addressLine1: addressLine1 ?? _addressLine1,
        addressLine2: addressLine2 ?? _addressLine2,
        details: details ?? _details,
        type: type ?? _type,
        listedInSupplier: listedInSupplier ?? _listedInSupplier,
        published: published ?? _published,
        creditPeriod: creditPeriod ?? _creditPeriod,
        creditPeriodExceed: creditPeriodExceed ?? _creditPeriodExceed,
        creditAmount: creditAmount ?? _creditAmount,
        creditAmountExceed: creditAmountExceed ?? _creditAmountExceed,
        bank: bank ?? _bank,
        accountNo: accountNo ?? _accountNo,
        ifscCode: ifscCode ?? _ifscCode,
        area: area ?? _area,
        route: route ?? _route,
        location: location ?? _location,
        priceList: priceList ?? _priceList,
        updatedate: updatedate ?? _updatedate,
        nameLan: nameLan ?? _nameLan,
        addressLine1Lan: addressLine1Lan ?? _addressLine1Lan,
        addressLine2Lan: addressLine2Lan ?? _addressLine2Lan,
        pincode: pincode ?? _pincode,
        isActive: isActive ?? _isActive,
      );
  String? get id => _id;
  String? get leadRefId => _leadRefId;
  String? get supplierMainId => _supplierMainId;
  String? get name => _name;
  String? get code => _code;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get phone => _phone;
  String? get totalPoints => _totalPoints;
  String? get redeemedPoints => _redeemedPoints;
  String? get cusAgent => _cusAgent;
  String? get cusSalesman => _cusSalesman;
  String? get cusRate => _cusRate;
  String? get contactPerson => _contactPerson;
  String? get contactNumber => _contactNumber;
  String? get tin => _tin;
  String? get cst => _cst;
  String? get gst => _gst;
  String? get district => _district;
  String? get branch => _branch;
  String? get customerType => _customerType;
  String? get email => _email;
  String? get password => _password;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get details => _details;
  String? get type => _type;
  String? get listedInSupplier => _listedInSupplier;
  String? get published => _published;
  String? get creditPeriod => _creditPeriod;
  String? get creditPeriodExceed => _creditPeriodExceed;
  String? get creditAmount => _creditAmount;
  String? get creditAmountExceed => _creditAmountExceed;
  String? get bank => _bank;
  String? get accountNo => _accountNo;
  String? get ifscCode => _ifscCode;
  String? get area => _area;
  String? get route => _route;
  String? get location => _location;
  String? get priceList => _priceList;
  String? get updatedate => _updatedate;
  dynamic get nameLan => _nameLan;
  dynamic get addressLine1Lan => _addressLine1Lan;
  dynamic get addressLine2Lan => _addressLine2Lan;
  String? get pincode => _pincode;
  String? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['lead_ref_id'] = _leadRefId;
    map['supplier_main_id'] = _supplierMainId;
    map['name'] = _name;
    map['code'] = _code;
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    map['phone'] = _phone;
    map['total_points'] = _totalPoints;
    map['redeemed_points'] = _redeemedPoints;
    map['cus_agent'] = _cusAgent;
    map['cus_salesman'] = _cusSalesman;
    map['cus_rate'] = _cusRate;
    map['contact_person'] = _contactPerson;
    map['contact_number'] = _contactNumber;
    map['tin'] = _tin;
    map['cst'] = _cst;
    map['gst'] = _gst;
    map['district'] = _district;
    map['branch'] = _branch;
    map['customer_type'] = _customerType;
    map['email'] = _email;
    map['password'] = _password;
    map['address_line1'] = _addressLine1;
    map['address_line2'] = _addressLine2;
    map['details'] = _details;
    map['type'] = _type;
    map['listed_in_supplier'] = _listedInSupplier;
    map['published'] = _published;
    map['credit_period'] = _creditPeriod;
    map['credit_period_exceed'] = _creditPeriodExceed;
    map['credit_amount'] = _creditAmount;
    map['credit_amount_exceed'] = _creditAmountExceed;
    map['bank'] = _bank;
    map['account_no'] = _accountNo;
    map['ifsc_code'] = _ifscCode;
    map['area'] = _area;
    map['route'] = _route;
    map['location'] = _location;
    map['price_list'] = _priceList;
    map['updatedate'] = _updatedate;
    map['name_lan'] = _nameLan;
    map['address_line1_lan'] = _addressLine1Lan;
    map['address_line2_lan'] = _addressLine2Lan;
    map['pincode'] = _pincode;
    map['is_active'] = _isActive;
    return map;
  }
}

class Items {
  Items({
    String? hsncodename,
    String? priceDiscount,
    String? priceListRate,
    String? priceListId,
    dynamic category,
    String? itemCategoryId,
    String? subUnitOne,
    String? subUnitTwo,
    String? itemgodownid,
    String? id,
    String? freeQty,
    String? freeQtyFor,
    String? partNo,
    String? makeModel,
    String? itemSizeId,
    String? brandId,
    String? barcode,
    String? priceCode,
    String? itemGroupId,
    String? unitId,
    String? prate,
    String? srate,
    String? whRate,
    String? specialRate,
    String? mrp,
    String? openStkRate,
    String? commission,
    String? taxId,
    String? taxLedgerId,
    String? taxSalesId,
    String? taxPurchaseId,
    String? published,
    String? hsncode,
    String? itemTypeId,
    String? godown,
    String? description,
    String? mfgDate,
    String? expDate,
    String? updatedate,
    String? cessId,
    String? name,
    dynamic cesName,
    String? cesId,
    String? cesPercent,
    String? batch,
    String? godownId,
    String? itemId,
    String? itemQty,
    String? itemSrate,
    String? itemPrate,
    String? itemWhrate,
    String? itemMrp,
    String? itemOpnstkrate,
    String? type,
    String? currentStock,
    String? openStock,
  }) {
    _hsncodename = hsncodename;
    _priceDiscount = priceDiscount;
    _priceListRate = priceListRate;
    _priceListId = priceListId;
    _category = category;
    _itemCategoryId = itemCategoryId;
    _subUnitOne = subUnitOne;
    _subUnitTwo = subUnitTwo;
    _itemgodownid = itemgodownid;
    _id = id;
    _freeQty = freeQty;
    _freeQtyFor = freeQtyFor;
    _partNo = partNo;
    _makeModel = makeModel;
    _itemSizeId = itemSizeId;
    _brandId = brandId;
    _barcode = barcode;
    _priceCode = priceCode;
    _itemGroupId = itemGroupId;
    _unitId = unitId;
    _prate = prate;
    _srate = srate;
    _whRate = whRate;
    _specialRate = specialRate;
    _mrp = mrp;
    _openStkRate = openStkRate;
    _commission = commission;
    _taxId = taxId;
    _taxLedgerId = taxLedgerId;
    _taxSalesId = taxSalesId;
    _taxPurchaseId = taxPurchaseId;
    _published = published;
    _hsncode = hsncode;
    _itemTypeId = itemTypeId;
    _godown = godown;
    _description = description;
    _mfgDate = mfgDate;
    _expDate = expDate;
    _updatedate = updatedate;
    _cessId = cessId;
    _name = name;
    _cesName = cesName;
    _cesId = cesId;
    _cesPercent = cesPercent;
    _batch = batch;
    _godownId = godownId;
    _itemId = itemId;
    _itemQty = itemQty;
    _itemSrate = itemSrate;
    _itemPrate = itemPrate;
    _itemWhrate = itemWhrate;
    _itemMrp = itemMrp;
    _itemOpnstkrate = itemOpnstkrate;
    _type = type;
    _currentStock = currentStock;
    _openStock = openStock;
  }

  Items.fromJson(dynamic json) {
    _hsncodename = json['hsncodename'];
    _priceDiscount = json['price_discount'];
    _priceListRate = json['price_list_rate'];
    _priceListId = json['price_list_id'];
    _category = json['category'];
    _itemCategoryId = json['item_category_id'];
    _subUnitOne = json['sub_unit_one'];
    _subUnitTwo = json['sub_unit_two'];
    _itemgodownid = json['itemgodownid'];
    _id = json['id'];
    _freeQty = json['free_qty'];
    _freeQtyFor = json['free_qty_for'];
    _partNo = json['part_no'];
    _makeModel = json['make_model'];
    _itemSizeId = json['item_size_id'];
    _brandId = json['brand_id'];
    _barcode = json['barcode'];
    _priceCode = json['price_code'];
    _itemGroupId = json['item_group_id'];
    _unitId = json['unit_id'];
    _prate = json['prate'];
    _srate = json['srate'];
    _whRate = json['wh_rate'];
    _specialRate = json['special_rate'];
    _mrp = json['MRP'];
    _openStkRate = json['open_stk_rate'];
    _commission = json['commission'];
    _taxId = json['tax_id'];
    _taxLedgerId = json['tax_ledger_id'];
    _taxSalesId = json['tax_sales_id'];
    _taxPurchaseId = json['tax_purchase_id'];
    _published = json['published'];
    _hsncode = json['hsncode'];
    _itemTypeId = json['item_type_id'];
    _godown = json['godown'];
    _description = json['description'];
    _mfgDate = json['mfg_date'];
    _expDate = json['exp_date'];
    _updatedate = json['updatedate'];
    _cessId = json['cess_id'];
    _name = json['name'];
    _cesName = json['ces_name'];
    _cesId = json['ces_id'];
    _cesPercent = json['ces_percent'];
    _batch = json['batch'];
    _godownId = json['godown_id'];
    _itemId = json['item_id'];
    _itemQty = json['item_qty'];
    _itemSrate = json['item_srate'];
    _itemPrate = json['item_prate'];
    _itemWhrate = json['item_whrate'];
    _itemMrp = json['item_mrp'];
    _itemOpnstkrate = json['item_opnstkrate'];
    _type = json['type'];
    _currentStock = json['current_stock'];
    _openStock = json['open_stock'];
  }
  String? _hsncodename;
  String? _priceDiscount;
  String? _priceListRate;
  String? _priceListId;
  dynamic _category;
  String? _itemCategoryId;
  String? _subUnitOne;
  String? _subUnitTwo;
  String? _itemgodownid;
  String? _id;
  String? _freeQty;
  String? _freeQtyFor;
  String? _partNo;
  String? _makeModel;
  String? _itemSizeId;
  String? _brandId;
  String? _barcode;
  String? _priceCode;
  String? _itemGroupId;
  String? _unitId;
  String? _prate;
  String? _srate;
  String? _whRate;
  String? _specialRate;
  String? _mrp;
  String? _openStkRate;
  String? _commission;
  String? _taxId;
  String? _taxLedgerId;
  String? _taxSalesId;
  String? _taxPurchaseId;
  String? _published;
  String? _hsncode;
  String? _itemTypeId;
  String? _godown;
  String? _description;
  String? _mfgDate;
  String? _expDate;
  String? _updatedate;
  String? _cessId;
  String? _name;
  dynamic _cesName;
  String? _cesId;
  String? _cesPercent;
  String? _batch;
  String? _godownId;
  String? _itemId;
  String? _itemQty;
  String? _itemSrate;
  String? _itemPrate;
  String? _itemWhrate;
  String? _itemMrp;
  String? _itemOpnstkrate;
  String? _type;
  String? _currentStock;
  String? _openStock;
  Items copyWith({
    String? hsncodename,
    String? priceDiscount,
    String? priceListRate,
    String? priceListId,
    dynamic category,
    String? itemCategoryId,
    String? subUnitOne,
    String? subUnitTwo,
    String? itemgodownid,
    String? id,
    String? freeQty,
    String? freeQtyFor,
    String? partNo,
    String? makeModel,
    String? itemSizeId,
    String? brandId,
    String? barcode,
    String? priceCode,
    String? itemGroupId,
    String? unitId,
    String? prate,
    String? srate,
    String? whRate,
    String? specialRate,
    String? mrp,
    String? openStkRate,
    String? commission,
    String? taxId,
    String? taxLedgerId,
    String? taxSalesId,
    String? taxPurchaseId,
    String? published,
    String? hsncode,
    String? itemTypeId,
    String? godown,
    String? description,
    String? mfgDate,
    String? expDate,
    String? updatedate,
    String? cessId,
    String? name,
    dynamic cesName,
    String? cesId,
    String? cesPercent,
    String? batch,
    String? godownId,
    String? itemId,
    String? itemQty,
    String? itemSrate,
    String? itemPrate,
    String? itemWhrate,
    String? itemMrp,
    String? itemOpnstkrate,
    String? type,
    String? currentStock,
    String? openStock,
  }) =>
      Items(
        hsncodename: hsncodename ?? _hsncodename,
        priceDiscount: priceDiscount ?? _priceDiscount,
        priceListRate: priceListRate ?? _priceListRate,
        priceListId: priceListId ?? _priceListId,
        category: category ?? _category,
        itemCategoryId: itemCategoryId ?? _itemCategoryId,
        subUnitOne: subUnitOne ?? _subUnitOne,
        subUnitTwo: subUnitTwo ?? _subUnitTwo,
        itemgodownid: itemgodownid ?? _itemgodownid,
        id: id ?? _id,
        freeQty: freeQty ?? _freeQty,
        freeQtyFor: freeQtyFor ?? _freeQtyFor,
        partNo: partNo ?? _partNo,
        makeModel: makeModel ?? _makeModel,
        itemSizeId: itemSizeId ?? _itemSizeId,
        brandId: brandId ?? _brandId,
        barcode: barcode ?? _barcode,
        priceCode: priceCode ?? _priceCode,
        itemGroupId: itemGroupId ?? _itemGroupId,
        unitId: unitId ?? _unitId,
        prate: prate ?? _prate,
        srate: srate ?? _srate,
        whRate: whRate ?? _whRate,
        specialRate: specialRate ?? _specialRate,
        mrp: mrp ?? _mrp,
        openStkRate: openStkRate ?? _openStkRate,
        commission: commission ?? _commission,
        taxId: taxId ?? _taxId,
        taxLedgerId: taxLedgerId ?? _taxLedgerId,
        taxSalesId: taxSalesId ?? _taxSalesId,
        taxPurchaseId: taxPurchaseId ?? _taxPurchaseId,
        published: published ?? _published,
        hsncode: hsncode ?? _hsncode,
        itemTypeId: itemTypeId ?? _itemTypeId,
        godown: godown ?? _godown,
        description: description ?? _description,
        mfgDate: mfgDate ?? _mfgDate,
        expDate: expDate ?? _expDate,
        updatedate: updatedate ?? _updatedate,
        cessId: cessId ?? _cessId,
        name: name ?? _name,
        cesName: cesName ?? _cesName,
        cesId: cesId ?? _cesId,
        cesPercent: cesPercent ?? _cesPercent,
        batch: batch ?? _batch,
        godownId: godownId ?? _godownId,
        itemId: itemId ?? _itemId,
        itemQty: itemQty ?? _itemQty,
        itemSrate: itemSrate ?? _itemSrate,
        itemPrate: itemPrate ?? _itemPrate,
        itemWhrate: itemWhrate ?? _itemWhrate,
        itemMrp: itemMrp ?? _itemMrp,
        itemOpnstkrate: itemOpnstkrate ?? _itemOpnstkrate,
        type: type ?? _type,
        currentStock: currentStock ?? _currentStock,
        openStock: openStock ?? _openStock,
      );
  String? get hsncodename => _hsncodename;
  String? get priceDiscount => _priceDiscount;
  String? get priceListRate => _priceListRate;
  String? get priceListId => _priceListId;
  dynamic get category => _category;
  String? get itemCategoryId => _itemCategoryId;
  String? get subUnitOne => _subUnitOne;
  String? get subUnitTwo => _subUnitTwo;
  String? get itemgodownid => _itemgodownid;
  String? get id => _id;
  String? get freeQty => _freeQty;
  String? get freeQtyFor => _freeQtyFor;
  String? get partNo => _partNo;
  String? get makeModel => _makeModel;
  String? get itemSizeId => _itemSizeId;
  String? get brandId => _brandId;
  String? get barcode => _barcode;
  String? get priceCode => _priceCode;
  String? get itemGroupId => _itemGroupId;
  String? get unitId => _unitId;
  String? get prate => _prate;
  String? get srate => _srate;
  String? get whRate => _whRate;
  String? get specialRate => _specialRate;
  String? get mrp => _mrp;
  String? get openStkRate => _openStkRate;
  String? get commission => _commission;
  String? get taxId => _taxId;
  String? get taxLedgerId => _taxLedgerId;
  String? get taxSalesId => _taxSalesId;
  String? get taxPurchaseId => _taxPurchaseId;
  String? get published => _published;
  String? get hsncode => _hsncode;
  String? get itemTypeId => _itemTypeId;
  String? get godown => _godown;
  String? get description => _description;
  String? get mfgDate => _mfgDate;
  String? get expDate => _expDate;
  String? get updatedate => _updatedate;
  String? get cessId => _cessId;
  String? get name => _name;
  dynamic get cesName => _cesName;
  String? get cesId => _cesId;
  String? get cesPercent => _cesPercent;
  String? get batch => _batch;
  String? get godownId => _godownId;
  String? get itemId => _itemId;
  String? get itemQty => _itemQty;
  String? get itemSrate => _itemSrate;
  String? get itemPrate => _itemPrate;
  String? get itemWhrate => _itemWhrate;
  String? get itemMrp => _itemMrp;
  String? get itemOpnstkrate => _itemOpnstkrate;
  String? get type => _type;
  String? get currentStock => _currentStock;
  String? get openStock => _openStock;

  set itemQty(String? itemQty) => _itemQty = itemQty;
  set freeQty(String? freeQty) => _freeQty = freeQty;
  set srate(String? srate) => _srate = srate;
  set priceDiscount(String? priceDiscount) => _priceDiscount = priceDiscount;
  set unitId(String? unitId) => _unitId = unitId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hsncodename'] = _hsncodename;
    map['price_discount'] = _priceDiscount;
    map['price_list_rate'] = _priceListRate;
    map['price_list_id'] = _priceListId;
    map['category'] = _category;
    map['item_category_id'] = _itemCategoryId;
    map['sub_unit_one'] = _subUnitOne;
    map['sub_unit_two'] = _subUnitTwo;
    map['itemgodownid'] = _itemgodownid;
    map['id'] = _id;
    map['free_qty'] = _freeQty;
    map['free_qty_for'] = _freeQtyFor;
    map['part_no'] = _partNo;
    map['make_model'] = _makeModel;
    map['item_size_id'] = _itemSizeId;
    map['brand_id'] = _brandId;
    map['barcode'] = _barcode;
    map['price_code'] = _priceCode;
    map['item_group_id'] = _itemGroupId;
    map['unit_id'] = _unitId;
    map['prate'] = _prate;
    map['srate'] = _srate;
    map['wh_rate'] = _whRate;
    map['special_rate'] = _specialRate;
    map['MRP'] = _mrp;
    map['open_stk_rate'] = _openStkRate;
    map['commission'] = _commission;
    map['tax_id'] = _taxId;
    map['tax_ledger_id'] = _taxLedgerId;
    map['tax_sales_id'] = _taxSalesId;
    map['tax_purchase_id'] = _taxPurchaseId;
    map['published'] = _published;
    map['hsncode'] = _hsncode;
    map['item_type_id'] = _itemTypeId;
    map['godown'] = _godown;
    map['description'] = _description;
    map['mfg_date'] = _mfgDate;
    map['exp_date'] = _expDate;
    map['updatedate'] = _updatedate;
    map['cess_id'] = _cessId;
    map['name'] = _name;
    map['ces_name'] = _cesName;
    map['ces_id'] = _cesId;
    map['ces_percent'] = _cesPercent;
    map['batch'] = _batch;
    map['godown_id'] = _godownId;
    map['item_id'] = _itemId;
    map['item_qty'] = _itemQty;
    map['item_srate'] = _itemSrate;
    map['item_prate'] = _itemPrate;
    map['item_whrate'] = _itemWhrate;
    map['item_mrp'] = _itemMrp;
    map['item_opnstkrate'] = _itemOpnstkrate;
    map['type'] = _type;
    map['current_stock'] = _currentStock;
    map['open_stock'] = _openStock;
    return map;
  }
}
