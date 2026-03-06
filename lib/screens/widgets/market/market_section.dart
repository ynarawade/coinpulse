import 'package:coin_pulse/screens/widgets/market/market_coin_tile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ── Filter category model ────────────────────────────────────────────────────

class MarketCategory {
  final String label;

  const MarketCategory({required this.label});
}

// ── All available categories ─────────────────────────────────────────────────

const List<MarketCategory> marketCategories = [
  MarketCategory(label: 'All'),
  MarketCategory(label: 'Crypto'),
  MarketCategory(label: 'NFT'),
  MarketCategory(label: 'DeFi'),
  MarketCategory(label: 'Layer 1'),
  MarketCategory(label: 'Layer 2'),
  MarketCategory(label: 'Meme'),
];

// ── Market Section widget ─────────────────────────────────────────────────────

class MarketSection extends StatefulWidget {
  final List<Map<String, dynamic>> coinsList;
  final VoidCallback? onSeeAll;

  const MarketSection({super.key, required this.coinsList, this.onSeeAll});

  @override
  State<MarketSection> createState() => _MarketSectionState();
}

class _MarketSectionState extends State<MarketSection> {
  int _selectedIndex = 0;

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
                SizedBox(
                  width: 28,
                  child: Text('#', style: theme.textTheme.labelSmall),
                ),
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
            itemCount: widget.coinsList.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: theme.dividerColor,
            ),
            itemBuilder: (context, index) {
              final coin = widget.coinsList[index];
              return MarketCoinTile(
                rank: coin['rank'] as int,
                name: coin['name'] as String,
                symbol: coin['symbol'] as String,
                imageUrl: coin['image'] as String,
                price: coin['price'] as String,
                marketCap: coin['marketCap'] as String,
                changePercent: (coin['change'] as num).toDouble(),
                sparklineData: List<double>.from(
                  (coin['sparkline'] as List).map((e) => (e as num).toDouble()),
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
