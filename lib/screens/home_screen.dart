import 'package:coin_pulse/controller/theme_controller.dart';
import 'package:coin_pulse/screens/widgets/gainer/top_gainer_section.dart';
import 'package:coin_pulse/screens/widgets/market/market_section.dart';
import 'package:coin_pulse/screens/widgets/trending/trending_section.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ── Dummy data — replace with your TrendingController later ─────────────
  static const List<Map<String, dynamic>> _dummyTrending = [
    {
      'name': 'Bitcoin',
      'symbol': 'btc',
      'image': 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      'price': r'$67,432.10',
      'change': 2.41,
    },
    {
      'name': 'Ethereum',
      'symbol': 'eth',
      'image':
          'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      'price': r'$3,512.88',
      'change': 1.87,
    },
    {
      'name': 'Solana',
      'symbol': 'sol',
      'image':
          'https://assets.coingecko.com/coins/images/4128/large/solana.png',
      'price': r'$142.55',
      'change': -3.14,
    },
    {
      'name': 'BNB',
      'symbol': 'bnb',
      'image':
          'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png',
      'price': r'$598.20',
      'change': -0.92,
    },
    {
      'name': 'XRP',
      'symbol': 'xrp',
      'image':
          'https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png',
      'price': r'$0.5842',
      'change': 5.23,
    },
  ];

  // dummy data — swap with controller later
  static const List<Map<String, dynamic>> _dummyGainers = [
    {
      'rank': 1,
      'name': 'Pepe',
      'symbol': 'pepe',
      'image':
          'https://assets.coingecko.com/coins/images/29850/large/pepe-token.jpeg',
      'price': r'$0.00001423',
      'change': 38.52,
    },
    {
      'rank': 2,
      'name': 'Render',
      'symbol': 'rndr',
      'image': 'https://assets.coingecko.com/coins/images/11636/large/rndr.png',
      'price': r'$8.21',
      'change': 22.14,
    },
    {
      'rank': 3,
      'name': 'Bonk',
      'symbol': 'bonk',
      'image': 'https://assets.coingecko.com/coins/images/28600/large/bonk.jpg',
      'price': r'$0.00003214',
      'change': 18.73,
    },
    {
      'rank': 4,
      'name': 'Arbitrum',
      'symbol': 'arb',
      'image':
          'https://assets.coingecko.com/coins/images/16547/large/arbitrum.png',
      'price': r'$1.24',
      'change': 15.62,
    },
    {
      'rank': 5,
      'name': 'Optimism',
      'symbol': 'op',
      'image':
          'https://assets.coingecko.com/coins/images/25244/large/Optimism.png',
      'price': r'$3.08',
      'change': 13.47,
    },
  ];

  static const List<Map<String, dynamic>> _dummyMarket = [
    {
      'rank': 1,
      'name': 'Bitcoin',
      'symbol': 'btc',
      'image': 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      'price': r'$67,432.10',
      'marketCap': r'$1.33T',
      'change': 2.41,
      'sparkline': [100, 105, 98, 112, 108, 115, 120, 118, 125],
    },
    {
      'rank': 2,
      'name': 'Ethereum',
      'symbol': 'eth',
      'image':
          'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      'price': r'$3,512.88',
      'marketCap': r'$422.6B',
      'change': -1.12,
      'sparkline': [100, 105, 98, 10, 58, 115, 120, 118, 125],
    },
    // add more...
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeController>();

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
              TrendingSection(trendingList: _dummyTrending),

              TopGainersSection(gainersList: _dummyGainers),
              MarketSection(
                coinsList: _dummyMarket,
                onSeeAll: () {
                  // TODO: navigate to full market screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
