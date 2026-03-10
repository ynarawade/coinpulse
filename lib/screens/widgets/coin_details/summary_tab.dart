import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/utils/currency_formatter.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class SummaryTab extends StatelessWidget {
  final CoinModel coin;
  const SummaryTab({required this.coin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = coin.priceChangePercent24h >= 0;
    final changeColor = isPositive ? AppColors.positive : AppColors.negative;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Market Cap',
                  value: coin.formattedMarketCap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatItem(
                  label: '24h Volume',
                  value: coin.formattedVolume,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Rank',
                  value: '#${coin.marketCapRank}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatItem(
                  label: '24h Change',
                  value: CurrencyFormatter.formatPercent(
                    coin.priceChangePercent24h,
                  ),
                  valueColor: changeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Price Performance', style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          _PricePerformanceBar(changePercent: coin.priceChangePercent24h),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('24h Low', style: theme.textTheme.labelSmall),
              Text('24h High', style: theme.textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _PricePerformanceBar extends StatelessWidget {
  final double changePercent;
  const _PricePerformanceBar({required this.changePercent});

  @override
  Widget build(BuildContext context) {
    final position = ((changePercent + 10) / 20).clamp(0.0, 1.0);
    final color = changePercent >= 0 ? AppColors.positive : AppColors.negative;

    return Stack(
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        FractionallySizedBox(
          widthFactor: position,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _StatItem({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
