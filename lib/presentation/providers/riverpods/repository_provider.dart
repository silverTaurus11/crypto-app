import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/crypto_res_datasource.dart';
import '../../../data/datasources/crypto_ws_datasource.dart';
import '../../../data/repositories/crypto_repository_impl.dart';

//Res DataSource
final cryptoResDataSource = Provider((ref) {
  return CryptoRestDataSource(
      apiKey:
          "084b71664f9bfe10315949e1eab71ec8de1cc78027645ef86a58d05b1bcd320c");
});

//Ws DataSource
final cryptoWsDataSource = Provider((ref) {
  return CryptoWsDataSource();
});

//Repository Provider
final cryptoRepositoryProvider = Provider((ref) {
  final res = ref.watch(cryptoResDataSource);
  final ws = ref.watch(cryptoWsDataSource);

  return CryptoRepositoryImpl(restDataSource: res, wsDataSource: ws);
});
