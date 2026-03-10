import 'package:coin_pulse/controller/coin_detail_controller.dart';
import 'package:coin_pulse/utils/currency_formatter.dart';
import 'package:coin_pulse/utils/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Unified chart — line or candlestick.
/// High label overlaid top-right, Low label bottom-left (matching reference).
/// Pinch-to-zoom and pan supported.
class CoinChart extends StatefulWidget {
  final ChartType chartType;
  final List<fl.FlSpot> spots;

  final List<OhlcData> ohlcData;
  final Color lineColor;
  final bool showGrid;

  const CoinChart({
    super.key,
    required this.chartType,
    required this.spots,
    required this.ohlcData,
    required this.lineColor,
    this.showGrid = false,
  });

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

  double get _dataLength {
    final len = widget.chartType == ChartType.candlestick
        ? widget.ohlcData.length
        : widget.spots.length;
    return len.toDouble();
  }

  double get _high {
    if (widget.chartType == ChartType.candlestick &&
        widget.ohlcData.isNotEmpty) {
      return widget.ohlcData.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    }
    return widget.spots.isEmpty
        ? 0
        : widget.spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
  }

  double get _low {
    if (widget.chartType == ChartType.candlestick &&
        widget.ohlcData.isNotEmpty) {
      return widget.ohlcData.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    }
    return widget.spots.isEmpty
        ? 0
        : widget.spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
  }

  void _resetZoom() {
    _scale = 1.0;
    _minX = 0;
    _maxX = (_dataLength - 1).clamp(1.0, double.infinity);
    _initialized = true;
  }

