import 'dart:convert';
import 'package:crypto_app/utils/app_logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoWsDataSource {
  final String baseSocketUrl;
  WebSocketChannel? _channel;

  CryptoWsDataSource({required this.baseSocketUrl});

  Stream<Map<String, double>> connect(List<String> assets, String apiKey) {
    final symbols = assets.map((e) => e.toLowerCase()).join(',');
    final uri = Uri.parse(
      '$baseSocketUrl/prices?assets=$symbols&apiKey=$apiKey',
    );

    AppLogger.d(">>> CONNECTING to: $uri"); // log request URL

    _channel?.sink.close();
    _channel = WebSocketChannel.connect(uri);

    final broadcast = _channel!.stream.asBroadcastStream();

    // listen to raw messages for debugging
    /*broadcast.listen(
          (event) {
        AppLogger.d("<<< RESPONSE raw: $event");
      },
      onError: (error) {
        AppLogger.e("!!! ERROR: $error");
      },
      onDone: () {
        AppLogger.i("<<< CONNECTION CLOSED");
      },
    );*/

    return broadcast.map((event) {
      final jsonMap = json.decode(event as String) as Map<String, dynamic>;
      final parsed = jsonMap.map(
            (k, v) => MapEntry(k, double.tryParse(v.toString()) ?? 0),
      );
      AppLogger.d("<<< PARSED response: $parsed"); // log parsed response
      return parsed;
    });
  }

  void send(String message) {
    if (_channel != null) {
      AppLogger.d(">>> REQUEST: $message");
      _channel!.sink.add(message);
    } else {
      AppLogger.e("!!! ERROR: WebSocket not connected");
    }
  }

  void dispose() {
    AppLogger.i(">>> DISCONNECTING WebSocket");
    _channel?.sink.close();
    _channel = null;
  }
}
