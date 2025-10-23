class StockUpdate {
  StockUpdate({
    String? stock,
    String? itemId,
    String? name,
    String? barcode,
  }) {
    _stock = stock;
    _itemId = itemId;
    _name = name;
    _barcode = barcode;
  }

  StockUpdate.fromJson(dynamic json) {
    _stock = json['stock'];
    _itemId = json['item_id'];
    _name = json['name'];
    _barcode = json['barcode'];
  }
  String? _stock;
  String? _itemId;
  String? _name;
  String? _barcode;
  StockUpdate copyWith({
    String? stock,
    String? itemId,
    String? name,
    String? barcode,
  }) =>
      StockUpdate(
        stock: stock ?? _stock,
        itemId: itemId ?? _itemId,
        name: name ?? _name,
        barcode: barcode ?? _barcode,
      );
  String? get stock => _stock;
  String? get itemId => _itemId;
  String? get name => _name;
  String? get barcode => _barcode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['stock'] = _stock;
    map['item_id'] = _itemId;
    map['name'] = _name;
    map['barcode'] = _barcode;
    return map;
  }
}
