import 'package:coin_pulse/controller/coin_detail_controller.dart';
import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/screens/widgets/coin_details/analysis_tab.dart';
import 'package:coin_pulse/screens/widgets/coin_details/coin_chart.dart';
import 'package:coin_pulse/screens/widgets/coin_details/high_low_item.dart';
import 'package:coin_pulse/screens/widgets/coin_details/summary_tab.dart';
import 'package:coin_pulse/utils/currency_formatter.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class CoinDetailScreen extends StatelessWidget {
  final CoinModel coin;
  const CoinDetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CoinDetailController(coin: coin)..init(),
      child: const _CoinDetailView(),
    );
  }
}

class _CoinDetailView extends StatefulWidget {
  const _CoinDetailView();

  @override
  State<_CoinDetailView> createState() => _CoinDetailViewState();
}

class _CoinDetailViewState extends State<_CoinDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // print("API KEY: ${dotenv.env['coingecko_api_key']}");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ctrl = context.watch<CoinDetailController>();
    final coin = ctrl.coin;
    final isPositive = coin.priceChangePercent24h >= 0;
    final changeColor = isPositive ? AppColors.positive : AppColors.negative;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // ── 1. Header card ─────────────────────────────────────────
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _IconBtn(
                          icon: Iconsax.arrow_left_2,
                          isDark: isDark,
                          onTap: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                coin.imageUrl,
                                width: 22,
                                height: 22,
                                errorBuilder: (_, _, _) =>
                                    const SizedBox(width: 22, height: 22),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${coin.symbol.toUpperCase()} / USDT',
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                        _IconBtn(
                          icon: ctrl.isWatchlisted
                              ? Iconsax.star5
                              : Iconsax.star,
                          isDark: isDark,
                          color: ctrl.isWatchlisted ? AppColors.primary : null,
                          onTap: () => context
                              .read<CoinDetailController>()
                              .toggleWatchlist(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coin.formattedPrice,
                                style: theme.textTheme.displaySmall,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    CurrencyFormatter.formatDelta(
                                      coin.currentPrice *
                                          coin.priceChangePercent24h /
                                          100,
                                    ),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.darkTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    CurrencyFormatter.formatPercent(
                                      coin.priceChangePercent24h,
                                    ),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: changeColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 12,
                          children: [
                            HighLowItem(
                              label: 'HIGH',
                              value: CurrencyFormatter.formatPrice(
                                ctrl.chartHigh,
                              ),
                            ),
                            const SizedBox(height: 8),
                            HighLowItem(
                              label: 'LOW',
                              value: CurrencyFormatter.formatPrice(
                                ctrl.chartLow,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── 2. Chart card ──────────────────────────────────────────
              _Card(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context
                          .read<CoinDetailController>()
                          .toggleChartType(),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: Row(
                          key: ValueKey(ctrl.chartType),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.dividerColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Icon(
                                ctrl.chartType == ChartType.line
                                    ? Iconsax.chart
                                    : Iconsax.candle,
                                size: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              ctrl.chartType == ChartType.line
                                  ? 'Line'
                                  : 'Candle',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(height: 1, color: theme.dividerColor),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: CoinChart(ctrl: ctrl, lineColor: changeColor),
                    ),
                    const SizedBox(height: 16),
                    Divider(height: 1, color: theme.dividerColor),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: CoinDetailController.periodDays.keys
                          .map((p) => _PeriodChip(period: p))
                          .toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── 3. Tabs card ───────────────────────────────────────────
              _Card(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: theme.colorScheme.onSurface,
                      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                      labelStyle: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: theme.textTheme.labelLarge,
                      dividerColor: theme.dividerColor,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Signals'),
                      ],
                    ),
                    SizedBox(
                      height: 480,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          OverviewTab(coin: coin),
                          SignalsTab(coin: coin),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: child,
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final Color? color;
  final VoidCallback onTap;
  const _IconBtn({
    required this.icon,
    required this.isDark,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceVariant
              : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: color ?? theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String period;
  const _PeriodChip({required this.period});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = context.watch<CoinDetailController>();
    final isSelected = ctrl.selectedPeriod == period;

    return GestureDetector(
      onTap: () => context.read<CoinDetailController>().selectPeriod(period),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.surfaceContainerHighest
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          period,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
