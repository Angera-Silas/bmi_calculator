import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../models/bmi_record.dart';
import '../database/app_database.dart';
import '../services/session_service.dart';

class InputHistory extends StatefulWidget {
  const InputHistory({super.key});

  @override
  State<InputHistory> createState() => _InputHistoryState();
}

class _InputHistoryState extends State<InputHistory> {
  late Future<List<BmiRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    final userId = SessionService.userId;
    _recordsFuture = userId != null ? AppDatabase.fetchRecords(userId) : Future.value([]);
  }

  void _refresh() => setState(() {
        final userId = SessionService.userId;
        _recordsFuture = userId != null ? AppDatabase.fetchRecords(userId) : Future.value([]);
      });

  Future<void> _deleteRecord(BmiRecord record) async {
    await AppDatabase.softDeleteRecord(record.id);
    // Sync will propagate the deletion to Firestore on next sync
    _refresh();
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final recordDay = DateTime(dt.year, dt.month, dt.day);

    if (recordDay == today) return 'Today';
    if (recordDay == yesterday) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(dt);
  }

  String _formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BmiRecord>>(
      future: _recordsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: kAccent));
        }

        if (snapshot.hasError) {
          return _ErrorState(onRetry: _refresh);
        }

        final records = snapshot.data ?? [];
        if (records.isEmpty) {
          return _EmptyState();
        }

        // ── Compute stats ────────────────────────────────────────────────
        final avgBMI = records.map((r) => r.bmiValue).reduce((a, b) => a + b) / records.length;
        final minBMI = records.map((r) => r.bmiValue).reduce((a, b) => a < b ? a : b);
        final maxBMI = records.map((r) => r.bmiValue).reduce((a, b) => a > b ? a : b);
        final trend = records.length >= 2
            ? records[0].bmiValue - records[1].bmiValue
            : 0.0;

        // ── Group by date ────────────────────────────────────────────────
        final grouped = <String, List<BmiRecord>>{};
        for (final r in records) {
          final key = _formatDate(r.timestamp);
          grouped.putIfAbsent(key, () => []).add(r);
        }

        return RefreshIndicator(
          color: kAccent,
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: const EdgeInsets.all(kSpaceMD),
            children: [
              // ── Stats Summary Card ─────────────────────────────────────
              _StatsSummaryCard(
                total: records.length,
                avgBMI: avgBMI,
                minBMI: minBMI,
                maxBMI: maxBMI,
                trend: trend,
              ),
              const SizedBox(height: kSpaceMD),

              // ── Records by date group ──────────────────────────────────
              ...grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: kSpaceSM),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: DynamicColors.textSecondary(context),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...entry.value.map(
                      (r) => _HistoryTile(
                        record: r,
                        time: _formatTime(r.timestamp),
                        onDelete: () => _deleteRecord(r),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// ─── Stats Summary ────────────────────────────────────────────────────────────

class _StatsSummaryCard extends StatelessWidget {
  final int total;
  final double avgBMI;
  final double minBMI;
  final double maxBMI;
  final double trend;

  const _StatsSummaryCard({
    required this.total,
    required this.avgBMI,
    required this.minBMI,
    required this.maxBMI,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final trendUp = trend > 0.05;
    final trendDown = trend < -0.05;
    final trendColor = trendUp ? kWarningColor : (trendDown ? kNormalColor : kInfoColor);
    final trendIcon = trendUp ? Icons.trending_up : (trendDown ? Icons.trending_down : Icons.trending_flat);
    final trendLabel = trendUp ? '+${trend.toStringAsFixed(1)}' : trend.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(color: DynamicColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(kRadiusSM),
                ),
                child: const Icon(Icons.bar_chart_outlined, color: kAccent, size: 16),
              ),
              const SizedBox(width: kSpaceSM),
              Text(
                'Your Progress',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: DynamicColors.textPrimary(context),
                ),
              ),
              const Spacer(),
              Text(
                '$total ${total == 1 ? "entry" : "entries"}',
                style: TextStyle(
                  fontSize: 12,
                  color: DynamicColors.textSecondary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceMD),
          Row(
            children: [
              _MiniStat(label: 'Average', value: avgBMI.toStringAsFixed(1), color: getBMIColor(avgBMI)),
              _MiniStat(label: 'Lowest', value: minBMI.toStringAsFixed(1), color: getBMIColor(minBMI)),
              _MiniStat(label: 'Highest', value: maxBMI.toStringAsFixed(1), color: getBMIColor(maxBMI)),
              Expanded(
                child: Column(
                  children: [
                    Icon(trendIcon, color: trendColor, size: 22),
                    const SizedBox(height: 2),
                    Text(
                      trendLabel,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: trendColor,
                      ),
                    ),
                    Text(
                      'Trend',
                      style: TextStyle(
                        fontSize: 11,
                        color: DynamicColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
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
          ),
        ],
      ),
    );
  }
}

// ─── History Tile ─────────────────────────────────────────────────────────────

class _HistoryTile extends StatelessWidget {
  final BmiRecord record;
  final String time;
  final VoidCallback onDelete;

  const _HistoryTile({
    required this.record,
    required this.time,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bmiColor = getBMIColor(record.bmiValue);

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: kSpaceSM),
        decoration: BoxDecoration(
          color: kErrorColor,
          borderRadius: BorderRadius.circular(kRadiusMD),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: kSpaceMD),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: DynamicColors.card(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMD)),
          title: Text('Delete record?', style: TextStyle(color: DynamicColors.textPrimary(context))),
          content: Text(
            'This will permanently remove this BMI record.',
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: TextStyle(color: DynamicColors.textSecondary(context))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: kErrorColor, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: kSpaceSM),
        padding: const EdgeInsets.all(kSpaceMD),
        decoration: BoxDecoration(
          color: DynamicColors.card(context),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: DynamicColors.border(context)),
        ),
        child: Row(
          children: [
            // BMI Badge
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: bmiColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(kRadiusSM),
                border: Border.all(color: bmiColor.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    record.bmiResult,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: bmiColor,
                      height: 1,
                    ),
                  ),
                  Text(
                    'BMI',
                    style: TextStyle(
                      fontSize: 10,
                      color: bmiColor.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: kSpaceMD),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.resultText,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: bmiColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${record.height} cm · ${record.weight} kg · ${record.age} yrs',
                    style: TextStyle(
                      fontSize: 12,
                      color: DynamicColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),

            // Time + swipe hint
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: DynamicColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_left, size: 14, color: DynamicColors.textSecondary(context).withOpacity(0.4)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty / Error States ─────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
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
              child: const Icon(Icons.history, color: kAccent, size: 40),
            ),
            const SizedBox(height: kSpaceLG),
            Text(
              'No history yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: DynamicColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: kSpaceSM),
            Text(
              'Calculate your BMI on the Home tab and your history will appear here.',
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

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kSpaceXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: kErrorColor, size: 48),
            const SizedBox(height: kSpaceMD),
            Text(
              'Failed to load history',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: DynamicColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: kSpaceSM),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry', style: TextStyle(color: kAccent, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
