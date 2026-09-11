import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/blood_pressure_record.dart';
import '../providers/blood_pressure_provider.dart';
import '../widgets/bp_gauge.dart';
import '../widgets/bp_trend_chart.dart';
import 'blood_pressure_input.dart';

class BloodPressureHistory extends ConsumerWidget {
  const BloodPressureHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recordsAsync = ref.watch(bloodPressureProvider);

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        title: Text(
          l10n.bpHistoryTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: kAccent),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BloodPressureInput()),
            ),
          ),
        ],
      ),
      body: recordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Failed to load readings',
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
        ),
        data: (records) => records.isEmpty
            ? _EmptyState(
                message: l10n.bpHistoryEmpty,
                onAdd: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BloodPressureInput()),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(kSpaceMD),
                children: [
                  // ── Latest reading gauge ──────────────────────────────────
                  _LatestReadingCard(
                    records: records,
                    onAdd: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BloodPressureInput()),
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),

                  // ── Trend chart ───────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(kSpaceMD),
                    decoration: BoxDecoration(
                      color: DynamicColors.card(context),
                      borderRadius: BorderRadius.circular(kRadiusLG),
                      border: Border.all(color: DynamicColors.border(context)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.bpTrendTitle, style: labelStyle(context)),
                        const SizedBox(height: kSpaceMD),
                        BpTrendChart(records: records),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),

                  // ── Reading list ──────────────────────────────────────────
                  Text(l10n.bpReadingsTitle, style: labelStyle(context)),
                  const SizedBox(height: kSpaceSM),
                  ...records.map(
                    (record) => _ReadingTile(
                      record: record,
                      onDismissed: () => ref
                          .read(bloodPressureProvider.notifier)
                          .softDelete(record.id),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _LatestReadingCard extends StatelessWidget {
  const _LatestReadingCard({required this.records, required this.onAdd});

  final List<BloodPressureRecord> records;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final latest = records.first;
    return Container(
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: DynamicColors.border(context)),
      ),
      child: Column(
        children: [
          BpGauge(
            systolic: latest.systolic,
            diastolic: latest.diastolic,
          ),
          const SizedBox(height: kSpaceMD),
          _CategoryChip(category: latest.category),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final BloodPressureCategory category;

  @override
  Widget build(BuildContext context) {
    final color = getBpCategoryColor(category);
    final label = switch (category) {
      BloodPressureCategory.normal => 'Normal',
      BloodPressureCategory.elevated => 'Elevated',
      BloodPressureCategory.stage1 => 'Stage 1 High',
      BloodPressureCategory.stage2 => 'Stage 2 High',
      BloodPressureCategory.crisis => 'Crisis',
    };
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: kSpaceXS),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ReadingTile extends StatelessWidget {
  const _ReadingTile({required this.record, required this.onDismissed});

  final BloodPressureRecord record;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final color = getBpCategoryColor(record.category);
    final formatter = DateFormat('EEE, MMM d • HH:mm');

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: kSpaceMD),
        decoration: BoxDecoration(
          color: kErrorColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(kRadiusSM),
        ),
        child: const Icon(Icons.delete_outline, color: kErrorColor),
      ),
      onDismissed: (_) => onDismissed(),
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
            Container(
              width: 6,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: kSpaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${record.systolic}/${record.diastolic} mmHg',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                  if (record.pulse != null)
                    Text(
                      '♥ ${record.pulse} bpm',
                      style: TextStyle(
                        fontSize: 13,
                        color: DynamicColors.textSecondary(context),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatter.format(record.measurementTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: DynamicColors.textSecondary(context),
                  ),
                ),
                if (record.notes != null && record.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      record.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: DynamicColors.textSecondary(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.onAdd});

  final String message;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kSpaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.monitor_heart_outlined,
              size: 64,
              color: DynamicColors.iconColor(context),
            ),
            const SizedBox(height: kSpaceMD),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DynamicColors.textSecondary(context),
              ),
            ),
            const SizedBox(height: kSpaceLG),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add reading'),
              style: FilledButton.styleFrom(backgroundColor: kAccent),
            ),
          ],
        ),
      ),
    );
  }
}
