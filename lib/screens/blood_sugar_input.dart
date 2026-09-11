import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/blood_sugar_record.dart';
import '../providers/blood_sugar_provider.dart';
import '../providers/session_provider.dart';
import 'blood_sugar_history.dart';

class BloodSugarInput extends ConsumerStatefulWidget {
  const BloodSugarInput({super.key});

  @override
  ConsumerState<BloodSugarInput> createState() => _BloodSugarInputState();
}

class _BloodSugarInputState extends ConsumerState<BloodSugarInput> {
  int _glucoseLevel = 100;
  GlucoseMeasurementType _type = GlucoseMeasurementType.fasting;
  String? _mealContext;
  String? _notes;
  bool _saving = false;

  BloodSugarStatus get _status => BloodSugarRecord(
        id: 'preview',
        userId: 'preview',
        glucoseLevel: _glucoseLevel,
        measurementType: _type,
        measurementTime: DateTime.now(),
      ).status;

  Color _statusColor(BloodSugarStatus s) => switch (s) {
        BloodSugarStatus.normal => kNormalColor,
        BloodSugarStatus.prediabetes => kWarningColor,
        BloodSugarStatus.diabetes => kObeseIColor,
      };

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final session = ref.read(sessionProvider);
    final userId = session.userId;
    if (userId == null) return;

    final record = BloodSugarRecord(
      id: const Uuid().v4(),
      userId: userId,
      glucoseLevel: _glucoseLevel,
      measurementType: _type,
      mealContext: _mealContext,
      measurementTime: DateTime.now(),
      notes: _notes?.trim().isEmpty ?? true ? null : _notes!.trim(),
    );

    setState(() => _saving = true);
    await ref.read(bloodSugarProvider.notifier).addRecord(record);
    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.bsSaved),
        backgroundColor: kSuccessColor,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BloodSugarHistory()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = _status;
    final statusColor = _statusColor(status);

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        title: Text(
          l10n.bsTitle,
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
              MaterialPageRoute(builder: (_) => const BloodSugarHistory()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Live status badge ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kSpaceMD, vertical: kSpaceSM),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(kRadiusMD),
                border: Border.all(color: statusColor.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop_outlined, color: statusColor),
                  const SizedBox(width: kSpaceSM),
                  Text(
                    l10n.bsStatusLabel,
                    style: TextStyle(
                      color: DynamicColors.textSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: kSpaceXS),
                  Text(
                    _statusLabel(l10n, status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Glucose level ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(kSpaceLG),
              decoration: BoxDecoration(
                color: DynamicColors.card(context),
                borderRadius: BorderRadius.circular(kRadiusLG),
                border: Border.all(color: DynamicColors.border(context)),
              ),
              child: Column(
                children: [
                  Text(l10n.bsLevel, style: labelStyle(context)),
                  const SizedBox(height: kSpaceSM),
                  Text(
                    '$_glucoseLevel',
                    style: kBMITextStyle.copyWith(
                      color: statusColor,
                      fontSize: 72,
                    ),
                  ),
                  Text(
                    'mg/dL',
                    style: TextStyle(
                      color: DynamicColors.textSecondary(context),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: kSpaceMD),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: statusColor,
                      thumbColor: statusColor,
                      inactiveTrackColor: statusColor.withOpacity(0.2),
                      overlayColor: statusColor.withOpacity(0.15),
                      trackHeight: 8,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 14),
                    ),
                    child: Slider(
                      value: _glucoseLevel.toDouble().clamp(40, 600),
                      min: 40,
                      max: 600,
                      divisions: 560,
                      label: '$_glucoseLevel mg/dL',
                      onChanged: (v) =>
                          setState(() => _glucoseLevel = v.round()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceMD),

            // ── Measurement type ────────────────────────────────────────────
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
                  Text(l10n.bsTypeLabel, style: labelStyle(context)),
                  const SizedBox(height: kSpaceMD),
                  Row(
                    children: [
                      _TypeChip(
                        label: l10n.bsTypeFasting,
                        selected: _type == GlucoseMeasurementType.fasting,
                        onTap: () => setState(
                            () => _type = GlucoseMeasurementType.fasting),
                      ),
                      const SizedBox(width: kSpaceSM),
                      _TypeChip(
                        label: l10n.bsTypePostMeal,
                        selected: _type == GlucoseMeasurementType.postMeal,
                        onTap: () => setState(
                            () => _type = GlucoseMeasurementType.postMeal),
                      ),
                      const SizedBox(width: kSpaceSM),
                      _TypeChip(
                        label: l10n.bsTypeRandom,
                        selected: _type == GlucoseMeasurementType.random,
                        onTap: () => setState(
                            () => _type = GlucoseMeasurementType.random),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSpaceMD),
                  DropdownButtonFormField<String>(
                    value: _mealContext,
                    decoration: InputDecoration(
                      labelText: l10n.bsMealContext,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kRadiusSM),
                      ),
                    ),
                    items: [
                      l10n.bsMealBeforeBreakfast,
                      l10n.bsMealAfterBreakfast,
                      l10n.bsMealBeforeLunch,
                      l10n.bsMealAfterLunch,
                      l10n.bsMealBeforeDinner,
                      l10n.bsMealAfterDinner,
                      l10n.bsMealBedtime,
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _mealContext = v),
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
                  Text(l10n.bsNotes, style: labelStyle(context)),
                  const SizedBox(height: kSpaceSM),
                  TextField(
                    maxLines: 3,
                    onChanged: (v) => setState(() => _notes = v),
                    decoration: InputDecoration(
                      hintText: l10n.bsNotesHint,
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
                        l10n.bsSave,
                        style: kLargeButtonTextStyle,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, BloodSugarStatus s) => switch (s) {
        BloodSugarStatus.normal => l10n.bsStatusNormal,
        BloodSugarStatus.prediabetes => l10n.bsStatusPrediabetes,
        BloodSugarStatus.diabetes => l10n.bsStatusDiabetes,
      };
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: kSpaceSM),
          decoration: BoxDecoration(
            color: selected ? kAccent : DynamicColors.cardAlt(context),
            borderRadius: BorderRadius.circular(kRadiusMD),
            border: Border.all(
              color: selected ? kAccent : DynamicColors.border(context),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : DynamicColors.textSecondary(context),
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
