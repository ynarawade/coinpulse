import 'package:coin_pulse/common/widgets/price_change_badge.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MarketCoinTile extends StatelessWidget {
  final String name;
  final String symbol;
  final String imageUrl;
  final String price;
  final String marketCap;
  final double changePercent;
  final int rank;
  final List<double> sparklineData; // 7-day price points
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
    required this.sparklineData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = changePercent >= 0;
    final changeColor = isPositive ? AppColors.positive : AppColors.negative;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ── Coin image ───────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                imageUrl,
                width: 38,
                height: 38,
                errorBuilder: (_, __, ___) => Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    symbol.substring(0, 1).toUpperCase(),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Name + symbol ─────────────────────────────────────────────
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(symbol.toUpperCase(), style: theme.textTheme.labelSmall),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // ── Sparkline chart ───────────────────────────────────────────
            Expanded(
              child: sparklineData.length >= 2
                  ? SizedBox(
                      height: 40,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: const LineTouchData(enabled: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: sparklineData
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                                  .toList(),
                              isCurved: true,
                              curveSmoothness: 0.3,
                              color: changeColor,
                              barWidth: 1.5,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),

            const SizedBox(width: 40),

            // ── Price + change ────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),

                PriceChangeBadge(changePercent: changePercent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
