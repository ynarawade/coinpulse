import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MarketCoinTile extends StatelessWidget {
  final String name;
  final String symbol;
  final String imageUrl;
  final String price;
  final String marketCap;
  final double changePercent;
  final int rank;
  final VoidCallback? onTap;

  const MarketCoinTile({
    super.key,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.marketCap,
    required this.changePercent,
    required this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = changePercent >= 0;
    final changeColor = isPositive ? AppColors.positive : AppColors.negative;
    final changeBg = isPositive
        ? AppColors.positiveSurface
        : AppColors.negativeSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // ── Rank ────────────────────────────────────────────────────
            SizedBox(
              width: 28,
              child: Text('$rank', style: theme.textTheme.labelMedium),
            ),

            // ── Coin image ───────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                imageUrl,
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    symbol.substring(0, 1).toUpperCase(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Name + symbol ─────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(symbol.toUpperCase(), style: theme.textTheme.labelSmall),
                ],
              ),
            ),

            // ── Price + change ────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
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
      ),
    );
  }
}
