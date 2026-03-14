import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/utils/currency_formatter.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OverviewTab extends StatelessWidget {
  final CoinModel coin;
  const OverviewTab({required this.coin, super.key});

  String _volatility() {
    final c = coin.priceChangePercent24h.abs();
    if (c > 8) return 'High';
    if (c > 3) return 'Medium';
    return 'Low';
  }

  Color _volatilityColor() {
    final c = coin.priceChangePercent24h.abs();
    if (c > 8) return AppColors.negative;
    if (c > 3) return const Color(0xFFF59E0B);
    return AppColors.positive;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = coin.priceChangePercent24h >= 0;
    final changeColor = isPositive ? AppColors.positive : AppColors.negative;
    final volColor = _volatilityColor();

    // Estimate 24h low/high from currentPrice + changePercent
    final changeAmt = coin.currentPrice * coin.priceChangePercent24h / 100;
    final h24Low = (coin.currentPrice - changeAmt.abs())
        .clamp(0, double.infinity)
        .toDouble();
    final h24High = coin.currentPrice + changeAmt.abs();
    final range = h24High - h24Low;
    final position = range > 0
        ? ((coin.currentPrice - h24Low) / range).clamp(0.0, 1.0)
        : 0.5;
    final positionPct = (position * 100).toStringAsFixed(0);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Market Overview Card ──────────────────────────────────────
          _SectionLabel(label: 'Market Overview'),
          const SizedBox(height: 10),
          _OutlineCard(
            child: Column(
              children: [
                _MetricRow(
                  icon: Iconsax.chart_21,
                  label: 'Market Cap',
                  value: coin.formattedMarketCap,
                ),
                _Hairline(),
                _MetricRow(
                  icon: Iconsax.activity,
                  label: '24h Volume',
                  value: coin.formattedVolume,
                ),
                _Hairline(),
                _MetricRow(
                  icon: Iconsax.medal_star,
                  label: 'Rank',
                  value: '#${coin.marketCapRank}',
                ),
                _Hairline(),
                _MetricRow(
                  icon: Iconsax.flash_1,
                  label: 'Volatility',
                  value: _volatility(),
                  valueColor: volColor,
                  valueSuffix: Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: volColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── 24h Price Range ───────────────────────────────────────────
          _SectionLabel(label: '24h Price Range'),
          const SizedBox(height: 12),
          _OutlineCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Marker label
                LayoutBuilder(
                  builder: (context, constraints) {
                    final markerLeft = (position * (constraints.maxWidth - 12))
                        .clamp(0.0, constraints.maxWidth - 12);
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Ghost track
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.dividerColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Filled track
                        FractionallySizedBox(
                          widthFactor: position,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.negative, changeColor],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Marker dot
                        Positioned(
                          left: markerLeft,
                          top: -5,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: changeColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.surface,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: changeColor.withOpacity(0.4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RangeLabel(
                      label: '24h Low',
                      value: CurrencyFormatter.formatPrice(h24Low),
                      color: AppColors.negative,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: changeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Position: $positionPct% of range',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: changeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _RangeLabel(
                      label: '24h High',
                      value: CurrencyFormatter.formatPrice(h24High),
                      color: AppColors.positive,
                      alignRight: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared ────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _OutlineCard extends StatelessWidget {
  final Widget child;
  const _OutlineCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: child,
    );
  }
}

class _Hairline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Theme.of(context).dividerColor);
  }
}

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Widget? valueSuffix;

  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueSuffix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 15, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Text(label, style: theme.textTheme.bodySmall),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (valueSuffix != null) valueSuffix!,
        ],
      ),
    );
  }
}

class _RangeLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool alignRight;

  const _RangeLabel({
    required this.label,
    required this.value,
    required this.color,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
