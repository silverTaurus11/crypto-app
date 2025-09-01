import '../repositories/favorite_repository.dart';

class GetFavoriteCoins {
  final FavoriteCoinsRepository repository;

  GetFavoriteCoins(this.repository);

  Future<Set<String>> call() => repository.getFavorites();
}