/// The `DeviceDetails` class serves as a top-level container for data received from an API.
/// It holds the overall status of the response, a potential result object, and a message.
class DeviceDetails {
  /// This is the primary constructor for the `DeviceDetails` class.
    /// It allows creating an instance of `DeviceDetails` by directly providing values for its properties.
    /// The constructor uses named, optional parameters (`{...}`).
    ///
    /// - `status`: A boolean indicating the success or failure of the API call.
    /// - `result`: An object of type `Result` containing the main data payload if the call was successful.
    /// - `message`: A string providing additional information, like an error message or a success confirmation.
    ///
    /// Inside the constructor, the provided parameters are assigned to the private member variables `_status`, `_result`, and `_message`.
  DeviceDetails({
    bool? status,
    Result? result,
    String? message,
  }) {
    _status = status;
    _result = result;
    _message = message;
  }

  /// This is a named constructor, specifically a "factory constructor," designed to create a `DeviceDetails` object from a JSON map (represented as a `dynamic` type).
  /// This is essential for deserializing JSON data received from an API into a structured Dart object.
  ///
  /// It takes a `json` object and populates the `DeviceDetails` properties by accessing the corresponding keys in the map:
  /// - `_status` is assigned the value of `json['status']`.
  /// - `_result` is created by calling the `Result.fromJson` constructor if `json['result']` is not null. Otherwise, it's set to `null`. This handles nested JSON objects.
  /// - `_message` is assigned the value of `json['message']`.
  DeviceDetails.fromJson(dynamic json) {
    _status = json['status'];
    _result = json['result'] != null ? Result.fromJson(json['result']) : null;
    _message = json['message'];
  }
  bool? _status;
  Result? _result;
  String? _message;
  DeviceDetails copyWith({
    bool? status,
    Result? result,
    String? message,
  }) =>
      DeviceDetails(
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
    List<CompanySettings>? companySettings,
    Config? config,
    List<Company>? company,
    Device? device,
    List<PointSettings>? pointSettings,
    List<Tax>? tax,
    List<Unit>? unit,
    List<Category>? category,
    List<Area>? area,
    List<SalesOrders>? salesOrders,
    List<Billnumber>? billnumber,
    List<AccType>? accType,
    List<AccSubType>? accSubType,
    List<AccMain>? accMain,
    List<AccLedgers>? accLedgers,
  }) {
    _companySettings = companySettings;
    _config = config;
    _company = company;
    _device = device;
    _pointSettings = pointSettings;
    _tax = tax;
    _unit = unit;
    _category = category;
    _area = area;
    _salesOrders = salesOrders;
    _billnumber = billnumber;
    _accType = accType;
    _accSubType = accSubType;
    _accMain = accMain;
    _accLedgers = accLedgers;
  }

  Result.fromJson(dynamic json) {
    if (json['company_settings'] != null) {
      _companySettings = [];
      json['company_settings'].forEach((v) {
        _companySettings?.add(CompanySettings.fromJson(v));
      });
    }
    _config = json['config'] != null ? Config.fromJson(json['config']) : null;
    if (json['company'] != null) {
      _company = [];
      json['company'].forEach((v) {
        _company?.add(Company.fromJson(v));
      });
    }
    _device = json['device'] != null ? Device.fromJson(json['device']) : null;
    if (json['point_settings'] != null) {
      _pointSettings = [];
      json['point_settings'].forEach((v) {
        _pointSettings?.add(PointSettings.fromJson(v));
      });
    }
    if (json['tax'] != null) {
      _tax = [];
      json['tax'].forEach((v) {
        _tax?.add(Tax.fromJson(v));
      });
    }
    if (json['unit'] != null) {
      _unit = [];
      json['unit'].forEach((v) {
        _unit?.add(Unit.fromJson(v));
      });
    }
    if (json['category'] != null) {
      _category = [];
      json['category'].forEach((v) {
        _category?.add(Category.fromJson(v));
      });
    }
    if (json['area'] != null) {
      _area = [];
      json['area'].forEach((v) {
        _area?.add(Area.fromJson(v));
      });
    }
    if (json['sales_orders'] != null) {
      _salesOrders = [];
      json['sales_orders'].forEach((v) {
        _salesOrders?.add(SalesOrders.fromJson(v));
      });
    }
    if (json['billnumber'] != null) {
      _billnumber = [];
      json['billnumber'].forEach((v) {
        _billnumber?.add(Billnumber.fromJson(v));
      });
    }
    if (json['acc_type'] != null) {
      _accType = [];
      json['acc_type'].forEach((v) {
        _accType?.add(AccType.fromJson(v));
      });
    }
    if (json['acc_sub_type'] != null) {
      _accSubType = [];
      json['acc_sub_type'].forEach((v) {
        _accSubType?.add(AccSubType.fromJson(v));
      });
    }
    if (json['acc_main'] != null) {
      _accMain = [];
      json['acc_main'].forEach((v) {
        _accMain?.add(AccMain.fromJson(v));
      });
    }
    if (json['acc_ledgers'] != null) {
      _accLedgers = [];
      json['acc_ledgers'].forEach((v) {
        _accLedgers?.add(AccLedgers.fromJson(v));
      });
    }
  }
  List<CompanySettings>? _companySettings;
  Config? _config;
  List<Company>? _company;
  Device? _device;
  List<PointSettings>? _pointSettings;
  List<Tax>? _tax;
  List<Unit>? _unit;
  List<Category>? _category;
  List<Area>? _area;
  List<SalesOrders>? _salesOrders;
  List<Billnumber>? _billnumber;
  List<AccType>? _accType;
  List<AccSubType>? _accSubType;
  List<AccMain>? _accMain;
  List<AccLedgers>? _accLedgers;
  Result copyWith({
    List<CompanySettings>? companySettings,
    Config? config,
    List<Company>? company,
    Device? device,
    List<PointSettings>? pointSettings,
    List<Tax>? tax,
    List<Unit>? unit,
    List<Category>? category,
    List<Area>? area,
    List<SalesOrders>? salesOrders,
    List<Billnumber>? billnumber,
    List<AccType>? accType,
    List<AccSubType>? accSubType,
    List<AccMain>? accMain,
    List<AccLedgers>? accLedgers,
  }) =>
      Result(
        companySettings: companySettings ?? _companySettings,
        config: config ?? _config,
        company: company ?? _company,
        device: device ?? _device,
        pointSettings: pointSettings ?? _pointSettings,
        tax: tax ?? _tax,
        unit: unit ?? _unit,
        category: category ?? _category,
        area: area ?? _area,
        salesOrders: salesOrders ?? _salesOrders,
        billnumber: billnumber ?? _billnumber,
        accType: accType ?? _accType,
        accSubType: accSubType ?? _accSubType,
        accMain: accMain ?? _accMain,
        accLedgers: accLedgers ?? _accLedgers,
      );
  List<CompanySettings>? get companySettings => _companySettings;
  Config? get config => _config;
  List<Company>? get company => _company;
  Device? get device => _device;
  List<PointSettings>? get pointSettings => _pointSettings;
  List<Tax>? get tax => _tax;
  List<Unit>? get unit => _unit;
  List<Category>? get category => _category;
  List<Area>? get area => _area;
  List<SalesOrders>? get salesOrders => _salesOrders;
  List<Billnumber>? get billnumber => _billnumber;
  List<AccType>? get accType => _accType;
  List<AccSubType>? get accSubType => _accSubType;
  List<AccMain>? get accMain => _accMain;
  List<AccLedgers>? get accLedgers => _accLedgers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_companySettings != null) {
      map['company_settings'] =
          _companySettings?.map((v) => v.toJson()).toList();
    }
    if (_config != null) {
      map['config'] = _config?.toJson();
    }
    if (_company != null) {
      map['company'] = _company?.map((v) => v.toJson()).toList();
    }
    if (_device != null) {
      map['device'] = _device?.toJson();
    }
    if (_pointSettings != null) {
      map['point_settings'] = _pointSettings?.map((v) => v.toJson()).toList();
    }
    if (_tax != null) {
      map['tax'] = _tax?.map((v) => v.toJson()).toList();
    }
    if (_unit != null) {
      map['unit'] = _unit?.map((v) => v.toJson()).toList();
    }
    if (_category != null) {
      map['category'] = _category?.map((v) => v.toJson()).toList();
    }
    if (_area != null) {
      map['area'] = _area?.map((v) => v.toJson()).toList();
    }
    if (_salesOrders != null) {
      map['sales_orders'] = _salesOrders?.map((v) => v.toJson()).toList();
    }
    if (_billnumber != null) {
      map['billnumber'] = _billnumber?.map((v) => v.toJson()).toList();
    }
    if (_accType != null) {
      map['acc_type'] = _accType?.map((v) => v.toJson()).toList();
    }
    if (_accSubType != null) {
      map['acc_sub_type'] = _accSubType?.map((v) => v.toJson()).toList();
    }
    if (_accMain != null) {
      map['acc_main'] = _accMain?.map((v) => v.toJson()).toList();
    }
    if (_accLedgers != null) {
      map['acc_ledgers'] = _accLedgers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "1"
/// fin_sync_id : "0"
/// ledger_main_id : "0"
/// name : "Cash In Hand"
/// acc_ledger_code : ""
/// code : "Cash"
/// ref_id : "1"
/// tax_id : "0"
/// ref_code : "yes"
/// hsncode : "0"
/// is_default : "0"
/// acc_main_id : "4"
/// type : "Cr"
/// openning_bal : "26414.00"
/// opening_balance_paid : "0.00"
/// published : "yes"
/// updatedate : "2021-04-01 03:39:27"
/// is_for_purchase : "0"
/// is_for_sales : "0"
/// name_lan : null
/// balance : "6478842.19"
/// cash_type : "Cr"

class AccLedgers {
  AccLedgers({
    String? id,
    String? finSyncId,
    String? ledgerMainId,
    String? name,
    String? accLedgerCode,
    String? code,
    String? refId,
    String? taxId,
    String? refCode,
    String? hsncode,
    String? isDefault,
    String? accMainId,
    String? type,
    String? openningBal,
    String? openingBalancePaid,
    String? published,
    String? updatedate,
    String? isForPurchase,
    String? isForSales,
    dynamic nameLan,
    String? balance,
    String? cashType,
  }) {
    _id = id;
    _finSyncId = finSyncId;
    _ledgerMainId = ledgerMainId;
    _name = name;
    _accLedgerCode = accLedgerCode;
    _code = code;
    _refId = refId;
    _taxId = taxId;
    _refCode = refCode;
    _hsncode = hsncode;
    _isDefault = isDefault;
    _accMainId = accMainId;
    _type = type;
    _openningBal = openningBal;
    _openingBalancePaid = openingBalancePaid;
    _published = published;
    _updatedate = updatedate;
    _isForPurchase = isForPurchase;
    _isForSales = isForSales;
    _nameLan = nameLan;
    _balance = balance;
    _cashType = cashType;
  }

  AccLedgers.fromJson(dynamic json) {
    _id = json['id'];
    _finSyncId = json['fin_sync_id'];
    _ledgerMainId = json['ledger_main_id'];
    _name = json['name'];
    _accLedgerCode = json['acc_ledger_code'];
    _code = json['code'];
    _refId = json['ref_id'];
    _taxId = json['tax_id'];
    _refCode = json['ref_code'];
    _hsncode = json['hsncode'];
    _isDefault = json['is_default'];
    _accMainId = json['acc_main_id'];
    _type = json['type'];
    _openningBal = json['openning_bal'];
    _openingBalancePaid = json['opening_balance_paid'];
    _published = json['published'];
    _updatedate = json['updatedate'];
    _isForPurchase = json['is_for_purchase'];
    _isForSales = json['is_for_sales'];
    _nameLan = json['name_lan'];
    _balance = json['balance'];
    _cashType = json['cash_type'];
  }
  String? _id;
  String? _finSyncId;
  String? _ledgerMainId;
  String? _name;
  String? _accLedgerCode;
  String? _code;
  String? _refId;
  String? _taxId;
  String? _refCode;
  String? _hsncode;
  String? _isDefault;
  String? _accMainId;
  String? _type;
  String? _openningBal;
  String? _openingBalancePaid;
  String? _published;
  String? _updatedate;
  String? _isForPurchase;
  String? _isForSales;
  dynamic _nameLan;
  String? _balance;
  String? _cashType;
  AccLedgers copyWith({
    String? id,
    String? finSyncId,
    String? ledgerMainId,
    String? name,
    String? accLedgerCode,
    String? code,
    String? refId,
    String? taxId,
    String? refCode,
    String? hsncode,
    String? isDefault,
    String? accMainId,
    String? type,
    String? openningBal,
    String? openingBalancePaid,
    String? published,
    String? updatedate,
    String? isForPurchase,
    String? isForSales,
    dynamic nameLan,
    String? balance,
    String? cashType,
  }) =>
      AccLedgers(
        id: id ?? _id,
        finSyncId: finSyncId ?? _finSyncId,
        ledgerMainId: ledgerMainId ?? _ledgerMainId,
        name: name ?? _name,
        accLedgerCode: accLedgerCode ?? _accLedgerCode,
        code: code ?? _code,
        refId: refId ?? _refId,
        taxId: taxId ?? _taxId,
        refCode: refCode ?? _refCode,
        hsncode: hsncode ?? _hsncode,
        isDefault: isDefault ?? _isDefault,
        accMainId: accMainId ?? _accMainId,
        type: type ?? _type,
        openningBal: openningBal ?? _openningBal,
        openingBalancePaid: openingBalancePaid ?? _openingBalancePaid,
        published: published ?? _published,
        updatedate: updatedate ?? _updatedate,
        isForPurchase: isForPurchase ?? _isForPurchase,
        isForSales: isForSales ?? _isForSales,
        nameLan: nameLan ?? _nameLan,
        balance: balance ?? _balance,
        cashType: cashType ?? _cashType,
      );
  String? get id => _id;
  String? get finSyncId => _finSyncId;
  String? get ledgerMainId => _ledgerMainId;
  String? get name => _name;
  String? get accLedgerCode => _accLedgerCode;
  String? get code => _code;
  String? get refId => _refId;
  String? get taxId => _taxId;
  String? get refCode => _refCode;
  String? get hsncode => _hsncode;
  String? get isDefault => _isDefault;
  String? get accMainId => _accMainId;
  String? get type => _type;
  String? get openningBal => _openningBal;
  String? get openingBalancePaid => _openingBalancePaid;
  String? get published => _published;
  String? get updatedate => _updatedate;
  String? get isForPurchase => _isForPurchase;
  String? get isForSales => _isForSales;
  dynamic get nameLan => _nameLan;
  String? get balance => _balance;
  String? get cashType => _cashType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['fin_sync_id'] = _finSyncId;
    map['ledger_main_id'] = _ledgerMainId;
    map['name'] = _name;
    map['acc_ledger_code'] = _accLedgerCode;
    map['code'] = _code;
    map['ref_id'] = _refId;
    map['tax_id'] = _taxId;
    map['ref_code'] = _refCode;
    map['hsncode'] = _hsncode;
    map['is_default'] = _isDefault;
    map['acc_main_id'] = _accMainId;
    map['type'] = _type;
    map['openning_bal'] = _openningBal;
    map['opening_balance_paid'] = _openingBalancePaid;
    map['published'] = _published;
    map['updatedate'] = _updatedate;
    map['is_for_purchase'] = _isForPurchase;
    map['is_for_sales'] = _isForSales;
    map['name_lan'] = _nameLan;
    map['balance'] = _balance;
    map['cash_type'] = _cashType;
    return map;
  }
}

/// id : "1"
/// name : "Bank Accounts"
/// code : ""
/// branch_id : "0"
/// acc_sub_type_id : "1"
/// published : "yes"
/// updatedate : "2018-11-16 06:05:48"
/// name_lan : null

