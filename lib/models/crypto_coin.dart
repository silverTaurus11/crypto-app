class CryptoCoin {
  final String id;
  final String rank;
  final String symbol;
  final String name;
  final double priceUsd;
  final double changePercent24Hr;
  final double marketCapUsd;
  final double volumeUsd24Hr;

  CryptoCoin({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.changePercent24Hr,
    required this.marketCapUsd,
    required this.volumeUsd24Hr
  });

  factory CryptoCoin.fromJson(Map<String, dynamic> json) {
    return CryptoCoin(
      id: json['id'],
      rank: json['rank'],
      symbol: json['symbol'],
      name: json['name'],
      priceUsd: double.tryParse(json['priceUsd'] ?? '0') ?? 0,
      changePercent24Hr: double.tryParse(json['changePercent24Hr'] ?? '0') ?? 0,
      marketCapUsd: double.tryParse(json['marketCapUsd'] ?? '0') ?? 0,
      volumeUsd24Hr: double.tryParse(json['volumeUsd24Hr'] ?? '0') ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rank': rank,
      'symbol': symbol,
      'name': name,
      'priceUsd': priceUsd.toString(),
      'changePercent24Hr': changePercent24Hr.toString(),
      'marketCapUsd': marketCapUsd.toString(),
      'volumeUsd24Hr': volumeUsd24Hr.toString()
    };
  }
}
