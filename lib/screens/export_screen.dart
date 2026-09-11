import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';
import '../models/bmi_record.dart';
import '../providers/blood_pressure_provider.dart';
import '../providers/blood_sugar_provider.dart';
import '../providers/bmi_records_provider.dart';
import '../providers/export_controller_provider.dart';
import '../services/export_format.dart';
import '../services/export_service.dart';
import '../services/export_share_service.dart';

/// Sprint 3.2 Week 23 — Export UI integration.
///
/// Allows the user to choose export format (CSV/PDF), date range, and which
/// metrics to include, then share the generated report via the platform share
/// sheet. The screen is intentionally self-contained so it can be pushed from
/// any screen that has health records to share.
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(exportControllerProvider);
    final controller = ref.read(exportControllerProvider.notifier);

    final bmiAsync = ref.watch(bmiRecordsProvider);
    final bpAsync = ref.watch(bloodPressureProvider);
    final glucoseAsync = ref.watch(bloodSugarProvider);

    final bmiRecords = bmiAsync.value ?? const <BmiRecord>[];
    final bpRecords = bpAsync.value ?? const <BloodPressureRecord>[];
    final glucoseRecords = glucoseAsync.value ?? const <BloodSugarRecord>[];

    final isLoading =
        bmiAsync.isLoading || bpAsync.isLoading || glucoseAsync.isLoading || state.isGenerating;

    final preview = controller.preview(
      bmiRecords: bmiRecords,
      bpRecords: bpRecords,
      glucoseRecords: glucoseRecords,
    );

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.surface(context),
        elevation: 0,
        centerTitle: false,
        title: Text(
          l10n.exportTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        iconTheme: IconThemeData(color: DynamicColors.textPrimary(context)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: DynamicColors.border(context)),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(kSpaceMD),
          children: [
            _Subtitle(l10n.exportSubtitle),
            const SizedBox(height: kSpaceLG),

            // ── Format selector ───────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(l10n.exportFormatLabel),
                  const SizedBox(height: kSpaceSM),
                  Row(
                    children: [
                      _FormatChip(
                        label: 'PDF',
                        icon: Icons.picture_as_pdf,
                        selected: state.format == ExportFormat.pdf,
                        onTap: () => controller.setFormat(ExportFormat.pdf),
                      ),
                      const SizedBox(width: kSpaceSM),
                      _FormatChip(
                        label: 'CSV',
                        icon: Icons.table_chart,
                        selected: state.format == ExportFormat.csv,
                        onTap: () => controller.setFormat(ExportFormat.csv),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Metrics selector ──────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Metrics to include'),
                  const SizedBox(height: kSpaceSM),
                  _MetricTile(
                    label: 'BMI & Weight',
                    icon: Icons.monitor_weight_outlined,
                    count: preview.bmiCount,
                    selected: state.selectedMetrics.contains(ExportMetric.bmi),
                    onTap: () => controller.toggleMetric(ExportMetric.bmi),
                  ),
                  _MetricTile(
                    label: 'Blood Pressure',
                    icon: Icons.favorite_outline,
                    count: preview.bpCount,
                    selected: state.selectedMetrics
                        .contains(ExportMetric.bloodPressure),
                    onTap: () => controller.toggleMetric(ExportMetric.bloodPressure),
                  ),
                  _MetricTile(
                    label: 'Blood Glucose',
                    icon: Icons.water_drop_outlined,
                    count: preview.glucoseCount,
                    selected: state.selectedMetrics
                        .contains(ExportMetric.glucose),
                    onTap: () => controller.toggleMetric(ExportMetric.glucose),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Date range ─────────────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Date range'),
                  const SizedBox(height: kSpaceSM),
                  Row(
                    children: [
                      Expanded(
                        child: _DateField(
                          label: 'From',
                          date: _startDate,
                          onCleared: () {
                            setState(() => _startDate = null);
                            controller.setDateRange(null, _endDate);
                          },
                          onPicked: (value) {
                            setState(() => _startDate = value);
                            controller.setDateRange(value, _endDate);
                          },
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: _DateField(
                          label: 'To',
                          date: _endDate,
                          onCleared: () {
                            setState(() => _endDate = null);
                            controller.setDateRange(_startDate, null);
                          },
                          onPicked: (value) {
                            setState(() => _endDate = value);
                            controller.setDateRange(_startDate, value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Options ────────────────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    activeColor: kAccent,
                    title: Text(
                      l10n.exportAnonymizeLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: DynamicColors.textPrimary(context),
                      ),
                    ),
                    subtitle: Text(
                      l10n.exportAnonymizeSub,
                      style: TextStyle(
                        fontSize: 12,
                        color: DynamicColors.textSecondary(context),
                      ),
                    ),
                    value: state.anonymize,
                    onChanged: (value) => controller.setAnonymize(value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Preview ─────────────────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Preview'),
                  const SizedBox(height: kSpaceSM),
                  _PreviewRow(label: 'BMI records', value: '${preview.bmiCount}'),
                  _PreviewRow(label: 'BP records', value: '${preview.bpCount}'),
                  _PreviewRow(
                      label: 'Glucose records', value: '${preview.glucoseCount}'),
                  if (preview.latestBmi != null)
                    _PreviewRow(label: 'Latest BMI', value: preview.latestBmi!),
                  if (preview.trend != null)
                    _PreviewRow(label: 'Trend', value: preview.trend!),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: kSpaceSM),
                child: Text(
                  state.error!,
                  style: const TextStyle(color: kErrorColor, fontSize: 13),
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : () => _onShare(context),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.share, size: 18),
                label: Text(l10n.exportShareBtn),
              ),
            ),
            const SizedBox(height: kSpaceLG),
          ],
        ),
      ),
    );
  }

  Future<void> _onShare(BuildContext context) async {
    final controller = ref.read(exportControllerProvider.notifier);
    final bmiAsync = ref.read(bmiRecordsProvider);
    final bpAsync = ref.read(bloodPressureProvider);
    final glucoseAsync = ref.read(bloodSugarProvider);

    try {
      final payload = await controller.generate(
        bmiRecords: bmiAsync.value ?? const [],
        bpRecords: bpAsync.value ?? const [],
        glucoseRecords: glucoseAsync.value ?? const [],
      );

      final result = payload.bytes != null
          ? await ExportShareService.shareBytes(
              bytes: Uint8List.fromList(payload.bytes!),
              fileName: payload.fileName,
              subject: payload.title,
            )
          : await ExportShareService.shareText(
              text: payload.text!,
              fileName: payload.fileName,
              subject: payload.title,
            );

      if (result.status == ShareResultStatus.dismissed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Share cancelled.')),
        );
      }
    } on StateError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }
}

// ─── Widgets ─────────────────────────────────────────────────────────────────

class _Subtitle extends StatelessWidget {
  final String text;
  const _Subtitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: DynamicColors.textSecondary(context),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: DynamicColors.textPrimary(context),
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FormatChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? kAccent : DynamicColors.cardAlt(context);
    final fg = selected ? Colors.white : DynamicColors.textPrimary(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kRadiusMD),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(kRadiusMD),
            border: Border.all(
              color: selected ? kAccent : DynamicColors.border(context),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _MetricTile({
    required this.label,
    required this.icon,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kRadiusMD),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected
                    ? kAccent.withValues(alpha: 0.12)
                    : DynamicColors.cardAlt(context),
                borderRadius: BorderRadius.circular(kRadiusSM),
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected ? kAccent : DynamicColors.textSecondary(context),
              ),
            ),
            const SizedBox(width: kSpaceSM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    '$count records',
                    style: TextStyle(
                      fontSize: 12,
                      color: DynamicColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Checkbox.adaptive(
              value: selected,
              onChanged: (_) => onTap(),
              activeColor: kAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onCleared;
  final ValueChanged<DateTime> onPicked;

  const _DateField({
    required this.label,
    required this.date,
    required this.onCleared,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    final display = date == null
        ? label
        : DateFormat('MMM d, y').format(date!);
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final initial = date ?? now;
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(now.year - 5),
          lastDate: now,
        );
        if (picked != null) onPicked(picked);
      },
      borderRadius: BorderRadius.circular(kRadiusMD),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: DynamicColors.cardAlt(context),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: DynamicColors.border(context)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              display,
              style: TextStyle(
                fontSize: 13,
                color: date == null
                    ? DynamicColors.textSecondary(context)
                    : DynamicColors.textPrimary(context),
              ),
            ),
            if (date != null)
              GestureDetector(
                onTap: onCleared,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: DynamicColors.textSecondary(context),
                ),
              )
            else
              Icon(
                Icons.calendar_today,
                size: 16,
                color: DynamicColors.textSecondary(context),
              ),
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _PreviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: DynamicColors.textSecondary(context),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: DynamicColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
