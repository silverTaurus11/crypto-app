class CryptoPriceTick {
  final String asset;
  final double price;
  final DateTime time;

  const CryptoPriceTick({
    required this.asset,
    required this.price,
    required this.time,
  });
}
