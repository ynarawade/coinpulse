import 'package:coin_pulse/controller/coin_detail_controller.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class InfoTab extends StatelessWidget {
  final CoinDetailController ctrl;
  const InfoTab({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coin = ctrl.coin;

    if (ctrl.isLoadingDetail) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      );
    }

    final description =
        (ctrl.coinDetail?['description']?['en'] as String? ?? '')
            .replaceAll(RegExp(r'<[^>]*>'), '')
            .trim();

    final homepage =
        ctrl.coinDetail?['links']?['homepage']?[0] as String? ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description.isNotEmpty) ...[
            Text('About ${coin.name}', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              description.length > 400
                  ? '${description.substring(0, 400)}...'
                  : description,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 16),
          ],
          if (homepage.isNotEmpty) ...[
            Text('Links', style: theme.textTheme.titleSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Iconsax.global, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Official Website', style: theme.textTheme.bodySmall),
                const Spacer(),
                Flexible(
                  child: Text(
                    homepage,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Text('Token Details', style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          _InfoRow(label: 'Symbol', value: coin.symbol.toUpperCase()),
          _InfoRow(label: 'Market Cap Rank', value: '#${coin.marketCapRank}'),
          _InfoRow(label: 'Market Cap', value: coin.formattedMarketCap),
          _InfoRow(label: '24h Volume', value: coin.formattedVolume),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(value, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}
