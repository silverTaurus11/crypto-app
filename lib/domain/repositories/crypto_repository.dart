import '../entities/crypto_coin.dart';

abstract class CryptoRepository {
  Future<List<CryptoCoin>> fetchCoins();

  Future<Map<String, dynamic>> fetchHistoricalDataWithTimestamps(
      String coinId, String interval);
}