class AccMain {
  AccMain({
    String? id,
    String? name,
    String? code,
    String? branchId,
    String? accSubTypeId,
    String? published,
    String? updatedate,
    dynamic nameLan,
  }) {
    _id = id;
    _name = name;
    _code = code;
    _branchId = branchId;
    _accSubTypeId = accSubTypeId;
    _published = published;
    _updatedate = updatedate;
    _nameLan = nameLan;
  }

  AccMain.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _branchId = json['branch_id'];
    _accSubTypeId = json['acc_sub_type_id'];
    _published = json['published'];
    _updatedate = json['updatedate'];
    _nameLan = json['name_lan'];
  }
  String? _id;
  String? _name;
  String? _code;
  String? _branchId;
  String? _accSubTypeId;
  String? _published;
  String? _updatedate;
  dynamic _nameLan;
  AccMain copyWith({
    String? id,
    String? name,
    String? code,
    String? branchId,
    String? accSubTypeId,
    String? published,
    String? updatedate,
    dynamic nameLan,
  }) =>
      AccMain(
        id: id ?? _id,
        name: name ?? _name,
        code: code ?? _code,
        branchId: branchId ?? _branchId,
        accSubTypeId: accSubTypeId ?? _accSubTypeId,
        published: published ?? _published,
        updatedate: updatedate ?? _updatedate,
        nameLan: nameLan ?? _nameLan,
      );
  String? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get branchId => _branchId;
  String? get accSubTypeId => _accSubTypeId;
  String? get published => _published;
  String? get updatedate => _updatedate;
  dynamic get nameLan => _nameLan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['branch_id'] = _branchId;
    map['acc_sub_type_id'] = _accSubTypeId;
    map['published'] = _published;
    map['updatedate'] = _updatedate;
    map['name_lan'] = _nameLan;
    return map;
  }
}

/// id : "1"
/// name : "Current Asset"
/// name_lan : null
/// sub_code : ""
/// code : "0"
/// acc_type_id : "3"
/// published : "yes"
/// updatedate : "2018-11-16 10:32:25"

class AccSubType {
  AccSubType({
    String? id,
    String? name,
    dynamic nameLan,
    String? subCode,
    String? code,
    String? accTypeId,
    String? published,
    String? updatedate,
  }) {
    _id = id;
    _name = name;
    _nameLan = nameLan;
    _subCode = subCode;
    _code = code;
    _accTypeId = accTypeId;
    _published = published;
    _updatedate = updatedate;
  }

  AccSubType.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _nameLan = json['name_lan'];
    _subCode = json['sub_code'];
    _code = json['code'];
    _accTypeId = json['acc_type_id'];
    _published = json['published'];
    _updatedate = json['updatedate'];
  }
  String? _id;
  String? _name;
  dynamic _nameLan;
  String? _subCode;
  String? _code;
  String? _accTypeId;
  String? _published;
  String? _updatedate;
  AccSubType copyWith({
    String? id,
    String? name,
    dynamic nameLan,
    String? subCode,
    String? code,
    String? accTypeId,
    String? published,
    String? updatedate,
  }) =>
      AccSubType(
        id: id ?? _id,
        name: name ?? _name,
        nameLan: nameLan ?? _nameLan,
        subCode: subCode ?? _subCode,
        code: code ?? _code,
        accTypeId: accTypeId ?? _accTypeId,
        published: published ?? _published,
        updatedate: updatedate ?? _updatedate,
      );
  String? get id => _id;
  String? get name => _name;
  dynamic get nameLan => _nameLan;
  String? get subCode => _subCode;
  String? get code => _code;
  String? get accTypeId => _accTypeId;
  String? get published => _published;
  String? get updatedate => _updatedate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['name_lan'] = _nameLan;
    map['sub_code'] = _subCode;
    map['code'] = _code;
    map['acc_type_id'] = _accTypeId;
    map['published'] = _published;
    map['updatedate'] = _updatedate;
    return map;
  }
}

/// id : "1"
/// name : "Expense "
/// type_code : ""
/// published : "yes"
/// updatedate : "2018-01-28 06:45:28"
/// name_lan : null

class AccType {
  AccType({
    String? id,
    String? name,
    String? typeCode,
    String? published,
    String? updatedate,
    dynamic nameLan,
  }) {
    _id = id;
    _name = name;
    _typeCode = typeCode;
    _published = published;
    _updatedate = updatedate;
    _nameLan = nameLan;
  }

  AccType.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _typeCode = json['type_code'];
    _published = json['published'];
    _updatedate = json['updatedate'];
    _nameLan = json['name_lan'];
  }
  String? _id;
  String? _name;
  String? _typeCode;
  String? _published;
  String? _updatedate;
  dynamic _nameLan;
  AccType copyWith({
    String? id,
    String? name,
    String? typeCode,
    String? published,
    String? updatedate,
    dynamic nameLan,
  }) =>
      AccType(
        id: id ?? _id,
        name: name ?? _name,
        typeCode: typeCode ?? _typeCode,
        published: published ?? _published,
        updatedate: updatedate ?? _updatedate,
        nameLan: nameLan ?? _nameLan,
      );
  String? get id => _id;
  String? get name => _name;
  String? get typeCode => _typeCode;
  String? get published => _published;
  String? get updatedate => _updatedate;
  dynamic get nameLan => _nameLan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['type_code'] = _typeCode;
    map['published'] = _published;
    map['updatedate'] = _updatedate;
    map['name_lan'] = _nameLan;
    return map;
  }
}

/// id : "1"
/// is_pos : "0"
/// is_return_damage : "0"
/// type : "Purchase"
/// print_type : "1"
/// branch_id : "1"
/// startnumber : "1"
/// seperator : "-"
/// suffix : ""
/// preffix : "PU"
/// transaction : "purchase"
/// cash : "1"
/// bank : "313"
/// godown_id : "1"
/// set_rate : "srate"
/// updatedate : "2023-03-23 09:34:12"
/// name_lan : null

class Billnumber {
  Billnumber({
    String? id,
    String? isPos,
    String? isReturnDamage,
    String? type,
    String? printType,
    String? branchId,
    String? startnumber,
    String? seperator,
    String? suffix,
    String? preffix,
    String? transaction,
    String? cash,
    String? bank,
    String? godownId,
    String? setRate,
    String? updatedate,
    dynamic nameLan,
  }) {
    _id = id;
    _isPos = isPos;
    _isReturnDamage = isReturnDamage;
    _type = type;
    _printType = printType;
    _branchId = branchId;
    _startnumber = startnumber;
    _seperator = seperator;
    _suffix = suffix;
    _preffix = preffix;
    _transaction = transaction;
    _cash = cash;
    _bank = bank;
    _godownId = godownId;
    _setRate = setRate;
    _updatedate = updatedate;
    _nameLan = nameLan;
  }

  Billnumber.fromJson(dynamic json) {
    _id = json['id'];
    _isPos = json['is_pos'];
    _isReturnDamage = json['is_return_damage'];
    _type = json['type'];
    _printType = json['print_type'];
    _branchId = json['branch_id'];
    _startnumber = json['startnumber'].toString();
    _seperator = json['seperator'];
    _suffix = json['suffix'];
    _preffix = json['preffix'];
    _transaction = json['transaction'];
    _cash = json['cash'];
    _bank = json['bank'];
    _godownId = json['godown_id'];
    _setRate = json['set_rate'];
    _updatedate = json['updatedate'];
    _nameLan = json['name_lan'];
  }
  String? _id;
  String? _isPos;
  String? _isReturnDamage;
  String? _type;
  String? _printType;
  String? _branchId;
  String? _startnumber;
  String? _seperator;
  String? _suffix;
  String? _preffix;
  String? _transaction;
  String? _cash;
  String? _bank;
  String? _godownId;
  String? _setRate;
  String? _updatedate;
  dynamic _nameLan;
  Billnumber copyWith({
    String? id,
    String? isPos,
    String? isReturnDamage,
    String? type,
    String? printType,
    String? branchId,
    String? startnumber,
    String? seperator,
    String? suffix,
    String? preffix,
    String? transaction,
    String? cash,
    String? bank,
    String? godownId,
    String? setRate,
    String? updatedate,
    dynamic nameLan,
  }) =>
      Billnumber(
        id: id ?? _id,
        isPos: isPos ?? _isPos,
        isReturnDamage: isReturnDamage ?? _isReturnDamage,
        type: type ?? _type,
        printType: printType ?? _printType,
        branchId: branchId ?? _branchId,
        startnumber: startnumber ?? _startnumber,
        seperator: seperator ?? _seperator,
        suffix: suffix ?? _suffix,
        preffix: preffix ?? _preffix,
        transaction: transaction ?? _transaction,
        cash: cash ?? _cash,
        bank: bank ?? _bank,
        godownId: godownId ?? _godownId,
        setRate: setRate ?? _setRate,
        updatedate: updatedate ?? _updatedate,
        nameLan: nameLan ?? _nameLan,
      );
  String? get id => _id;
  String? get isPos => _isPos;
  String? get isReturnDamage => _isReturnDamage;
  String? get type => _type;
  String? get printType => _printType;
  String? get branchId => _branchId;
  String? get startnumber => _startnumber;
  String? get seperator => _seperator;
  String? get suffix => _suffix;
  String? get preffix => _preffix;
  String? get transaction => _transaction;
  String? get cash => _cash;
  String? get bank => _bank;
  String? get godownId => _godownId;
  String? get setRate => _setRate;
  String? get updatedate => _updatedate;
  dynamic get nameLan => _nameLan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['is_pos'] = _isPos;
    map['is_return_damage'] = _isReturnDamage;
    map['type'] = _type;
    map['print_type'] = _printType;
    map['branch_id'] = _branchId;
    map['startnumber'] = _startnumber;
    map['seperator'] = _seperator;
    map['suffix'] = _suffix;
    map['preffix'] = _preffix;
    map['transaction'] = _transaction;
    map['cash'] = _cash;
    map['bank'] = _bank;
    map['godown_id'] = _godownId;
    map['set_rate'] = _setRate;
    map['updatedate'] = _updatedate;
    map['name_lan'] = _nameLan;
    return map;
  }
}

class SalesOrders {
  SalesOrders({
    String? salesId,
    String? invoice,
    String? remarks,
    String? deviceId,
    String? invoiceDate,
    dynamic dueDate,
    String? deliveryDate,
    String? creditEod,
    String? total,
    String? dollarValue,
    String? packingDetails,
    String? receiptAmount,
    String? cess,
    String? additionalCess,
    String? cashAmount,
    String? bankAmount,
    String? bankId,
    String? bankPayMethod,
    String? gpayNo,
    String? cardNo,
    String? bankRef,
    String? tax,
    String? buyerOrderNo,
    String? otherRef,
    String? deliveryAmt,
    String? payAmt,
    String? taxId,
    String? isMobile,
    String? isAssigned,
    String? isSynced,
    String? other,
    String? freight,
    String? advance,
    String? discount,
    String? redeemedAmount,
    String? redeemedPoints,
    String? globalMrp,
    String? roundoff,
    String? refId,
    String? refAmount,
    String? salesRef,
    dynamic managerId,
    dynamic salesManId,
    String? createdDate,
    String? narration,
    String? createdBy,
    String? type,
    String? billType,
    String? paperSize,
    String? billMargin,
    String? published,
    String? shippingTerms,
    String? paymentTerm,
    String? customerId,
    String? longitude,
    String? latitude,
    String? estimateId,
    String? status,
    String? salesStatus,
    String? cashType,
    String? cashStatus,
    String? printtype,
    String? area,
    String? route,
    String? location,
    String? vehicle,
    String? salesman,
    String? packedBy,
    String? cusname,
    String? cusgst,
    String? cusstate,
    String? collectedAmount,
    String? adjustmentAmount,
    dynamic adjustmentRef,
    String? ewbNo,
    String? refNo,
    String? buyer,
    String? preCarriage,
    String? placeOfReceipt,
    String? flightNo,
    String? portOfLanding,
    String? portOfDischarge,
    String? finalDestination,
    String? countryFinalDestination,
    String? countryOriginOfGoods,
    String? transportMode,
    String? place,
    String? vehicleNo,
    dynamic conName,
    dynamic conAddr,
    dynamic conContact,
    dynamic conGst,
    dynamic conState,
    String? ewbDetails,
    String? termsCondition,
    String? despatchDetails,
    String? cusdetails,
    String? cusemail,
    String? costCenter,
    String? updatedate,
    String? distance,
    String? eInvoiceStatus,
    String? eWayStatus,
    String? loyltyId,
    String? loyltyAmount,
    String? saletype,
    List<SalesItems>? salesItems,
  }) {
    _salesId = salesId;
    _invoice = invoice;
    _remarks = remarks;
    _deviceId = deviceId;
    _invoiceDate = invoiceDate;
    _dueDate = dueDate;
    _deliveryDate = deliveryDate;
    _creditEod = creditEod;
    _total = total;
    _dollarValue = dollarValue;
    _packingDetails = packingDetails;
    _receiptAmount = receiptAmount;
    _cess = cess;
    _additionalCess = additionalCess;
    _cashAmount = cashAmount;
    _bankAmount = bankAmount;
    _bankId = bankId;
    _bankPayMethod = bankPayMethod;
    _gpayNo = gpayNo;
    _cardNo = cardNo;
    _bankRef = bankRef;
    _tax = tax;
    _buyerOrderNo = buyerOrderNo;
    _otherRef = otherRef;
    _deliveryAmt = deliveryAmt;
    _payAmt = payAmt;
    _taxId = taxId;
    _isMobile = isMobile;
    _isAssigned = isAssigned;
    _isSynced = isSynced;
    _other = other;
    _freight = freight;
    _advance = advance;
    _discount = discount;
    _redeemedAmount = redeemedAmount;
    _redeemedPoints = redeemedPoints;
    _globalMrp = globalMrp;
    _roundoff = roundoff;
    _refId = refId;
    _refAmount = refAmount;
    _salesRef = salesRef;
    _managerId = managerId;
    _salesManId = salesManId;
    _createdDate = createdDate;
    _narration = narration;
    _createdBy = createdBy;
    _type = type;
    _billType = billType;
    _paperSize = paperSize;
    _billMargin = billMargin;
    _published = published;
    _shippingTerms = shippingTerms;
    _paymentTerm = paymentTerm;
    _customerId = customerId;
    _longitude = longitude;
    _latitude = latitude;
    _estimateId = estimateId;
    _status = status;
    _salesStatus = salesStatus;
    _cashType = cashType;
    _cashStatus = cashStatus;
    _printtype = printtype;
    _area = area;
    _route = route;
    _location = location;
    _vehicle = vehicle;
    _salesman = salesman;
    _packedBy = packedBy;
    _cusname = cusname;
    _cusgst = cusgst;
    _cusstate = cusstate;
    _collectedAmount = collectedAmount;
    _adjustmentAmount = adjustmentAmount;
    _adjustmentRef = adjustmentRef;
    _ewbNo = ewbNo;
    _refNo = refNo;
    _buyer = buyer;
    _preCarriage = preCarriage;
    _placeOfReceipt = placeOfReceipt;
    _flightNo = flightNo;
    _portOfLanding = portOfLanding;
    _portOfDischarge = portOfDischarge;
    _finalDestination = finalDestination;
    _countryFinalDestination = countryFinalDestination;
    _countryOriginOfGoods = countryOriginOfGoods;
    _transportMode = transportMode;
    _place = place;
    _vehicleNo = vehicleNo;
    _conName = conName;
    _conAddr = conAddr;
    _conContact = conContact;
    _conGst = conGst;
    _conState = conState;
    _ewbDetails = ewbDetails;
    _termsCondition = termsCondition;
    _despatchDetails = despatchDetails;
    _cusdetails = cusdetails;
    _cusemail = cusemail;
    _costCenter = costCenter;
    _updatedate = updatedate;
    _distance = distance;
    _eInvoiceStatus = eInvoiceStatus;
    _eWayStatus = eWayStatus;
    _loyltyId = loyltyId;
    _loyltyAmount = loyltyAmount;
    _saletype = saletype;
    _salesItems = salesItems;
  }

