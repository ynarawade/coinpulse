import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AnalysisTab extends StatelessWidget {
  final CoinModel coin;
  const AnalysisTab({super.key, required this.coin});

  String get _signal {
    final c = coin.priceChangePercent24h;
    if (c > 5) return 'Strong Buy';
    if (c > 1) return 'Buy';
    if (c > -1) return 'Neutral';
    if (c > -5) return 'Sell';
    return 'Strong Sell';
  }

  Color _signalColor() {
    final c = coin.priceChangePercent24h;
    if (c > 1) return AppColors.positive;
    if (c > -1) return AppColors.darkTextSecondary;
    return AppColors.negative;
  }

  String get _trendSummary {
    final c = coin.priceChangePercent24h;
    final name = coin.name;
    if (c > 5) {
      return '$name is showing strong bullish momentum with a ${c.toStringAsFixed(2)}% gain in the last 24 hours. Volume is supporting the move.';
    }
    if (c > 1) {
      return '$name is trending upward with a modest gain of ${c.toStringAsFixed(2)}% over the past 24 hours. Market sentiment appears cautiously optimistic.';
    }
    if (c > -1) {
      return '$name is consolidating with minimal price movement in the last 24 hours. The market is in a wait-and-see mode.';
    }
    if (c > -5) {
      return '$name is experiencing a slight pullback of ${c.abs().toStringAsFixed(2)}% over the past 24 hours. This could be a healthy correction within a larger trend.';
    }
    return '$name is under significant selling pressure with a ${c.abs().toStringAsFixed(2)}% decline in the last 24 hours. Caution is advised.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signalColor = _signalColor();
    final isPositive = coin.priceChangePercent24h >= 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Signal badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: signalColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: signalColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Iconsax.trend_up : Iconsax.trend_down,
                  color: signalColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  _signal,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: signalColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Sentiment Indicators', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          _SentimentRow(
            label: 'Momentum',
            value: (coin.priceChangePercent24h.clamp(-100, 100) / 100).abs(),
          ),
          const SizedBox(height: 10),
          _SentimentRow(
            label: 'Volume Trend',
            value: (coin.totalVolume / (coin.marketCap + 1)).clamp(0, 1),
          ),
          const SizedBox(height: 10),
          _SentimentRow(
            label: 'Market Strength',
            value: (1 / (coin.marketCapRank + 1) * 100).clamp(0, 1),
          ),
          const SizedBox(height: 16),
          Text('Trend Summary', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(
            _trendSummary,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _SentimentRow extends StatelessWidget {
  final String label;
  final double value;
  const _SentimentRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = value >= 0.5 ? AppColors.positive : AppColors.negative;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              backgroundColor: theme.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(value * 100).toStringAsFixed(0)}%',
          style: theme.textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
