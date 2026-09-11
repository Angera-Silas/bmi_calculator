import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/blood_sugar_record.dart';
import '../providers/blood_sugar_provider.dart';
import '../widgets/glucose_trend_chart.dart';
import 'blood_sugar_input.dart';

class BloodSugarHistory extends ConsumerWidget {
  const BloodSugarHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recordsAsync = ref.watch(bloodSugarProvider);

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        title: Text(
          l10n.bsHistoryTitle,
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
              MaterialPageRoute(builder: (_) => const BloodSugarInput()),
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
                message: l10n.bsHistoryEmpty,
                onAdd: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BloodSugarInput()),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(kSpaceMD),
                children: [
                  // ── Latest reading + A1C estimate ─────────────────────────
                  _LatestReadingCard(
                    records: records,
                    onAdd: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BloodSugarInput()),
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
                        Text(l10n.bsTrendTitle, style: labelStyle(context)),
                        const SizedBox(height: kSpaceMD),
                        GlucoseTrendChart(records: records),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),

                  // ── Reading list ──────────────────────────────────────────
                  Text(l10n.bsReadingsTitle, style: labelStyle(context)),
                  const SizedBox(height: kSpaceSM),
                  ...records.map(
                    (record) => _ReadingTile(
                      record: record,
                      onDismissed: () => ref
                          .read(bloodSugarProvider.notifier)
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

  final List<BloodSugarRecord> records;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final latest = records.first;
    final actualA1c = A1CEstimator.fromRecords(records
            .where((r) => r.measurementType == GlucoseMeasurementType.fasting)
            .toList()) ??
        A1CEstimator.fromRecords(records);

    return Container(
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: DynamicColors.border(context)),
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: '${latest.glucoseLevel}',
              style: kNumberTextStyle.copyWith(
                color: _statusColor(context, latest.status),
              ),
              children: [
                TextSpan(
                  text: ' mg/dL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: DynamicColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kSpaceSM),
          _StatusChip(status: latest.status),
          const SizedBox(height: kSpaceLG),
          if (actualA1c != null)
            Container(
              padding: const EdgeInsets.all(kSpaceMD),
              decoration: BoxDecoration(
                color: DynamicColors.cardAlt(context),
                borderRadius: BorderRadius.circular(kRadiusMD),
              ),
              child: Row(
                children: [
                  const Icon(Icons.science_outlined, color: kAccent),
                  const SizedBox(width: kSpaceMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.bsEstimatedA1c}: '
                          '${actualA1c.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: DynamicColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          l10n.bsA1cDisclosure,
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
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BloodSugarStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context, status);
    final label = switch (status) {
      BloodSugarStatus.normal => 'Normal',
      BloodSugarStatus.prediabetes => 'Prediabetes',
      BloodSugarStatus.diabetes => 'Diabetes',
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

  final BloodSugarRecord record;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context, record.status);
    final formatter = DateFormat('EEE, MMM d • HH:mm');
    final typeLabel = switch (record.measurementType) {
      GlucoseMeasurementType.fasting => 'Fasting',
      GlucoseMeasurementType.postMeal => 'Post-meal',
      GlucoseMeasurementType.random => 'Random',
    };

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
                    '${record.glucoseLevel} mg/dL',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    typeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w700,
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
                if (record.mealContext != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      record.mealContext!,
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

Color _statusColor(BuildContext context, BloodSugarStatus status) =>
    switch (status) {
      BloodSugarStatus.normal => kNormalColor,
      BloodSugarStatus.prediabetes => kWarningColor,
      BloodSugarStatus.diabetes => kObeseIColor,
    };

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
              Icons.water_drop_outlined,
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
