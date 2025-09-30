import '../entities/crypto_coin.dart';
import '../entities/crypto_price_tick.dart';

abstract class CryptoRepository {
  Future<List<CryptoCoin>> fetchCoins();

  Future<Map<String, dynamic>> fetchHistoricalDataWithTimestamps(
      String coinId, String interval);

  Stream<List<CryptoPriceTick>> streamPrices(List<String> assets);
}
