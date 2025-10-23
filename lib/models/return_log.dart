class ReturnLog {
  ReturnLog({
    num? id,
    String? salesId,
    String? itemId,
    String? invoice,
    String? createdDate,
    int? saleQuantity,
    int? returnQuantity,
  }) {
    _id = id;
    _salesId = salesId;
    _itemId = itemId;
    _invoice = invoice;
    _createdDate = createdDate;
    _saleQuantity = saleQuantity;
    _returnQuantity = returnQuantity;
  }

  ReturnLog.fromJson(dynamic json) {
    _id = json['id'];
    _salesId = json['sales_id'];
    _itemId = json['item_id'];
    _invoice = json['invoice'];
    _createdDate = json['created_date'];
    _saleQuantity = json['sale_quantity'];
    _returnQuantity = json['return_quantity'];
  }
  num? _id;
  String? _salesId;
  String? _itemId;
  String? _invoice;
  String? _createdDate;
  int? _saleQuantity;
  int? _returnQuantity;
  ReturnLog copyWith({
    num? id,
    String? salesId,
    String? itemId,
    String? invoice,
    String? createdDate,
    int? saleQuantity,
    int? returnQuantity,
  }) =>
      ReturnLog(
        id: id ?? _id,
        salesId: salesId ?? _salesId,
        itemId: itemId ?? _itemId,
        invoice: invoice ?? _invoice,
        createdDate: createdDate ?? _createdDate,
        saleQuantity: saleQuantity ?? _saleQuantity,
        returnQuantity: returnQuantity ?? _returnQuantity,
      );
  num? get id => _id;
  String? get salesId => _salesId;
  String? get itemId => _itemId;
  String? get invoice => _invoice;
  String? get createdDate => _createdDate;
  int? get saleQuantity => _saleQuantity;
  int? get returnQuantity => _returnQuantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sales_id'] = _salesId;
    map['item_id'] = _itemId;
    map['invoice'] = _invoice;
    map['created_date'] = _createdDate;
    map['sale_quantity'] = _saleQuantity;
    map['return_quantity'] = _returnQuantity;
    return map;
  }
}
