// presentation/bloc/coin_bloc.dart
import 'dart:async';
import 'package:crypto_app/presentation/providers/blocs/states/coint_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/crypto_price_tick.dart';
import '../../../domain/usecases/get_coins.dart';
import '../../../domain/usecases/stream_crypto_prices.dart';
import 'events/coint_event.dart';


class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final GetCoins getCoins;
  final StreamPrices streamPrices;

  StreamSubscription<List<CryptoPriceTick>>? _priceSub;

  CoinBloc({required this.getCoins, required this.streamPrices})
      : super(CoinInitial()) {
    on<LoadCoins>(_onLoadCoins);
    on<StreamPricesEvent>(_onStreamPrices);
    on<UpdatePrices>(_onUpdatePrices);
    on<UpdatePricesError>(_onUpdatePricesError);
  }

  Future<void> _onLoadCoins(
      LoadCoins event, Emitter<CoinState> emit) async {
    emit(CoinLoading());
    try {
      final coins = await getCoins.getCoins();

      // setelah coins berhasil didapat, langsung mulai stream harga
      add(StreamPricesEvent(coins.map((e) => e.id).toList()));

      emit(CoinLoaded(coins: coins, livePrices: {}));
    } catch (e) {
      emit(CoinError("Failed to fetch coins: $e"));
    }
  }

  Future<void> _onStreamPrices(
      StreamPricesEvent event, Emitter<CoinState> emit) async {
    await _priceSub?.cancel();

    _priceSub = streamPrices(event.assets).listen(
          (ticks) => add(UpdatePrices(ticks)), // ✅ lempar event baru
      onError: (e) => add(UpdatePricesError("WS error: $e")),
    );
  }

  Future<void> _onUpdatePrices(
      UpdatePrices event, Emitter<CoinState> emit) async {
    if (state is CoinLoaded) {
      final current = state as CoinLoaded;
      final priceMap = Map<String, double>.from(current.livePrices);

      for (final t in event.ticks) {
        priceMap[t.asset] = t.price;
      }

      emit(CoinLoaded(coins: current.coins, livePrices: priceMap));
    }
  }

  Future<void> _onUpdatePricesError(
      UpdatePricesError event, Emitter<CoinState> emit) async {
    emit(CoinError(event.message));
  }

  @override
  Future<void> close() {
    _priceSub?.cancel();
    return super.close();
  }
}
