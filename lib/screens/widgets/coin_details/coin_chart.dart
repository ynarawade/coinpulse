import 'package:coin_pulse/controller/coin_detail_controller.dart';
import 'package:coin_pulse/utils/currency_formatter.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pure chart area only — no label, no period chips, no card.
/// Wrap in a SizedBox to control height.
class CoinChart extends StatefulWidget {
  final CoinDetailController ctrl;
  final Color lineColor;

  const CoinChart({super.key, required this.ctrl, required this.lineColor});

  @override
  State<CoinChart> createState() => _CoinChartState();
}

class _CoinChartState extends State<CoinChart> {
  double _minX = 0;
  double _maxX = 0;
  double _scale = 1.0;
  double _lastScale = 1.0;
  Offset? _lastFocalPoint;
  bool _initialized = false;

  static const double _xPad = 0.5;

  CoinDetailController get ctrl => widget.ctrl;

  double get _dataLength {
    final len = ctrl.chartType == ChartType.candlestick
        ? ctrl.ohlcData.length
        : ctrl.chartPrices.length;
    return len.toDouble();
  }

  double get _high {
    if (ctrl.chartType == ChartType.candlestick && ctrl.ohlcData.isNotEmpty) {
      return ctrl.ohlcData.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    }
    return ctrl.chartPrices.isEmpty
        ? 0
        : ctrl.chartPrices.reduce((a, b) => a > b ? a : b);
  }

  double get _low {
    if (ctrl.chartType == ChartType.candlestick && ctrl.ohlcData.isNotEmpty) {
      return ctrl.ohlcData.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    }
    return ctrl.chartPrices.isEmpty
        ? 0
        : ctrl.chartPrices.reduce((a, b) => a < b ? a : b);
  }

  void _resetZoom() {
    _scale = 1.0;
    _minX = -_xPad;
    _maxX = (_dataLength - 1 + _xPad).clamp(1.0, double.infinity);
    _initialized = true;
  }

  @override
  void didUpdateWidget(CoinChart old) {
    super.didUpdateWidget(old);
    if (old.ctrl.chartPrices != ctrl.chartPrices ||
        old.ctrl.ohlcData != ctrl.ohlcData) {
      setState(_resetZoom);
    }
  }

