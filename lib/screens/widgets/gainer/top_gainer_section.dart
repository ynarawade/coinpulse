import 'package:coin_pulse/common/widgets/shimmer.dart';
import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/screens/coin_details.dart';
import 'package:coin_pulse/screens/widgets/gainer/gainer_coin_card.dart';
import 'package:flutter/material.dart';

class TopGainersSection extends StatelessWidget {
  final List<CoinModel> gainersList;
  final bool isLoading;

  const TopGainersSection({
    super.key,
    required this.gainersList,
    this.isLoading = false,
  });

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
          // ── Heading ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
            child: Text('Top Gainers', style: theme.textTheme.headlineSmall),
          ),

          // ── List ──────────────────────────────────────────────────────
          SizedBox(
            height: 190,
            child: isLoading
                ? _GainerSkeleton()
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: gainersList.length,
                    separatorBuilder: (_, __) => VerticalDivider(
                      width: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: theme.dividerColor,
                    ),
                    itemBuilder: (context, index) {
                      final coin = gainersList[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => CoinDetailScreen(coin: coin),
                          ),
                        ),
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

// ── Skeleton — 4 placeholder cards in a horizontal row ───────────────────

class _GainerSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShimmer(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (_, __) => VerticalDivider(
          width: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: theme.dividerColor,
        ),
        itemBuilder: (_, __) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // rank badge + coin image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 30, height: 20, radius: 6),
                const ShimmerCircle(size: 30),
              ],
            ),
            const SizedBox(height: 12),
            // name
            ShimmerBox(width: 90, height: 13, radius: 6),
            const SizedBox(height: 10),
            // price
            ShimmerBox(width: 70, height: 15, radius: 6),
            const SizedBox(height: 6),
            // badge
            ShimmerBox(width: 80, height: 26, radius: 8),
          ],
        ),
      ),
    );
  }
}
