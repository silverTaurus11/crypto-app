import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/crypto_coin.dart';
import '../services/crypto_service.dart';
import '../utils/formatter.dart';

class CoinDetailPage extends StatefulWidget {
  final CryptoCoin coin;

  const CoinDetailPage({required this.coin});

  @override
  _CoinDetailPageState createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  List<FlSpot> priceSpots = [];
  List<String> timeLabels = [];
  bool isLoading = true;
  String selectedInterval = 'm15';

  final Map<String, Map<String, dynamic>> intervalData = {
    '15M': {'label': '15 Minutes', 'value': 'm15'},
    '1H': {'label': '1 Hour', 'value': 'h1'},
    '1D': {'label': '1 Day', 'value': 'd1'},
  };

  @override
  void initState() {
    super.initState();
    fetchHistoricalPrices();
  }

  Future<void> fetchHistoricalPrices() async {
    setState(() {
      isLoading = true;
    });
    final history = await CryptoService()
        .fetchHistoricalDataWithTimestamps(widget.coin.id, selectedInterval);
    setState(() {
      priceSpots = history['spots'];
      timeLabels = history['labels'];
      isLoading = false;
    });
  }

  Widget _buildIntervalTabs() {
    return Row(
      children: intervalData.entries.map((entry) {
        final label = entry.value['label'] as String;
        final value = entry.value['value'] as String;

        final isSelected = value == selectedInterval;
        final width = (MediaQuery.of(context).size.width / 4 - 16);
        final space = 6.0;
        return Row(
          children: [
            SizedBox(
              width: width,
              child: ChoiceChip(
                label: Center(child: Text(label)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      selectedInterval = value;
                      fetchHistoricalPrices();
                    });
                  }
                },
              ),
            ),
            SizedBox(width: space), // Jarak antar chip
          ],
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Symbol: ${widget.coin.symbol}', style: TextStyle(fontSize: 16)),
        Text('Rank: ${widget.coin.rank}', style: TextStyle(fontSize: 16)),
        Text('Market Cap: ${formatCurrency(widget.coin.marketCapUsd)}',
            style: TextStyle(fontSize: 16)),
        Text('Volume (24Hr): ${formatCurrency(widget.coin.volumeUsd24Hr)}',
            style: TextStyle(fontSize: 16)),
        Text(
            'Change (24Hr): ${widget.coin.changePercent24Hr.toStringAsFixed(2)}%',
            style: TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.coin.name)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Current Price: ${formatCurrency(widget.coin.priceUsd)}'),
                  SizedBox(height: 16),
                  _buildIntervalTabs(),
                  SizedBox(height: 16),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: priceSpots,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 2,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                        borderData: FlBorderData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: true),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.black,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  formatCurrency(spot.y),
                                  const TextStyle(color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildInfoCard()
                ],
              ),
            ),
    );
  }
}
