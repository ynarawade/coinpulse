import 'dart:async';
import 'dart:developer';

import 'package:coin_pulse/models/coin_model.dart';
import 'package:coin_pulse/services/api_service.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';

enum ChartType { line, candlestick }

/// OHLC candle data parsed from CoinGecko OHLC endpoint
class OhlcData {
  final double timestamp;
  final double open;
  final double high;
  final double low;
  final double close;

  const OhlcData({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory OhlcData.fromList(List<dynamic> item) {
    return OhlcData(
      timestamp: (item[0] as num).toDouble(),
      open: (item[1] as num).toDouble(),
      high: (item[2] as num).toDouble(),
      low: (item[3] as num).toDouble(),
      close: (item[4] as num).toDouble(),
    );
  }

  bool get isBullish => close >= open;
}

class CoinDetailController extends ChangeNotifier {
  final CoinModel coin;

  CoinDetailController({required this.coin}) {
    _chartPrices = coin.sparkline;
    _chartSpots = coin.sparkline
        .asMap()
        .entries
        .map((e) => fl.FlSpot(e.key.toDouble(), e.value))
        .toList();
  }

  // ── Chart state ────────────────────────────────────────────────────────────

  List<double> _chartPrices = [];
  List<OhlcData> _ohlcData = [];
  List<fl.FlSpot> _chartSpots = [];
  bool _isLoadingChart = false;
  String? _chartError;
  String _selectedPeriod = 'M';
  ChartType _chartType = ChartType.line;

  List<double> get chartPrices => _chartPrices;
  List<OhlcData> get ohlcData => _ohlcData;
  List<fl.FlSpot> get chartSpots => _chartSpots;
  bool get isLoadingChart => _isLoadingChart;
  String? get chartError => _chartError;
  String get selectedPeriod => _selectedPeriod;
  ChartType get chartType => _chartType;

  // ── Cache — key: "$type-$period" → data ───────────────────────────────────
  final Map<String, List<double>> _lineCache = {};
  final Map<String, List<OhlcData>> _ohlcCache = {};

  // ── Debounce timer ─────────────────────────────────────────────────────────
  Timer? _debounce;
  static const _debounceDuration = Duration(milliseconds: 500);

  // ── Coin detail state ──────────────────────────────────────────────────────

  Map<String, dynamic>? _coinDetail;
  bool _isLoadingDetail = false;
  String? _detailError;

  Map<String, dynamic>? get coinDetail => _coinDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  // ── Watchlist state ────────────────────────────────────────────────────────

  bool _isWatchlisted = false;
  bool get isWatchlisted => _isWatchlisted;

  // ── Derived chart values ───────────────────────────────────────────────────

  double get chartHigh {
    if (_chartType == ChartType.candlestick && _ohlcData.isNotEmpty) {
      return _ohlcData.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    }
    return _chartPrices.isEmpty
        ? 0
        : _chartPrices.reduce((a, b) => a > b ? a : b);
  }

  double get chartLow {
    if (_chartType == ChartType.candlestick && _ohlcData.isNotEmpty) {
      return _ohlcData.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    }
    return _chartPrices.isEmpty
        ? 0
        : _chartPrices.reduce((a, b) => a < b ? a : b);
  }

  // ── Period → API days mapping ──────────────────────────────────────────────

  static const Map<String, String> periodDays = {
    'D': '1',
    'W': '7',
    'M': '30',
    '6M': '180',
    'Y': '365',
    'All': 'max',
  };

  // ── Init ───────────────────────────────────────────────────────────────────

  Future<void> init() async {
    await Future.wait([fetchChart('30'), fetchCoinDetail()]);
  }

  // ── Fetch line chart (/coins/{id}/market_chart) ────────────────────────────

  Future<void> fetchChart(String days) async {
    final cacheKey = 'line-$days';

    // serve from cache instantly — no loading flicker
    if (_lineCache.containsKey(cacheKey)) {
      _applyLineData(_lineCache[cacheKey]!);
      return;
    }

    _isLoadingChart = true;
    _chartError = null;
    notifyListeners();

    try {
      final data = await ApiService.getCoinChart(coin.id, days: days);
      final prices = (data['prices'] as List<dynamic>)
          .map((e) => ((e as List<dynamic>)[1] as num).toDouble())
          .toList();

      _lineCache[cacheKey] = prices;
      _applyLineData(prices);
    } on ApiException catch (e) {
      _chartError = e.message;
      log('fetchChart error: ${e.message}');
    } catch (e) {
      _chartError = 'Failed to load chart data.';
      log('fetchChart error: $e');
    } finally {
      _isLoadingChart = false;
      notifyListeners();
    }
  }

  void _applyLineData(List<double> prices) {
    _chartPrices = prices;
    _chartSpots = prices
        .asMap()
        .entries
        .map((e) => fl.FlSpot(e.key.toDouble(), e.value))
        .toList();
  }

  // ── Fetch OHLC (/coins/{id}/ohlc) ─────────────────────────────────────────

  Future<void> fetchOhlc(String days) async {
    final cacheKey = 'ohlc-$days';

    if (_ohlcCache.containsKey(cacheKey)) {
      _ohlcData = _ohlcCache[cacheKey]!;
      notifyListeners();
      return;
    }

    _isLoadingChart = true;
    _chartError = null;
    notifyListeners();

    try {
      final data = await ApiService.getCoinOhlc(coin.id, days: days);
      final candles = (data as List<dynamic>)
          .map((e) => OhlcData.fromList(e as List<dynamic>))
          .toList();

      _ohlcCache[cacheKey] = candles;
      _ohlcData = candles;
    } on ApiException catch (e) {
      _chartError = e.message;
      log('fetchOhlc error: ${e.message}');
    } catch (e) {
      _chartError = 'Failed to load OHLC data.';
      log('fetchOhlc error: $e');
    } finally {
      _isLoadingChart = false;
      notifyListeners();
    }
  }

  // ── Period selection — debounced ───────────────────────────────────────────

  void selectPeriod(String period) {
    if (_selectedPeriod == period) return;
    _selectedPeriod = period;
    notifyListeners(); // update chip highlight immediately

    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, _fetchForCurrentType);
  }

  // ── Chart type toggle ──────────────────────────────────────────────────────

  void toggleChartType() {
    _chartType = _chartType == ChartType.line
        ? ChartType.candlestick
        : ChartType.line;
    notifyListeners();

    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, _fetchForCurrentType);
  }

  void _fetchForCurrentType() {
    final days = periodDays[_selectedPeriod]!;
    if (_chartType == ChartType.line) {
      fetchChart(days);
    } else {
      fetchOhlc(days);
    }
  }

  // ── Fetch coin detail (/coins/{id}) ────────────────────────────────────────

  Future<void> fetchCoinDetail() async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      _coinDetail = await ApiService.getCoinDetail(coin.id);
    } on ApiException catch (e) {
      _detailError = e.message;
    } catch (_) {
      _detailError = 'Failed to load coin details.';
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  // ── Watchlist toggle ───────────────────────────────────────────────────────

  void toggleWatchlist() {
    _isWatchlisted = !_isWatchlisted;
    notifyListeners();
    // TODO: persist to local storage
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
