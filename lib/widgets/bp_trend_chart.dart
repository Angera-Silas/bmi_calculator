import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/blood_pressure_record.dart';

/// Line chart of systolic + diastolic readings over time.
///
/// Two line series — systolic (accent) and diastolic (blue) — plotted against
/// measurement time. The empty state shows a friendly placeholder.
class BpTrendChart extends StatelessWidget {
  const BpTrendChart({
    super.key,
    required this.records,
    this.height = 220,
  });

  final List<BloodPressureRecord> records; // newest first
  final double height;

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

    final sorted = List<BloodPressureRecord>.from(records)
      ..sort((a, b) => b.measurementTime.compareTo(a.measurementTime));

    final spotsSystolic = <FlSpot>[];
    final spotsDiastolic = <FlSpot>[];
    final hasTwoOrMore = sorted.length >= 2;

    for (var i = 0; i < sorted.length; i++) {
      final record = sorted[i];
      final x = i / max(sorted.length - 1, 1);
      spotsSystolic.add(FlSpot(x, record.systolic.toDouble()));
      spotsDiastolic.add(FlSpot(x, record.diastolic.toDouble()));
    }

    final yMin =
        (sorted.map((r) => r.diastolic).reduce((a, b) => a < b ? a : b) - 10)
            .clamp(40, 1000);
    final yMax =
        (sorted.map((r) => r.systolic).reduce((a, b) => a > b ? a : b) + 10)
            .clamp(100, 1000);

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
            horizontalInterval: ((yMax - yMin) / 4).clamp(10, 50).toDouble(),
            getDrawingHorizontalLine: (_) => FlLine(
              color: DynamicColors.border(context).withOpacity(0.5),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: ((yMax - yMin) / 4).clamp(10, 50).toDouble(),
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
                final recordIndex = (spot.x * max(sorted.length - 1, 1))
                    .round()
                    .clamp(0, sorted.length - 1);
                final record = sorted[recordIndex];
                return LineTooltipItem(
                  '${record.systolic}/${record.diastolic}\n'
                  '${_formatTime(record.measurementTime)}',
                  TextStyle(
                    color: DynamicColors.textPrimary(context),
                    fontWeight: FontWeight.w700,
                  ),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spotsSystolic,
              isCurved: true,
              curveSmoothness: 0.25,
              color: kAccent,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: hasTwoOrMore ? 3 : 4,
                  color: kAccent,
                  strokeWidth: 2,
                  strokeColor: DynamicColors.bg(context),
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: kAccent.withOpacity(0.12),
              ),
            ),
            LineChartBarData(
              spots: spotsDiastolic,
              isCurved: true,
              curveSmoothness: 0.25,
              color: const Color(0xFF29B6F6),
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: hasTwoOrMore ? 3 : 4,
                  color: const Color(0xFF29B6F6),
                  strokeWidth: 2,
                  strokeColor: DynamicColors.bg(context),
                ),
              ),
            ),
          ],
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
