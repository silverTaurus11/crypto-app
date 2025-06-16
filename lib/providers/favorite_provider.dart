import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteCoinsProvider = StateNotifierProvider<FavoriteCoinsNotifier, Set<String>>((ref) {
  // Gunakan AsyncValue dari storage
  final stored = ref.watch(favoriteCoinsStorageProvider);

  return stored.maybeWhen(
    data: (data) => FavoriteCoinsNotifier(data),
    orElse: () => FavoriteCoinsNotifier({}), // fallback jika belum siap
  );
});

final favoriteCoinsStorageProvider = FutureProvider<Set<String>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final favoriteCoins = prefs.getStringList('favoriteCoins') ?? [];
  return favoriteCoins.toSet();
});

class FavoriteCoinsNotifier extends StateNotifier<Set<String>> {
  FavoriteCoinsNotifier(Set<String> initialFavorites)
      : super(initialFavorites);

  void toggleFavorite(String id) {
    final updated = {...state};
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = updated;
    saveFavoritesToStorage(); // Simpan setiap kali diubah
  }

  bool isFavorite(String id) => state.contains(id);

  Future<void> saveFavoritesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteCoins', state.toList());
  }
}
