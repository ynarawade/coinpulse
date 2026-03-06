import 'package:coin_pulse/utils/currency_formatter.dart';

class TrendingCoinModel {
  final String id;
  final String symbol;
  final String name;
  final String thumbImageUrl;
  final int marketCapRank;
  final double priceUsd;
  final double priceChangePercent24h;

  const TrendingCoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.thumbImageUrl,
    required this.marketCapRank,
    required this.priceUsd,
    required this.priceChangePercent24h,
  });

  factory TrendingCoinModel.fromJson(Map<String, dynamic> json) {
    final item = json['item'] as Map<String, dynamic>? ?? json;

    // data.price is USD price string e.g. "$0.00001423"
    // we strip the $ and parse it as double
    final dataMap = item['data'] as Map<String, dynamic>?;
    final rawPrice = dataMap?['price']?.toString() ?? '0';
    final cleanPrice = rawPrice.replaceAll(r'$', '').replaceAll(',', '');
    final usdPrice = double.tryParse(cleanPrice) ?? 0.0;

    // 24h change is nested inside data.price_change_percentage_24h.usd
    final priceChangeData =
        dataMap?['price_change_percentage_24h'] as Map<String, dynamic>?;
    final change = (priceChangeData?['usd'] as num?)?.toDouble() ?? 0.0;

    return TrendingCoinModel(
      id: item['id'] as String? ?? '',
      symbol: item['symbol'] as String? ?? '',
      name: item['name'] as String? ?? '',
      thumbImageUrl: item['large'] as String? ?? item['thumb'] as String? ?? '',
      marketCapRank: (item['market_cap_rank'] as num?)?.toInt() ?? 0,
      priceUsd: usdPrice,
      priceChangePercent24h: change,
    );
  }

  String get formattedPrice => CurrencyFormatter.formatPrice(priceUsd);
}