  SalesOrders.fromJson(dynamic json) {
    _salesId = json['sales_id'];
    _invoice = json['invoice'];
    _remarks = json['remarks'];
    _deviceId = json['device_id'];
    _invoiceDate = json['invoice_date'];
    _dueDate = json['due_date'];
    _deliveryDate = json['delivery_date'];
    _creditEod = json['credit_eod'];
    _total = json['total'];
    _dollarValue = json['dollar_value'];
    _packingDetails = json['packing_details'];
    _receiptAmount = json['receipt_amount'];
    _cess = json['cess'];
    _additionalCess = json['additional_cess'];
    _cashAmount = json['cash_amount'];
    _bankAmount = json['bank_amount'];
    _bankId = json['bank_id'];
    _bankPayMethod = json['bank_pay_method'];
    _gpayNo = json['gpay_no'];
    _cardNo = json['card_no'];
    _bankRef = json['bank_ref'];
    _tax = json['tax'];
    _buyerOrderNo = json['buyer_order_no'];
    _otherRef = json['other_ref'];
    _deliveryAmt = json['delivery_amt'];
    _payAmt = json['pay_amt'];
    _taxId = json['tax_id'];
    _isMobile = json['is_mobile'];
    _isAssigned = json['is_assigned'];
    _isSynced = json['is_synced'];
    _other = json['other'];
    _freight = json['freight'];
    _advance = json['advance'];
    _discount = json['discount'];
    _redeemedAmount = json['redeemed_amount'];
    _redeemedPoints = json['redeemed_points'];
    _globalMrp = json['global_mrp'];
    _roundoff = json['roundoff'];
    _refId = json['ref_id'];
    _refAmount = json['ref_amount'];
    _salesRef = json['sales_ref'];
    _managerId = json['manager_id'];
    _salesManId = json['sales_man_id'];
    _createdDate = json['created_date'];
    _narration = json['narration'];
    _createdBy = json['created_by'];
    _type = json['type'];
    _billType = json['bill_type'];
    _paperSize = json['paper_size'];
    _billMargin = json['bill_margin'];
    _published = json['published'];
    _shippingTerms = json['shipping_terms'];
    _paymentTerm = json['payment_term'];
    _customerId = json['customer_id'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _estimateId = json['estimate_id'];
    _status = json['status'];
    _salesStatus = json['sales_status'];
    _cashType = json['cash_type'];
    _cashStatus = json['cash_status'];
    _printtype = json['printtype'];
    _area = json['area'];
    _route = json['route'];
    _location = json['location'];
    _vehicle = json['vehicle'];
    _salesman = json['salesman'];
    _packedBy = json['packed_by'];
    _cusname = json['cusname'];
    _cusgst = json['cusgst'];
    _cusstate = json['cusstate'];
    _collectedAmount = json['collected_amount'];
    _adjustmentAmount = json['adjustment_amount'];
    _adjustmentRef = json['adjustment_ref'];
    _ewbNo = json['ewb_no'];
    _refNo = json['ref_no'];
    _buyer = json['buyer'];
    _preCarriage = json['pre_carriage'];
    _placeOfReceipt = json['place_of_receipt'];
    _flightNo = json['flight_no'];
    _portOfLanding = json['port_of_landing'];
    _portOfDischarge = json['port_of_discharge'];
    _finalDestination = json['final_destination'];
    _countryFinalDestination = json['country_final_destination'];
    _countryOriginOfGoods = json['country_origin_of_goods'];
    _transportMode = json['transport_mode'];
    _place = json['place'];
    _vehicleNo = json['vehicle_no'];
    _conName = json['con_name'];
    _conAddr = json['con_addr'];
    _conContact = json['con_contact'];
    _conGst = json['con_gst'];
    _conState = json['con_state'];
    _ewbDetails = json['ewb_details'];
    _termsCondition = json['terms_condition'];
    _despatchDetails = json['despatch_details'];
    _cusdetails = json['cusdetails'];
    _cusemail = json['cusemail'];
    _costCenter = json['cost_center'];
    _updatedate = json['updatedate'];
    _distance = json['distance'];
    _eInvoiceStatus = json['e_invoice_status'];
    _eWayStatus = json['e_way_status'];
    _loyltyId = json['loylty_id'];
    _loyltyAmount = json['loylty_amount'];
    _saletype = json['saletype'];
    if (json['sales_items'] != null) {
      _salesItems = [];
      json['sales_items'].forEach((v) {
        _salesItems?.add(SalesItems.fromJson(v));
      });
    }
  }
  String? _salesId;
  String? _invoice;
  String? _remarks;
  String? _deviceId;
  String? _invoiceDate;
  dynamic _dueDate;
  String? _deliveryDate;
  String? _creditEod;
  String? _total;
  String? _dollarValue;
  String? _packingDetails;
  String? _receiptAmount;
  String? _cess;
  String? _additionalCess;
  String? _cashAmount;
  String? _bankAmount;
  String? _bankId;
  String? _bankPayMethod;
  String? _gpayNo;
  String? _cardNo;
  String? _bankRef;
  String? _tax;
  String? _buyerOrderNo;
  String? _otherRef;
  String? _deliveryAmt;
  String? _payAmt;
  String? _taxId;
  String? _isMobile;
  String? _isAssigned;
  String? _isSynced;
  String? _other;
  String? _freight;
  String? _advance;
  String? _discount;
  String? _redeemedAmount;
  String? _redeemedPoints;
  String? _globalMrp;
  String? _roundoff;
  String? _refId;
  String? _refAmount;
  String? _salesRef;
  dynamic _managerId;
  dynamic _salesManId;
  String? _createdDate;
  String? _narration;
  String? _createdBy;
  String? _type;
  String? _billType;
  String? _paperSize;
  String? _billMargin;
  String? _published;
  String? _shippingTerms;
  String? _paymentTerm;
  String? _customerId;
  String? _longitude;
  String? _latitude;
  String? _estimateId;
  String? _status;
  String? _salesStatus;
  String? _cashType;
  String? _cashStatus;
  String? _printtype;
  String? _area;
  String? _route;
  String? _location;
  String? _vehicle;
  String? _salesman;
  String? _packedBy;
  String? _cusname;
  String? _cusgst;
  String? _cusstate;
  String? _collectedAmount;
  String? _adjustmentAmount;
  dynamic _adjustmentRef;
  String? _ewbNo;
  String? _refNo;
  String? _buyer;
  String? _preCarriage;
  String? _placeOfReceipt;
  String? _flightNo;
  String? _portOfLanding;
  String? _portOfDischarge;
  String? _finalDestination;
  String? _countryFinalDestination;
  String? _countryOriginOfGoods;
  String? _transportMode;
  String? _place;
  String? _vehicleNo;
  dynamic _conName;
  dynamic _conAddr;
  dynamic _conContact;
  dynamic _conGst;
  dynamic _conState;
  String? _ewbDetails;
  String? _termsCondition;
  String? _despatchDetails;
  String? _cusdetails;
  String? _cusemail;
  String? _costCenter;
  String? _updatedate;
  String? _distance;
  String? _eInvoiceStatus;
  String? _eWayStatus;
  String? _loyltyId;
  String? _loyltyAmount;
  String? _saletype;
  List<SalesItems>? _salesItems;
  SalesOrders copyWith({
    String? salesId,
    String? invoice,
    String? remarks,
    String? deviceId,
    String? invoiceDate,
    dynamic dueDate,
    String? deliveryDate,
    String? creditEod,
    String? total,
    String? dollarValue,
    String? packingDetails,
    String? receiptAmount,
    String? cess,
    String? additionalCess,
    String? cashAmount,
    String? bankAmount,
    String? bankId,
    String? bankPayMethod,
    String? gpayNo,
    String? cardNo,
    String? bankRef,
    String? tax,
    String? buyerOrderNo,
    String? otherRef,
    String? deliveryAmt,
    String? payAmt,
    String? taxId,
    String? isMobile,
    String? isAssigned,
    String? isSynced,
    String? other,
    String? freight,
    String? advance,
    String? discount,
    String? redeemedAmount,
    String? redeemedPoints,
    String? globalMrp,
    String? roundoff,
    String? refId,
    String? refAmount,
    String? salesRef,
    dynamic managerId,
    dynamic salesManId,
    String? createdDate,
    String? narration,
    String? createdBy,
    String? type,
    String? billType,
    String? paperSize,
    String? billMargin,
    String? published,
    String? shippingTerms,
    String? paymentTerm,
    String? customerId,
    String? longitude,
    String? latitude,
    String? estimateId,
    String? status,
    String? salesStatus,
    String? cashType,
    String? cashStatus,
    String? printtype,
    String? area,
    String? route,
    String? location,
    String? vehicle,
    String? salesman,
    String? packedBy,
    String? cusname,
    String? cusgst,
    String? cusstate,
    String? collectedAmount,
    String? adjustmentAmount,
    dynamic adjustmentRef,
    String? ewbNo,
    String? refNo,
    String? buyer,
    String? preCarriage,
    String? placeOfReceipt,
    String? flightNo,
    String? portOfLanding,
    String? portOfDischarge,
    String? finalDestination,
    String? countryFinalDestination,
    String? countryOriginOfGoods,
    String? transportMode,
    String? place,
    String? vehicleNo,
    dynamic conName,
    dynamic conAddr,
    dynamic conContact,
    dynamic conGst,
    dynamic conState,
    String? ewbDetails,
    String? termsCondition,
    String? despatchDetails,
    String? cusdetails,
    String? cusemail,
    String? costCenter,
    String? updatedate,
    String? distance,
    String? eInvoiceStatus,
    String? eWayStatus,
    String? loyltyId,
    String? loyltyAmount,
    String? saletype,
    List<SalesItems>? salesItems,
  }) =>
      SalesOrders(
        salesId: salesId ?? _salesId,
        invoice: invoice ?? _invoice,
        remarks: remarks ?? _remarks,
        deviceId: deviceId ?? _deviceId,
        invoiceDate: invoiceDate ?? _invoiceDate,
        dueDate: dueDate ?? _dueDate,
        deliveryDate: deliveryDate ?? _deliveryDate,
        creditEod: creditEod ?? _creditEod,
        total: total ?? _total,
        dollarValue: dollarValue ?? _dollarValue,
        packingDetails: packingDetails ?? _packingDetails,
        receiptAmount: receiptAmount ?? _receiptAmount,
        cess: cess ?? _cess,
        additionalCess: additionalCess ?? _additionalCess,
        cashAmount: cashAmount ?? _cashAmount,
        bankAmount: bankAmount ?? _bankAmount,
        bankId: bankId ?? _bankId,
        bankPayMethod: bankPayMethod ?? _bankPayMethod,
        gpayNo: gpayNo ?? _gpayNo,
        cardNo: cardNo ?? _cardNo,
        bankRef: bankRef ?? _bankRef,
        tax: tax ?? _tax,
        buyerOrderNo: buyerOrderNo ?? _buyerOrderNo,
        otherRef: otherRef ?? _otherRef,
        deliveryAmt: deliveryAmt ?? _deliveryAmt,
        payAmt: payAmt ?? _payAmt,
        taxId: taxId ?? _taxId,
        isMobile: isMobile ?? _isMobile,
        isAssigned: isAssigned ?? _isAssigned,
        isSynced: isSynced ?? _isSynced,
        other: other ?? _other,
        freight: freight ?? _freight,
        advance: advance ?? _advance,
        discount: discount ?? _discount,
        redeemedAmount: redeemedAmount ?? _redeemedAmount,
        redeemedPoints: redeemedPoints ?? _redeemedPoints,
        globalMrp: globalMrp ?? _globalMrp,
        roundoff: roundoff ?? _roundoff,
        refId: refId ?? _refId,
        refAmount: refAmount ?? _refAmount,
        salesRef: salesRef ?? _salesRef,
        managerId: managerId ?? _managerId,
        salesManId: salesManId ?? _salesManId,
        createdDate: createdDate ?? _createdDate,
        narration: narration ?? _narration,
        createdBy: createdBy ?? _createdBy,
        type: type ?? _type,
        billType: billType ?? _billType,
        paperSize: paperSize ?? _paperSize,
        billMargin: billMargin ?? _billMargin,
        published: published ?? _published,
        shippingTerms: shippingTerms ?? _shippingTerms,
        paymentTerm: paymentTerm ?? _paymentTerm,
        customerId: customerId ?? _customerId,
        longitude: longitude ?? _longitude,
        latitude: latitude ?? _latitude,
        estimateId: estimateId ?? _estimateId,
        status: status ?? _status,
        salesStatus: salesStatus ?? _salesStatus,
        cashType: cashType ?? _cashType,
        cashStatus: cashStatus ?? _cashStatus,
        printtype: printtype ?? _printtype,
        area: area ?? _area,
        route: route ?? _route,
        location: location ?? _location,
        vehicle: vehicle ?? _vehicle,
        salesman: salesman ?? _salesman,
        packedBy: packedBy ?? _packedBy,
        cusname: cusname ?? _cusname,
        cusgst: cusgst ?? _cusgst,
        cusstate: cusstate ?? _cusstate,
        collectedAmount: collectedAmount ?? _collectedAmount,
        adjustmentAmount: adjustmentAmount ?? _adjustmentAmount,
        adjustmentRef: adjustmentRef ?? _adjustmentRef,
        ewbNo: ewbNo ?? _ewbNo,
        refNo: refNo ?? _refNo,
        buyer: buyer ?? _buyer,
        preCarriage: preCarriage ?? _preCarriage,
        placeOfReceipt: placeOfReceipt ?? _placeOfReceipt,
        flightNo: flightNo ?? _flightNo,
        portOfLanding: portOfLanding ?? _portOfLanding,
        portOfDischarge: portOfDischarge ?? _portOfDischarge,
        finalDestination: finalDestination ?? _finalDestination,
        countryFinalDestination:
            countryFinalDestination ?? _countryFinalDestination,
        countryOriginOfGoods: countryOriginOfGoods ?? _countryOriginOfGoods,
        transportMode: transportMode ?? _transportMode,
        place: place ?? _place,
        vehicleNo: vehicleNo ?? _vehicleNo,
        conName: conName ?? _conName,
        conAddr: conAddr ?? _conAddr,
        conContact: conContact ?? _conContact,
        conGst: conGst ?? _conGst,
        conState: conState ?? _conState,
        ewbDetails: ewbDetails ?? _ewbDetails,
        termsCondition: termsCondition ?? _termsCondition,
        despatchDetails: despatchDetails ?? _despatchDetails,
        cusdetails: cusdetails ?? _cusdetails,
        cusemail: cusemail ?? _cusemail,
        costCenter: costCenter ?? _costCenter,
        updatedate: updatedate ?? _updatedate,
        distance: distance ?? _distance,
        eInvoiceStatus: eInvoiceStatus ?? _eInvoiceStatus,
        eWayStatus: eWayStatus ?? _eWayStatus,
        loyltyId: loyltyId ?? _loyltyId,
        loyltyAmount: loyltyAmount ?? _loyltyAmount,
        saletype: saletype ?? _saletype,
        salesItems: salesItems ?? _salesItems,
      );
  String? get salesId => _salesId;
  String? get invoice => _invoice;
  String? get remarks => _remarks;
  String? get deviceId => _deviceId;
  String? get invoiceDate => _invoiceDate;
  dynamic get dueDate => _dueDate;
  String? get deliveryDate => _deliveryDate;
  String? get creditEod => _creditEod;
  String? get total => _total;
  String? get dollarValue => _dollarValue;
  String? get packingDetails => _packingDetails;
  String? get receiptAmount => _receiptAmount;
  String? get cess => _cess;
  String? get additionalCess => _additionalCess;
  String? get cashAmount => _cashAmount;
  String? get bankAmount => _bankAmount;
  String? get bankId => _bankId;
  String? get bankPayMethod => _bankPayMethod;
  String? get gpayNo => _gpayNo;
  String? get cardNo => _cardNo;
  String? get bankRef => _bankRef;
  String? get tax => _tax;
  String? get buyerOrderNo => _buyerOrderNo;
  String? get otherRef => _otherRef;
  String? get deliveryAmt => _deliveryAmt;
  String? get payAmt => _payAmt;
  String? get taxId => _taxId;
  String? get isMobile => _isMobile;
  String? get isAssigned => _isAssigned;
  String? get isSynced => _isSynced;
  String? get other => _other;
  String? get freight => _freight;
  String? get advance => _advance;
  String? get discount => _discount;
  String? get redeemedAmount => _redeemedAmount;
  String? get redeemedPoints => _redeemedPoints;
  String? get globalMrp => _globalMrp;
  String? get roundoff => _roundoff;
  String? get refId => _refId;
  String? get refAmount => _refAmount;
  String? get salesRef => _salesRef;
  dynamic get managerId => _managerId;
  dynamic get salesManId => _salesManId;
  String? get createdDate => _createdDate;
  String? get narration => _narration;
  String? get createdBy => _createdBy;
  String? get type => _type;
  String? get billType => _billType;
  String? get paperSize => _paperSize;
  String? get billMargin => _billMargin;
  String? get published => _published;
  String? get shippingTerms => _shippingTerms;
  String? get paymentTerm => _paymentTerm;
  String? get customerId => _customerId;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get estimateId => _estimateId;
  String? get status => _status;
  String? get salesStatus => _salesStatus;
  String? get cashType => _cashType;
  String? get cashStatus => _cashStatus;
  String? get printtype => _printtype;
  String? get area => _area;
  String? get route => _route;
  String? get location => _location;
  String? get vehicle => _vehicle;
  String? get salesman => _salesman;
  String? get packedBy => _packedBy;
  String? get cusname => _cusname;
  String? get cusgst => _cusgst;
  String? get cusstate => _cusstate;
  String? get collectedAmount => _collectedAmount;
  String? get adjustmentAmount => _adjustmentAmount;
  dynamic get adjustmentRef => _adjustmentRef;
  String? get ewbNo => _ewbNo;
  String? get refNo => _refNo;
  String? get buyer => _buyer;
  String? get preCarriage => _preCarriage;
  String? get placeOfReceipt => _placeOfReceipt;
  String? get flightNo => _flightNo;
  String? get portOfLanding => _portOfLanding;
  String? get portOfDischarge => _portOfDischarge;
  String? get finalDestination => _finalDestination;
  String? get countryFinalDestination => _countryFinalDestination;
  String? get countryOriginOfGoods => _countryOriginOfGoods;
  String? get transportMode => _transportMode;
  String? get place => _place;
  String? get vehicleNo => _vehicleNo;
  dynamic get conName => _conName;
  dynamic get conAddr => _conAddr;
  dynamic get conContact => _conContact;
  dynamic get conGst => _conGst;
  dynamic get conState => _conState;
  String? get ewbDetails => _ewbDetails;
  String? get termsCondition => _termsCondition;
  String? get despatchDetails => _despatchDetails;
  String? get cusdetails => _cusdetails;
  String? get cusemail => _cusemail;
  String? get costCenter => _costCenter;
  String? get updatedate => _updatedate;
  String? get distance => _distance;
  String? get eInvoiceStatus => _eInvoiceStatus;
  String? get eWayStatus => _eWayStatus;
  String? get loyltyId => _loyltyId;
  String? get loyltyAmount => _loyltyAmount;
  String? get saletype => _saletype;
  List<SalesItems>? get salesItems => _salesItems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sales_id'] = _salesId;
    map['invoice'] = _invoice;
    map['remarks'] = _remarks;
    map['device_id'] = _deviceId;
    map['invoice_date'] = _invoiceDate;
    map['due_date'] = _dueDate;
    map['delivery_date'] = _deliveryDate;
    map['credit_eod'] = _creditEod;
    map['total'] = _total;
    map['dollar_value'] = _dollarValue;
    map['packing_details'] = _packingDetails;
    map['receipt_amount'] = _receiptAmount;
    map['cess'] = _cess;
    map['additional_cess'] = _additionalCess;
    map['cash_amount'] = _cashAmount;
    map['bank_amount'] = _bankAmount;
    map['bank_id'] = _bankId;
    map['bank_pay_method'] = _bankPayMethod;
    map['gpay_no'] = _gpayNo;
    map['card_no'] = _cardNo;
    map['bank_ref'] = _bankRef;
    map['tax'] = _tax;
    map['buyer_order_no'] = _buyerOrderNo;
    map['other_ref'] = _otherRef;
    map['delivery_amt'] = _deliveryAmt;
    map['pay_amt'] = _payAmt;
    map['tax_id'] = _taxId;
    map['is_mobile'] = _isMobile;
    map['is_assigned'] = _isAssigned;
    map['is_synced'] = _isSynced;
    map['other'] = _other;
    map['freight'] = _freight;
    map['advance'] = _advance;
    map['discount'] = _discount;
    map['redeemed_amount'] = _redeemedAmount;
    map['redeemed_points'] = _redeemedPoints;
    map['global_mrp'] = _globalMrp;
    map['roundoff'] = _roundoff;
    map['ref_id'] = _refId;
    map['ref_amount'] = _refAmount;
    map['sales_ref'] = _salesRef;
    map['manager_id'] = _managerId;
    map['sales_man_id'] = _salesManId;
    map['created_date'] = _createdDate;
    map['narration'] = _narration;
    map['created_by'] = _createdBy;
    map['type'] = _type;
    map['bill_type'] = _billType;
    map['paper_size'] = _paperSize;
    map['bill_margin'] = _billMargin;
    map['published'] = _published;
    map['shipping_terms'] = _shippingTerms;
    map['payment_term'] = _paymentTerm;
    map['customer_id'] = _customerId;
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    map['estimate_id'] = _estimateId;
    map['status'] = _status;
    map['sales_status'] = _salesStatus;
    map['cash_type'] = _cashType;
    map['cash_status'] = _cashStatus;
    map['printtype'] = _printtype;
    map['area'] = _area;
    map['route'] = _route;
    map['location'] = _location;
    map['vehicle'] = _vehicle;
    map['salesman'] = _salesman;
    map['packed_by'] = _packedBy;
    map['cusname'] = _cusname;
    map['cusgst'] = _cusgst;
    map['cusstate'] = _cusstate;
    map['collected_amount'] = _collectedAmount;
    map['adjustment_amount'] = _adjustmentAmount;
    map['adjustment_ref'] = _adjustmentRef;
    map['ewb_no'] = _ewbNo;
    map['ref_no'] = _refNo;
    map['buyer'] = _buyer;
    map['pre_carriage'] = _preCarriage;
    map['place_of_receipt'] = _placeOfReceipt;
    map['flight_no'] = _flightNo;
    map['port_of_landing'] = _portOfLanding;
    map['port_of_discharge'] = _portOfDischarge;
    map['final_destination'] = _finalDestination;
    map['country_final_destination'] = _countryFinalDestination;
    map['country_origin_of_goods'] = _countryOriginOfGoods;
    map['transport_mode'] = _transportMode;
    map['place'] = _place;
    map['vehicle_no'] = _vehicleNo;
    map['con_name'] = _conName;
    map['con_addr'] = _conAddr;
    map['con_contact'] = _conContact;
    map['con_gst'] = _conGst;
    map['con_state'] = _conState;
    map['ewb_details'] = _ewbDetails;
    map['terms_condition'] = _termsCondition;
    map['despatch_details'] = _despatchDetails;
    map['cusdetails'] = _cusdetails;
    map['cusemail'] = _cusemail;
    map['cost_center'] = _costCenter;
    map['updatedate'] = _updatedate;
    map['distance'] = _distance;
    map['e_invoice_status'] = _eInvoiceStatus;
    map['e_way_status'] = _eWayStatus;
    map['loylty_id'] = _loyltyId;
    map['loylty_amount'] = _loyltyAmount;
    map['saletype'] = _saletype;
    if (_salesItems != null) {
      map['sales_items'] = _salesItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// sal_itms_id : "756"
/// sales_id : "499"
/// sales_ref_type : "Nil"
/// sales_ref_id : "0"
/// emei : ""
/// emei_pur_id : "0"
/// item_id : "4"
/// item_landing_cost : "0.00"
/// batch : ""
/// size_id : "0"
/// unit_id : "1"
/// free_unit_id : "0"
/// base_unit_id : "0"
/// quantity : "1.00"
/// cartel_wt : "0.00"
/// cartel_no : "0.00"
/// base_quantity : "1.00"
/// unit_qty : "0.00"
/// base_free_quantity : "0.00"
/// base_damage_quantity : "0.00"
/// actual_quantity : "0.00"
/// damage_quantity : "0.00"
/// free_qty : "0.00"
/// free_quantity : "0.00"
/// itm_fre_qty : "0.00"
/// itm_fre_qty_for : "0.00"
/// estimate_quantity : "0.00"
/// rate : "0.00"
/// ces : "0.00"
/// itm_ces_id : "0"
/// itm_ces_name : "null"
/// itm_ces_per : "0.00"
/// itm_raw_ces : "0.00"
/// ces_amt : "0.00"
/// mrp : "600.00"
/// salemrp : "0.00"
/// item_rate : "0.00"
/// item_margin : "600.00"
/// mar_pur_rate : "0.00"
/// item_commission : "0.00"
/// godown : "8"
/// analytics : "0"
/// tax_id : "1"
/// tax : "0.00"
/// is_taxincluded : "1"
/// discount : "0.00"
/// total : "600.00"
/// published : "yes"
/// updatedate : "2022-02-28 05:33:22"
/// dis_amt : "0.000"
/// add_dis_per : "0.00"
/// add_dis_amt : "0.00"
/// item_discription : null
/// delivered_qty : "0.00"
/// item_name : "BD004"

class SalesItems {
  SalesItems({
    String? salItmsId,
    String? salesId,
    String? salesRefType,
    String? salesRefId,
    String? emei,
    String? emeiPurId,
    String? itemId,
    String? itemLandingCost,
    String? batch,
    String? sizeId,
    String? unitId,
    String? freeUnitId,
    String? baseUnitId,
    String? quantity,
    String? cartelWt,
    String? cartelNo,
    String? baseQuantity,
    String? unitQty,
    String? baseFreeQuantity,
    String? baseDamageQuantity,
    String? actualQuantity,
    String? damageQuantity,
    String? freeQty,
    String? freeQuantity,
    String? itmFreQty,
    String? itmFreQtyFor,
    String? estimateQuantity,
    String? rate,
    String? ces,
    String? itmCesId,
    String? itmCesName,
    String? itmCesPer,
    String? itmRawCes,
    String? cesAmt,
    String? mrp,
    String? salemrp,
    String? itemRate,
    String? itemMargin,
    String? marPurRate,
    String? itemCommission,
    String? godown,
    String? analytics,
    String? taxId,
    String? tax,
    String? isTaxincluded,
    String? discount,
    String? total,
    String? published,
    String? updatedate,
    String? disAmt,
    String? addDisPer,
    String? addDisAmt,
    dynamic itemDiscription,
    String? deliveredQty,
    String? itemName,
  }) {
    _salItmsId = salItmsId;
    _salesId = salesId;
    _salesRefType = salesRefType;
    _salesRefId = salesRefId;
    _emei = emei;
    _emeiPurId = emeiPurId;
    _itemId = itemId;
    _itemLandingCost = itemLandingCost;
    _batch = batch;
    _sizeId = sizeId;
    _unitId = unitId;
    _freeUnitId = freeUnitId;
    _baseUnitId = baseUnitId;
    _quantity = quantity;
    _cartelWt = cartelWt;
    _cartelNo = cartelNo;
    _baseQuantity = baseQuantity;
    _unitQty = unitQty;
    _baseFreeQuantity = baseFreeQuantity;
    _baseDamageQuantity = baseDamageQuantity;
    _actualQuantity = actualQuantity;
    _damageQuantity = damageQuantity;
    _freeQty = freeQty;
    _freeQuantity = freeQuantity;
    _itmFreQty = itmFreQty;
    _itmFreQtyFor = itmFreQtyFor;
    _estimateQuantity = estimateQuantity;
    _rate = rate;
    _ces = ces;
    _itmCesId = itmCesId;
    _itmCesName = itmCesName;
    _itmCesPer = itmCesPer;
    _itmRawCes = itmRawCes;
    _cesAmt = cesAmt;
    _mrp = mrp;
    _salemrp = salemrp;
    _itemRate = itemRate;
    _itemMargin = itemMargin;
    _marPurRate = marPurRate;
    _itemCommission = itemCommission;
    _godown = godown;
    _analytics = analytics;
    _taxId = taxId;
    _tax = tax;
    _isTaxincluded = isTaxincluded;
    _discount = discount;
    _total = total;
    _published = published;
    _updatedate = updatedate;
    _disAmt = disAmt;
    _addDisPer = addDisPer;
    _addDisAmt = addDisAmt;
    _itemDiscription = itemDiscription;
    _deliveredQty = deliveredQty;
    _itemName = itemName;
  }

  SalesItems.fromJson(dynamic json) {
    _salItmsId = json['sal_itms_id'].toString();
    _salesId = json['sales_id'].toString();
    _salesRefType = json['sales_ref_type'];
    _salesRefId = json['sales_ref_id'];
    _emei = json['emei'];
    _emeiPurId = json['emei_pur_id'];
    _itemId = json['item_id'];
    _itemLandingCost = json['item_landing_cost'];
    _batch = json['batch'];
    _sizeId = json['size_id'];
    _unitId = json['unit_id'];
    _freeUnitId = json['free_unit_id'];
    _baseUnitId = json['base_unit_id'];
    _quantity = json['quantity'];
    _cartelWt = json['cartel_wt'];
    _cartelNo = json['cartel_no'];
    _baseQuantity = json['base_quantity'];
    _unitQty = json['unit_qty'];
    _baseFreeQuantity = json['base_free_quantity'];
    _baseDamageQuantity = json['base_damage_quantity'];
    _actualQuantity = json['actual_quantity'];
    _damageQuantity = json['damage_quantity'];
    _freeQty = json['free_qty'];
    _freeQuantity = json['free_quantity'];
    _itmFreQty = json['itm_fre_qty'];
    _itmFreQtyFor = json['itm_fre_qty_for'];
    _estimateQuantity = json['estimate_quantity'];
    _rate = json['rate'];
    _ces = json['ces'];
    _itmCesId = json['itm_ces_id'];
    _itmCesName = json['itm_ces_name'];
    _itmCesPer = json['itm_ces_per'];
    _itmRawCes = json['itm_raw_ces'];
    _cesAmt = json['ces_amt'];
    _mrp = json['mrp'];
    _salemrp = json['salemrp'];
    _itemRate = json['item_rate'];
    _itemMargin = json['item_margin'];
    _marPurRate = json['mar_pur_rate'];
    _itemCommission = json['item_commission'];
    _godown = json['godown'];
    _analytics = json['analytics'];
    _taxId = json['tax_id'];
    _tax = json['tax'];
    _isTaxincluded = json['is_taxincluded'];
    _discount = json['discount'];
    _total = json['total'];
    _published = json['published'];
    _updatedate = json['updatedate'];
    _disAmt = json['dis_amt'];
    _addDisPer = json['add_dis_per'];
    _addDisAmt = json['add_dis_amt'];
    _itemDiscription = json['item_discription'];
    _deliveredQty = json['delivered_qty'];
    _itemName = json['item_name'];
  }
  String? _salItmsId;
  String? _salesId;
  String? _salesRefType;
  String? _salesRefId;
  String? _emei;
  String? _emeiPurId;
  String? _itemId;
  String? _itemLandingCost;
  String? _batch;
  String? _sizeId;
  String? _unitId;
  String? _freeUnitId;
  String? _baseUnitId;
  String? _quantity;
  String? _cartelWt;
  String? _cartelNo;
  String? _baseQuantity;
  String? _unitQty;
  String? _baseFreeQuantity;
  String? _baseDamageQuantity;
  String? _actualQuantity;
  String? _damageQuantity;
  String? _freeQty;
  String? _freeQuantity;
  String? _itmFreQty;
  String? _itmFreQtyFor;
  String? _estimateQuantity;
  String? _rate;
  String? _ces;
  String? _itmCesId;
  String? _itmCesName;
  String? _itmCesPer;
  String? _itmRawCes;
  String? _cesAmt;
  String? _mrp;
  String? _salemrp;
  String? _itemRate;
  String? _itemMargin;
  String? _marPurRate;
  String? _itemCommission;
  String? _godown;
  String? _analytics;
  String? _taxId;
  String? _tax;
  String? _isTaxincluded;
  String? _discount;
  String? _total;
  String? _published;
  String? _updatedate;
  String? _disAmt;
  String? _addDisPer;
  String? _addDisAmt;
  dynamic _itemDiscription;
  String? _deliveredQty;
  String? _itemName;
  SalesItems copyWith({
    String? salItmsId,
    String? salesId,
    String? salesRefType,
    String? salesRefId,
    String? emei,
    String? emeiPurId,
    String? itemId,
    String? itemLandingCost,
    String? batch,
    String? sizeId,
    String? unitId,
    String? freeUnitId,
    String? baseUnitId,
    String? quantity,
    String? cartelWt,
    String? cartelNo,
    String? baseQuantity,
    String? unitQty,
    String? baseFreeQuantity,
    String? baseDamageQuantity,
    String? actualQuantity,
    String? damageQuantity,
    String? freeQty,
    String? freeQuantity,
    String? itmFreQty,
    String? itmFreQtyFor,
    String? estimateQuantity,
    String? rate,
    String? ces,
    String? itmCesId,
    String? itmCesName,
    String? itmCesPer,
    String? itmRawCes,
    String? cesAmt,
    String? mrp,
    String? salemrp,
    String? itemRate,
    String? itemMargin,
    String? marPurRate,
    String? itemCommission,
    String? godown,
    String? analytics,
    String? taxId,
    String? tax,
    String? isTaxincluded,
    String? discount,
    String? total,
    String? published,
    String? updatedate,
    String? disAmt,
    String? addDisPer,
    String? addDisAmt,
    dynamic itemDiscription,
    String? deliveredQty,
    String? itemName,
  }) =>
      SalesItems(
        salItmsId: salItmsId ?? _salItmsId,
        salesId: salesId ?? _salesId,
        salesRefType: salesRefType ?? _salesRefType,
        salesRefId: salesRefId ?? _salesRefId,
        emei: emei ?? _emei,
        emeiPurId: emeiPurId ?? _emeiPurId,
        itemId: itemId ?? _itemId,
        itemLandingCost: itemLandingCost ?? _itemLandingCost,
        batch: batch ?? _batch,
        sizeId: sizeId ?? _sizeId,
        unitId: unitId ?? _unitId,
        freeUnitId: freeUnitId ?? _freeUnitId,
        baseUnitId: baseUnitId ?? _baseUnitId,
        quantity: quantity ?? _quantity,
        cartelWt: cartelWt ?? _cartelWt,
        cartelNo: cartelNo ?? _cartelNo,
        baseQuantity: baseQuantity ?? _baseQuantity,
        unitQty: unitQty ?? _unitQty,
        baseFreeQuantity: baseFreeQuantity ?? _baseFreeQuantity,
        baseDamageQuantity: baseDamageQuantity ?? _baseDamageQuantity,
        actualQuantity: actualQuantity ?? _actualQuantity,
        damageQuantity: damageQuantity ?? _damageQuantity,
        freeQty: freeQty ?? _freeQty,
        freeQuantity: freeQuantity ?? _freeQuantity,
        itmFreQty: itmFreQty ?? _itmFreQty,
        itmFreQtyFor: itmFreQtyFor ?? _itmFreQtyFor,
        estimateQuantity: estimateQuantity ?? _estimateQuantity,
        rate: rate ?? _rate,
        ces: ces ?? _ces,
        itmCesId: itmCesId ?? _itmCesId,
        itmCesName: itmCesName ?? _itmCesName,
        itmCesPer: itmCesPer ?? _itmCesPer,
        itmRawCes: itmRawCes ?? _itmRawCes,
        cesAmt: cesAmt ?? _cesAmt,
        mrp: mrp ?? _mrp,
        salemrp: salemrp ?? _salemrp,
        itemRate: itemRate ?? _itemRate,
        itemMargin: itemMargin ?? _itemMargin,
        marPurRate: marPurRate ?? _marPurRate,
        itemCommission: itemCommission ?? _itemCommission,
        godown: godown ?? _godown,
        analytics: analytics ?? _analytics,
        taxId: taxId ?? _taxId,
        tax: tax ?? _tax,
        isTaxincluded: isTaxincluded ?? _isTaxincluded,
        discount: discount ?? _discount,
        total: total ?? _total,
        published: published ?? _published,
        updatedate: updatedate ?? _updatedate,
        disAmt: disAmt ?? _disAmt,
        addDisPer: addDisPer ?? _addDisPer,
        addDisAmt: addDisAmt ?? _addDisAmt,
        itemDiscription: itemDiscription ?? _itemDiscription,
        deliveredQty: deliveredQty ?? _deliveredQty,
        itemName: itemName ?? _itemName,
      );
  String? get salItmsId => _salItmsId;
  String? get salesId => _salesId;
  String? get salesRefType => _salesRefType;
  String? get salesRefId => _salesRefId;
  String? get emei => _emei;
  String? get emeiPurId => _emeiPurId;
  String? get itemId => _itemId;
  String? get itemLandingCost => _itemLandingCost;
  String? get batch => _batch;
  String? get sizeId => _sizeId;
  String? get unitId => _unitId;
  String? get freeUnitId => _freeUnitId;
  String? get baseUnitId => _baseUnitId;
  String? get quantity => _quantity;
  String? get cartelWt => _cartelWt;
  String? get cartelNo => _cartelNo;
  String? get baseQuantity => _baseQuantity;
  String? get unitQty => _unitQty;
  String? get baseFreeQuantity => _baseFreeQuantity;
  String? get baseDamageQuantity => _baseDamageQuantity;
  String? get actualQuantity => _actualQuantity;
  String? get damageQuantity => _damageQuantity;
  String? get freeQty => _freeQty;
  String? get freeQuantity => _freeQuantity;
  String? get itmFreQty => _itmFreQty;
  String? get itmFreQtyFor => _itmFreQtyFor;
  String? get estimateQuantity => _estimateQuantity;
  String? get rate => _rate;
  String? get ces => _ces;
  String? get itmCesId => _itmCesId;
  String? get itmCesName => _itmCesName;
  String? get itmCesPer => _itmCesPer;
  String? get itmRawCes => _itmRawCes;
  String? get cesAmt => _cesAmt;
  String? get mrp => _mrp;
  String? get salemrp => _salemrp;
  String? get itemRate => _itemRate;
  String? get itemMargin => _itemMargin;
  String? get marPurRate => _marPurRate;
  String? get itemCommission => _itemCommission;
  String? get godown => _godown;
  String? get analytics => _analytics;
  String? get taxId => _taxId;
  String? get tax => _tax;
  String? get isTaxincluded => _isTaxincluded;
  String? get discount => _discount;
  String? get total => _total;
  String? get published => _published;
  String? get updatedate => _updatedate;
  String? get disAmt => _disAmt;
  String? get addDisPer => _addDisPer;
  String? get addDisAmt => _addDisAmt;
  dynamic get itemDiscription => _itemDiscription;
  String? get deliveredQty => _deliveredQty;
  String? get itemName => _itemName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sal_itms_id'] = _salItmsId;
    map['sales_id'] = _salesId;
    map['sales_ref_type'] = _salesRefType;
    map['sales_ref_id'] = _salesRefId;
    map['emei'] = _emei;
    map['emei_pur_id'] = _emeiPurId;
    map['item_id'] = _itemId;
    map['item_landing_cost'] = _itemLandingCost;
    map['batch'] = _batch;
    map['size_id'] = _sizeId;
    map['unit_id'] = _unitId;
    map['free_unit_id'] = _freeUnitId;
    map['base_unit_id'] = _baseUnitId;
    map['quantity'] = _quantity;
    map['cartel_wt'] = _cartelWt;
    map['cartel_no'] = _cartelNo;
    map['base_quantity'] = _baseQuantity;
    map['unit_qty'] = _unitQty;
    map['base_free_quantity'] = _baseFreeQuantity;
    map['base_damage_quantity'] = _baseDamageQuantity;
    map['actual_quantity'] = _actualQuantity;
    map['damage_quantity'] = _damageQuantity;
    map['free_qty'] = _freeQty;
    map['free_quantity'] = _freeQuantity;
    map['itm_fre_qty'] = _itmFreQty;
    map['itm_fre_qty_for'] = _itmFreQtyFor;
    map['estimate_quantity'] = _estimateQuantity;
    map['rate'] = _rate;
    map['ces'] = _ces;
    map['itm_ces_id'] = _itmCesId;
    map['itm_ces_name'] = _itmCesName;
    map['itm_ces_per'] = _itmCesPer;
    map['itm_raw_ces'] = _itmRawCes;
    map['ces_amt'] = _cesAmt;
    map['mrp'] = _mrp;
    map['salemrp'] = _salemrp;
    map['item_rate'] = _itemRate;
    map['item_margin'] = _itemMargin;
    map['mar_pur_rate'] = _marPurRate;
    map['item_commission'] = _itemCommission;
    map['godown'] = _godown;
    map['analytics'] = _analytics;
    map['tax_id'] = _taxId;
    map['tax'] = _tax;
    map['is_taxincluded'] = _isTaxincluded;
    map['discount'] = _discount;
    map['total'] = _total;
    map['published'] = _published;
    map['updatedate'] = _updatedate;
    map['dis_amt'] = _disAmt;
    map['add_dis_per'] = _addDisPer;
    map['add_dis_amt'] = _addDisAmt;
    map['item_discription'] = _itemDiscription;
    map['delivered_qty'] = _deliveredQty;
    map['item_name'] = _itemName;
    return map;
  }
}

/// id : "5"
/// area : "shyamaarea"
/// name_lan : ""
/// details : null
/// updatedate : "2021-05-14 09:40:02"

class Area {
  Area({
    String? id,
    String? area,
    String? nameLan,
    dynamic details,
    String? updatedate,
  }) {
    _id = id;
    _area = area;
    _nameLan = nameLan;
    _details = details;
    _updatedate = updatedate;
  }

  Area.fromJson(dynamic json) {
    _id = json['id'];
    _area = json['area'];
    _nameLan = json['name_lan'];
    _details = json['details'];
    _updatedate = json['updatedate'];
  }
  String? _id;
  String? _area;
  String? _nameLan;
  dynamic _details;
  String? _updatedate;
  Area copyWith({
    String? id,
    String? area,
    String? nameLan,
    dynamic details,
    String? updatedate,
  }) =>
      Area(
        id: id ?? _id,
        area: area ?? _area,
        nameLan: nameLan ?? _nameLan,
        details: details ?? _details,
        updatedate: updatedate ?? _updatedate,
      );
  String? get id => _id;
  String? get area => _area;
  String? get nameLan => _nameLan;
  dynamic get details => _details;
  String? get updatedate => _updatedate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['area'] = _area;
    map['name_lan'] = _nameLan;
    map['details'] = _details;
    map['updatedate'] = _updatedate;
    return map;
  }
}

/// id : "1"
/// category_main_id : "0"
/// name : "General"
/// discount : "0"
/// item_type_id : null
/// item_category_id : "10"
/// category_tax : "3"
/// category_hsncode : "3"
/// published : "yes"
/// updatedate : "2023-02-20 12:50:47"
/// image : ""
/// name_lan : null

class Category {
  Category({
    String? id,
    String? categoryMainId,
    String? name,
    String? discount,
    dynamic itemTypeId,
    String? itemCategoryId,
    String? categoryTax,
    String? categoryHsncode,
    String? published,
    String? updatedate,
    String? image,
    dynamic nameLan,
  }) {
    _id = id;
    _categoryMainId = categoryMainId;
    _name = name;
    _discount = discount;
    _itemTypeId = itemTypeId;
    _itemCategoryId = itemCategoryId;
    _categoryTax = categoryTax;
    _categoryHsncode = categoryHsncode;
    _published = published;
    _updatedate = updatedate;
    _image = image;
    _nameLan = nameLan;
  }

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _categoryMainId = json['category_main_id'];
    _name = json['name'];
    _discount = json['discount'];
    _itemTypeId = json['item_type_id'];
    _itemCategoryId = json['item_category_id'];
    _categoryTax = json['category_tax'];
    _categoryHsncode = json['category_hsncode'];
    _published = json['published'];
    _updatedate = json['updatedate'];
    _image = json['image'];
    _nameLan = json['name_lan'];
  }
  String? _id;
  String? _categoryMainId;
  String? _name;
  String? _discount;
  dynamic _itemTypeId;
  String? _itemCategoryId;
  String? _categoryTax;
  String? _categoryHsncode;
  String? _published;
  String? _updatedate;
  String? _image;
  dynamic _nameLan;
  Category copyWith({
    String? id,
    String? categoryMainId,
    String? name,
    String? discount,
    dynamic itemTypeId,
    String? itemCategoryId,
    String? categoryTax,
    String? categoryHsncode,
    String? published,
    String? updatedate,
    String? image,
    dynamic nameLan,
  }) =>
      Category(
        id: id ?? _id,
        categoryMainId: categoryMainId ?? _categoryMainId,
        name: name ?? _name,
        discount: discount ?? _discount,
        itemTypeId: itemTypeId ?? _itemTypeId,
        itemCategoryId: itemCategoryId ?? _itemCategoryId,
        categoryTax: categoryTax ?? _categoryTax,
        categoryHsncode: categoryHsncode ?? _categoryHsncode,
        published: published ?? _published,
        updatedate: updatedate ?? _updatedate,
        image: image ?? _image,
        nameLan: nameLan ?? _nameLan,
      );
  String? get id => _id;
  String? get categoryMainId => _categoryMainId;
  String? get name => _name;
  String? get discount => _discount;
  dynamic get itemTypeId => _itemTypeId;
  String? get itemCategoryId => _itemCategoryId;
  String? get categoryTax => _categoryTax;
  String? get categoryHsncode => _categoryHsncode;
  String? get published => _published;
  String? get updatedate => _updatedate;
  String? get image => _image;
  dynamic get nameLan => _nameLan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_main_id'] = _categoryMainId;
    map['name'] = _name;
    map['discount'] = _discount;
    map['item_type_id'] = _itemTypeId;
    map['item_category_id'] = _itemCategoryId;
    map['category_tax'] = _categoryTax;
    map['category_hsncode'] = _categoryHsncode;
    map['published'] = _published;
    map['updatedate'] = _updatedate;
    map['image'] = _image;
    map['name_lan'] = _nameLan;
    return map;
  }
}

