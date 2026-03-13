import 'package:coin_pulse/common/widgets/shimmer.dart';
import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/screens/coin_details.dart';
import 'package:coin_pulse/screens/widgets/market/market_coin_tile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MarketSection extends StatelessWidget {
  final List<CoinModel> coinsList;
  final bool isLoading;
  final VoidCallback? onSeeAll;

  const MarketSection({
    super.key,
    required this.coinsList,
    this.isLoading = false,
    this.onSeeAll,
  });

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
          // ── Heading ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Markets', style: theme.textTheme.headlineSmall),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Iconsax.filter_add),
                  color: theme.colorScheme.secondary,
                  iconSize: 20,
                ),
              ],
            ),
          ),

          // ── Column header ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Row(
              children: [
                const SizedBox(width: 28),
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

          // ── List ──────────────────────────────────────────────────────
          isLoading
              ? _MarketSkeleton()
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
                    return MarketCoinTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => CoinDetailScreen(coin: coin),
                        ),
                      ),
                      name: coin.name,
                      symbol: coin.symbol,
                      imageUrl: coin.imageUrl,
                      price: coin.formattedPrice,
                      changePercent: coin.priceChangePercent24h,
                      sparklineData: List<double>.from(
                        coin.sparkline.map((e) => (e as num).toDouble()),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

// ── Skeleton — 10 placeholder rows ───────────────────────────────────────────

class _MarketSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShimmer(
      child: Column(
        children: List.generate(10, (index) {
          final isLast = index == 9;
          return Column(
            children: [
              _SkeletonTile(),
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

class _SkeletonTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // coin image
          const ShimmerCircle(size: 30),
          const SizedBox(width: 12),

          // name + symbol
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 70, height: 13, radius: 6),
              const SizedBox(height: 5),
              ShimmerBox(width: 36, height: 10, radius: 4),
            ],
          ),

          const SizedBox(width: 20),

          // sparkline placeholder
          Expanded(child: ShimmerBox.wide(height: 30, radius: 6)),

          const SizedBox(width: 40),

          // price + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerBox(width: 72, height: 13, radius: 6),
              const SizedBox(height: 5),
              ShimmerBox(width: 52, height: 20, radius: 6),
            ],
          ),
        ],
      ),
    );
  }
}
