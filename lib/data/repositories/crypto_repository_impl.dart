// data/repositories/crypto_repository_impl.dart
import '../../domain/entities/crypto_coin.dart';
import '../../domain/entities/crypto_price_tick.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_res_datasource.dart';
import '../datasources/crypto_ws_datasource.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRestDataSource restDataSource;
  final CryptoWsDataSource wsDataSource;

  CryptoRepositoryImpl({
    required this.restDataSource,
    required this.wsDataSource,
  });

  @override
  Future<List<CryptoCoin>> fetchCoins() {
    return restDataSource.fetchCoins();
  }

  @override
  Future<Map<String, dynamic>> fetchHistoricalDataWithTimestamps(
      String coinId, String interval) {
    return restDataSource.fetchHistoricalDataWithTimestamps(coinId, interval);
  }

  @override
  Stream<List<CryptoPriceTick>> streamPrices(List<String> assets) {
    final stream = wsDataSource.connect(assets, restDataSource.apiKey);
    return stream.map((priceMap) {
      final now = DateTime.now();
      return priceMap.entries.map((e) {
        return CryptoPriceTick(
          asset: e.key,
          price: e.value,
          time: now,
        );
      }).toList();
    });
  }
}