/// unit_id : "0"
/// id : "1"
/// name : "Meters"
/// code : "mtr"
/// unit_count : "1.00"
/// published : "yes"
/// updatedate : "2022-09-01 12:57:07"
/// name_lan : null

class Unit {
  Unit({
    String? unitId,
    String? id,
    String? name,
    String? code,
    String? unitCount,
    String? published,
    String? updatedate,
    dynamic nameLan,
  }) {
    _unitId = unitId;
    _id = id;
    _name = name;
    _code = code;
    _unitCount = unitCount;
    _published = published;
    _updatedate = updatedate;
    _nameLan = nameLan;
  }

  Unit.fromJson(dynamic json) {
    _unitId = json['unit_id'];
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _unitCount = json['unit_count'];
    _published = json['published'];
    _updatedate = json['updatedate'];
    _nameLan = json['name_lan'];
  }
  String? _unitId;
  String? _id;
  String? _name;
  String? _code;
  String? _unitCount;
  String? _published;
  String? _updatedate;
  dynamic _nameLan;
  Unit copyWith({
    String? unitId,
    String? id,
    String? name,
    String? code,
    String? unitCount,
    String? published,
    String? updatedate,
    dynamic nameLan,
  }) =>
      Unit(
        unitId: unitId ?? _unitId,
        id: id ?? _id,
        name: name ?? _name,
        code: code ?? _code,
        unitCount: unitCount ?? _unitCount,
        published: published ?? _published,
        updatedate: updatedate ?? _updatedate,
        nameLan: nameLan ?? _nameLan,
      );
  String? get unitId => _unitId;
  String? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get unitCount => _unitCount;
  String? get published => _published;
  String? get updatedate => _updatedate;
  dynamic get nameLan => _nameLan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unit_id'] = _unitId;
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['unit_count'] = _unitCount;
    map['published'] = _published;
    map['updatedate'] = _updatedate;
    map['name_lan'] = _nameLan;
    return map;
  }
}

