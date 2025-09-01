import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/crypto_coin.dart';
import '../../utils/formatter.dart';
import '../providers/blocs/events/favorite_coin_event.dart';
import '../providers/blocs/favorite_coin_bloc.dart';
import '../providers/blocs/states/favorite_coin_state.dart';
import '../providers/riverpods/crypto_provider.dart';
import 'detail_page.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = ref.watch(cryptoAutoRefreshProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Favorite Coins')),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, favState) {
        if (favState is FavoriteLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (favState is FavoriteLoaded) {
          final favorites = favState.favorites;
          return coinsAsync.when(
            data: (coins) {
              return _buildFavoriteList(favorites, coins, (id) {
                context.read<FavoriteBloc>().add(ToggleFavoriteEvent(id));
              });
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        }
        if (favState is FavoriteError) {
          return Center(child: Text('Error: ${favState.message}'));
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildFavoriteList(Set<String> favorites, List<CryptoCoin> coins,
      void Function(String id) favoritePressed) {
    final favoriteCoinsList =
        coins.where((coin) => favorites.contains(coin.id)).toList();

    if (favoriteCoinsList.isEmpty) {
      return const Center(child: Text('No favorites yet.'));
    }

    return ListView.builder(
      itemCount: favoriteCoinsList.length,
      itemBuilder: (context, index) {
        final coin = favoriteCoinsList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[900],
            child: Text(
              coin.symbol.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(coin.name),
          subtitle: Text(formatCurrency(coin.priceUsd)),
          trailing: IconButton(
            icon: Icon(
              favorites.contains(coin.id) ? Icons.star : Icons.star_border,
              color: favorites.contains(coin.id) ? Colors.amber : Colors.white,
            ),
            onPressed: () => favoritePressed(coin.id),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CoinDetailPage(coin: coin),
            ),
          ),
        );
      },
    );
  }
}
