import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main_page.dart';
import 'splash_screen.dart';
import '../../providers/crypto_provider.dart';
import '../../providers/favorite_provider.dart';

class StartupWrapper extends ConsumerWidget {
  const StartupWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = ref.watch(cryptoAutoRefreshProvider);
    final favorites = ref.watch(favoriteCoinsProvider);

    final isCoinsReady = coinsAsync is AsyncData;

    if (!isCoinsReady) {
      return const SplashScreen();
    }

    return const MainTabs();
  }
}
