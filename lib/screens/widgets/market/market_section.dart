import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/screens/widgets/market/market_coin_tile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ── Filter category model ────────────────────────────────────────────────────

class MarketCategory {
  final String label;

  const MarketCategory({required this.label});
}

// ── Market Section widget ─────────────────────────────────────────────────────

class MarketSection extends StatelessWidget {
  final List<CoinModel> coinsList;
  final VoidCallback? onSeeAll;

  const MarketSection({super.key, required this.coinsList, this.onSeeAll});

  // Show only first 5 items
  List<CoinModel> get _items => coinsList.take(10).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section heading ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Markets', style: theme.textTheme.headlineSmall),
                IconButton(
                  // style: ButtonStyle(
                  //   shape: WidgetStateProperty.all(
                  //     RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //   ),
                  //   backgroundColor: WidgetStateColor.resolveWith((_) {
                  //     return isDark
                  //         ? AppColors.darkSurfaceVariant
                  //         : AppColors.lightSurfaceVariant;
                  //   }),
                  // ),
                  onPressed: () {
                    // TODO: navigate to full trending screen
                  },
                  icon: const Icon(Iconsax.filter_add),
                  color: theme.colorScheme.secondary,
                  iconSize: 20,
                ),
              ],
            ),
          ),

          // ── Column header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                SizedBox(width: 28),
                Text('Coin', style: theme.textTheme.labelSmall),
                const Spacer(),
                Text('Price / 24h', style: theme.textTheme.labelSmall),
              ],
            ),
          ),

          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: theme.dividerColor,
          ),

          // ── Coin list ──────────────────────────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: theme.dividerColor,
            ),
            itemBuilder: (context, index) {
              final coin = _items[index];
              return MarketCoinTile(
                name: coin.name,
                symbol: coin.symbol,
                imageUrl: coin.imageUrl,
                price: coin.formattedPrice,
                changePercent: coin.priceChangePercent24h,
                sparklineData: List<double>.from(
                  (coin.sparkline).map((e) => (e as num).toDouble()),
                ),

                onTap: () {
                  // TODO: navigate to coin detail screen
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