  @override
  void didUpdateWidget(CoinChart old) {
    super.didUpdateWidget(old);
    if (old.spots != widget.spots || old.ohlcData != widget.ohlcData) {
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

      // zoom
      if ((d.scale - 1.0).abs() > 0.01) {
        final newScale = (_lastScale * d.scale).clamp(1.0, 12.0);
        final focal = (d.localFocalPoint.dx / size.width).clamp(0.0, 1.0);
        final focalX = _minX + visibleRange * focal;
        final newRange = (_dataLength / newScale).clamp(5.0, _dataLength);
        _minX = (focalX - newRange * focal).clamp(0.0, _dataLength - newRange);
        _maxX = _minX + newRange;
        _scale = newScale;
      }

      // pan
      if (_lastFocalPoint != null && d.scale == 1.0) {
        final dx = d.localFocalPoint.dx - _lastFocalPoint!.dx;
        final pxPerUnit = size.width / visibleRange;
        final shift = dx / pxPerUnit;
        final newMin = (_minX - shift).clamp(0.0, _dataLength - visibleRange);
        _minX = newMin;
        _maxX = _minX + visibleRange;
        _lastFocalPoint = d.localFocalPoint;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dataLength < 2) return const SizedBox();
    if (!_initialized) _resetZoom();

    final high = _high;
    final low = _low;

    final chart = widget.chartType == ChartType.candlestick
        ? _CandlestickChart(
            ohlcData: widget.ohlcData,
            high: high,
            low: low,
            minX: _minX,
            maxX: _maxX,
            showGrid: widget.showGrid,
          )
        : _LineChart(
            spots: widget.spots,
            high: high,
            low: low,
            minX: _minX,
            maxX: _maxX,
            lineColor: widget.lineColor,
            showGrid: widget.showGrid,
          );

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: Stack(
        children: [
          // ── Chart fills full width ─────────────────────────────────────
          Positioned.fill(child: chart),

          // ── High label — top right ─────────────────────────────────────
          Positioned(top: 6, right: 4, child: _PriceLabel(value: high)),

          Positioned(bottom: 6, left: 4, child: _PriceLabel(value: low)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// LINE CHART  — no axis reserved space, fills full width
// ════════════════════════════════════════════════════════════════════════════

class _LineChart extends StatelessWidget {
  final List<fl.FlSpot> spots;
  final double high;
  final double low;
  final double minX;
  final double maxX;
  final Color lineColor;
  final bool showGrid;

  const _LineChart({
    required this.spots,
    required this.high,
    required this.low,
    required this.minX,
    required this.maxX,
    required this.lineColor,
    required this.showGrid,
  });

  @override
  Widget build(BuildContext context) {
    final padding = (high - low) * 0.05;
    final minY = low - padding;
    final maxY = high + padding;

    return fl.LineChart(
      fl.LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        clipData: const fl.FlClipData.all(),
        gridData: fl.FlGridData(
          show: showGrid,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (_) => fl.FlLine(
            color: Theme.of(context).dividerColor,
            strokeWidth: 0.5,
          ),
        ),
        borderData: fl.FlBorderData(show: false),
        // No axis labels — labels are Stack overlays instead
        titlesData: const fl.FlTitlesData(
          leftTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          rightTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          topTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          bottomTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
        ),
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
            isCurved: true,
            curveSmoothness: 0.35,
            color: lineColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const fl.FlDotData(show: false),
            belowBarData: fl.BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withOpacity(0.18),
                  lineColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CANDLESTICK CHART
// ════════════════════════════════════════════════════════════════════════════

class _CandlestickChart extends StatelessWidget {
  final List<OhlcData> ohlcData;
  final double high;
  final double low;
  final double minX;
  final double maxX;
  final bool showGrid;

  const _CandlestickChart({
    required this.ohlcData,
    required this.high,
    required this.low,
    required this.minX,
    required this.maxX,
    required this.showGrid,
  });

  @override
  Widget build(BuildContext context) {
    if (ohlcData.isEmpty) return const SizedBox();

    final range = (high - low).abs();
    final padding = range == 0 ? high * 0.01 : range * 0.05;
    final minY = low - padding;
    final maxY = high + padding;

    final start = minX.floor().clamp(0, ohlcData.length - 1);
    final end = maxX.ceil().clamp(0, ohlcData.length - 1);
    final visible = ohlcData.sublist(start, end + 1);

    return fl.BarChart(
      fl.BarChartData(
        minY: minY,
        maxY: maxY,
        gridData: fl.FlGridData(
          show: showGrid,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (_) => fl.FlLine(
            color: Theme.of(context).dividerColor,
            strokeWidth: 0.5,
          ),
        ),
        borderData: fl.FlBorderData(show: false),
        titlesData: const fl.FlTitlesData(
          leftTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          rightTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          topTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          bottomTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
        ),
        barTouchData: fl.BarTouchData(
          enabled: true,
          touchTooltipData: fl.BarTouchTooltipData(
            getTooltipColor: (_) =>
                Theme.of(context).colorScheme.surfaceContainerHighest,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (rodIndex != 1) return null;
              final candle = visible[groupIndex];
              return fl.BarTooltipItem(
                'O: ${CurrencyFormatter.formatPrice(candle.open)}\n'
                'H: ${CurrencyFormatter.formatPrice(candle.high)}\n'
                'L: ${CurrencyFormatter.formatPrice(candle.low)}\n'
                'C: ${CurrencyFormatter.formatPrice(candle.close)}',
                GoogleFonts.dmSans(
                  fontSize: 10,
                  color: candle.isBullish
                      ? AppColors.positive
                      : AppColors.negative,
                ),
              );
            },
          ),
        ),
        barGroups: visible.asMap().entries.map((entry) {
          final candle = entry.value;
          final isBullish = candle.isBullish;
          final candleColor = isBullish
              ? AppColors.positive
              : AppColors.negative;
          final bodyTop = isBullish ? candle.close : candle.open;
          final bodyBottom = isBullish ? candle.open : candle.close;

          return fl.BarChartGroupData(
            x: entry.key,
            barRods: [
              fl.BarChartRodData(
                fromY: candle.low,
                toY: candle.high,
                width: 1,
                color: candleColor.withOpacity(0.5),
                borderRadius: BorderRadius.zero,
              ),
              fl.BarChartRodData(
                fromY: bodyBottom,
                toY: bodyTop,
                width: 5,
                color: candleColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  final double value;

  const _PriceLabel({required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      CurrencyFormatter.formatPrice(value),
      style: theme.textTheme.labelMedium,
    );
  }
}
