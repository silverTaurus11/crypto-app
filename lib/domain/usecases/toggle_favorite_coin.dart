import '../repositories/favorite_repository.dart';

class ToggleFavoriteCoin {
  final FavoriteCoinsRepository repository;

  ToggleFavoriteCoin(this.repository);

  Future<Set<String>> call(String id) async {
    final favorites = await repository.getFavorites();
    final updated = {...favorites};
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    await repository.saveFavorites(updated);
    return updated;
  }
}