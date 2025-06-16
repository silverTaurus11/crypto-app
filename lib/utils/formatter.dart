String formatCurrency(double number) {
  if (number >= 1e12) return '\$${(number / 1e12).toStringAsFixed(2)}T';
  if (number >= 1e9) return '\$${(number / 1e9).toStringAsFixed(2)}B';
  if (number >= 1e6) return '\$${(number / 1e6).toStringAsFixed(2)}M';
  if (number >= 1e3) return '\$${(number / 1e3).toStringAsFixed(2)}K';
  return '\$${number.toStringAsFixed(2)}';
}