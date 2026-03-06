import 'package:coin_pulse/utils/currency_formatter.dart';

class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double marketCap;
  final double totalVolume;
  final double priceChangePercent24h;
  final int marketCapRank;
  final List<double> sparkline; // 7-day price points

  const CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    required this.marketCap,
    required this.totalVolume,
    required this.priceChangePercent24h,
    required this.marketCapRank,
    required this.sparkline,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    // sparkline_in_7d.price is a List of doubles from the API
    final rawSparkline =
        json['sparkline_in_7d']?['price'] as List<dynamic>? ?? [];

    return CoinModel(
      id: json['id'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      totalVolume: (json['total_volume'] as num?)?.toDouble() ?? 0.0,
      priceChangePercent24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      sparkline: rawSparkline.map((e) => (e as num).toDouble()).toList(),
    );
  }

  // ── Formatted getters ──────────────────────────────────────────────────────

  String get formattedPrice => CurrencyFormatter.formatPrice(currentPrice);
  String get formattedMarketCap => CurrencyFormatter.formatCompact(marketCap);
  String get formattedVolume => CurrencyFormatter.formatCompact(totalVolume);
}
