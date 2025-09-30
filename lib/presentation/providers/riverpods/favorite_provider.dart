import 'dart:async';
import 'package:crypto_app/domain/repositories/favorite_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../data/repositories/favorite_coin_repository_impl.dart';
import '../../../domain/entities/crypto_price_tick.dart';
import '../../../domain/usecases/get_favorite_coins.dart';
import '../../../domain/usecases/toggle_favorite_coin.dart';
import 'coin_use_case_provider.dart';


// Repository Provider
final favoriteCoinsRepositoryProvider = Provider<FavoriteCoinsRepository>((ref) {
  return FavoriteCoinsRepositoryImpl();
});

// Use Case Providers
final getFavoriteCoinsProvider = Provider<GetFavoriteCoins>((ref) {
  return GetFavoriteCoins(ref.read(favoriteCoinsRepositoryProvider));
});

final toggleFavoriteCoinProvider = Provider<ToggleFavoriteCoin>((ref) {
  return ToggleFavoriteCoin(ref.read(favoriteCoinsRepositoryProvider));
});

// StateNotifier
class FavoriteCoinsNotifier extends StateNotifier<AsyncValue<Set<String>>> {
  final GetFavoriteCoins getFavorites;
  final ToggleFavoriteCoin toggleFavorite;

  FavoriteCoinsNotifier(this.getFavorites, this.toggleFavorite) : super(const AsyncValue.loading()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await getFavorites();
    state = AsyncValue.data(favorites);
  }

  Future<void> toggle(String id) async {
    state = const AsyncValue.loading();
    final updated = await toggleFavorite(id);
    state = AsyncValue.data(updated);
  }
}

// Provider for StateNotifier
final favoriteCoinsProvider = StateNotifierProvider<FavoriteCoinsNotifier, AsyncValue<Set<String>>>((ref) {
  return FavoriteCoinsNotifier(
    ref.read(getFavoriteCoinsProvider),
    ref.read(toggleFavoriteCoinProvider),
  );
});

// Favorite Live Prices
final favoritePricesProvider =
StreamProvider.family<List<CryptoPriceTick>, String>((ref, idsParam) {
  if (idsParam.isEmpty) {
    return const Stream.empty();
  }

  final useCase = ref.watch(streamPricesUseCaseProvider);
  final assets = idsParam.split(",");
  return useCase(assets);
});
