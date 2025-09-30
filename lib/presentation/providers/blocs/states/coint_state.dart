import '../../../../domain/entities/crypto_coin.dart';

abstract class CoinState {}

class CoinInitial extends CoinState {}

class CoinLoading extends CoinState {}

class CoinLoaded extends CoinState {
  final List<CryptoCoin> coins;
  final Map<String, double> livePrices; // id -> price
  CoinLoaded({required this.coins, required this.livePrices});
}

class CoinError extends CoinState {
  final String message;
  CoinError(this.message);
}
