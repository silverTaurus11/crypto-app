
import '../repositories/crypto_repository.dart';

class GetDetail {
  final CryptoRepository repository;

  GetDetail(this.repository);

  Future<Map<String, dynamic>> getHistoricalDataWithTimestamps(
      String coinId, String interval) {
    return repository.fetchHistoricalDataWithTimestamps(coinId, interval);
  }
}