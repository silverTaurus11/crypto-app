
import '../../../../domain/entities/crypto_price_tick.dart';

abstract class CoinEvent {}

class LoadCoins extends CoinEvent {}

class StreamPricesEvent extends CoinEvent {
  final List<String> assets;
  StreamPricesEvent(this.assets);
}

class UpdatePrices extends CoinEvent {
  final List<CryptoPriceTick> ticks;
  UpdatePrices(this.ticks);
}

class UpdatePricesError extends CoinEvent {
  final String message;
  UpdatePricesError(this.message);
}
