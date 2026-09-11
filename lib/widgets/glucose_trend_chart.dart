import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/blood_sugar_record.dart';

/// Glucose trend line chart with ADA target bands.
///
/// A green band marks the fasting normal target (< 100 mg/dL) and a dashed
/// line at 140 mg/dL marks the 2-hour post-meal / random target. Points are
/// color-coded by status.
class GlucoseTrendChart extends StatelessWidget {
  const GlucoseTrendChart({
    super.key,
    required this.records,
    this.height = 220,
  });

  final List<BloodSugarRecord> records; // newest first
  final double height;

  static const double _fastingTarget = 100; // mg/dL
  static const double _postMealTarget = 140; // mg/dL

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return SizedBox(
        height: height * 0.6,
        child: Center(
          child: Text(
            'No readings yet',
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
        ),
      );
    }

    final sorted = List<BloodSugarRecord>.from(records)
      ..sort((a, b) => b.measurementTime.compareTo(a.measurementTime));

    final spots = <FlSpot>[];
    final minLevel =
        sorted.map((r) => r.glucoseLevel).reduce((a, b) => a < b ? a : b);
    final maxLevel =
        sorted.map((r) => r.glucoseLevel).reduce((a, b) => a > b ? a : b);
    final yMin = (minLevel - 20).clamp(30, 1000);
    final yMax = (maxLevel + 20).clamp(140, 1000);

    for (var i = 0; i < sorted.length; i++) {
      spots.add(FlSpot(
        i / max(sorted.length - 1, 1),
        sorted[i].glucoseLevel.toDouble(),
      ));
    }

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 1,
          minY: yMin.toDouble(),
          maxY: yMax.toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((yMax - yMin) / 4).clamp(20, 100).toDouble(),
            getDrawingHorizontalLine: (_) => FlLine(
              color: DynamicColors.border(context).withOpacity(0.5),
              strokeWidth: 1,
            ),
          ),
          // ADA target band: shaded green below the fasting target.
          // The band rect is 0..1 on X (normalized chart coordinates) so it
          // spans the full width and stops at the fasting target on Y.
          lineBarsData: [
            // ADA fasting target band: green fill below 100 mg/dL.
            LineChartBarData(
              spots: [
                FlSpot(0, _fastingTarget),
                FlSpot(1, _fastingTarget),
              ],
              color: Colors.transparent,
              barWidth: 0,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: kNormalColor.withOpacity(0.12),
              ),
            ),
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.25,
              color: kAccent,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final record = sorted[index.clamp(0, sorted.length - 1)];
                  final color = switch (record.status) {
                    BloodSugarStatus.normal => kNormalColor,
                    BloodSugarStatus.prediabetes => kWarningColor,
                    BloodSugarStatus.diabetes => kObeseIColor,
                  };
                  return FlDotCirclePainter(
                    radius: sorted.length < 2 ? 4 : 3,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: DynamicColors.bg(context),
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: kAccent.withOpacity(0.10),
              ),
            ),
          ],
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              // Post-meal / random target (140 mg/dL).
              HorizontalLine(
                y: _postMealTarget,
                color: kWarningColor.withOpacity(0.7),
                strokeWidth: 1,
                dashArray: [6, 4],
                label: HorizontalLineLabel(
                  show: true,
                  labelResolver: (_) => '140',
                  style: TextStyle(
                    fontSize: 10,
                    color: kWarningColor.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: ((yMax - yMin) / 4).clamp(20, 100).toDouble(),
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: DynamicColors.textSecondary(context),
                  ),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final record = sorted[(spot.x * max(sorted.length - 1, 1))
                    .round()
                    .clamp(0, sorted.length - 1)];
                return LineTooltipItem(
                  '${record.glucoseLevel} mg/dL\n'
                  '${_formatTime(record.measurementTime)} · ${record.measurementType.storageValue.replaceFirst('_', ' ')}',
                  TextStyle(
                    color: DynamicColors.textPrimary(context),
                    fontWeight: FontWeight.w700,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