/// gstid : "1"
/// cgst : "0.00"
/// sgst : "0.00"
/// igst : "0.00"
/// GST : "0"
/// cess_type : "0"
/// published : "0"
/// updatedate : "2019-06-25 20:23:21"
/// ces_name : null
/// ces_percent : "0.000"
/// ces_id : null

class Tax {
  Tax({
    String? gstid,
    String? cgst,
    String? sgst,
    String? igst,
    String? gst,
    String? cessType,
    String? published,
    String? updatedate,
    dynamic cesName,
    String? cesPercent,
    dynamic cesId,
  }) {
    _gstid = gstid;
    _cgst = cgst;
    _sgst = sgst;
    _igst = igst;
    _gst = gst;
    _cessType = cessType;
    _published = published;
    _updatedate = updatedate;
    _cesName = cesName;
    _cesPercent = cesPercent;
    _cesId = cesId;
  }

  Tax.fromJson(dynamic json) {
    _gstid = json['gstid'];
    _cgst = json['cgst'];
    _sgst = json['sgst'];
    _igst = json['igst'];
    _gst = json['GST'];
    _cessType = json['cess_type'];
    _published = json['published'];
    _updatedate = json['updatedate'];
    _cesName = json['ces_name'];
    _cesPercent = json['ces_percent'];
    _cesId = json['ces_id'];
  }
  String? _gstid;
  String? _cgst;
  String? _sgst;
  String? _igst;
  String? _gst;
  String? _cessType;
  String? _published;
  String? _updatedate;
  dynamic _cesName;
  String? _cesPercent;
  dynamic _cesId;
  Tax copyWith({
    String? gstid,
    String? cgst,
    String? sgst,
    String? igst,
    String? gst,
    String? cessType,
    String? published,
    String? updatedate,
    dynamic cesName,
    String? cesPercent,
    dynamic cesId,
  }) =>
      Tax(
        gstid: gstid ?? _gstid,
        cgst: cgst ?? _cgst,
        sgst: sgst ?? _sgst,
        igst: igst ?? _igst,
        gst: gst ?? _gst,
        cessType: cessType ?? _cessType,
        published: published ?? _published,
        updatedate: updatedate ?? _updatedate,
        cesName: cesName ?? _cesName,
        cesPercent: cesPercent ?? _cesPercent,
        cesId: cesId ?? _cesId,
      );
  String? get gstid => _gstid;
  String? get cgst => _cgst;
  String? get sgst => _sgst;
  String? get igst => _igst;
  String? get gst => _gst;
  String? get cessType => _cessType;
  String? get published => _published;
  String? get updatedate => _updatedate;
  dynamic get cesName => _cesName;
  String? get cesPercent => _cesPercent;
  dynamic get cesId => _cesId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gstid'] = _gstid;
    map['cgst'] = _cgst;
    map['sgst'] = _sgst;
    map['igst'] = _igst;
    map['GST'] = _gst;
    map['cess_type'] = _cessType;
    map['published'] = _published;
    map['updatedate'] = _updatedate;
    map['ces_name'] = _cesName;
    map['ces_percent'] = _cesPercent;
    map['ces_id'] = _cesId;
    return map;
  }
}

