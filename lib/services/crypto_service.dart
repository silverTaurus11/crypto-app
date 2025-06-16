import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_coin.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CryptoService {
  final String _apiKey = '60df39130fe319f7b1012cebc0668fb6064293ee459fa24da8612cdad25a29f5';
  //'7a17994206166fc27849a4800875fb9645031ac36b6d8ff53f901f336c30774d';

  Future<List<CryptoCoin>> fetchCoins() async {
    final url = Uri.https(
      'rest.coincap.io',
      '/v3/assets',
      {'limit': '100', 'apiKey': _apiKey},
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List coins = data['data'];
      return coins.map((json) => CryptoCoin.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data CoinCap (v3)');
    }
  }

  Future<Map<String, dynamic>> fetchHistoricalDataWithTimestamps(String coinId, String interval) async {
    final url = Uri.https(
      'rest.coincap.io',
      '/v3/assets/$coinId/history',
      {'apiKey': _apiKey, 'interval': interval},
    );

    final response = await http.get(url);

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

      // Format waktu tergantung interval
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
