import 'package:coin_pulse/utils/currency_formatter.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinLineChart extends StatelessWidget {
  final List<double> prices;
  final Color lineColor;

  /// Show horizontal grid lines (default: true)
  final bool showGrid;

  /// Show high/low labels on the right axis (default: true)
  final bool showAxisLabels;

  /// Width of the chart line (default: 2)
  final double barWidth;

  /// Curve smoothness 0.0–1.0 (default: 0.3)
  final double curveSmoothness;

  const CoinLineChart({
    super.key,
    required this.prices,
    required this.lineColor,
    this.showGrid = true,
    this.showAxisLabels = true,
    this.barWidth = 2,
    this.curveSmoothness = 0.3,
  });

  double get _high =>
      prices.isEmpty ? 0 : prices.reduce((a, b) => a > b ? a : b);
  double get _low =>
      prices.isEmpty ? 0 : prices.reduce((a, b) => a < b ? a : b);

  @override
  Widget build(BuildContext context) {
    if (prices.length < 2) return const SizedBox();

    final spots = prices
        .asMap()
        .entries
        .map((e) => fl.FlSpot(e.key.toDouble(), e.value))
        .toList();

    final minY = _low * 0.998;
    final maxY = _high * 1.002;

    return fl.LineChart(
      fl.LineChartData(
        minY: minY,
        maxY: maxY,

        // ── Grid ─────────────────────────────────────────────────────────
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

        // ── Axis labels ───────────────────────────────────────────────────
        titlesData: fl.FlTitlesData(
          leftTitles: const fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          topTitles: const fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          bottomTitles: const fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          rightTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(
              showTitles: showAxisLabels,
              reservedSize: showAxisLabels ? 72 : 0,
              getTitlesWidget: (value, _) {
                if (value == _high || value == _low) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      CurrencyFormatter.formatPrice(value),
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),

        // ── Touch tooltip ─────────────────────────────────────────────────
        lineTouchData: fl.LineTouchData(
          enabled: showAxisLabels, // disable touch on sparklines
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

        // ── Line ──────────────────────────────────────────────────────────
        lineBarsData: [
          fl.LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: curveSmoothness,
            color: lineColor,
            barWidth: barWidth,
            isStrokeCapRound: true,
            dotData: const fl.FlDotData(show: false),
            belowBarData: fl.BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withOpacity(0.15),
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
