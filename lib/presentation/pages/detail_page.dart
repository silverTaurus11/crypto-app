import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/crypto_coin.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/formatter.dart';
import '../providers/riverpods/coin_use_case_provider.dart';

class CoinDetailPage extends ConsumerWidget {
  final CryptoCoin coin;

  const CoinDetailPage({super.key, required this.coin});

  static Map<String, String> intervalKeys = {
    '15M': 'minutes15',
    '1H': 'hour1',
    '1D': 'day1',
  };

  Widget _buildIntervalTabs(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final selectedInterval = ref.watch(selectedIntervalProvider);

    return Row(
      children: intervalKeys.entries.map((entry) {
        final label = _getLabel(loc, entry.value);
        final value = entry.key.toLowerCase();

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
            const SizedBox(width: space),
          ],
        );
      }).toList(),
    );
  }

  String _getLabel(AppLocalizations loc, String key) {
    switch (key) {
      case 'minutes15':
        return loc.minutes15;
      case 'hour1':
        return loc.hour1;
      case 'day1':
        return loc.day1;
      default:
        return key;
    }
  }

  Widget _buildInfoCard(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${loc.symbol}: ${coin.symbol}', style: const TextStyle(fontSize: 16)),
        Text('${loc.rank}: ${coin.rank}', style: const TextStyle(fontSize: 16)),
        Text('${loc.marketCap}: ${formatCurrency(coin.marketCapUsd)}',
            style: const TextStyle(fontSize: 16)),
        Text('${loc.volume24h}: ${formatCurrency(coin.volumeUsd24Hr)}',
            style: const TextStyle(fontSize: 16)),
        Text('${loc.change24h}: ${coin.changePercent24Hr.toStringAsFixed(2)}%',
            style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
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
                Text('${loc.currentPrice}: ${formatCurrency(coin.priceUsd)}'),
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
                _buildInfoCard(context),
              ],
            ),
          );
        },
      ),
    );
  }
}
