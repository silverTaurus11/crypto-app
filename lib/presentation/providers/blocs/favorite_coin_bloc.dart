import 'package:crypto_app/presentation/providers/blocs/states/favorite_coin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_favorite_coins.dart';
import '../../../domain/usecases/toggle_favorite_coin.dart';
import 'events/favorite_coin_event.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoriteCoins getFavorites;
  final ToggleFavoriteCoin toggleFavorite;

  FavoriteBloc(this.getFavorites, this.toggleFavorite)
      : super(FavoriteLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLoading());
      final favorites = await getFavorites();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    if (state is FavoriteLoaded) {
      final updated = await toggleFavorite(event.id);
      emit(FavoriteLoaded(updated));
    }
  }
}