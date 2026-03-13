import 'package:coin_pulse/controller/market_controller.dart';
import 'package:coin_pulse/controller/theme_controller.dart';
import 'package:coin_pulse/screens/widgets/gainer/top_gainer_section.dart';
import 'package:coin_pulse/screens/widgets/market/market_section.dart';
import 'package:coin_pulse/screens/widgets/trending/trending_section.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // fetch all data when screen mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketController>().init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeController>();
    final market = context.watch<MarketController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Transform.rotate(
                angle: 270,
                child: const Icon(
                  Icons.currency_bitcoin,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text('CoinPulse', style: theme.textTheme.headlineMedium),
          ],
        ),
        actions: [
          IconButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              backgroundColor: WidgetStateColor.resolveWith((_) {
                return themeProvider.isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant;
              }),
            ),
            icon: Icon(themeProvider.isDark ? Iconsax.sun_1 : Iconsax.moon4),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDark);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              TrendingSection(
                trendingList: market.trending,
                isLoading: market.isLoading,
              ),

              TopGainersSection(
                gainersList: market.gainers,
                isLoading: market.isLoading,
              ),
              MarketSection(
                coinsList: market.allCoins,
                isLoading: market.isLoading,
                onSeeAll: () {
                  // TODO: navigate to full market screen
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