  void _onScaleStart(ScaleStartDetails d) {
    _lastFocalPoint = d.localFocalPoint;
    _lastScale = _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    if (!mounted) return;
    final size = context.size;
    if (size == null || size.width == 0) return;

    setState(() {
      final visibleRange = _maxX - _minX;

      if ((d.scale - 1.0).abs() > 0.01) {
        final newScale = (_lastScale * d.scale).clamp(1.0, 12.0);
        final focal = (d.localFocalPoint.dx / size.width).clamp(0.0, 1.0);
        final focalX = _minX + visibleRange * focal;
        final newRange = (_dataLength / newScale).clamp(5.0, _dataLength);
        _minX = (focalX - newRange * focal).clamp(
          -_xPad,
          _dataLength - newRange,
        );
        _maxX = _minX + newRange;
        _scale = newScale;
      }

      if (_lastFocalPoint != null && d.scale == 1.0) {
        final dx = d.localFocalPoint.dx - _lastFocalPoint!.dx;
        final pxPerUnit = size.width / visibleRange;
        final shift = dx / pxPerUnit;
        _minX = (_minX - shift).clamp(-_xPad, _dataLength - visibleRange);
        _maxX = _minX + visibleRange;
        _lastFocalPoint = d.localFocalPoint;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLine = ctrl.chartType == ChartType.line;

    if (!_initialized && _dataLength >= 2) _resetZoom();

    // First load — no data yet
    if (_dataLength < 2) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      );
    }

    final high = _high;
    final low = _low;

    return Stack(
      children: [
        // Chart
        GestureDetector(
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          child: SizedBox.expand(
            child: isLine
                ? _LineChart(
                    prices: ctrl.chartPrices,
                    high: high,
                    low: low,
                    minX: _minX,
                    maxX: _maxX,
                    lineColor: widget.lineColor,
                  )
                : _CandlestickChart(
                    ohlcData: ctrl.ohlcData,
                    high: high,
                    low: low,
                    minX: _minX,
                    maxX: _maxX,
                  ),
          ),
        ),

        // High — top right
        Positioned(
          top: 4,
          right: 4,
          child: _PriceLabel(
            value: high,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // Low — bottom left
        Positioned(
          bottom: 4,
          left: 4,
          child: _PriceLabel(
            value: low,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // Overlay spinner while refreshing — keeps old chart visible
        if (ctrl.isLoadingChart)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.12),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PriceLabel extends StatelessWidget {
  final double value;
  final Color color;
  const _PriceLabel({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      CurrencyFormatter.formatPrice(value),
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// LINE CHART
// ══════════════════════════════════════════════════════════════════

class _LineChart extends StatelessWidget {
  final List<double> prices;
  final double high, low, minX, maxX;
  final Color lineColor;

  const _LineChart({
    required this.prices,
    required this.high,
    required this.low,
    required this.minX,
    required this.maxX,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final spots = prices
        .asMap()
        .entries
        .map((e) => fl.FlSpot(e.key.toDouble(), e.value))
        .toList();
    final pad = (high - low) * 0.05;

    return fl.LineChart(
      fl.LineChartData(
        minX: minX,
        maxX: maxX,
        minY: low - pad,
        maxY: high + pad,
        clipData: const fl.FlClipData.all(),
        gridData: const fl.FlGridData(show: false),
        borderData: fl.FlBorderData(show: false),
        titlesData: _noTitles,
        lineTouchData: fl.LineTouchData(
          enabled: true,
          touchTooltipData: fl.LineTouchTooltipData(
            getTooltipColor: (_) =>
                Theme.of(context).colorScheme.surfaceContainerHighest,
            getTooltipItems: (spots) => spots
                .map(
                  (s) => fl.LineTooltipItem(
                    CurrencyFormatter.formatPrice(s.y),
                    GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: lineColor,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        lineBarsData: [
          fl.LineChartBarData(
            spots: spots,
            isCurved: false,
            color: lineColor,
            barWidth: 1.5,
            isStrokeCapRound: true,
            belowBarData: fl.BarAreaData(show: false),
            dotData: fl.FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// CANDLESTICK CHART
// ══════════════════════════════════════════════════════════════════

class _CandlestickChart extends StatelessWidget {
  final List<OhlcData> ohlcData;
  final double high, low, minX, maxX;

  const _CandlestickChart({
    required this.ohlcData,
    required this.high,
    required this.low,
    required this.minX,
    required this.maxX,
  });

  @override
  Widget build(BuildContext context) {
    final pad = (high - low) * 0.05;
    final start = minX.floor().clamp(0, ohlcData.length - 1);
    final end = maxX.ceil().clamp(0, ohlcData.length - 1);
    final visible = ohlcData.sublist(start, end + 1);

    return fl.BarChart(
      fl.BarChartData(
        minY: low - pad,
        maxY: high + pad,
        gridData: const fl.FlGridData(show: false),
        borderData: fl.FlBorderData(show: false),
        titlesData: _noTitles,
        barTouchData: fl.BarTouchData(
          enabled: true,
          touchTooltipData: fl.BarTouchTooltipData(
            getTooltipColor: (_) =>
                Theme.of(context).colorScheme.surfaceContainerHighest,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (rodIndex != 1) return null;
              final c = visible[groupIndex];
              return fl.BarTooltipItem(
                'O: ${CurrencyFormatter.formatPrice(c.open)}\n'
                'H: ${CurrencyFormatter.formatPrice(c.high)}\n'
                'L: ${CurrencyFormatter.formatPrice(c.low)}\n'
                'C: ${CurrencyFormatter.formatPrice(c.close)}',
                GoogleFonts.dmSans(
                  fontSize: 10,
                  color: c.isBullish ? AppColors.positive : AppColors.negative,
                ),
              );
            },
          ),
        ),
        barGroups: visible.asMap().entries.map((entry) {
          final c = entry.value;
          final color = c.isBullish ? AppColors.positive : AppColors.negative;
          final bodyTop = c.isBullish ? c.close : c.open;
          final bodyBottom = c.isBullish ? c.open : c.close;
          return fl.BarChartGroupData(
            x: entry.key,
            barRods: [
              fl.BarChartRodData(
                fromY: c.low,
                toY: c.high,
                width: 1,
                color: color.withOpacity(0.5),
                borderRadius: BorderRadius.zero,
              ),
              fl.BarChartRodData(
                fromY: bodyBottom,
                toY: bodyTop,
                width: 5,
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

const fl.FlTitlesData _noTitles = fl.FlTitlesData(
  leftTitles: fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
  rightTitles: fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
  topTitles: fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
  bottomTitles: fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
);
