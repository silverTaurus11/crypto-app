import 'package:crypto_app/domain/usecases/get_coins.dart';
import 'package:crypto_app/domain/usecases/get_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/crypto_repository_impl.dart';
import '../../../domain/entities/crypto_coin.dart';

//Repository Provider
final cryptoRepositoryProvider = Provider((ref) {
  return CoinRepositoryImpl();
});

//Coins UseCase Provider
final getCoinsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(cryptoRepositoryProvider);
  return GetCoins(repo);
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

//Coins Provider
final cryptoAutoRefreshProvider =
    StreamProvider<List<CryptoCoin>>((ref) async* {
  final useCase = ref.watch(getCoinsUseCaseProvider);
  while (true) {
    try {
      final coins = await useCase.getCoins();
      print("✅ Response: $coins"); // <-- Tambahkan ini
      yield coins;
    } catch (e) {
      print("❌ Error: $e");
      yield [];
    }
    await Future.delayed(Duration(hours: 1));
  }
});
