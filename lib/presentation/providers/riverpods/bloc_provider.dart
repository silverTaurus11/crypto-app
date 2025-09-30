import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../blocs/coin_bloc.dart';
import '../blocs/events/coint_event.dart';
import 'coin_use_case_provider.dart';

final coinBlocProvider = Provider<CoinBloc>((ref) {
  final getCoinsUseCase = ref.watch(getCoinsUseCaseProvider);
  final streamPricesUseCase = ref.watch(streamPricesUseCaseProvider);
  final bloc = CoinBloc(getCoins: getCoinsUseCase, streamPrices: streamPricesUseCase);
  bloc.add(LoadCoins());
  return bloc;
});