/// id : "1"
/// min_point_to_redeem : "100.00"
/// one_currency_equivalent : "0.50"
/// one_point_equivalent : "10.00"

class PointSettings {
  PointSettings({
    String? id,
    String? minPointToRedeem,
    String? oneCurrencyEquivalent,
    String? onePointEquivalent,
  }) {
    _id = id;
    _minPointToRedeem = minPointToRedeem;
    _oneCurrencyEquivalent = oneCurrencyEquivalent;
    _onePointEquivalent = onePointEquivalent;
  }

  PointSettings.fromJson(dynamic json) {
    _id = json['id'];
    _minPointToRedeem = json['min_point_to_redeem'];
    _oneCurrencyEquivalent = json['one_currency_equivalent'];
    _onePointEquivalent = json['one_point_equivalent'];
  }
  String? _id;
  String? _minPointToRedeem;
  String? _oneCurrencyEquivalent;
  String? _onePointEquivalent;
  PointSettings copyWith({
    String? id,
    String? minPointToRedeem,
    String? oneCurrencyEquivalent,
    String? onePointEquivalent,
  }) =>
      PointSettings(
        id: id ?? _id,
        minPointToRedeem: minPointToRedeem ?? _minPointToRedeem,
        oneCurrencyEquivalent: oneCurrencyEquivalent ?? _oneCurrencyEquivalent,
        onePointEquivalent: onePointEquivalent ?? _onePointEquivalent,
      );
  String? get id => _id;
  String? get minPointToRedeem => _minPointToRedeem;
  String? get oneCurrencyEquivalent => _oneCurrencyEquivalent;
  String? get onePointEquivalent => _onePointEquivalent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['min_point_to_redeem'] = _minPointToRedeem;
    map['one_currency_equivalent'] = _oneCurrencyEquivalent;
    map['one_point_equivalent'] = _onePointEquivalent;
    return map;
  }
}

/// dev_id : "24"
/// edit_itemrate : "0"
/// dev_name : "a"
/// bill_id : "25"
/// sales_billtype : "25"
/// payment_billtype : "36"
/// estimate_billtype : "21"
/// salereturn_billtype : "5"
/// receipt_billtype : "20"
/// dev_number : "d004f3f047c4dfgfq"
/// com_id : "4"
/// godown_id : "4"
/// branch_id : "3"

class Device {
  Device({
    String? devId,
    String? editItemrate,
    String? devName,
    String? billId,
    String? salesBilltype,
    String? paymentBilltype,
    String? estimateBilltype,
    String? salereturnBilltype,
    String? receiptBilltype,
    String? devNumber,
    String? comId,
    String? godownId,
    String? branchId,
  }) {
    _devId = devId;
    _editItemrate = editItemrate;
    _devName = devName;
    _billId = billId;
    _salesBilltype = salesBilltype;
    _paymentBilltype = paymentBilltype;
    _estimateBilltype = estimateBilltype;
    _salereturnBilltype = salereturnBilltype;
    _receiptBilltype = receiptBilltype;
    _devNumber = devNumber;
    _comId = comId;
    _godownId = godownId;
    _branchId = branchId;
  }

  Device.fromJson(dynamic json) {
    _devId = json['dev_id'];
    _editItemrate = json['edit_itemrate'];
    _devName = json['dev_name'];
    _billId = json['bill_id'];
    _salesBilltype = json['sales_billtype'];
    _paymentBilltype = json['payment_billtype'];
    _estimateBilltype = json['estimate_billtype'];
    _salereturnBilltype = json['salereturn_billtype'];
    _receiptBilltype = json['receipt_billtype'];
    _devNumber = json['dev_number'];
    _comId = json['com_id'];
    _godownId = json['godown_id'];
    _branchId = json['branch_id'];
  }
  String? _devId;
  String? _editItemrate;
  String? _devName;
  String? _billId;
  String? _salesBilltype;
  String? _paymentBilltype;
  String? _estimateBilltype;
  String? _salereturnBilltype;
  String? _receiptBilltype;
  String? _devNumber;
  String? _comId;
  String? _godownId;
  String? _branchId;
  Device copyWith({
    String? devId,
    String? editItemrate,
    String? devName,
    String? billId,
    String? salesBilltype,
    String? paymentBilltype,
    String? estimateBilltype,
    String? salereturnBilltype,
    String? receiptBilltype,
    String? devNumber,
    String? comId,
    String? godownId,
    String? branchId,
  }) =>
      Device(
        devId: devId ?? _devId,
        editItemrate: editItemrate ?? _editItemrate,
        devName: devName ?? _devName,
        billId: billId ?? _billId,
        salesBilltype: salesBilltype ?? _salesBilltype,
        paymentBilltype: paymentBilltype ?? _paymentBilltype,
        estimateBilltype: estimateBilltype ?? _estimateBilltype,
        salereturnBilltype: salereturnBilltype ?? _salereturnBilltype,
        receiptBilltype: receiptBilltype ?? _receiptBilltype,
        devNumber: devNumber ?? _devNumber,
        comId: comId ?? _comId,
        godownId: godownId ?? _godownId,
        branchId: branchId ?? _branchId,
      );
  String? get devId => _devId;
  String? get editItemrate => _editItemrate;
  String? get devName => _devName;
  String? get billId => _billId;
  String? get salesBilltype => _salesBilltype;
  String? get paymentBilltype => _paymentBilltype;
  String? get estimateBilltype => _estimateBilltype;
  String? get salereturnBilltype => _salereturnBilltype;
  String? get receiptBilltype => _receiptBilltype;
  String? get devNumber => _devNumber;
  String? get comId => _comId;
  String? get godownId => _godownId;
  String? get branchId => _branchId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dev_id'] = _devId;
    map['edit_itemrate'] = _editItemrate;
    map['dev_name'] = _devName;
    map['bill_id'] = _billId;
    map['sales_billtype'] = _salesBilltype;
    map['payment_billtype'] = _paymentBilltype;
    map['estimate_billtype'] = _estimateBilltype;
    map['salereturn_billtype'] = _salereturnBilltype;
    map['receipt_billtype'] = _receiptBilltype;
    map['dev_number'] = _devNumber;
    map['com_id'] = _comId;
    map['godown_id'] = _godownId;
    map['branch_id'] = _branchId;
    return map;
  }
}

/// address : "Address"
/// com_id : "1"
/// name : "ROYAL BAKES"
/// comkey : "123"
/// is_multiplegodown : ""
/// phone : "8846864200"
/// tin : "NiL"
/// details : ""
/// menutype : "1"
/// company_master : "1"
/// email : "royal@gmail.com"
/// name_lan : null
/// address_lan : null
/// updatedate : "2024-09-04 15:25:55"

class Company {
  Company({
    String? address,
    String? comId,
    String? name,
    String? comkey,
    String? isMultiplegodown,
    String? phone,
    String? tin,
    String? details,
    String? menutype,
    String? companyMaster,
    String? email,
    dynamic nameLan,
    dynamic addressLan,
    String? updatedate,
  }) {
    _address = address;
    _comId = comId;
    _name = name;
    _comkey = comkey;
    _isMultiplegodown = isMultiplegodown;
    _phone = phone;
    _tin = tin;
    _details = details;
    _menutype = menutype;
    _companyMaster = companyMaster;
    _email = email;
    _nameLan = nameLan;
    _addressLan = addressLan;
    _updatedate = updatedate;
  }

  Company.fromJson(dynamic json) {
    _address = json['address'];
    _comId = json['com_id'];
    _name = json['name'];
    _comkey = json['comkey'];
    _isMultiplegodown = json['is_multiplegodown'];
    _phone = json['phone'];
    _tin = json['tin'];
    _details = json['details'];
    _menutype = json['menutype'];
    _companyMaster = json['company_master'];
    _email = json['email'];
    _nameLan = json['name_lan'];
    _addressLan = json['address_lan'];
    _updatedate = json['updatedate'];
  }
  String? _address;
  String? _comId;
  String? _name;
  String? _comkey;
  String? _isMultiplegodown;
  String? _phone;
  String? _tin;
  String? _details;
  String? _menutype;
  String? _companyMaster;
  String? _email;
  dynamic _nameLan;
  dynamic _addressLan;
  String? _updatedate;
  Company copyWith({
    String? address,
    String? comId,
    String? name,
    String? comkey,
    String? isMultiplegodown,
    String? phone,
    String? tin,
    String? details,
    String? menutype,
    String? companyMaster,
    String? email,
    dynamic nameLan,
    dynamic addressLan,
    String? updatedate,
  }) =>
      Company(
        address: address ?? _address,
        comId: comId ?? _comId,
        name: name ?? _name,
        comkey: comkey ?? _comkey,
        isMultiplegodown: isMultiplegodown ?? _isMultiplegodown,
        phone: phone ?? _phone,
        tin: tin ?? _tin,
        details: details ?? _details,
        menutype: menutype ?? _menutype,
        companyMaster: companyMaster ?? _companyMaster,
        email: email ?? _email,
        nameLan: nameLan ?? _nameLan,
        addressLan: addressLan ?? _addressLan,
        updatedate: updatedate ?? _updatedate,
      );
  String? get address => _address;
  String? get comId => _comId;
  String? get name => _name;
  String? get comkey => _comkey;
  String? get isMultiplegodown => _isMultiplegodown;
  String? get phone => _phone;
  String? get tin => _tin;
  String? get details => _details;
  String? get menutype => _menutype;
  String? get companyMaster => _companyMaster;
  String? get email => _email;
  dynamic get nameLan => _nameLan;
  dynamic get addressLan => _addressLan;
  String? get updatedate => _updatedate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['com_id'] = _comId;
    map['name'] = _name;
    map['comkey'] = _comkey;
    map['is_multiplegodown'] = _isMultiplegodown;
    map['phone'] = _phone;
    map['tin'] = _tin;
    map['details'] = _details;
    map['menutype'] = _menutype;
    map['company_master'] = _companyMaster;
    map['email'] = _email;
    map['name_lan'] = _nameLan;
    map['address_lan'] = _addressLan;
    map['updatedate'] = _updatedate;
    return map;
  }
}

/// name : "DIMS"
/// logo : "DIMS"
/// is_taxincluded : false

class Config {
  Config({
    String? name,
    String? logo,
    bool? isTaxincluded,
  }) {
    _name = name;
    _logo = logo;
    _isTaxincluded = isTaxincluded;
  }

  Config.fromJson(dynamic json) {
    _name = json['name'];
    _logo = json['logo'];
    _isTaxincluded = json['is_taxincluded'] == '1'
        ? true
        : json['is_taxincluded'] == '0'
            ? false
            : json['is_taxincluded'];
  }
  String? _name;
  String? _logo;
  bool? _isTaxincluded;
  Config copyWith({
    String? name,
    String? logo,
    bool? isTaxincluded,
  }) =>
      Config(
        name: name ?? _name,
        logo: logo ?? _logo,
        isTaxincluded: isTaxincluded ?? _isTaxincluded,
      );
  String? get name => _name;
  String? get logo => _logo;
  bool? get isTaxincluded => _isTaxincluded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['logo'] = _logo;
    map['is_taxincluded'] = _isTaxincluded;
    return map;
  }
}

