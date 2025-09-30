import 'package:crypto_app/presentation/providers/riverpods/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../domain/entities/crypto_coin.dart';
import '../../../domain/usecases/get_coins.dart';
import '../../../domain/usecases/get_detail.dart';
import '../../../domain/usecases/stream_crypto_prices.dart';

//Coins UseCase Provider
final getCoinsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(cryptoRepositoryProvider);
  return GetCoins(repo);
});

//Coins UseCase FutureProvider
final coinsFutureProvider = FutureProvider<List<CryptoCoin>>((ref) async {
  final useCase = ref.watch(getCoinsUseCaseProvider);
  try {
    final coins = await useCase.getCoins();
    print("✅ Coins fetched: $coins");
    return coins;
  } catch (e) {
    print("❌ Error fetching coins: $e");
    return [];
  }
});

//CoinDetail UseCase Provider
final getDetailUseCaseProvider = Provider((ref) {
  final repo = ref.watch(cryptoRepositoryProvider);
  return GetDetail(repo);
});

//CoinDetail Provider
final coinDetailProvider =
    FutureProvider.family<Map<String, dynamic>, (String, String)>(
        (ref, params) async {
  final (coinId, interval) = params;
  final useCase = ref.watch(getDetailUseCaseProvider);
  return useCase.getHistoricalDataWithTimestamps(coinId, interval);
});

//Selected Interval Provider
final selectedIntervalProvider = StateProvider<String>((ref) => 'm15');

// StreamPrices UseCase Provider
final streamPricesUseCaseProvider = Provider<StreamPrices>((ref) {
  final repo = ref.watch(cryptoRepositoryProvider);
  return StreamPrices(repo);
});
