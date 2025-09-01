import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/favorite_repository.dart';

class FavoriteCoinsRepositoryImpl implements FavoriteCoinsRepository {
  static const key = 'favoriteCoins';

  @override
  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    return list.toSet();
  }

  @override
  Future<void> saveFavorites(Set<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, favorites.toList());
  }
}