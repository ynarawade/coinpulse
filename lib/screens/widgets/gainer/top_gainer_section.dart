import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/screens/coin_details.dart';
import 'package:coin_pulse/screens/widgets/gainer/gainer_coin_card.dart';
import 'package:flutter/material.dart';

class TopGainersSection extends StatelessWidget {
  final List<CoinModel> gainersList;

  const TopGainersSection({super.key, required this.gainersList});

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
          // ── Heading row ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Top Gainers', style: theme.textTheme.headlineSmall),
                // IconButton(
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
                //   onPressed: () {
                //     // TODO: navigate to full trending screen
                //   },
                //   icon: const Icon(Iconsax.arrow_right_3),
                //   color: theme.colorScheme.secondary,
                //   iconSize: 20,
                // ),
              ],
            ),
          ),

          // ── Horizontal scrollable list ──────────────────────────────────
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: gainersList.length,
              separatorBuilder: (_, _) => VerticalDivider(
                width: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
                color: theme.dividerColor,
              ),
              itemBuilder: (context, index) {
                final coin = gainersList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => CoinDetailScreen(coin: coin),
                      ),
                    );
                  },
                  child: GainerCoinCard(
                    name: coin.name,
                    symbol: coin.symbol,
                    imageUrl: coin.imageUrl,
                    price: coin.formattedPrice,
                    changePercent: coin.priceChangePercent24h,
                    rank: index + 1,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
