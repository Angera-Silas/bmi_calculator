import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/bmi_record.dart';
import '../services/analytics_service.dart';

/// BMI trend line chart with a 3-point moving-average overlay and WHO zone
/// reference bands. Takes records in any order (sorts internally).
class BmiTrendChart extends StatelessWidget {
  const BmiTrendChart({
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
            'No BMI records yet',
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
        ),
      );
    }

    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final ma = AnalyticsService.movingAverage(sorted, window: 3);

    final spots = <FlSpot>[];
    for (var i = 0; i < sorted.length; i++) {
      spots.add(FlSpot(i.toDouble(), sorted[i].bmiValue));
    }

    final maSpots = <FlSpot>[];
    for (var i = 0; i < ma.length; i++) {
      maSpots
          .add(FlSpot((i + 2).toDouble(), ma[i])); // centered on last of window
    }

    final allY = sorted.map((r) => r.bmiValue).toList();
    final yMin = (allY.reduce((a, b) => a < b ? a : b) - 2).clamp(10.0, 50.0);
    final yMax = (allY.reduce((a, b) => a > b ? a : b) + 2).clamp(12.0, 55.0);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minY: yMin,
          maxY: yMax,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
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
                interval: 5,
                reservedSize: 32,
                getTitlesWidget: (v, _) => Text(
                  v.toStringAsFixed(0),
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
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                  y: 18.5,
                  color: kUnderweightColor.withValues(alpha: 0.4),
                  strokeWidth: 1,
                  dashArray: [4, 4]),
              HorizontalLine(
                  y: 25.0,
                  color: kOverweightColor.withValues(alpha: 0.4),
                  strokeWidth: 1,
                  dashArray: [4, 4]),
              HorizontalLine(
                  y: 30.0,
                  color: kObeseIColor.withValues(alpha: 0.4),
                  strokeWidth: 1,
                  dashArray: [4, 4]),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((s) {
                final label = s.spotIndex < sorted.length
                    ? '${sorted[s.spotIndex].bmiValue.toStringAsFixed(1)} BMI'
                    : 'MA: ${s.y.toStringAsFixed(1)}';
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
            // Moving average — dashed accent line
            if (maSpots.length >= 2)
              LineChartBarData(
                spots: maSpots,
                isCurved: true,
                color: kAccent,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                dashArray: [6, 3],
              ),
            // Raw BMI — solid dots
            LineChartBarData(
              spots: spots,
              isCurved: spots.length > 1,
              color: DynamicColors.textSecondary(context),
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, idx) => FlDotCirclePainter(
                  radius: 3,
                  color: kAccent,
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
