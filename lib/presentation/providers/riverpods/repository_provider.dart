import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/crypto_res_datasource.dart';
import '../../../data/datasources/crypto_ws_datasource.dart';
import '../../../data/repositories/crypto_repository_impl.dart';

//Res DataSource
final cryptoResDataSource = Provider((ref) {
  return CryptoRestDataSource(
      baseUrl: dotenv.env['BASE_URL'] ?? "",
      apiKey: dotenv.env['API_KEY'] ?? "");
});

//Ws DataSource
final cryptoWsDataSource = Provider((ref) {
  return CryptoWsDataSource(baseSocketUrl: dotenv.env['BASE_SOCKET_URL'] ?? "");
});

//Repository Provider
final cryptoRepositoryProvider = Provider((ref) {
  final res = ref.watch(cryptoResDataSource);
  final ws = ref.watch(cryptoWsDataSource);

  return CryptoRepositoryImpl(restDataSource: res, wsDataSource: ws);
});
