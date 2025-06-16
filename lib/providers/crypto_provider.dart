import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crypto_coin.dart';
import '../services/crypto_service.dart';

final cryptoAutoRefreshProvider = StreamProvider<List<CryptoCoin>>((ref) async* {
  final service = CryptoService();
  while (true) {
    try {
      final coins = await service.fetchCoins();
      yield coins;
    } catch (_) {
      // yield empty list or handle error silently
      yield [];
    }
    await Future.delayed(Duration(hours: 1));
  }
});
