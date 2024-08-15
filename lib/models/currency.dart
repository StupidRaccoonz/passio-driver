import 'dart:developer';

class Currency {
  int id;
  String code = "USD";
  String symbol = "\$";

  Currency({
    required this.id,
    required this.code,
    required this.symbol,
  });

  factory Currency.fromJSON(dynamic json) {
    final currency = Currency(
      id: int.parse(json["id"].toString()),
      code: json["code"],
      symbol: json["symbol"],
    );
    return currency;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'symbol': symbol,
      };
}