class CompanySettings {
  CompanySettings({
    String? comId,
    String? isMain,
    String? name,
    String? comkey,
    String? whatsappStatus,
    String? retailStoreId,
    String? logo,
    String? isMultiplegodown,
    String? address,
    String? pincode,
    String? location,
    String? phone,
    String? tin,
    String? fssai,
    String? details,
    String? menutype,
    String? companyMaster,
    String? email,
    dynamic nameLan,
    dynamic addressLan,
    String? updatedate,
    String? billwiseOpening,
    String? comTaxType,
    String? isLocation,
    String? isDiscription,
    String? itemTransferBill,
    String? isBilltype,
    String? isCess,
    String? isProduction,
    String? itemTransferBills,
    String? isTaxincluded,
    String? isItemcode,
    String? isAgeing,
    String? isAnalytics,
    String? isCostcenter,
    String? isBankac,
    String? isBatch,
    String? barcodeSettings,
    String? itemImage,
    String? priceMargin,
    String? quantityPrice,
    String? itemVideo,
    String? lcAutoUpdate,
    String? additionalCess,
    String? itemAlternate,
    String? isSupplier,
    String? isMultipletax,
    String? isPartNo,
    String? sjUnitCost,
    String? isItemType,
    String? isGodown,
    String? isMakemodel,
    String? isConfirm,
    String? isUnit,
    String? itemRack,
    String? itemCommission,
    String? commissionType,
    String? itemMinRate,
    String? itemAdvanced,
    String? isAutobarcode,
    String? isSize,
    String? barcodePreffix,
    String? autoBarcode,
    String? isFeature,
    String? isItemqrcode,
    String? exportInvoice,
    String? onsyncDiscount,
    String? onsyncCusrate,
    String? showCriterion,
    String? isRawmaterial,
    String? isAdjustment,
    String? printSize,
    String? roundOff,
    String? enableBarcode,
    String? saleCashType,
    String? isFreequantity,
    String? discountOn,
    String? globalMrp,
    String? globalMrpValue,
    String? globalDiscount,
    String? isKitgroup,
    String? customerPoints,
    String? isKitcustomer,
    String? isCashCollection,
    String? isComposite,
    String? isBkgroundPrint,
    String? billMrp,
    String? isReturnDamage,
    String? isIMEI,
    String? purCashType,
    String? c2,
    String? comsetCurrency,
    String? currencySymbol,
    String? comsetBank,
    String? comsetAccountNo,
    String? comsetIfsccode,
    String? crmType,
    String? comsetStatecode,
    String? termsCondition,
    String? comsetDeclaration,
    String? openingAeging,
    String? isNew,
    String? selectMaster,
    String? paperOrientation,
  }) {
    _comId = comId;
    _isMain = isMain;
    _name = name;
    _comkey = comkey;
    _whatsappStatus = whatsappStatus;
    _retailStoreId = retailStoreId;
    _logo = logo;
    _isMultiplegodown = isMultiplegodown;
    _address = address;
    _pincode = pincode;
    _location = location;
    _phone = phone;
    _tin = tin;
    _fssai = fssai;
    _details = details;
    _menutype = menutype;
    _companyMaster = companyMaster;
    _email = email;
    _nameLan = nameLan;
    _addressLan = addressLan;
    _updatedate = updatedate;
    _billwiseOpening = billwiseOpening;
    _comTaxType = comTaxType;
    _isLocation = isLocation;
    _isDiscription = isDiscription;
    _itemTransferBill = itemTransferBill;
    _isBilltype = isBilltype;
    _isCess = isCess;
    _isProduction = isProduction;
    _itemTransferBills = itemTransferBills;
    _isTaxincluded = isTaxincluded;
    _isItemcode = isItemcode;
    _isAgeing = isAgeing;
    _isAnalytics = isAnalytics;
    _isCostcenter = isCostcenter;
    _isBankac = isBankac;
    _isBatch = isBatch;
    _barcodeSettings = barcodeSettings;
    _itemImage = itemImage;
    _priceMargin = priceMargin;
    _quantityPrice = quantityPrice;
    _itemVideo = itemVideo;
    _lcAutoUpdate = lcAutoUpdate;
    _additionalCess = additionalCess;
    _itemAlternate = itemAlternate;
    _isSupplier = isSupplier;
    _isMultipletax = isMultipletax;
    _isPartNo = isPartNo;
    _sjUnitCost = sjUnitCost;
    _isItemType = isItemType;
    _isGodown = isGodown;
    _isMakemodel = isMakemodel;
    _isConfirm = isConfirm;
    _isUnit = isUnit;
    _itemRack = itemRack;
    _itemCommission = itemCommission;
    _commissionType = commissionType;
    _itemMinRate = itemMinRate;
    _itemAdvanced = itemAdvanced;
    _isAutobarcode = isAutobarcode;
    _isSize = isSize;
    _barcodePreffix = barcodePreffix;
    _autoBarcode = autoBarcode;
    _isFeature = isFeature;
    _isItemqrcode = isItemqrcode;
    _exportInvoice = exportInvoice;
    _onsyncDiscount = onsyncDiscount;
    _onsyncCusrate = onsyncCusrate;
    _showCriterion = showCriterion;
    _isRawmaterial = isRawmaterial;
    _isAdjustment = isAdjustment;
    _printSize = printSize;
    _roundOff = roundOff;
    _enableBarcode = enableBarcode;
    _saleCashType = saleCashType;
    _isFreequantity = isFreequantity;
    _discountOn = discountOn;
    _globalMrp = globalMrp;
    _globalMrpValue = globalMrpValue;
    _globalDiscount = globalDiscount;
    _isKitgroup = isKitgroup;
    _customerPoints = customerPoints;
    _isKitcustomer = isKitcustomer;
    _isCashCollection = isCashCollection;
    _isComposite = isComposite;
    _isBkgroundPrint = isBkgroundPrint;
    _billMrp = billMrp;
    _isReturnDamage = isReturnDamage;
    _isIMEI = isIMEI;
    _purCashType = purCashType;
    _c2 = c2;
    _comsetCurrency = comsetCurrency;
    _currencySymbol = currencySymbol;
    _comsetBank = comsetBank;
    _comsetAccountNo = comsetAccountNo;
    _comsetIfsccode = comsetIfsccode;
    _crmType = crmType;
    _comsetStatecode = comsetStatecode;
    _termsCondition = termsCondition;
    _comsetDeclaration = comsetDeclaration;
    _openingAeging = openingAeging;
    _new = isNew;
    _selectMaster = selectMaster;
    _paperOrientation = paperOrientation;
  }

