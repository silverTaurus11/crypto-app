import 'package:crypto_app/domain/repositories/crypto_repository.dart';

import '../entities/crypto_coin.dart';

class GetCoins {
  final CryptoRepository repository;

  GetCoins(this.repository);

  Future<List<CryptoCoin>> getCoins() {
    return repository.fetchCoins();
  }
}
