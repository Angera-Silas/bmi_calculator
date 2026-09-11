import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/bmi_record.dart';
import '../services/analytics_service.dart';

/// Weight trend line chart with a linear regression overlay.
/// Takes records in any order (sorts internally).
class WeightTrendChart extends StatelessWidget {
  const WeightTrendChart({
    super.key,
    required this.records,
    this.height = 220,
  });

  final List<BmiRecord> records;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return SizedBox(
        height: height * 0.6,
        child: Center(
          child: Text(
            'No weight records yet',
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
        ),
      );
    }

    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final spots = <FlSpot>[];
    for (var i = 0; i < sorted.length; i++) {
      spots.add(FlSpot(i.toDouble(), sorted[i].weight.toDouble()));
    }

    // Regression line
    final reg = AnalyticsService.weightRegression(sorted);
    final regressionSpots = <FlSpot>[];
    if (reg != null && sorted.length >= 2) {
      final start = FlSpot(0, reg.$2);
      final end = FlSpot((sorted.length - 1).toDouble(),
          reg.$1 * (sorted.length - 1) + reg.$2);
      regressionSpots.addAll([start, end]);
    }

    final allY = sorted.map((r) => r.weight.toDouble()).toList();
    final yMin = (allY.reduce((a, b) => a < b ? a : b) - 3).clamp(20.0, 300.0);
    final yMax = (allY.reduce((a, b) => a > b ? a : b) + 3).clamp(25.0, 310.0);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minY: yMin,
          maxY: yMax,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((yMax - yMin) / 4).ceilToDouble().clamp(1, 50),
            getDrawingHorizontalLine: (_) => FlLine(
              color: DynamicColors.border(context),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (v, _) => Text(
                  '${v.round()}',
                  style: TextStyle(
                    fontSize: 10,
                    color: DynamicColors.textSecondary(context),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (sorted.length / 6)
                    .ceilToDouble()
                    .clamp(1, double.infinity),
                reservedSize: 24,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= sorted.length) return const SizedBox();
                  return Text(
                    '${sorted[idx].timestamp.month}/${sorted[idx].timestamp.day}',
                    style: TextStyle(
                      fontSize: 9,
                      color: DynamicColors.textSecondary(context),
                    ),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((s) {
                final isRegression = s.barIndex == 1;
                final label = isRegression
                    ? 'Trend: ${s.y.toStringAsFixed(1)} kg'
                    : '${sorted[s.spotIndex].weight} kg';
                return LineTooltipItem(
                  label,
                  TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            // Regression line — dashed
            if (regressionSpots.length == 2)
              LineChartBarData(
                spots: regressionSpots,
                isCurved: false,
                color: kAccent.withValues(alpha: 0.5),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                dashArray: [8, 4],
              ),
            // Raw weight — solid dots
            LineChartBarData(
              spots: spots,
              isCurved: spots.length > 1,
              color: DynamicColors.textPrimary(context),
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, idx) => FlDotCirclePainter(
                  radius: 3,
                  color: DynamicColors.textPrimary(context),
                  strokeColor: DynamicColors.surface(context),
                  strokeWidth: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
