/// Usage:
///   CurrencyFormatter.formatPrice(67432.10)   → '$67,432.10'
///   CurrencyFormatter.formatPrice(0.00001423) → '$0.00001423'
///   CurrencyFormatter.formatCompact(1330000000000) → '$1.33T'
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats a USD price with appropriate decimal places.
  ///
  /// >= 1000  → $67,432.10  (2 decimals + comma separators)
  /// >= 1     → $3.51       (2 decimals)
  /// < 1      → $0.00001423 (up to 8 decimals, trailing zeros stripped)
  static String formatPrice(double value) {
    if (value == 0) return '\$0.00';

    if (value >= 1000) {
      return '\$${value.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    }

    if (value >= 1) return '\$${value.toStringAsFixed(2)}';

    // small values — strip trailing zeros e.g. $0.00001423000 → $0.00001423
    return '\$${value.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '')}';
  }

  /// Formats large numbers into compact human-readable form.
  ///
  /// 1_330_000_000_000 → $1.33T
  /// 422_600_000_000   → $422.6B
  /// 38_200_000        → $38.2M
  static String formatCompact(double value) {
    if (value == 0) return '\$0';
    if (value >= 1e12) return '\$${(value / 1e12).toStringAsFixed(2)}T';
    if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(1)}B';
    if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(1)}M';
    return '\$${value.toStringAsFixed(0)}';
  }

  /// Formats a price delta (absolute change) fixed to 2 or 4 decimal places.
  ///
  /// >= 1    → +97.28  (2 decimals)
  /// < 1     → +0.0042 (4 decimals)
  static String formatDelta(double value) {
    final sign = value >= 0 ? '+' : '';
    if (value.abs() >= 1) return '$sign${value.toStringAsFixed(2)}';
    return '$sign${value.toStringAsFixed(4)}';
  }

  /// Formats a percentage change with a + or - sign.
  ///
  /// 2.41  → '+2.41%'
  /// -3.14 → '-3.14%'
  static String formatPercent(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }
}
