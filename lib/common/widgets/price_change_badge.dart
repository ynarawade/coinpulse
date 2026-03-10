import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PriceChangeBadge extends StatelessWidget {
  final double changePercent;

  /// Badge size — affects icon size, font size, and padding
  final PriceChangeBadgeSize size;

  const PriceChangeBadge({
    super.key,
    required this.changePercent,

    this.size = PriceChangeBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = changePercent >= 0;
    final changeColor = isPositive ? AppColors.positive : AppColors.negative;
    final changeBg = isPositive
        ? AppColors.positiveSurface
        : AppColors.negativeSurface;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
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
            size: _iconSize,
          ),
          const SizedBox(width: 3),
          Text(
            '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
            style: _badgeTextStyle(theme)?.copyWith(color: changeColor),
          ),
        ],
      ),
    );
  }

  // ── Size-based values ────────────────────────────────────────────────────

  double get _iconSize => switch (size) {
    PriceChangeBadgeSize.small => 10,
    PriceChangeBadgeSize.medium => 12,
    PriceChangeBadgeSize.large => 14,
  };

  double get _horizontalPadding => switch (size) {
    PriceChangeBadgeSize.small => 5,
    PriceChangeBadgeSize.medium => 7,
    PriceChangeBadgeSize.large => 10,
  };

  double get _verticalPadding => switch (size) {
    PriceChangeBadgeSize.small => 2,
    PriceChangeBadgeSize.medium => 3,
    PriceChangeBadgeSize.large => 5,
  };

  TextStyle? _badgeTextStyle(ThemeData theme) => switch (size) {
    PriceChangeBadgeSize.small => theme.textTheme.labelSmall,
    PriceChangeBadgeSize.medium => theme.textTheme.labelSmall,
    PriceChangeBadgeSize.large => theme.textTheme.labelMedium,
  };
}

enum PriceChangeBadgeSize { small, medium, large }
