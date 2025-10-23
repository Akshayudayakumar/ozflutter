enum SavePayment { skip, save, abort }

class PaymentModel {
  PaymentModel({
    num? id,
    String? transactionId,
    String? type,
    String? value,
    String? bankName,
    String? customerId,
    String? salesId,
  }) {
    _id = id;
    _transactionId = transactionId;
    _type = type;
    _value = value;
    _bankName = bankName;
    _customerId = customerId;
    _salesId = salesId;
  }

  PaymentModel.fromJson(dynamic json) {
    _id = json['id'];
    _transactionId = json['transaction_id'];
    _type = json['type'];
    _value = json['value'];
    _bankName = json['bank_name'];
    _salesId = json['sales_id'];
    _customerId = json['customer_id'];
  }

  num? _id;
  String? _transactionId;
  String? _type;
  String? _value;
  String? _bankName;
  String? _customerId;
  String? _salesId;

  PaymentModel copyWith({
    num? id,
    String? transactionId,
    String? type,
    String? value,
    String? bankName,
    String? customerId,
    String? salesId,
  }) =>
      PaymentModel(
        id: id ?? _id,
        transactionId: transactionId ?? _transactionId,
        type: type ?? _type,
        value: value ?? _value,
        bankName: bankName ?? _bankName,
        customerId: customerId ?? _customerId,
        salesId: salesId ?? _salesId,
      );

  num? get id => _id;

  String? get transactionId => _transactionId;

  String? get type => _type;

  String? get value => _value;

  String? get bankName => _bankName;

  String? get customerId => _customerId;

  String? get salesId => _salesId;

  set id(num? itemQty) => _id = id;

  set transactionId(String? transactionId) => _transactionId = transactionId;

  set type(String? type) => _type = type;

  set value(String? value) => _value = value;

  set bankName(String? bankName) => _bankName = bankName;

  set customerId(String? customerId) => _customerId = customerId;

  set salesId(String? salesId) => _salesId = salesId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['transaction_id'] = _transactionId;
    map['type'] = _type;
    map['value'] = _value;
    map['bank_name'] = _bankName;
    map['sales_id'] = _salesId;
    map['customer_id'] = _customerId;
    return map;
  }
}