  CompanySettings.fromJson(dynamic json) {
    _comId = json['com_id'];
    _isMain = json['is_main'];
    _name = json['name'];
    _comkey = json['comkey'];
    _whatsappStatus = json['whatsapp_status'];
    _retailStoreId = json['retail_store_id'];
    _logo = json['logo'];
    _isMultiplegodown = json['is_multiplegodown'];
    _address = json['address'];
    _pincode = json['pincode'];
    _location = json['location'];
    _phone = json['phone'];
    _tin = json['tin'];
    _fssai = json['FSSAI'];
    _details = json['details'];
    _menutype = json['menutype'];
    _companyMaster = json['company_master'];
    _email = json['email'];
    _nameLan = json['name_lan'];
    _addressLan = json['address_lan'];
    _updatedate = json['updatedate'];
    _billwiseOpening = json['billwise_opening'];
    _comTaxType = json['com_tax_type'];
    _isLocation = json['is_location'];
    _isDiscription = json['is_discription'];
    _itemTransferBill = json['item_transfer_bill'];
    _isBilltype = json['is_billtype'];
    _isCess = json['is_cess'];
    _isProduction = json['is_production'];
    _itemTransferBills = json['item_transfer_bills'];
    _isTaxincluded = json['is_taxincluded'];
    _isItemcode = json['is_itemcode'];
    _isAgeing = json['is_ageing'];
    _isAnalytics = json['is_analytics'];
    _isCostcenter = json['is_costcenter'];
    _isBankac = json['is_bankac'];
    _isBatch = json['is_batch'];
    _barcodeSettings = json['barcode_settings'];
    _itemImage = json['item_image'];
    _priceMargin = json['price_margin'];
    _quantityPrice = json['quantity_price'];
    _itemVideo = json['item_video'];
    _lcAutoUpdate = json['lc_auto_update'];
    _additionalCess = json['additional_cess'];
    _itemAlternate = json['item_alternate'];
    _isSupplier = json['is_supplier'];
    _isMultipletax = json['is_multipletax'];
    _isPartNo = json['is_part_no'];
    _sjUnitCost = json['sj_unit_cost'];
    _isItemType = json['is_item_type'];
    _isGodown = json['is_godown'];
    _isMakemodel = json['is_makemodel'];
    _isConfirm = json['is_confirm'];
    _isUnit = json['is_unit'];
    _itemRack = json['item_rack'];
    _itemCommission = json['item_commission'];
    _commissionType = json['commission_type'];
    _itemMinRate = json['item_min_rate'];
    _itemAdvanced = json['item_advanced'];
    _isAutobarcode = json['is_autobarcode'];
    _isSize = json['is_size'];
    _barcodePreffix = json['barcode_preffix'];
    _autoBarcode = json['auto_barcode'];
    _isFeature = json['is_feature'];
    _isItemqrcode = json['is_itemqrcode'];
    _exportInvoice = json['export_invoice'];
    _onsyncDiscount = json['onsync_discount'];
    _onsyncCusrate = json['onsync_cusrate'];
    _showCriterion = json['show_criterion'];
    _isRawmaterial = json['is_rawmaterial'];
    _isAdjustment = json['is_adjustment'];
    _printSize = json['print_size'];
    _roundOff = json['round_off'];
    _enableBarcode = json['enable_barcode'];
    _saleCashType = json['sale_cash_type'];
    _isFreequantity = json['is_freequantity'];
    _discountOn = json['discount_on'];
    _globalMrp = json['global_mrp'];
    _globalMrpValue = json['global_mrp_value'];
    _globalDiscount = json['global_discount'];
    _isKitgroup = json['is_kitgroup'];
    _customerPoints = json['customer_points'];
    _isKitcustomer = json['is_kitcustomer'];
    _isCashCollection = json['is_cash_collection'];
    _isComposite = json['is_composite'];
    _isBkgroundPrint = json['is_bkground_print'];
    _billMrp = json['bill_mrp'];
    _isReturnDamage = json['is_return_damage'];
    _isIMEI = json['is_IMEI'];
    _purCashType = json['pur_cash_type'];
    _c2 = json['c2'];
    _comsetCurrency = json['comset_currency'];
    _currencySymbol = json['currency_symbol'];
    _comsetBank = json['comset_bank'];
    _comsetAccountNo = json['comset_account_no'];
    _comsetIfsccode = json['comset_ifsccode'];
    _crmType = json['crm_type'];
    _comsetStatecode = json['comset_statecode'];
    _termsCondition = json['terms_condition'];
    _comsetDeclaration = json['comset_declaration'];
    _openingAeging = json['opening_aeging'];
    _new = json['new'];
    _selectMaster = json['select_master'];
    _paperOrientation = json['paper_orientation'];
  }
  String? _comId;
  String? _isMain;
  String? _name;
  String? _comkey;
  String? _whatsappStatus;
  String? _retailStoreId;
  String? _logo;
  String? _isMultiplegodown;
  String? _address;
  String? _pincode;
  String? _location;
  String? _phone;
  String? _tin;
  String? _fssai;
  String? _details;
  String? _menutype;
  String? _companyMaster;
  String? _email;
  dynamic _nameLan;
  dynamic _addressLan;
  String? _updatedate;
  String? _billwiseOpening;
  String? _comTaxType;
  String? _isLocation;
  String? _isDiscription;
  String? _itemTransferBill;
  String? _isBilltype;
  String? _isCess;
  String? _isProduction;
  String? _itemTransferBills;
  String? _isTaxincluded;
  String? _isItemcode;
  String? _isAgeing;
  String? _isAnalytics;
  String? _isCostcenter;
  String? _isBankac;
  String? _isBatch;
  String? _barcodeSettings;
  String? _itemImage;
  String? _priceMargin;
  String? _quantityPrice;
  String? _itemVideo;
  String? _lcAutoUpdate;
  String? _additionalCess;
  String? _itemAlternate;
  String? _isSupplier;
  String? _isMultipletax;
  String? _isPartNo;
  String? _sjUnitCost;
  String? _isItemType;
  String? _isGodown;
  String? _isMakemodel;
  String? _isConfirm;
  String? _isUnit;
  String? _itemRack;
  String? _itemCommission;
  String? _commissionType;
  String? _itemMinRate;
  String? _itemAdvanced;
  String? _isAutobarcode;
  String? _isSize;
  String? _barcodePreffix;
  String? _autoBarcode;
  String? _isFeature;
  String? _isItemqrcode;
  String? _exportInvoice;
  String? _onsyncDiscount;
  String? _onsyncCusrate;
  String? _showCriterion;
  String? _isRawmaterial;
  String? _isAdjustment;
  String? _printSize;
  String? _roundOff;
  String? _enableBarcode;
  String? _saleCashType;
  String? _isFreequantity;
  String? _discountOn;
  String? _globalMrp;
  String? _globalMrpValue;
  String? _globalDiscount;
  String? _isKitgroup;
  String? _customerPoints;
  String? _isKitcustomer;
  String? _isCashCollection;
  String? _isComposite;
  String? _isBkgroundPrint;
  String? _billMrp;
  String? _isReturnDamage;
  String? _isIMEI;
  String? _purCashType;
  String? _c2;
  String? _comsetCurrency;
  String? _currencySymbol;
  String? _comsetBank;
  String? _comsetAccountNo;
  String? _comsetIfsccode;
  String? _crmType;
  String? _comsetStatecode;
  String? _termsCondition;
  String? _comsetDeclaration;
  String? _openingAeging;
  String? _new;
  String? _selectMaster;
  String? _paperOrientation;
  CompanySettings copyWith({
    String? comId,
    String? isMain,
    String? name,
    String? comkey,
    String? whatsappStatus,
    String? retailStoreId,
    String? logo,
    String? isMultiplegodown,
    String? address,
    String? pincode,
    String? location,
    String? phone,
    String? tin,
    String? fssai,
    String? details,
    String? menutype,
    String? companyMaster,
    String? email,
    dynamic nameLan,
    dynamic addressLan,
    String? updatedate,
    String? billwiseOpening,
    String? comTaxType,
    String? isLocation,
    String? isDiscription,
    String? itemTransferBill,
    String? isBilltype,
    String? isCess,
    String? isProduction,
    String? itemTransferBills,
    String? isTaxincluded,
    String? isItemcode,
    String? isAgeing,
    String? isAnalytics,
    String? isCostcenter,
    String? isBankac,
    String? isBatch,
    String? barcodeSettings,
    String? itemImage,
    String? priceMargin,
    String? quantityPrice,
    String? itemVideo,
    String? lcAutoUpdate,
    String? additionalCess,
    String? itemAlternate,
    String? isSupplier,
    String? isMultipletax,
    String? isPartNo,
    String? sjUnitCost,
    String? isItemType,
    String? isGodown,
    String? isMakemodel,
    String? isConfirm,
    String? isUnit,
    String? itemRack,
    String? itemCommission,
    String? commissionType,
    String? itemMinRate,
    String? itemAdvanced,
    String? isAutobarcode,
    String? isSize,
    String? barcodePreffix,
    String? autoBarcode,
    String? isFeature,
    String? isItemqrcode,
    String? exportInvoice,
    String? onsyncDiscount,
    String? onsyncCusrate,
    String? showCriterion,
    String? isRawmaterial,
    String? isAdjustment,
    String? printSize,
    String? roundOff,
    String? enableBarcode,
    String? saleCashType,
    String? isFreequantity,
    String? discountOn,
    String? globalMrp,
    String? globalMrpValue,
    String? globalDiscount,
    String? isKitgroup,
    String? customerPoints,
    String? isKitcustomer,
    String? isCashCollection,
    String? isComposite,
    String? isBkgroundPrint,
    String? billMrp,
    String? isReturnDamage,
    String? isIMEI,
    String? purCashType,
    String? c2,
    String? comsetCurrency,
    String? currencySymbol,
    String? comsetBank,
    String? comsetAccountNo,
    String? comsetIfsccode,
    String? crmType,
    String? comsetStatecode,
    String? termsCondition,
    String? comsetDeclaration,
    String? openingAeging,
    String? isNew,
    String? selectMaster,
    String? paperOrientation,
  }) =>
      CompanySettings(
        comId: comId ?? _comId,
        isMain: isMain ?? _isMain,
        name: name ?? _name,
        comkey: comkey ?? _comkey,
        whatsappStatus: whatsappStatus ?? _whatsappStatus,
        retailStoreId: retailStoreId ?? _retailStoreId,
        logo: logo ?? _logo,
        isMultiplegodown: isMultiplegodown ?? _isMultiplegodown,
        address: address ?? _address,
        pincode: pincode ?? _pincode,
        location: location ?? _location,
        phone: phone ?? _phone,
        tin: tin ?? _tin,
        fssai: fssai ?? _fssai,
        details: details ?? _details,
        menutype: menutype ?? _menutype,
        companyMaster: companyMaster ?? _companyMaster,
        email: email ?? _email,
        nameLan: nameLan ?? _nameLan,
        addressLan: addressLan ?? _addressLan,
        updatedate: updatedate ?? _updatedate,
        billwiseOpening: billwiseOpening ?? _billwiseOpening,
        comTaxType: comTaxType ?? _comTaxType,
        isLocation: isLocation ?? _isLocation,
        isDiscription: isDiscription ?? _isDiscription,
        itemTransferBill: itemTransferBill ?? _itemTransferBill,
        isBilltype: isBilltype ?? _isBilltype,
        isCess: isCess ?? _isCess,
        isProduction: isProduction ?? _isProduction,
        itemTransferBills: itemTransferBills ?? _itemTransferBills,
        isTaxincluded: isTaxincluded ?? _isTaxincluded,
        isItemcode: isItemcode ?? _isItemcode,
        isAgeing: isAgeing ?? _isAgeing,
        isAnalytics: isAnalytics ?? _isAnalytics,
        isCostcenter: isCostcenter ?? _isCostcenter,
        isBankac: isBankac ?? _isBankac,
        isBatch: isBatch ?? _isBatch,
        barcodeSettings: barcodeSettings ?? _barcodeSettings,
        itemImage: itemImage ?? _itemImage,
        priceMargin: priceMargin ?? _priceMargin,
        quantityPrice: quantityPrice ?? _quantityPrice,
        itemVideo: itemVideo ?? _itemVideo,
        lcAutoUpdate: lcAutoUpdate ?? _lcAutoUpdate,
        additionalCess: additionalCess ?? _additionalCess,
        itemAlternate: itemAlternate ?? _itemAlternate,
        isSupplier: isSupplier ?? _isSupplier,
        isMultipletax: isMultipletax ?? _isMultipletax,
        isPartNo: isPartNo ?? _isPartNo,
        sjUnitCost: sjUnitCost ?? _sjUnitCost,
        isItemType: isItemType ?? _isItemType,
        isGodown: isGodown ?? _isGodown,
        isMakemodel: isMakemodel ?? _isMakemodel,
        isConfirm: isConfirm ?? _isConfirm,
        isUnit: isUnit ?? _isUnit,
        itemRack: itemRack ?? _itemRack,
        itemCommission: itemCommission ?? _itemCommission,
        commissionType: commissionType ?? _commissionType,
        itemMinRate: itemMinRate ?? _itemMinRate,
        itemAdvanced: itemAdvanced ?? _itemAdvanced,
        isAutobarcode: isAutobarcode ?? _isAutobarcode,
        isSize: isSize ?? _isSize,
        barcodePreffix: barcodePreffix ?? _barcodePreffix,
        autoBarcode: autoBarcode ?? _autoBarcode,
        isFeature: isFeature ?? _isFeature,
        isItemqrcode: isItemqrcode ?? _isItemqrcode,
        exportInvoice: exportInvoice ?? _exportInvoice,
        onsyncDiscount: onsyncDiscount ?? _onsyncDiscount,
        onsyncCusrate: onsyncCusrate ?? _onsyncCusrate,
        showCriterion: showCriterion ?? _showCriterion,
        isRawmaterial: isRawmaterial ?? _isRawmaterial,
        isAdjustment: isAdjustment ?? _isAdjustment,
        printSize: printSize ?? _printSize,
        roundOff: roundOff ?? _roundOff,
        enableBarcode: enableBarcode ?? _enableBarcode,
        saleCashType: saleCashType ?? _saleCashType,
        isFreequantity: isFreequantity ?? _isFreequantity,
        discountOn: discountOn ?? _discountOn,
        globalMrp: globalMrp ?? _globalMrp,
        globalMrpValue: globalMrpValue ?? _globalMrpValue,
        globalDiscount: globalDiscount ?? _globalDiscount,
        isKitgroup: isKitgroup ?? _isKitgroup,
        customerPoints: customerPoints ?? _customerPoints,
        isKitcustomer: isKitcustomer ?? _isKitcustomer,
        isCashCollection: isCashCollection ?? _isCashCollection,
        isComposite: isComposite ?? _isComposite,
        isBkgroundPrint: isBkgroundPrint ?? _isBkgroundPrint,
        billMrp: billMrp ?? _billMrp,
        isReturnDamage: isReturnDamage ?? _isReturnDamage,
        isIMEI: isIMEI ?? _isIMEI,
        purCashType: purCashType ?? _purCashType,
        c2: c2 ?? _c2,
        comsetCurrency: comsetCurrency ?? _comsetCurrency,
        currencySymbol: currencySymbol ?? _currencySymbol,
        comsetBank: comsetBank ?? _comsetBank,
        comsetAccountNo: comsetAccountNo ?? _comsetAccountNo,
        comsetIfsccode: comsetIfsccode ?? _comsetIfsccode,
        crmType: crmType ?? _crmType,
        comsetStatecode: comsetStatecode ?? _comsetStatecode,
        termsCondition: termsCondition ?? _termsCondition,
        comsetDeclaration: comsetDeclaration ?? _comsetDeclaration,
        openingAeging: openingAeging ?? _openingAeging,
        isNew: isNew ?? _new,
        selectMaster: selectMaster ?? _selectMaster,
        paperOrientation: paperOrientation ?? _paperOrientation,
      );
  String? get comId => _comId;
  String? get isMain => _isMain;
  String? get name => _name;
  String? get comkey => _comkey;
  String? get whatsappStatus => _whatsappStatus;
  String? get retailStoreId => _retailStoreId;
  String? get logo => _logo;
  String? get isMultiplegodown => _isMultiplegodown;
  String? get address => _address;
  String? get pincode => _pincode;
  String? get location => _location;
  String? get phone => _phone;
  String? get tin => _tin;
  String? get fssai => _fssai;
  String? get details => _details;
  String? get menutype => _menutype;
  String? get companyMaster => _companyMaster;
  String? get email => _email;
  dynamic get nameLan => _nameLan;
  dynamic get addressLan => _addressLan;
  String? get updatedate => _updatedate;
  String? get billwiseOpening => _billwiseOpening;
  String? get comTaxType => _comTaxType;
  String? get isLocation => _isLocation;
  String? get isDiscription => _isDiscription;
  String? get itemTransferBill => _itemTransferBill;
  String? get isBilltype => _isBilltype;
  String? get isCess => _isCess;
  String? get isProduction => _isProduction;
  String? get itemTransferBills => _itemTransferBills;
  String? get isTaxincluded => _isTaxincluded;
  String? get isItemcode => _isItemcode;
  String? get isAgeing => _isAgeing;
  String? get isAnalytics => _isAnalytics;
  String? get isCostcenter => _isCostcenter;
  String? get isBankac => _isBankac;
  String? get isBatch => _isBatch;
  String? get barcodeSettings => _barcodeSettings;
  String? get itemImage => _itemImage;
  String? get priceMargin => _priceMargin;
  String? get quantityPrice => _quantityPrice;
  String? get itemVideo => _itemVideo;
  String? get lcAutoUpdate => _lcAutoUpdate;
  String? get additionalCess => _additionalCess;
  String? get itemAlternate => _itemAlternate;
  String? get isSupplier => _isSupplier;
  String? get isMultipletax => _isMultipletax;
  String? get isPartNo => _isPartNo;
  String? get sjUnitCost => _sjUnitCost;
  String? get isItemType => _isItemType;
  String? get isGodown => _isGodown;
  String? get isMakemodel => _isMakemodel;
  String? get isConfirm => _isConfirm;
  String? get isUnit => _isUnit;
  String? get itemRack => _itemRack;
  String? get itemCommission => _itemCommission;
  String? get commissionType => _commissionType;
  String? get itemMinRate => _itemMinRate;
  String? get itemAdvanced => _itemAdvanced;
  String? get isAutobarcode => _isAutobarcode;
  String? get isSize => _isSize;
  String? get barcodePreffix => _barcodePreffix;
  String? get autoBarcode => _autoBarcode;
  String? get isFeature => _isFeature;
  String? get isItemqrcode => _isItemqrcode;
  String? get exportInvoice => _exportInvoice;
  String? get onsyncDiscount => _onsyncDiscount;
  String? get onsyncCusrate => _onsyncCusrate;
  String? get showCriterion => _showCriterion;
  String? get isRawmaterial => _isRawmaterial;
  String? get isAdjustment => _isAdjustment;
  String? get printSize => _printSize;
  String? get roundOff => _roundOff;
  String? get enableBarcode => _enableBarcode;
  String? get saleCashType => _saleCashType;
  String? get isFreequantity => _isFreequantity;
  String? get discountOn => _discountOn;
  String? get globalMrp => _globalMrp;
  String? get globalMrpValue => _globalMrpValue;
  String? get globalDiscount => _globalDiscount;
  String? get isKitgroup => _isKitgroup;
  String? get customerPoints => _customerPoints;
  String? get isKitcustomer => _isKitcustomer;
  String? get isCashCollection => _isCashCollection;
  String? get isComposite => _isComposite;
  String? get isBkgroundPrint => _isBkgroundPrint;
  String? get billMrp => _billMrp;
  String? get isReturnDamage => _isReturnDamage;
  String? get isIMEI => _isIMEI;
  String? get purCashType => _purCashType;
  String? get c2 => _c2;
  String? get comsetCurrency => _comsetCurrency;
  String? get currencySymbol => _currencySymbol;
  String? get comsetBank => _comsetBank;
  String? get comsetAccountNo => _comsetAccountNo;
  String? get comsetIfsccode => _comsetIfsccode;
  String? get crmType => _crmType;
  String? get comsetStatecode => _comsetStatecode;
  String? get termsCondition => _termsCondition;
  String? get comsetDeclaration => _comsetDeclaration;
  String? get openingAeging => _openingAeging;
  String? get isNew => _new;
  String? get selectMaster => _selectMaster;
  String? get paperOrientation => _paperOrientation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['com_id'] = _comId;
    map['is_main'] = _isMain;
    map['name'] = _name;
    map['comkey'] = _comkey;
    map['whatsapp_status'] = _whatsappStatus;
    map['retail_store_id'] = _retailStoreId;
    map['logo'] = _logo;
    map['is_multiplegodown'] = _isMultiplegodown;
    map['address'] = _address;
    map['pincode'] = _pincode;
    map['location'] = _location;
    map['phone'] = _phone;
    map['tin'] = _tin;
    map['FSSAI'] = _fssai;
    map['details'] = _details;
    map['menutype'] = _menutype;
    map['company_master'] = _companyMaster;
    map['email'] = _email;
    map['name_lan'] = _nameLan;
    map['address_lan'] = _addressLan;
    map['updatedate'] = _updatedate;
    map['billwise_opening'] = _billwiseOpening;
    map['com_tax_type'] = _comTaxType;
    map['is_location'] = _isLocation;
    map['is_discription'] = _isDiscription;
    map['item_transfer_bill'] = _itemTransferBill;
    map['is_billtype'] = _isBilltype;
    map['is_cess'] = _isCess;
    map['is_production'] = _isProduction;
    map['item_transfer_bills'] = _itemTransferBills;
    map['is_taxincluded'] = _isTaxincluded;
    map['is_itemcode'] = _isItemcode;
    map['is_ageing'] = _isAgeing;
    map['is_analytics'] = _isAnalytics;
    map['is_costcenter'] = _isCostcenter;
    map['is_bankac'] = _isBankac;
    map['is_batch'] = _isBatch;
    map['barcode_settings'] = _barcodeSettings;
    map['item_image'] = _itemImage;
    map['price_margin'] = _priceMargin;
    map['quantity_price'] = _quantityPrice;
    map['item_video'] = _itemVideo;
    map['lc_auto_update'] = _lcAutoUpdate;
    map['additional_cess'] = _additionalCess;
    map['item_alternate'] = _itemAlternate;
    map['is_supplier'] = _isSupplier;
    map['is_multipletax'] = _isMultipletax;
    map['is_part_no'] = _isPartNo;
    map['sj_unit_cost'] = _sjUnitCost;
    map['is_item_type'] = _isItemType;
    map['is_godown'] = _isGodown;
    map['is_makemodel'] = _isMakemodel;
    map['is_confirm'] = _isConfirm;
    map['is_unit'] = _isUnit;
    map['item_rack'] = _itemRack;
    map['item_commission'] = _itemCommission;
    map['commission_type'] = _commissionType;
    map['item_min_rate'] = _itemMinRate;
    map['item_advanced'] = _itemAdvanced;
    map['is_autobarcode'] = _isAutobarcode;
    map['is_size'] = _isSize;
    map['barcode_preffix'] = _barcodePreffix;
    map['auto_barcode'] = _autoBarcode;
    map['is_feature'] = _isFeature;
    map['is_itemqrcode'] = _isItemqrcode;
    map['export_invoice'] = _exportInvoice;
    map['onsync_discount'] = _onsyncDiscount;
    map['onsync_cusrate'] = _onsyncCusrate;
    map['show_criterion'] = _showCriterion;
    map['is_rawmaterial'] = _isRawmaterial;
    map['is_adjustment'] = _isAdjustment;
    map['print_size'] = _printSize;
    map['round_off'] = _roundOff;
    map['enable_barcode'] = _enableBarcode;
    map['sale_cash_type'] = _saleCashType;
    map['is_freequantity'] = _isFreequantity;
    map['discount_on'] = _discountOn;
    map['global_mrp'] = _globalMrp;
    map['global_mrp_value'] = _globalMrpValue;
    map['global_discount'] = _globalDiscount;
    map['is_kitgroup'] = _isKitgroup;
    map['customer_points'] = _customerPoints;
    map['is_kitcustomer'] = _isKitcustomer;
    map['is_cash_collection'] = _isCashCollection;
    map['is_composite'] = _isComposite;
    map['is_bkground_print'] = _isBkgroundPrint;
    map['bill_mrp'] = _billMrp;
    map['is_return_damage'] = _isReturnDamage;
    map['is_IMEI'] = _isIMEI;
    map['pur_cash_type'] = _purCashType;
    map['c2'] = _c2;
    map['comset_currency'] = _comsetCurrency;
    map['currency_symbol'] = _currencySymbol;
    map['comset_bank'] = _comsetBank;
    map['comset_account_no'] = _comsetAccountNo;
    map['comset_ifsccode'] = _comsetIfsccode;
    map['crm_type'] = _crmType;
    map['comset_statecode'] = _comsetStatecode;
    map['terms_condition'] = _termsCondition;
    map['comset_declaration'] = _comsetDeclaration;
    map['opening_aeging'] = _openingAeging;
    map['new'] = _new;
    map['select_master'] = _selectMaster;
    map['paper_orientation'] = _paperOrientation;
    return map;
  }
}
