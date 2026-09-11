import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

/// A timestamped value in a correlation series.
class DateTimeValue {
  final DateTime time;
  final double value;

  const DateTimeValue(this.time, this.value);
}

/// Dual-series correlation chart.
///
/// Each series is min-max normalized to 0–1 and plotted against a shared
/// timeline (oldest → newest, paired by taking both series' union of unique
/// measurement dates). Rising/falling together suggests a correlation.
class CorrelationChart extends StatelessWidget {
  const CorrelationChart({
    super.key,
    required this.seriesA,
    required this.seriesB,
    required this.labelA,
    required this.labelB,
    required this.colorA,
    required this.colorB,
    this.height = 200,
  });

  final List<DateTimeValue> seriesA;
  final List<DateTimeValue> seriesB;
  final String labelA;
  final String labelB;
  final Color colorA;
  final Color colorB;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (seriesA.isEmpty || seriesB.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Not enough data for correlation',
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
        ),
      );
    }

    final aNorm = _normalize(seriesA);
    final bNorm = _normalize(seriesB);
    final allTimes = {
      ...seriesA.map((v) => v.time),
      ...seriesB.map((v) => v.time),
    }.toList()
      ..sort();
    final xMax = max(allTimes.length - 1, 1);

    // Re-map each series onto the shared timeline by closest preceding value.
    List<FlSpot> _seriesToSpots(List<DateTimeValue> series, List<double> norm) {
      final spots = <FlSpot>[];
      for (var i = 0; i < allTimes.length; i++) {
        final t = allTimes[i];
        // Find latest measurement on or before t in this series.
        DateTimeValue? anchor;
        for (final v in series) {
          if (!v.time.isAfter(t)) anchor = v;
        }
        spots.add(FlSpot(i.toDouble() / xMax,
            anchor != null ? norm[series.indexOf(anchor)] : norm[0]));
      }
      return spots;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 1,
              minY: 0,
              maxY: 1,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: DynamicColors.border(context).withOpacity(0.5),
                  strokeWidth: 1,
                ),
              ),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _seriesToSpots(seriesA, aNorm),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: colorA,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: colorA.withValues(alpha: 0.08),
                  ),
                ),
                LineChartBarData(
                  spots: _seriesToSpots(seriesB, bNorm),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: colorB,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: colorB.withValues(alpha: 0.08),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _legendDot(colorA),
            const SizedBox(width: 4),
            Text(labelA,
                style: TextStyle(
                    fontSize: 12, color: DynamicColors.textSecondary(context))),
            const SizedBox(width: 12),
            _legendDot(colorB),
            const SizedBox(width: 4),
            Text(labelB,
                style: TextStyle(
                    fontSize: 12, color: DynamicColors.textSecondary(context))),
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  /// Min-max normalizes values to 0–1.
  List<double> _normalize(List<DateTimeValue> series) {
    var minV = series.first.value, maxV = series.first.value;
    for (final v in series) {
      if (v.value < minV) minV = v.value;
      if (v.value > maxV) maxV = v.value;
    }
    final range = (maxV - minV) == 0 ? 1.0 : maxV - minV;
    return [
      for (final v in series) (v.value - minV) / range,
    ];
  }
}
