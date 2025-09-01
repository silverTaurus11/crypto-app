import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/formatter.dart';
import '../providers/crypto_provider.dart';
import '../providers/favorite_provider.dart';
import 'detail_page.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = ref.watch(cryptoAutoRefreshProvider);
    final favoritesState = ref.watch(favoriteCoinsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Favorite Coins')),
      body: coinsAsync.when(
        data: (coins) {
          return favoritesState.when(
              data: (favorites) {
                final favoriteCoinsList =
                    coins.where((coin) => favorites.contains(coin.id)).toList();

                if (favoriteCoinsList.isEmpty) {
                  return Center(child: Text('No favorites yet.'));
                }

                return ListView.builder(
                  itemCount: favoriteCoinsList.length,
                  itemBuilder: (context, index) {
                    final coin = favoriteCoinsList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[900],
                        child: Text(
                          coin.symbol.substring(0, 1),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(coin.name),
                      subtitle: Text(formatCurrency(coin.priceUsd)),
                      trailing: Text(
                        '${coin.changePercent24Hr.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: coin.changePercent24Hr >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
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
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')));
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
