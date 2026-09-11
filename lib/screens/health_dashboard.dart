import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';
import '../models/bmi_record.dart';
import '../providers/blood_pressure_provider.dart';
import '../providers/blood_sugar_provider.dart';
import '../providers/bmi_records_provider.dart';
import '../providers/wearable_provider.dart';
import '../services/health_score_service.dart';
import '../widgets/bp_gauge.dart';
import '../widgets/correlation_chart.dart';
import '../widgets/glucose_trend_chart.dart';
import '../widgets/health_score_gauge.dart';
import '../widgets/metric_summary_card.dart';

/// Sprint 1.4 — Comprehensive health dashboard.
///
/// Aggregates BMI, blood pressure, blood sugar, and advanced body metrics into
/// a weighted health score (BMI 30% · BP 25% · Glucose 25% · Advanced 20%),
/// with per-metric trend sparklines and a BMI↔glucose correlation view.
class HealthDashboard extends ConsumerWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bmiAsync = ref.watch(bmiRecordsProvider);
    final bpAsync = ref.watch(bloodPressureProvider);
    final glucoseAsync = ref.watch(bloodSugarProvider);

    final bmiRecords = bmiAsync.value ?? const <BmiRecord>[];
    final bpRecords = bpAsync.value ?? const <BloodPressureRecord>[];
    final glucoseRecords = glucoseAsync.value ?? const <BloodSugarRecord>[];

    final latestBmi = bmiRecords.isNotEmpty ? bmiRecords.first.bmiValue : null;
    final latestBp = bpRecords.isNotEmpty ? bpRecords.first : null;
    final latestGlucose =
        glucoseRecords.isNotEmpty ? glucoseRecords.first : null;
    final latestWhtr = bmiRecords.isNotEmpty && bmiRecords.first.waistCm != null
        ? bmiRecords.first.waistCm! / bmiRecords.first.height
        : null;
    final latestRestingHr =
        bmiRecords.isNotEmpty ? bmiRecords.first.restingHeartRate : null;

    // ── Health score ──────────────────────────────────────────────────────────
    final result = HealthScoreService.compute(
      latestBmi: latestBmi,
      bpCategory: latestBp?.category,
      glucoseStatus: latestGlucose?.status,
      latestWhtr: latestWhtr,
      restingHeartRate: latestRestingHr,
    );
    final recs = HealthScoreService.recommendations(
      latestBmi: latestBmi,
      bpCategory: latestBp?.category,
      glucoseStatus: latestGlucose?.status,
      latestWhtr: latestWhtr,
      restingHeartRate: latestRestingHr,
    );

    return RefreshIndicator(
      onRefresh: () => _refreshAll(ref),
      child: ListView(
        padding: const EdgeInsets.all(kSpaceMD),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // ── Hero: health score ───────────────────────────────────────────
          Card(
            elevation: 0,
            color: DynamicColors.card(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusLG),
              side: BorderSide(color: DynamicColors.border(context)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kSpaceMD, vertical: kSpaceLG),
              child: Column(
                children: [
                  Text(
                    l10n.healthScoreTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: kSpaceSM),
                  HealthScoreGauge(score: result.score, label: result.label),
                  if (result.label != null) ...[
                    const SizedBox(height: kSpaceSM),
                    Text(
                      _scoreLabel(context, result.label!),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: getHealthScoreColor(result.label),
                      ),
                    ),
                  ],
                  const SizedBox(height: kSpaceSM),
                  Text(
                    result.score == null
                        ? l10n.healthScoreNoData
                        : _scoreBreakdown(context, result),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: DynamicColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kSpaceMD),

          // ── Metric summary tiles ─────────────────────────────────────────
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: kSpaceSM,
            crossAxisSpacing: kSpaceSM,
            childAspectRatio: 1.35,
            children: [
              MetricSummaryCard(
                icon: Icons.monitor_weight_outlined,
                title: l10n.dashboardBmi,
                value: latestBmi != null ? latestBmi.toStringAsFixed(1) : '--',
                subtitle: latestBmi != null
                    ? _bmiLabelFromValue(context, latestBmi)
                    : l10n.healthScoreNoData,
                color: kAccent,
                sparkline:
                    _chronological(bmiRecords.map((r) => r.bmiValue).toList()),
              ),
              MetricSummaryCard(
                icon: Icons.favorite_outline,
                title: l10n.dashboardBp,
                value: latestBp != null
                    ? '${latestBp.systolic}/${latestBp.diastolic}'
                    : '--',
                subtitle: latestBp != null
                    ? _bpLabel(context, latestBp)
                    : l10n.healthScoreNoData,
                color: kNormalColor,
                sparkline: _chronological(
                    bpRecords.map((r) => r.systolic.toDouble()).toList()),
              ),
              MetricSummaryCard(
                icon: Icons.water_drop_outlined,
                title: l10n.dashboardGlucose,
                value: latestGlucose != null
                    ? '${latestGlucose.glucoseLevel} mg/dL'
                    : '--',
                subtitle: latestGlucose != null
                    ? _glucoseLabel(context, latestGlucose)
                    : l10n.healthScoreNoData,
                color: kWarningColor,
                sparkline: _chronological(glucoseRecords
                    .map((r) => r.glucoseLevel.toDouble())
                    .toList()),
              ),
              MetricSummaryCard(
                icon: Icons.straighten,
                title: l10n.dashboardAdvanced,
                value:
                    latestWhtr != null ? latestWhtr.toStringAsFixed(2) : '--',
                subtitle: latestRestingHr != null
                    ? '${latestRestingHr} bpm'
                    : (latestWhtr != null
                        ? l10n.dashboardWhtr
                        : l10n.healthScoreNoData),
                color: kInfoColor,
                sparkline: _chronological([
                  for (final r in bmiRecords)
                    if (r.waistCm != null) r.waistCm! / r.height,
                ]),
              ),
            ],
          ),
          const SizedBox(height: kSpaceLG),

          // ── Export action (Sprint 3.2 Week 23) ────────────────────────────
          _ExportActionCard(),
          const SizedBox(height: kSpaceLG),

          // ── Wearable data (Sprint 3.1) ───────────────────────────────────
          const _WearableSection(),
          const SizedBox(height: kSpaceLG),

          // ── Pillar breakdown ──────────────────────────────────────────────
          _sectionHeader(context, l10n.healthScorePillars),
          const SizedBox(height: kSpaceSM),
          _pillarTile(
            context,
            icon: Icons.monitor_weight_outlined,
            label: l10n.dashboardBmi,
            score: result.bmiScore,
          ),
          _pillarTile(
            context,
            icon: Icons.favorite_outline,
            label: l10n.dashboardBp,
            score: result.bpScore,
          ),
          _pillarTile(
            context,
            icon: Icons.water_drop_outlined,
            label: l10n.dashboardGlucose,
            score: result.glucoseScore,
          ),
          _pillarTile(
            context,
            icon: Icons.straighten,
            label: l10n.dashboardAdvanced,
            score: result.advancedScore,
          ),
          const SizedBox(height: kSpaceLG),

          // ── Correlation: BMI ↔ glucose ───────────────────────────────────
          if (bmiRecords.isNotEmpty && glucoseRecords.isNotEmpty) ...[
            _sectionHeader(context, l10n.dashboardCorrelationTitle),
            const SizedBox(height: kSpaceSM),
            Card(
              elevation: 0,
              color: DynamicColors.card(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadiusLG),
                side: BorderSide(color: DynamicColors.border(context)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(kSpaceMD),
                child: CorrelationChart(
                  seriesA: _dateValues(
                      bmiRecords.map((r) => (r.timestamp, r.bmiValue))),
                  seriesB: _dateValues(glucoseRecords.map(
                      (r) => (r.measurementTime, r.glucoseLevel.toDouble()))),
                  labelA: l10n.dashboardBmi,
                  labelB: l10n.dashboardGlucose,
                  colorA: kAccent,
                  colorB: kWarningColor,
                ),
              ),
            ),
            const SizedBox(height: kSpaceLG),
          ],

          // ── Personalized recommendations ──────────────────────────────────
          _sectionHeader(context, l10n.healthScoreRecommendations),
          const SizedBox(height: kSpaceSM),
          ...recs.map((r) => _recommendationCard(context, r)),
          const SizedBox(height: kSpaceLG),

          // ── Latest BP gauge ───────────────────────────────────────────────
          if (bpRecords.isNotEmpty) ...[
            _sectionHeader(context, l10n.dashboardRecentBp),
            const SizedBox(height: kSpaceSM),
            Card(
              elevation: 0,
              color: DynamicColors.card(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadiusLG),
                side: BorderSide(color: DynamicColors.border(context)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(kSpaceMD),
                child: BpGauge(
                  systolic: bpRecords.first.systolic,
                  diastolic: bpRecords.first.diastolic,
                  size: 180,
                ),
              ),
            ),
            const SizedBox(height: kSpaceLG),
          ],

          // ── Glucose trend ─────────────────────────────────────────────────
          if (glucoseRecords.length > 1) ...[
            _sectionHeader(context, l10n.dashboardRecentGlucose),
            const SizedBox(height: kSpaceSM),
            Card(
              elevation: 0,
              color: DynamicColors.card(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadiusLG),
                side: BorderSide(color: DynamicColors.border(context)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(kSpaceMD),
                child: GlucoseTrendChart(
                  records: glucoseRecords,
                  height: 180,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _pillarTile(BuildContext context,
      {required IconData icon, required String label, required double? score}) {
    final l10n = AppLocalizations.of(context);
    final color = score != null
        ? getHealthScoreColor(HealthScoreService.labelForScore(score))
        : DynamicColors.textSecondary(context);
    return Card(
      elevation: 0,
      color: DynamicColors.cardAlt(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        side: BorderSide(color: DynamicColors.border(context)),
      ),
      margin: const EdgeInsets.only(bottom: kSpaceSM),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(kRadiusSM),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        trailing: Text(
          score != null ? '${score.round()}/100' : '--',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        subtitle: score == null
            ? Text(
                l10n.healthScoreNoData,
                style: TextStyle(
                  fontSize: 12,
                  color: DynamicColors.textSecondary(context),
                ),
              )
            : null,
      ),
    );
  }

  Widget _recommendationCard(
      BuildContext context, PersonalizedRecommendation rec) {
    final l10n = AppLocalizations.of(context);
    final (icon, title, detail) = switch (rec.category) {
      RecommendationCategory.healthyWeight => (
          Icons.monitor_weight_outlined,
          l10n.recHealthyWeight,
          l10n.recHealthyWeightDetail,
        ),
      RecommendationCategory.hypertension => (
          Icons.favorite_outline,
          l10n.recHypertension,
          l10n.recHypertensionDetail,
        ),
      RecommendationCategory.glucoseControl => (
          Icons.water_drop_outlined,
          l10n.recGlucose,
          l10n.recGlucoseDetail,
        ),
      RecommendationCategory.cardioFitness => (
          Icons.directions_run,
          l10n.recCardio,
          l10n.recCardioDetail,
        ),
      RecommendationCategory.waistReduction => (
          Icons.straighten,
          l10n.recWaist,
          l10n.recWaistDetail,
        ),
      RecommendationCategory.onTrack => (
          Icons.thumb_up_alt_outlined,
          l10n.recOnTrack,
          l10n.recOnTrackDetail,
        ),
    };
    return Card(
      elevation: 0,
      color: DynamicColors.card(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        side: BorderSide(color: DynamicColors.border(context)),
      ),
      margin: const EdgeInsets.only(bottom: kSpaceSM),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kAccent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(kRadiusSM),
          ),
          child: Icon(icon, size: 18, color: kAccent),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        subtitle: Text(
          detail,
          style: TextStyle(
            fontSize: 12,
            color: DynamicColors.textSecondary(context),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) => Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: DynamicColors.textPrimary(context),
        ),
      );

  String _scoreLabel(BuildContext context, HealthScoreLabel label) {
    final l10n = AppLocalizations.of(context);
    return switch (label) {
      HealthScoreLabel.excellent => l10n.scoreExcellent,
      HealthScoreLabel.veryGood => l10n.scoreVeryGood,
      HealthScoreLabel.good => l10n.scoreGood,
      HealthScoreLabel.fair => l10n.scoreFair,
      HealthScoreLabel.needsImprovement => l10n.scoreNeedsImprovement,
    };
  }

  String _scoreBreakdown(BuildContext context, HealthScoreResult result) {
    final l10n = AppLocalizations.of(context);
    final parts = <String>[
      if (result.bmiScore != null)
        '${l10n.dashboardBmi} ${result.bmiScore!.round()}',
      if (result.bpScore != null)
        '${l10n.dashboardBp} ${result.bpScore!.round()}',
      if (result.glucoseScore != null)
        '${l10n.dashboardGlucose} ${result.glucoseScore!.round()}',
      if (result.advancedScore != null)
        '${l10n.dashboardAdvanced} ${result.advancedScore!.round()}',
    ];
    return parts.join(' · ');
  }

  String _bmiLabelFromValue(BuildContext context, double bmi) {
    final l10n = AppLocalizations.of(context);
    if (bmi < 16.0) return l10n.bmiSeverelyUnderweight;
    if (bmi < 18.5) return l10n.bmiUnderweight;
    if (bmi < 25.0) return l10n.bmiNormalWeight;
    if (bmi < 30.0) return l10n.bmiOverweight;
    if (bmi < 35.0) return l10n.bmiObeseI;
    if (bmi < 40.0) return l10n.bmiObeseII;
    return l10n.bmiSeverelyObese;
  }

  String _bpLabel(BuildContext context, BloodPressureRecord r) {
    final l10n = AppLocalizations.of(context);
    return switch (r.category) {
      BloodPressureCategory.normal => l10n.bpCategoryNormal,
      BloodPressureCategory.elevated => l10n.bpCategoryElevated,
      BloodPressureCategory.stage1 => l10n.bpCategoryStage1,
      BloodPressureCategory.stage2 => l10n.bpCategoryStage2,
      BloodPressureCategory.crisis => l10n.bpCategoryCrisis,
    };
  }

  String _glucoseLabel(BuildContext context, BloodSugarRecord r) {
    final l10n = AppLocalizations.of(context);
    return switch (r.status) {
      BloodSugarStatus.normal => l10n.bsStatusNormal,
      BloodSugarStatus.prediabetes => l10n.bsStatusPrediabetes,
      BloodSugarStatus.diabetes => l10n.bsStatusDiabetes,
    };
  }

  List<double> _chronological(List<double> values) => values.reversed.toList();

  List<DateTimeValue> _dateValues(Iterable<(DateTime, double)> pairs) =>
      [for (final (t, v) in pairs) DateTimeValue(t, v)];

  Future<void> _refreshAll(WidgetRef ref) async {
    await Future.wait([
      ref.read(bmiRecordsProvider.notifier).refresh(),
      ref.read(bloodPressureProvider.notifier).refresh(),
      ref.read(bloodSugarProvider.notifier).refresh(),
    ]);
  }
}

/// One-tap card that navigates to the export/share screen.
class _ExportActionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      color: DynamicColors.card(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusLG),
        side: BorderSide(color: DynamicColors.border(context)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kAccent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(kRadiusSM),
          ),
          child: const Icon(Icons.share, color: kAccent, size: 20),
        ),
        title: Text(
          l10n.exportTitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        subtitle: Text(
          l10n.exportSubtitle,
          style: TextStyle(
            fontSize: 12,
            color: DynamicColors.textSecondary(context),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: DynamicColors.textSecondary(context),
        ),
        onTap: () => Navigator.pushNamed(context, '/export'),
      ),
    );
  }
}

/// Wearable / health-platform integration card (Sprint 3.1 Week 19).
///
/// Shows the last-24h wearable snapshot (steps + latest vitals) when connected
/// and offers an "Import to history" action that pushes BP/glucose reads into
/// the app's records. Tapping the link icon opens the wearable settings screen.
class _WearableSection extends ConsumerWidget {
  const _WearableSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final w = ref.watch(wearableProvider);

    final state = w.value;
    final connected = state?.permissionGranted ?? false;
    final snapshot = state?.snapshot;

    return Card(
      elevation: 0,
      color: DynamicColors.card(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusLG),
        side: BorderSide(color: DynamicColors.border(context)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              connected ? Icons.monitor_heart : Icons.monitor_heart_outlined,
              color: connected ? kAccent : DynamicColors.textSecondary(context),
            ),
            title: Text(
              l10n.wearableTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: DynamicColors.textPrimary(context),
              ),
            ),
            subtitle: Text(
              connected
                  ? (snapshot == null
                      ? l10n.wearableGrantedSubtitle
                      : '${snapshot.totalSteps} steps')
                  : l10n.wearableDryRun,
              style: TextStyle(color: DynamicColors.textSecondary(context)),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: l10n.wearableTitle,
              onPressed: () => Navigator.pushNamed(context, '/wearable'),
            ),
          ),
          if (connected && snapshot != null)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(kSpaceMD, 0, kSpaceMD, kSpaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: DynamicColors.border(context), height: 1),
                  const SizedBox(height: kSpaceSM),
                  Wrap(
                    spacing: kSpaceLG,
                    runSpacing: kSpaceSM,
                    children: [
                      _WearableStat(
                        label: l10n.metricSteps,
                        value: snapshot.totalSteps.toString(),
                        icon: Icons.directions_walk,
                      ),
                      if (snapshot.latestWeightKg != null)
                        _WearableStat(
                          label: l10n.metricWeight,
                          value:
                              '${snapshot.latestWeightKg!.toStringAsFixed(1)} kg',
                          icon: Icons.monitor_weight_outlined,
                        ),
                      if (snapshot.latestSystolic != null &&
                          snapshot.latestDiastolic != null)
                        _WearableStat(
                          label: l10n.metricBloodPressure,
                          value:
                              '${snapshot.latestSystolic!.round()}/${snapshot.latestDiastolic!.round()}',
                          icon: Icons.monitor_heart,
                        ),
                      if (snapshot.latestGlucoseMgdl != null)
                        _WearableStat(
                          label: l10n.metricGlucose,
                          value: '${snapshot.latestGlucoseMgdl!.round()} mg/dL',
                          icon: Icons.water_drop_outlined,
                        ),
                    ],
                  ),
                  const SizedBox(height: kSpaceSM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (state!.lastImportedRecords > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: kSpaceSM),
                          child: Text(
                            '${state.lastImportedRecords} imported',
                            style: TextStyle(
                              fontSize: 12,
                              color: kNormalColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      TextButton.icon(
                        icon: const Icon(Icons.download_done, size: 18),
                        label: Text(l10n.wearableImportBtn),
                        onPressed: () async {
                          final count = await ref
                              .read(wearableProvider.notifier)
                              .importRecords();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                count > 0
                                    ? l10n.wearableImportSuccess(count)
                                    : l10n.wearableImportNothing,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _WearableStat extends StatelessWidget {
  const _WearableStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: DynamicColors.textSecondary(context)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: DynamicColors.textPrimary(context),
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
      ],
    );
  }
}
