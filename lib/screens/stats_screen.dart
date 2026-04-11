import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../models/bmi_record.dart';
import '../database/app_database.dart';
import '../services/session_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<List<BmiRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    final userId = SessionService.userId;
    _recordsFuture = userId != null ? AppDatabase.fetchRecords(userId) : Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BmiRecord>>(
      future: _recordsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: kAccent));
        }

        final records = (snapshot.data ?? []);

        if (records.isEmpty) {
          return _EmptyStats();
        }

        // Chronological order for chart
        final chronological = [...records]..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        // Last 10 entries for chart
        final chartData = chronological.length > 10 ? chronological.sublist(chronological.length - 10) : chronological;

        final avgBMI = records.map((r) => r.bmiValue).reduce((a, b) => a + b) / records.length;
        final bestBMI = records.reduce((a, b) {
          final aDist = (a.bmiValue - 21.5).abs();
          final bDist = (b.bmiValue - 21.5).abs();
          return aDist < bDist ? a : b;
        });
        final latestBMI = records.first;
        final totalChecks = records.length;

        // Category distribution
        final categoryCount = <String, int>{};
        for (final r in records) {
          categoryCount[r.resultText] = (categoryCount[r.resultText] ?? 0) + 1;
        }

        return ListView(
          padding: const EdgeInsets.all(kSpaceMD),
          children: [
            // ── Hero Stats ──────────────────────────────────────────────────
            Row(
              children: [
                _HeroCard(
                  label: 'Total Checks',
                  value: '$totalChecks',
                  icon: Icons.calendar_month_outlined,
                  color: kAccent,
                ),
                const SizedBox(width: kSpaceSM),
                _HeroCard(
                  label: 'Avg BMI',
                  value: avgBMI.toStringAsFixed(1),
                  icon: Icons.analytics_outlined,
                  color: getBMIColor(avgBMI),
                ),
              ],
            ),
            const SizedBox(height: kSpaceSM),
            Row(
              children: [
                _HeroCard(
                  label: 'Latest BMI',
                  value: latestBMI.bmiResult,
                  icon: Icons.monitor_weight_outlined,
                  color: getBMIColor(latestBMI.bmiValue),
                ),
                const SizedBox(width: kSpaceSM),
                _HeroCard(
                  label: 'Best BMI',
                  value: bestBMI.bmiResult,
                  icon: Icons.emoji_events_outlined,
                  color: kNormalColor,
                ),
              ],
            ),
            const SizedBox(height: kSpaceMD),

            // ── BMI Trend Chart ─────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardHeader(
                    icon: Icons.show_chart,
                    iconColor: kAccent,
                    title: 'BMI Trend',
                    subtitle: 'Last ${chartData.length} measurements',
                  ),
                  const SizedBox(height: kSpaceLG),
                  SizedBox(
                    height: 200,
                    child: _BMILineChart(records: chartData),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Category Distribution ───────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardHeader(
                    icon: Icons.pie_chart_outline,
                    iconColor: kInfoColor,
                    title: 'Category Distribution',
                    subtitle: 'Based on all ${records.length} records',
                  ),
                  const SizedBox(height: kSpaceMD),
                  ...categoryCount.entries.map((e) {
                    final pct = (e.value / totalChecks * 100).round();
                    final color = _categoryColor(e.key);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: kSpaceSM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.key,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: DynamicColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                '${e.value}x · $pct%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(kRadiusSM),
                            child: LinearProgressIndicator(
                              value: e.value / totalChecks,
                              backgroundColor: color.withOpacity(0.15),
                              valueColor: AlwaysStoppedAnimation(color),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Recent Measurements ─────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardHeader(
                    icon: Icons.history_outlined,
                    iconColor: kWarningColor,
                    title: 'Recent Measurements',
                    subtitle: 'Last 5 entries',
                  ),
                  const SizedBox(height: kSpaceMD),
                  ...records.take(5).map((r) {
                    final color = getBMIColor(r.bmiValue);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: kSpaceSM),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(kRadiusSM),
                            ),
                            child: Center(
                              child: Text(
                                r.bmiResult,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: kSpaceSM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.resultText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                                Text(
                                  '${r.weight} kg · ${r.height} cm',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: DynamicColors.textSecondary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            DateFormat('d MMM').format(r.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: DynamicColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),
          ],
        );
      },
    );
  }

  // WHO 2004 category label → chart color
  Color _categoryColor(String category) {
    switch (category) {
      case 'Normal Range':
        return kNormalColor;
      case 'Pre-obese':
        return kOverweightColor;
      case 'Mild Thinness':
      case 'Moderate Thinness':
        return kUnderweightColor;
      case 'Severe Thinness':
        return kSeverelyUnderweightColor;
      case 'Obese Class I':
        return kObeseIColor;
      case 'Obese Class II':
        return kObeseIIColor;
      case 'Obese Class III':
        return kObeseIIIColor;
      default:
        return kAccent;
    }
  }
}

// ─── BMI Line Chart ───────────────────────────────────────────────────────────

class _BMILineChart extends StatelessWidget {
  final List<BmiRecord> records;

  const _BMILineChart({required this.records});

  @override
  Widget build(BuildContext context) {
    final isDark = DynamicColors.isDark(context);
    final gridColor = DynamicColors.border(context);

    final spots = records.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.bmiValue);
    }).toList();

    final minY = (records.map((r) => r.bmiValue).reduce((a, b) => a < b ? a : b) - 2).clamp(10.0, 50.0);
    final maxY = (records.map((r) => r.bmiValue).reduce((a, b) => a > b ? a : b) + 2).clamp(10.0, 50.0);

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (_) => FlLine(
            color: gridColor,
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
              interval: 1,
              reservedSize: 24,
              getTitlesWidget: (v, _) {
                final idx = v.toInt();
                if (idx < 0 || idx >= records.length) return const SizedBox();
                return Text(
                  DateFormat('d/M').format(records[idx].timestamp),
                  style: TextStyle(
                    fontSize: 9,
                    color: DynamicColors.textSecondary(context),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        // BMI zone reference lines
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(y: 18.5, color: kUnderweightColor.withOpacity(0.4), strokeWidth: 1, dashArray: [4, 4]),
            HorizontalLine(y: 25.0, color: kOverweightColor.withOpacity(0.4), strokeWidth: 1, dashArray: [4, 4]),
            HorizontalLine(y: 30.0, color: kObeseIColor.withOpacity(0.4), strokeWidth: 1, dashArray: [4, 4]),
          ],
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((s) {
              return LineTooltipItem(
                s.y.toStringAsFixed(1),
                TextStyle(
                  color: getBMIColor(s.y),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: kAccent,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                radius: 4,
                color: getBMIColor(spot.y),
                strokeWidth: 2,
                strokeColor: isDark ? const Color(0xFF0D1117) : Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kAccent.withOpacity(0.2),
                  kAccent.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _HeroCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(kSpaceMD),
        decoration: BoxDecoration(
          color: DynamicColors.card(context),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: DynamicColors.border(context)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(kRadiusSM),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: kSpaceSM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: DynamicColors.textSecondary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kSpaceMD),
        decoration: BoxDecoration(
          color: DynamicColors.card(context),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: DynamicColors.border(context)),
        ),
        child: child,
      );
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _CardHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(kRadiusSM),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: kSpaceSM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: DynamicColors.textPrimary(context),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: DynamicColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kSpaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.insights, color: kAccent, size: 40),
            ),
            const SizedBox(height: kSpaceLG),
            Text(
              'No data yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: DynamicColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: kSpaceSM),
            Text(
              'Start tracking your BMI and your insights will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DynamicColors.textSecondary(context),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
