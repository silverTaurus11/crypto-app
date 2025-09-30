import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/blocs/coin_bloc.dart';
import '../providers/blocs/states/coint_state.dart';
import '../providers/riverpods/bloc_provider.dart';
import '../providers/riverpods/favorite_provider.dart';
import 'detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final favoriteNotifier = ref.read(favoriteCoinsProvider.notifier);
    final favoriteState = ref.watch(favoriteCoinsProvider);

    final coinBloc = ref.watch(coinBlocProvider);

    return BlocProvider.value(
      value: coinBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(loc.home_title)),
        body: BlocBuilder<CoinBloc, CoinState>(
          builder: (context, state) {
            if (state is CoinLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CoinError) {
              return Center(child: Text("❌ ${state.message}"));
            } else if (state is CoinLoaded) {
              return favoriteState.when(
                data: (favorites) => RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(coinBlocProvider);
                  },
                  child: ListView.builder(
                    itemCount: state.coins.length,
                    itemBuilder: (context, index) {
                      final coin = state.coins[index];
                      final isFav = favorites.contains(coin.id);

                      // fallback: pakai REST price kalau belum ada WS update
                      final livePrice =
                          state.livePrices[coin.id.toLowerCase()] ??
                              coin.priceUsd;

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
                        subtitle: Text('\$${livePrice.toString()}'),
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
                                favoriteNotifier.toggle(coin.id);
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
                  ),
                ),
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Fav error: $e')),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
