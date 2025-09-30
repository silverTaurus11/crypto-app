// domain/usecases/stream_prices.dart
import '../entities/crypto_price_tick.dart';
import '../repositories/crypto_repository.dart';

class StreamPrices {
  final CryptoRepository repo;
  StreamPrices(this.repo);

  Stream<List<CryptoPriceTick>> call(List<String> assets) {
    return repo.streamPrices(assets);
  }
}
