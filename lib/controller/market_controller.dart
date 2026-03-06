import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/models/trending_coin_model.dart';
import 'package:coin_pulse/services/api_service.dart';
import 'package:flutter/material.dart';

class MarketController extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────

  List<CoinModel> _allCoins = [];
  List<CoinModel> _gainers = [];
  List<TrendingCoinModel> _trending = [];

  bool _isLoadingMarkets = false;
  bool _isLoadingTrending = false;

  String? _marketsError;
  String? _trendingError;

  // ── Getters ────────────────────────────────────────────────────────────────

  List<CoinModel> get allCoins => _allCoins;
  List<CoinModel> get gainers => _gainers;
  List<TrendingCoinModel> get trending => _trending;

  bool get isLoadingMarkets => _isLoadingMarkets;
  bool get isLoadingTrending => _isLoadingTrending;

  // true if either is still loading — useful for a combined loader
  bool get isLoading => _isLoadingMarkets || _isLoadingTrending;

  String? get marketsError => _marketsError;
  String? get trendingError => _trendingError;

  bool get hasMarketsError => _marketsError != null;
  bool get hasTrendingError => _trendingError != null;

  // ── Init — call this once when HomeScreen mounts ───────────────────────────

  Future<void> init() async {
    await Future.wait([fetchMarkets(), fetchTrending()]);
  }

  // ── Fetch markets (/coins/markets) ─────────────────────────────────────────

  Future<void> fetchMarkets({bool silent = false}) async {
    if (!silent) {
      _isLoadingMarkets = true;
      _marketsError = null;
      notifyListeners();
    }

    try {
      final raw = await ApiService.getMarkets(sparkline: true);
      _allCoins = raw.map((e) => CoinModel.fromJson(e)).toList();

      // top 10 gainers — sorted by highest positive 24h change
      _gainers = [..._allCoins]
        ..sort(
          (a, b) => b.priceChangePercent24h.compareTo(a.priceChangePercent24h),
        )
        ..removeWhere((c) => c.priceChangePercent24h <= 0);
      _gainers = _gainers.take(10).toList();
    } on ApiException catch (e) {
      _marketsError = e.message;
    } catch (e) {
      _marketsError = 'Something went wrong. Please try again.';
    } finally {
      _isLoadingMarkets = false;
      notifyListeners();
    }
  }

  // ── Fetch trending (/search/trending) ──────────────────────────────────────

  Future<void> fetchTrending({bool silent = false}) async {
    if (!silent) {
      _isLoadingTrending = true;
      _trendingError = null;
      notifyListeners();
    }

    try {
      final raw = await ApiService.getTrending();
      final coins = raw['coins'] as List<dynamic>? ?? [];
      _trending = coins
          .map((e) => TrendingCoinModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      _trendingError = e.message;
    } catch (e) {
      _trendingError = 'Something went wrong. Please try again.';
    } finally {
      _isLoadingTrending = false;
      notifyListeners();
    }
  }

  // ── Pull to refresh ────────────────────────────────────────────────────────

  Future<void> refresh() async {
    await Future.wait([
      fetchMarkets(silent: true),
      fetchTrending(silent: true),
    ]);
  }
}
