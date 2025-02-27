class Stock {
  final String symbol;
  final String name;
  final double price;
  final double change;

  Stock({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? 'N/A',
      name: json['name'] ?? 'N/A',
      price:
      json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      change: json['change'] != null
          ? double.parse(json['change'].toString())
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'price': price,
      'change': change,
    };
  }
}
