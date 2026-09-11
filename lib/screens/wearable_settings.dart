import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/wearable_metric.dart';
import '../providers/wearable_provider.dart';

/// Health-data connection screen (Sprint 3.1).
///
/// Handles the Health Connect / HealthKit permission flow and shows a summary
/// of the last 24 hours of measurements once access is granted.
class WearableSettingsScreen extends ConsumerWidget {
  const WearableSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final w = ref.watch(wearableProvider);

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        title: Text(
          l10n.wearableTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: DynamicColors.textPrimary(context),
          ),
        ),
      ),
      body: w.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildError(context, l10n),
        data: (state) => state.permissionGranted
            ? _buildConnected(context, l10n, state, ref)
            : _buildConnectPrompt(context, l10n, state, ref),
      ),
    );
  }

  Widget _buildError(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kSpaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off,
                size: 56, color: DynamicColors.textSecondary(context)),
            const SizedBox(height: kSpaceMD),
            Text(
              l10n.wearableErrorGeneric,
              textAlign: TextAlign.center,
              style: TextStyle(color: DynamicColors.textSecondary(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectPrompt(BuildContext context, AppLocalizations l10n,
      WearableState state, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(kSpaceMD),
      children: [
        Card(
          color: DynamicColors.surface(context),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
            side: BorderSide(color: DynamicColors.border(context)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kSpaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.monitor_heart, color: kAccent, size: 28),
                    const SizedBox(width: kSpaceSM),
                    Expanded(
                      child: Text(
                        l10n.wearableConnectTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: DynamicColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceSM),
                Text(
                  l10n.wearableConnectSubtitle,
                  style: TextStyle(
                    color: DynamicColors.textSecondary(context),
                    height: 1.4,
                  ),
                ),
                if (state.error != null) ...[
                  const SizedBox(height: kSpaceSM),
                  Text(
                    state.error!.contains('denied')
                        ? l10n.wearableErrorPermission
                        : l10n.wearableErrorGeneric,
                    style: TextStyle(color: kErrorColor, height: 1.4),
                  ),
                ],
                const SizedBox(height: kSpaceMD),
                Row(
                  children: [
                    Expanded(
                      child: Icon(Icons.directions_walk,
                          color: DynamicColors.textSecondary(context),
                          size: 20),
                    ),
                    const SizedBox(width: kSpaceSM),
                    Expanded(
                      flex: 5,
                      child: Text(
                        l10n.wearableStepInPerm,
                        style: TextStyle(
                          fontSize: 12,
                          color: DynamicColors.textSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceMD),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () =>
                        ref.read(wearableProvider.notifier).requestAccess(),
                    icon: Icon(
                        _granting(ref) ? Icons.hourglass_empty : Icons.link),
                    label: Text(_granting(ref)
                        ? l10n.wearableGrantingBtn
                        : l10n.wearableGrantBtn),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: kSpaceMD),
        _MetricLegendCard(context: context, l10n: l10n),
      ],
    );
  }

  bool _granting(WidgetRef ref) => ref.watch(wearableProvider).isLoading;

  Widget _buildConnected(BuildContext context, AppLocalizations l10n,
      WearableState state, WidgetRef ref) {
    final snapshot = state.snapshot;
    return ListView(
      padding: const EdgeInsets.all(kSpaceMD),
      children: [
        Card(
          color: DynamicColors.surface(context),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
            side: BorderSide(color: DynamicColors.border(context)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kSpaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: kNormalColor, size: 28),
                    const SizedBox(width: kSpaceSM),
                    Expanded(
                      child: Text(
                        l10n.wearableGrantedTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: DynamicColors.textPrimary(context),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: l10n.wearableRefreshBtn,
                      onPressed: () =>
                          ref.read(wearableProvider.notifier).refresh(),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceSM),
                Text(
                  l10n.wearableGrantedSubtitle,
                  style: TextStyle(
                    color: DynamicColors.textSecondary(context),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: kSpaceMD),
        if (state.error != null)
          Card(
            color: DynamicColors.surface(context),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(kSpaceMD),
              child: Text(
                state.error!.contains('denied')
                    ? l10n.wearableErrorPermission
                    : l10n.wearableErrorGeneric,
                style: TextStyle(color: kErrorColor),
              ),
            ),
          ),
        if (snapshot == null || snapshot.samples.isEmpty)
          Card(
            color: DynamicColors.surface(context),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(kSpaceLG),
              child: Text(
                l10n.wearableDryRun,
                textAlign: TextAlign.center,
                style: TextStyle(color: DynamicColors.textSecondary(context)),
              ),
            ),
          )
        else ...[
          _buildSnapshotSection(context, l10n, snapshot),
          const SizedBox(height: kSpaceMD),
        ],
        if (state.lastImportTime != null) ...[
          _buildImportStatusBanner(context, l10n, state),
          const SizedBox(height: kSpaceMD),
        ],
        Card(
          color: DynamicColors.surface(context),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
            side: BorderSide(color: DynamicColors.border(context)),
          ),
          child: ListTile(
            leading: Icon(Icons.link_off,
                color: DynamicColors.textSecondary(context)),
            title: Text(
              l10n.wearableRevokeBtn,
              style: TextStyle(
                color: DynamicColors.textPrimary(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => ref.read(wearableProvider.notifier).revoke(),
          ),
        ),
      ],
    );
  }

  Widget _buildImportStatusBanner(
      BuildContext context, AppLocalizations l10n, WearableState state) {
    final imported = state.lastImportedRecords;
    final rejected = state.lastRejectionCount;
    final time = state.lastImportTime!;
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';

    return Card(
      color: DynamicColors.surface(context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        side: BorderSide(color: DynamicColors.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kSpaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  imported > 0
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  color: imported > 0
                      ? kNormalColor
                      : DynamicColors.textSecondary(context),
                  size: 20,
                ),
                const SizedBox(width: kSpaceSM),
                Expanded(
                  child: Text(
                    imported > 0
                        ? l10n.wearableImportSuccess(imported)
                        : l10n.wearableImportNothing,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                ),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 12,
                    color: DynamicColors.textSecondary(context),
                  ),
                ),
              ],
            ),
            if (rejected > 0) ...[
              const SizedBox(height: kSpaceXS),
              Row(
                children: [
                  const SizedBox(width: 28),
                  Icon(Icons.warning_amber_rounded,
                      color: kErrorColor, size: 16),
                  const SizedBox(width: kSpaceXS),
                  Expanded(
                    child: Text(
                      l10n.wearableValidationRejected(rejected),
                      style: TextStyle(
                        fontSize: 12,
                        color: kErrorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSnapshotSection(
      BuildContext context, AppLocalizations l10n, WearableSnapshot snapshot) {
    final rows = <_MetricRow>[
      _MetricRow(
        icon: Icons.directions_walk,
        label: l10n.metricSteps,
        value: snapshot.totalSteps > 0 ? snapshot.totalSteps.toString() : null,
      ),
      _MetricRow(
        icon: Icons.monitor_weight_outlined,
        label: l10n.metricWeight,
        value: snapshot.latestWeightKg == null
            ? null
            : '${snapshot.latestWeightKg!.toStringAsFixed(1)} kg',
      ),
      _MetricRow(
        icon: Icons.height,
        label: l10n.height,
        value: snapshot.latestHeightM == null
            ? null
            : '${(snapshot.latestHeightM! * 100).toStringAsFixed(0)} cm',
      ),
      _MetricRow(
        icon: Icons.favorite_outline,
        label: l10n.metricHeartRate,
        value: snapshot.latestHeartRateBpm == null
            ? null
            : '${snapshot.latestHeartRateBpm!.round()} bpm',
      ),
      _MetricRow(
        icon: Icons.favorite_border,
        label: l10n.metricRestingHr,
        value: snapshot.latestRestingHeartRateBpm == null
            ? null
            : '${snapshot.latestRestingHeartRateBpm!.round()} bpm',
      ),
      _MetricRow(
        icon: Icons.monitor_heart,
        label: l10n.metricBloodPressure,
        value: (snapshot.latestSystolic == null ||
                snapshot.latestDiastolic == null)
            ? null
            : '${snapshot.latestSystolic!.round()}/${snapshot.latestDiastolic!.round()}',
        unit: 'mmHg',
      ),
      _MetricRow(
        icon: Icons.water_drop_outlined,
        label: l10n.metricGlucose,
        value: snapshot.latestGlucoseMgdl == null
            ? null
            : '${snapshot.latestGlucoseMgdl!.round()}',
        unit: 'mg/dL',
      ),
      _MetricRow(
        icon: Icons.water_drop,
        label: l10n.metricWater,
        value: snapshot.latestWaterLiters == null
            ? null
            : '${snapshot.latestWaterLiters!.toStringAsFixed(2)} L',
      ),
    ];

    return Card(
      color: DynamicColors.surface(context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        side: BorderSide(color: DynamicColors.border(context)),
      ),
      child: Column(
        children: [
          for (final row in rows) ...[
            ListTile(
              dense: true,
              leading:
                  Icon(row.icon, color: DynamicColors.textSecondary(context)),
              title: Text(
                row.label,
                style: TextStyle(color: DynamicColors.textPrimary(context)),
              ),
              trailing: Text(
                row.value ?? '—',
                style: TextStyle(
                  color: row.value == null
                      ? DynamicColors.textSecondary(context)
                      : DynamicColors.textPrimary(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (row != rows.last)
              Divider(color: DynamicColors.border(context), height: 1),
          ],
        ],
      ),
    );
  }
}

class _MetricRow {
  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String? unit;
}

/// Explains which metrics are read when the user grants access.
class _MetricLegendCard extends StatelessWidget {
  const _MetricLegendCard({required this.context, required this.l10n});

  final BuildContext context;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.metricPermissions,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: kSpaceSM),
        Card(
          color: DynamicColors.surface(context),
          elevation: 0,
          child: Column(
            children: [
              _LegendRow(icon: Icons.directions_walk, label: 'Steps'),
              _LegendRow(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight & height'),
              _LegendRow(
                  icon: Icons.favorite, label: 'Heart rate (incl. rest)'),
              _LegendRow(icon: Icons.monitor_heart, label: 'Blood pressure'),
              _LegendRow(icon: Icons.water_drop_outlined, label: 'Glucose'),
              _LegendRow(icon: Icons.water_drop, label: 'Water / hydration'),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading:
          Icon(icon, color: DynamicColors.textSecondary(context), size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: DynamicColors.textPrimary(context),
        ),
      ),
    );
  }
}
