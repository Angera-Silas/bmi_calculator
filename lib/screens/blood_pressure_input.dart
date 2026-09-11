import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/blood_pressure_record.dart';
import '../providers/blood_pressure_provider.dart';
import '../providers/session_provider.dart';
import '../widgets/bp_gauge.dart';
import 'blood_pressure_history.dart';

class BloodPressureInput extends ConsumerStatefulWidget {
  const BloodPressureInput({super.key});

  @override
  ConsumerState<BloodPressureInput> createState() => _BloodPressureInputState();
}

class _BloodPressureInputState extends ConsumerState<BloodPressureInput> {
  int _systolic = 120;
  int _diastolic = 80;
  int? _pulse;
  final _notesController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  BloodPressureCategory get _category => BloodPressureRecord(
        id: 'preview',
        userId: 'preview',
        systolic: _systolic,
        diastolic: _diastolic,
        measurementTime: DateTime.now(),
      ).category;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final session = ref.read(sessionProvider);
    final userId = session.userId;
    if (userId == null) return;

    final record = BloodPressureRecord(
      id: const Uuid().v4(),
      userId: userId,
      systolic: _systolic,
      diastolic: _diastolic,
      pulse: _pulse,
      measurementTime: DateTime.now(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    setState(() => _saving = true);
    await ref.read(bloodPressureProvider.notifier).addRecord(record);
    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.bpSaved),
        backgroundColor: kSuccessColor,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BloodPressureHistory()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final category = _category;
    final categoryColor = getBpCategoryColor(category);

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        title: Text(
          l10n.bpTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: DynamicColors.iconColor(context)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BloodPressureHistory()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Live WHO category badge ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kSpaceMD, vertical: kSpaceSM),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(kRadiusMD),
                border: Border.all(color: categoryColor.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monitor_heart_outlined, color: categoryColor),
                  const SizedBox(width: kSpaceSM),
                  Text(
                    l10n.bpCategoryLabel,
                    style: TextStyle(
                      color: DynamicColors.textSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: kSpaceXS),
                  Text(
                    _categoryLabel(l10n, category),
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Summary readout ─────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(kSpaceLG),
              decoration: BoxDecoration(
                color: DynamicColors.card(context),
                borderRadius: BorderRadius.circular(kRadiusLG),
                border: Border.all(color: DynamicColors.border(context)),
              ),
              child: Column(
                children: [
                  Text(
                    '$_systolic / $_diastolic',
                    style: kBMITextStyle.copyWith(
                      color: DynamicColors.textPrimary(context),
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    'mmHg',
                    style: TextStyle(
                      color: DynamicColors.textSecondary(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Systolic slider ─────────────────────────────────────────────
            _buildSliderCard(
              context,
              label: l10n.bpSystolic,
              value: _systolic,
              min: 80,
              max: 220,
              color: kAccent,
              onChanged: (v) => setState(() => _systolic = v.round()),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Diastolic slider ─────────────────────────────────────────────
            _buildSliderCard(
              context,
              label: l10n.bpDiastolic,
              value: _diastolic,
              min: 40,
              max: 140,
              color: const Color(0xFF29B6F6),
              onChanged: (v) => setState(() => _diastolic = v.round()),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Pulse (optional) ────────────────────────────────────────────
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
                  Text(
                    l10n.bpPulse,
                    style: labelStyle(context),
                  ),
                  const SizedBox(height: kSpaceMD),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: l10n.bpPulseHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(kRadiusSM),
                            ),
                          ),
                          onChanged: (v) {
                            final parsed = int.tryParse(v);
                            setState(() => _pulse = parsed);
                          },
                        ),
                      ),
                      const SizedBox(width: kSpaceMD),
                      Text(
                        l10n.bpPulseUnit,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: DynamicColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Notes ───────────────────────────────────────────────────────
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
                  Text(l10n.bpNotes, style: labelStyle(context)),
                  const SizedBox(height: kSpaceSM),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l10n.bpNotesHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kRadiusSM),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceXL),

            // ── Save ────────────────────────────────────────────────────────
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: kAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadiusMD),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.bpSave,
                        style: kLargeButtonTextStyle,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard(
    BuildContext context, {
    required String label,
    required int value,
    required double min,
    required double max,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: DynamicColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: labelStyle(context)),
              Text(
                '$value mmHg',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceSM),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              thumbColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              overlayColor: color.withOpacity(0.15),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: value.toDouble().clamp(min, max),
              min: min,
              max: max,
              divisions: (max - min).round(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, BloodPressureCategory c) {
    switch (c) {
      case BloodPressureCategory.normal:
        return l10n.bpCategoryNormal;
      case BloodPressureCategory.elevated:
        return l10n.bpCategoryElevated;
      case BloodPressureCategory.stage1:
        return l10n.bpCategoryStage1;
      case BloodPressureCategory.stage2:
        return l10n.bpCategoryStage2;
      case BloodPressureCategory.crisis:
        return l10n.bpCategoryCrisis;
    }
  }
}
