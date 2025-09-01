import 'package:crypto_app/domain/entities/crypto_coin.dart';

class CryptoCoinModel extends CryptoCoin {
  CryptoCoinModel(
      {required id,
      required rank,
      required symbol,
      required name,
      required priceUsd,
      required changePercent24Hr,
      required marketCapUsd,
      required volumeUsd24Hr})
      : super(
            id: id,
            rank: rank,
            symbol: symbol,
            name: name,
            priceUsd: priceUsd,
            changePercent24Hr: changePercent24Hr,
            marketCapUsd: marketCapUsd,
            volumeUsd24Hr: volumeUsd24Hr);

  factory CryptoCoinModel.fromJson(Map<String, dynamic> json) {
    return CryptoCoinModel(
        id: json['id'],
        rank: json['rank'],
        symbol: json['symbol'],
        name: json['name'],
        priceUsd: double.tryParse(json['priceUsd'] ?? '0') ?? 0,
        changePercent24Hr:
            double.tryParse(json['changePercent24Hr'] ?? '0') ?? 0,
        marketCapUsd: double.tryParse(json['marketCapUsd'] ?? '0') ?? 0,
        volumeUsd24Hr: double.tryParse(json['volumeUsd24Hr'] ?? '0') ?? 0);
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
