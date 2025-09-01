import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/crypto_coin.dart';
import '../../utils/formatter.dart';
import '../providers/riverpods/crypto_provider.dart';

class CoinDetailPage extends ConsumerWidget {
  final CryptoCoin coin;

  const CoinDetailPage({super.key, required this.coin});

  static const intervalData = {
    '15M': {'label': '15 Minutes', 'value': 'm15'},
    '1H': {'label': '1 Hour', 'value': 'h1'},
    '1D': {'label': '1 Day', 'value': 'd1'},
  };

  Widget _buildIntervalTabs(BuildContext context, WidgetRef ref) {
    final selectedInterval = ref.watch(selectedIntervalProvider);

    return Row(
      children: intervalData.entries.map((entry) {
        final label = entry.value['label'] as String;
        final value = entry.value['value'] as String;

        final isSelected = value == selectedInterval;
        final width = (MediaQuery.of(context).size.width / 4 - 16);
        const space = 6.0;
        return Row(
          children: [
            SizedBox(
              width: width,
              child: ChoiceChip(
                label: Center(child: Text(label)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(selectedIntervalProvider.notifier).state = value;
                  }
                },
              ),
            ),
            const SizedBox(width: space), // Jarak antar chip
          ],
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Symbol: ${coin.symbol}', style: const TextStyle(fontSize: 16)),
        Text('Rank: ${coin.rank}', style: const TextStyle(fontSize: 16)),
        Text('Market Cap: ${formatCurrency(coin.marketCapUsd)}',
            style: const TextStyle(fontSize: 16)),
        Text('Volume (24Hr): ${formatCurrency(coin.volumeUsd24Hr)}',
            style: const TextStyle(fontSize: 16)),
        Text('Change (24Hr): ${coin.changePercent24Hr.toStringAsFixed(2)}%',
            style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInterval = ref.watch(selectedIntervalProvider);
    final historyAsync = ref.watch(coinDetailProvider((coin.id, selectedInterval)));

    return Scaffold(
      appBar: AppBar(title: Text(coin.name)),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (history) {
          final priceSpots = history['spots'] as List<FlSpot>;
          final timeLabels = history['labels'] as List<String>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Price: ${formatCurrency(coin.priceUsd)}'),
                const SizedBox(height: 16),
                _buildIntervalTabs(context, ref),
                const SizedBox(height: 16),
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
                        bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                const SizedBox(height: 16),
                _buildInfoCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}
