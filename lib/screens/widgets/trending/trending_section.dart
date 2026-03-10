import 'package:coin_pulse/models/trending_coin_model.dart';
import 'package:coin_pulse/screens/widgets/trending/trending_coin_card.dart';
import 'package:flutter/material.dart';

class TrendingSection extends StatelessWidget {
  final List<TrendingCoinModel> trendingList;

  const TrendingSection({super.key, required this.trendingList});

  // Show only first 5 items
  List<TrendingCoinModel> get _items => trendingList.take(5).toList();

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
          // ── Heading row ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trending', style: theme.textTheme.headlineMedium),
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

          // ── Vertical list — divider only, no tile background ──────────
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
              return InkWell(
                onTap: () {
                  // Navigator.push(
                  // context,
                  // MaterialPageRoute<void>(
                  // builder: (context) => const CoinDetails(),
                  // ),
                  // );
                },
                child: TrendingCoinCard(
                  name: coin.name,
                  symbol: coin.symbol,
                  imageUrl: coin.thumbImageUrl,
                  price: coin.formattedPrice,
                  changePercent: coin.priceChangePercent24h,
                ),
              );
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
