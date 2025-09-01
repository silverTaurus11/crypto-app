import 'package:crypto_app/presentation/pages/splash/startup_wrapper.dart';
import 'package:crypto_app/presentation/providers/blocs/events/favorite_coin_event.dart';
import 'package:crypto_app/presentation/providers/blocs/favorite_coin_bloc.dart';
import 'package:crypto_app/presentation/providers/riverpods/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getFavorites = ref.read(getFavoriteCoinsProvider);
    final toggleFavorite = ref.read(toggleFavoriteCoinProvider);

    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteBloc>(
          create: (_) => FavoriteBloc(getFavorites, toggleFavorite)
            ..add(LoadFavorites()), // langsung load saat app start
        ),
      ],
      child: MaterialApp(
        title: 'Crypto App',
        theme: ThemeData.dark(),
        home: const StartupWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
