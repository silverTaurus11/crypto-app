abstract class FavoriteCoinsRepository {
  Future<Set<String>> getFavorites();
  Future<void> saveFavorites(Set<String> favorites);
}