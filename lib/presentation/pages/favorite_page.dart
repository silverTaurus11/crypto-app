import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/crypto_coin.dart';
import '../../l10n/app_localizations.dart';
import '../providers/blocs/events/favorite_coin_event.dart';
import '../providers/blocs/favorite_coin_bloc.dart';
import '../providers/blocs/states/favorite_coin_state.dart';
import '../providers/riverpods/coin_use_case_provider.dart';
import '../providers/riverpods/favorite_provider.dart';
import 'detail_page.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final coinsAsync = ref.watch(coinsFutureProvider);

    return Scaffold(
      appBar: AppBar(title: Text(loc.favorite_title)),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, favState) {
          if (favState is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favState is FavoriteLoaded) {
            final favorites = favState.favorites;

            return coinsAsync.when(
              data: (coins) {
                // ambil list favorite coins
                final favoriteCoinsList =
                    coins.where((c) => favorites.contains(c.id)).toList();

                if (favoriteCoinsList.isEmpty) {
                  return const Center(child: Text('No favorites yet.'));
                }

                // gabungkan jadi string biar stabil untuk provider
                final idsParam = favoriteCoinsList.map((c) => c.id).join(",");
                final livePricesAsync =
                    ref.watch(favoritePricesProvider(idsParam));

                return livePricesAsync.when(
                  data: (ticks) {
                    final priceMap = {
                      for (var t in ticks) t.asset: t.price,
                    };

                    return _buildFavoriteList(
                        favorites, favoriteCoinsList, priceMap, (id) {
                      context.read<FavoriteBloc>().add(ToggleFavoriteEvent(id));
                    }, () {
                      context.read<FavoriteBloc>().add(LoadFavorites());
                    });
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('WS Error: $e')),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            );
          }

          if (favState is FavoriteError) {
            return Center(child: Text('Error: ${favState.message}'));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildFavoriteList(
      Set<String> favorites,
      List<CryptoCoin> coins,
      Map<String, double> livePrices,
      void Function(String id) favoritePressed,
      void Function() onRefresh) {
    return RefreshIndicator(
        child: ListView.builder(
          itemCount: coins.length,
          itemBuilder: (context, index) {
            final coin = coins[index];

            // fallback ke harga REST kalau belum ada update WS
            final livePrice =
                livePrices[coin.id.toLowerCase()] ?? coin.priceUsd;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[900],
                child: Text(
                  coin.symbol.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(coin.name),
              subtitle: Text('\$${livePrice.toString()}'),
              trailing: IconButton(
                icon: Icon(
                  favorites.contains(coin.id) ? Icons.star : Icons.star_border,
                  color:
                      favorites.contains(coin.id) ? Colors.amber : Colors.white,
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
        ),
        onRefresh: () async {
          onRefresh();
        });
  }
}
