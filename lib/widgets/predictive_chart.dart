import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/bmi_record.dart';
import '../services/analytics_service.dart';

/// BMI trend chart with a dashed forward projection based on linear regression.
/// Shows historical data as a solid line and [forecastDays] of prediction as a
/// dashed extension. WHO zone reference bands are shown for context.
class PredictiveChart extends StatelessWidget {
  const PredictiveChart({
    super.key,
    required this.records,
    this.forecastDays = 30,
    this.height = 240,
  });

  final List<BmiRecord> records;
  final int forecastDays;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (records.length < 2) {
      return SizedBox(
        height: height * 0.6,
        child: Center(
          child: Text(
            'Need at least 2 BMI records to show a trend',
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
        ),
      );
    }

    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final reg = AnalyticsService.bmiRegression(sorted);

    final historicalSpots = <FlSpot>[];
    for (var i = 0; i < sorted.length; i++) {
      historicalSpots.add(FlSpot(i.toDouble(), sorted[i].bmiValue));
    }

    // Project forward: interpolate forecastDays into chart x-space.
    // Each day maps to a fraction of a chart unit based on average spacing.
    final totalDays =
        sorted.last.timestamp.difference(sorted.first.timestamp).inDays;
    final avgDaysPerPoint =
        totalDays > 0 ? totalDays / (sorted.length - 1) : 1.0;
    final forecastPoints = (forecastDays / avgDaysPerPoint).ceil();

    final projectionSpots = <FlSpot>[];
    if (reg != null) {
      final lastX = (sorted.length - 1).toDouble();
      final lastY = reg.$1 * lastX + reg.$2;
      projectionSpots.add(FlSpot(lastX, lastY));

      final projectedX = lastX + forecastPoints;
      final projectedY = reg.$1 * projectedX + reg.$2;
      projectionSpots.add(FlSpot(projectedX, projectedY));
    }

    final allHistoricY = historicalSpots.map((s) => s.y).toList();
    final allProjectionY = projectionSpots.map((s) => s.y).toList();
    final allY = [...allHistoricY, ...allProjectionY];
    final yMin = (allY.reduce((a, b) => a < b ? a : b) - 2).clamp(10.0, 50.0);
    final yMax = (allY.reduce((a, b) => a > b ? a : b) + 2).clamp(12.0, 55.0);
    final xMax = sorted.length - 1.0 + forecastPoints;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minY: yMin,
          maxY: yMax,
          maxX: xMax,
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
                interval: (sorted.length / 5)
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
                final isProjection = s.barIndex == 1;
                final label = isProjection
                    ? 'Projected: ${s.y.toStringAsFixed(1)}'
                    : '${s.y.toStringAsFixed(1)} BMI';
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
            // Projection — dashed
            if (projectionSpots.length == 2)
              LineChartBarData(
                spots: projectionSpots,
                isCurved: false,
                color: kAccent,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                dashArray: [6, 4],
              ),
            // Historical — solid
            LineChartBarData(
              spots: historicalSpots,
              isCurved: historicalSpots.length > 1,
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
