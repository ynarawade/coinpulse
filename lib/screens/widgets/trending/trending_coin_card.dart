import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TrendingCoinCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String imageUrl;
  final String price;
  final double changePercent;

  const TrendingCoinCard({
    super.key,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.changePercent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = changePercent >= 0;
    final changeColor = isPositive ? AppColors.positive : AppColors.negative;
    final changeBg = isPositive
        ? AppColors.positiveSurface
        : AppColors.negativeSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // ── Coin image ─────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              imageUrl,
              width: 26,
              height: 26,
              errorBuilder: (_, __, ___) => Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  symbol.substring(0, 1).toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ── Name + symbol ──────────────────────────────────────────────
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Price + change badge ───────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 6,
            children: [
              Text(price, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: changeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Iconsax.trend_up : Iconsax.trend_down,
                      color: changeColor,
                      size: 11,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${changePercent.abs().toStringAsFixed(2)}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
