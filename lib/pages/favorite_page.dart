import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';
import '../providers/favorite_provider.dart';
import 'detail_page.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = ref.watch(cryptoAutoRefreshProvider);
    final favorites = ref.watch(favoriteCoinsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Favorite Coins')),
      body: coinsAsync.when(
        data: (coins) {
          final favoriteCoins = coins.where((coin) => favorites.contains(coin.id)).toList();

          if (favoriteCoins.isEmpty) {
            return Center(child: Text('No favorites yet.'));
          }

          return ListView.builder(
            itemCount: favoriteCoins.length,
            itemBuilder: (context, index) {
              final coin = favoriteCoins[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[900],
                  child: Text(
                    coin.symbol.substring(0, 1),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(coin.name),
                subtitle: Text('\$${coin.priceUsd.toStringAsFixed(2)}'),
                trailing: Text(
                  '${coin.changePercent24Hr.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: coin.changePercent24Hr >= 0 ? Colors.green : Colors.red,
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
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}