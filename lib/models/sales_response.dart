class SalesResponse {
  SalesResponse({
    bool? status,
    List<CustomerPoints>? customerPoints,
    List<dynamic>? accLedgers,
    List<Result>? result,
    String? message,
  }) {
    _status = status;
    _customerPoints = customerPoints;
    _accLedgers = accLedgers;
    _result = result;
    _message = message;
  }

  SalesResponse.fromJson(dynamic json) {
    _status = json['status'];
    if (json['customer_points'] != null) {
      _customerPoints = [];
      json['customer_points'].forEach((v) {
        _customerPoints?.add(CustomerPoints.fromJson(v));
      });
    }
    if (json['acc_ledgers'] != null) {
      _accLedgers = [];
      json['acc_ledgers'].forEach((v) {
        _accLedgers?.add(v);
      });
    }
    if (json['result'] != null) {
      _result = [];
      json['result'].forEach((v) {
        _result?.add(Result.fromJson(v));
      });
    }
    _message = json['message'];
  }
  bool? _status;
  List<CustomerPoints>? _customerPoints;
  List<dynamic>? _accLedgers;
  List<Result>? _result;
  String? _message;
  SalesResponse copyWith({
    bool? status,
    List<CustomerPoints>? customerPoints,
    List<dynamic>? accLedgers,
    List<Result>? result,
    String? message,
  }) =>
      SalesResponse(
        status: status ?? _status,
        customerPoints: customerPoints ?? _customerPoints,
        accLedgers: accLedgers ?? _accLedgers,
        result: result ?? _result,
        message: message ?? _message,
      );
  bool? get status => _status;
  List<CustomerPoints>? get customerPoints => _customerPoints;
  List<dynamic>? get accLedgers => _accLedgers;
  List<Result>? get result => _result;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_customerPoints != null) {
      map['customer_points'] = _customerPoints?.map((v) => v.toJson()).toList();
    }
    if (_accLedgers != null) {
      map['acc_ledgers'] = _accLedgers?.map((v) => v.toJson()).toList();
    }
    if (_result != null) {
      map['result'] = _result?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    return map;
  }
}

class Result {
  Result({
    String? hi,
    String? invoice,
  }) {
    _hi = hi;
    _invoice = invoice;
  }

  Result.fromJson(dynamic json) {
    _hi = json['hi'];
    _invoice = json['invoice'];
  }
  String? _hi;
  String? _invoice;
  Result copyWith({
    String? hi,
    String? invoice,
  }) =>
      Result(
        hi: hi ?? _hi,
        invoice: invoice ?? _invoice,
      );
  String? get hi => _hi;
  String? get invoice => _invoice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hi'] = _hi;
    map['invoice'] = _invoice;
    return map;
  }
}

class CustomerPoints {
  CustomerPoints({
    String? oneCurrencyEquivalentPoint,
    String? minPointsToReedeem,
    String? customerPoints,
    String? id,
    String? name,
  }) {
    _oneCurrencyEquivalentPoint = oneCurrencyEquivalentPoint;
    _minPointsToReedeem = minPointsToReedeem;
    _customerPoints = customerPoints;
    _id = id;
    _name = name;
  }

  CustomerPoints.fromJson(dynamic json) {
    _oneCurrencyEquivalentPoint = json['one_currency_equivalent_point'];
    _minPointsToReedeem = json['min_points_to_reedeem'];
    _customerPoints = json['customer_points'];
    _id = json['id'];
    _name = json['name'];
  }
  String? _oneCurrencyEquivalentPoint;
  String? _minPointsToReedeem;
  String? _customerPoints;
  String? _id;
  String? _name;
  CustomerPoints copyWith({
    String? oneCurrencyEquivalentPoint,
    String? minPointsToReedeem,
    String? customerPoints,
    String? id,
    String? name,
  }) =>
      CustomerPoints(
        oneCurrencyEquivalentPoint:
            oneCurrencyEquivalentPoint ?? _oneCurrencyEquivalentPoint,
        minPointsToReedeem: minPointsToReedeem ?? _minPointsToReedeem,
        customerPoints: customerPoints ?? _customerPoints,
        id: id ?? _id,
        name: name ?? _name,
      );
  String? get oneCurrencyEquivalentPoint => _oneCurrencyEquivalentPoint;
  String? get minPointsToReedeem => _minPointsToReedeem;
  String? get customerPoints => _customerPoints;
  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['one_currency_equivalent_point'] = _oneCurrencyEquivalentPoint;
    map['min_points_to_reedeem'] = _minPointsToReedeem;
    map['customer_points'] = _customerPoints;
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}
