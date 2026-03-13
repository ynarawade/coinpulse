import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignalsTab extends StatelessWidget {
  final CoinModel coin;
  const SignalsTab({super.key, required this.coin});

  // ── Derived signal values ──────────────────────────────────────────────────

  double get _momentum =>
      (coin.priceChangePercent24h.clamp(-100, 100) / 100).abs();

  double get _volumeTrend =>
      (coin.totalVolume / (coin.marketCap + 1)).clamp(0.0, 1.0);

  double get _marketStrength =>
      (1 / (coin.marketCapRank + 1) * 100).clamp(0.0, 1.0);

  double get _sentimentScore =>
      ((_momentum + _volumeTrend + _marketStrength) / 3 * 100).clamp(0, 100);

  String get _signalLabel {
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

  String _momentumLabel() {
    final m = _momentum;
    if (m > 0.7) return 'Strong';
    if (m > 0.4) return 'Moderate';
    return 'Weak';
  }

  String _volumeLabel() {
    final v = _volumeTrend;
    if (v > 0.6) return 'Increasing';
    if (v > 0.3) return 'Stable';
    return 'Decreasing';
  }

  List<String> get _bulletPoints {
    final c = coin.priceChangePercent24h;
    return [
      c >= 0 ? 'Price trending upward' : 'Price trending downward',
      _volumeTrend > 0.4 ? 'Volume increasing' : 'Volume declining',
      _momentum > 0.5 ? 'Momentum building' : 'Momentum fading',
      _marketStrength > 0.5
          ? 'Strong market position'
          : 'Moderate market position',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signalColor = _signalColor();
    final isPositive = coin.priceChangePercent24h >= 0;
    final score = _sentimentScore;
    final scoreColor = score > 60
        ? AppColors.positive
        : score > 40
        ? const Color(0xFFF59E0B)
        : AppColors.negative;
    final sentimentLabel = score > 60
        ? 'Bullish'
        : score > 40
        ? 'Neutral'
        : 'Bearish';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Signal badge + indicators row ─────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Signal badge
              Expanded(
                child: _OutlineCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Signal',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: signalColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: signalColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive
                                  ? Iconsax.trend_up
                                  : Iconsax.trend_down,
                              color: signalColor,
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _signalLabel,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: signalColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Sentiment score
              Expanded(
                child: _OutlineCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sentiment Score',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            score.toStringAsFixed(0),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: scoreColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '/100',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Score bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: score / 100,
                          backgroundColor: theme.dividerColor,
                          valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sentimentLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Indicators ────────────────────────────────────────────────
          Text(
            'Indicators',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          _OutlineCard(
            child: Column(
              children: [
                _IndicatorRow(
                  icon: Iconsax.flash_1,
                  label: 'Momentum',
                  badge: _momentumLabel(),
                  value: _momentum,
                  isUp: _momentum > 0.5,
                ),
                Divider(height: 1, color: theme.dividerColor),
                _IndicatorRow(
                  icon: Iconsax.activity,
                  label: 'Volume Trend',
                  badge: _volumeLabel(),
                  value: _volumeTrend,
                  isUp: _volumeTrend > 0.4,
                ),
                Divider(height: 1, color: theme.dividerColor),
                _IndicatorRow(
                  icon: Iconsax.strongbox,
                  label: 'Market Strength',
                  badge: '${(_marketStrength * 100).toStringAsFixed(0)}%',
                  value: _marketStrength,
                  isUp: _marketStrength > 0.5,
                  showBar: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Trend Summary bullets ─────────────────────────────────────
          Text(
            'Trend Summary',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          _OutlineCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._bulletPoints.map(
                  (point) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: signalColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(point, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Market sentiment appears ${sentimentLabel.toLowerCase()}.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Recommendation ────────────────────────────────────────────
          Text(
            'Recommendation',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'BUY',
                  icon: Iconsax.trend_up,
                  color: AppColors.positive,
                  filled: isPositive,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: 'WAIT',
                  icon: Iconsax.timer_1,
                  color: theme.colorScheme.onSurfaceVariant,
                  filled: !isPositive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _OutlineCard extends StatelessWidget {
  final Widget child;
  const _OutlineCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: child,
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String badge;
  final double value;
  final bool isUp;
  final bool showBar;

  const _IndicatorRow({
    required this.icon,
    required this.label,
    required this.badge,
    required this.value,
    required this.isUp,
    this.showBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isUp ? AppColors.positive : AppColors.negative;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(label, style: theme.textTheme.bodySmall),
              const Spacer(),
              Icon(
                isUp ? Iconsax.arrow_up_3 : Iconsax.arrow_down_2,
                size: 12,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                badge,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (showBar) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                backgroundColor: theme.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: filled ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: filled
              ? color.withOpacity(0.5)
              : Theme.of(context).dividerColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
