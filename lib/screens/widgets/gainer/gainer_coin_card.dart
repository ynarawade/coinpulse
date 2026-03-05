import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GainerCoinCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String imageUrl;
  final String price;
  final double changePercent;
  final int rank;

  const GainerCoinCard({
    super.key,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.changePercent,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 12),
          _buildNameSection(theme),
          const SizedBox(height: 10),
          _buildPrice(theme),
          const SizedBox(height: 6),
          _buildChangeBadge(theme),
        ],
      ),
    );
  }

  /// ───────────────── Header (Rank + Coin Image) ─────────────────
  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildRankBadge(theme), _buildCoinImage(theme)],
    );
  }

  Widget _buildRankBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '#$rank',
        style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildCoinImage(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        imageUrl,
        width: 34,
        height: 34,
        errorBuilder: (_, __, ___) => _buildImageFallback(theme),
      ),
    );
  }

  Widget _buildImageFallback(ThemeData theme) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        symbol.substring(0, 1).toUpperCase(),
        style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary),
      ),
    );
  }

  /// ───────────────── Name + Symbol ─────────────────
  Widget _buildNameSection(ThemeData theme) {
    return Text(
      name,
      style: theme.textTheme.titleSmall,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// ───────────────── Price ─────────────────
  Widget _buildPrice(ThemeData theme) {
    return Text(
      price,
      style: theme.textTheme.titleMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// ───────────────── Change Badge ─────────────────
  Widget _buildChangeBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.positiveSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.trend_up, color: AppColors.positive, size: 12),
          const SizedBox(width: 3),
          Text(
            '+${changePercent.toStringAsFixed(2)}%',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.positive,
            ),
          ),
        ],
      ),
    );
  }
}
