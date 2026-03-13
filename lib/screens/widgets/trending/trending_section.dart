import 'package:coin_pulse/common/widgets/shimmer.dart';
import 'package:coin_pulse/models/trending_coin_model.dart';
import 'package:coin_pulse/screens/widgets/trending/trending_coin_card.dart';
import 'package:flutter/material.dart';

class TrendingSection extends StatelessWidget {
  final List<TrendingCoinModel> trendingList;
  final bool isLoading;

  const TrendingSection({
    super.key,
    required this.trendingList,
    this.isLoading = false,
  });

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
          // ── Heading row ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
            child: Text('Trending', style: theme.textTheme.headlineMedium),
          ),

          // ── List ─────────────────────────────────────────────────────
          isLoading
              ? _TrendingSkeleton()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: theme.dividerColor,
                  ),
                  itemBuilder: (context, index) {
                    final coin = _items[index];
                    return InkWell(
                      onTap: () {},
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

// ── Skeleton — 5 placeholder rows wrapped in one AppShimmer ──────────────

class _TrendingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShimmer(
      child: Column(
        children: List.generate(5, (index) {
          final isLast = index == 4;
          return Column(
            children: [
              _SkeletonRow(),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: theme.dividerColor,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // coin image
          const ShimmerCircle(size: 26),
          const SizedBox(width: 12),
          // name
          const Expanded(child: ShimmerBox(width: 100, height: 14)),
          const SizedBox(width: 12),
          // price
          const ShimmerBox(width: 64, height: 14),
          const SizedBox(width: 6),
          // badge
          ShimmerBox(width: 52, height: 22, radius: 6),
        ],
      ),
    );
  }
}
