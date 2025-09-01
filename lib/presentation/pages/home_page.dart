import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/formatter.dart';
import '../providers/crypto_provider.dart';
import '../providers/favorite_provider.dart';
import 'detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = ref.watch(cryptoAutoRefreshProvider);
    final favoriteNotifier = ref.read(favoriteCoinsProvider.notifier);
    final favoriteState =
        ref.watch(favoriteCoinsProvider); // AsyncValue<Set<String>>

    return Scaffold(
      appBar: AppBar(title: const Text('Crypto Prices (Auto Refresh)')),
      body: coinsAsync.when(
        data: (coins) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(cryptoAutoRefreshProvider);
            },
            child: favoriteState.when(
                data: (favorites) {
                  return ListView.builder(
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      final coin = coins[index];
                      final isFav = favorites.contains(coin.id);

                      return ListTile(
                        key: ValueKey(coin.id),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[900],
                          child: Text(
                            coin.symbol.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(coin.name),
                        subtitle: Text(formatCurrency(coin.priceUsd)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${coin.changePercent24Hr.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: coin.changePercent24Hr >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFav ? Icons.star : Icons.star_border,
                                color: isFav ? Colors.amber : Colors.white,
                              ),
                              onPressed: () {
                                favoriteNotifier
                                    .toggle(coin.id); // Toggle favorit
                              },
                            ),
                          ],
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
                error: (e, _) => Center(child: Text('Error: $e')),
                loading: () =>
                    const Center(child: CircularProgressIndicator()))),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
