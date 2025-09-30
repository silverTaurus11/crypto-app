import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/crypto_coin.dart';
import '../models/crypto_coin_model.dart';

class CryptoRestDataSource {
  final String apiKey;
  final http.Client client;

  CryptoRestDataSource({required this.apiKey, http.Client? client})
      : client = client ?? http.Client();

  Future<List<CryptoCoin>> fetchCoins({int limit = 100}) async {
    final url = Uri.https(
      'rest.coincap.io',
      '/v3/assets',
      {'limit': '$limit', 'apiKey': apiKey},
    );

    final response = await client.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load coins');
    }

    final data = json.decode(response.body);
    final List coins = data['data'];
    return coins.map((json) => CryptoCoinModel.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> fetchHistoricalDataWithTimestamps(
      String coinId, String interval) async {
    final url = Uri.https(
      'rest.coincap.io',
      '/v3/assets/$coinId/history',
      {'apiKey': apiKey, 'interval': interval},
    );

    final response = await client.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load historical data');
    }

    final List data = jsonDecode(response.body)['data'];
    List<FlSpot> spots = [];
    List<String> labels = [];

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      double price = double.tryParse(item['priceUsd']) ?? 0;
      int timeMs = int.tryParse(item['time'].toString()) ?? 0;
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timeMs);

      String label;
      if (interval == 'd1') {
        label = DateFormat.Hm().format(date); // 14:30
      } else {
        label = DateFormat.Md().format(date); // 6/15
      }

      spots.add(FlSpot(i.toDouble(), price));
      labels.add(label);
    }

    return {
      'spots': spots,
      'labels': labels,
    };
  }
}