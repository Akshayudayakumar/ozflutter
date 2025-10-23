class Currency {
  String? id;
  String? name;
  String? symbol;
  String? code;

  Currency({this.id, this.name, this.symbol, this.code});

  Currency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['symbol'] = symbol;
    data['code'] = code;
    return data;
  }

  static Currency getById(String? id) {
    return currencies.firstWhere(
      (element) => element.id == id,
      orElse: () => Currency(
        id: '2',
        code: 'INR',
        symbol: '₹',
        name: 'Indian Rupees',
      ),
    );
  }
}

List<Currency> currencies = [
  Currency(
    id: '1',
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
  ),
  Currency(
    id: '2',
    code: 'INR',
    symbol: '₹',
    name: 'Indian Rupees',
  ),
  Currency(
    id: '3',
    code: 'EUR',
    symbol: '€',
    name: 'Euro',
  ),
  Currency(
      id: '4', code: 'AED', symbol: 'د.إ', name: 'United Arab Emirates Dirham'),
  Currency(
    id: '5',
    code: 'SAR',
    symbol: '﷼',
    name: 'Saudi Riyal',
  ),
];
