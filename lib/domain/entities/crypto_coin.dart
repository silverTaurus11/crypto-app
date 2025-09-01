class CryptoCoin {
  final String id;
  final String rank;
  final String symbol;
  final String name;
  final double priceUsd;
  final double changePercent24Hr;
  final double marketCapUsd;
  final double volumeUsd24Hr;

  CryptoCoin(
      {required this.id,
      required this.rank,
      required this.symbol,
      required this.name,
      required this.priceUsd,
      required this.changePercent24Hr,
      required this.marketCapUsd,
      required this.volumeUsd24Hr});
}
