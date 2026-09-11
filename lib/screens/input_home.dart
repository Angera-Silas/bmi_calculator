import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../calculator_brain.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/bmi_record.dart';
import '../models/user_profile.dart';
import '../models/health_condition.dart';
import '../models/pregnancy_status.dart';
import '../providers/input_form_provider.dart';
import '../providers/bmi_records_provider.dart';
import '../providers/session_provider.dart';
import '../providers/wearable_provider.dart';
import '../widgets/daily_challenge_card.dart';
import 'blood_pressure_input.dart';
import 'blood_sugar_input.dart';
import 'results_page.dart';

class InputHome extends ConsumerWidget {
  const InputHome({super.key});

  Future<void> _calculate(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final form = ref.read(inputFormProvider);

    if (form.gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectGenderError),
          backgroundColor: kWarningColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusSM)),
        ),
      );
      return;
    }

    final session = ref.read(sessionProvider);
    if (!session.hasSession) {
      // Should not happen - splash screen handles this, but safety check
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.signInToSave),
          backgroundColor: kErrorColor,
        ),
      );
      return;
    }

    // Build UserProfile with health context
    final userProfile = UserProfile(
      age: form.age,
      isMale: form.gender == Gender.male,
      healthConditions: form.selectedConditions,
      pregnancyStatus: form.pregnancyStatus,
      prePregnancyWeight: form.prePregnancyWeight,
    );

    final CalculatorBrain calc;
    try {
      calc = CalculatorBrain.withProfile(
        height: form.heightCm,
        weight: form.weightKg,
        userProfile: userProfile,
        waistCircumferenceCm: form.waistCm,
        neckCircumferenceCm: form.neckCm,
        hipCircumferenceCm: form.hipCm,
        restingHeartRateBpm: form.restingHeartRate,
      );
    } on ArgumentError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.invalidMetricInput),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ref.read(inputFormProvider.notifier).setSaving(true);

    // Create local record with new health fields
    final record = BmiRecord(
      id: const Uuid().v4(),
      userId: session.userId!,
      height: form.heightCm,
      weight: form.weightKg,
      age: form.age,
      isMale: form.gender == Gender.male,
      bmiValue: calc.bmiValue,
      bmiResult: calc.calculateBMI(),
      resultText: calc.getResult(),
      interpretation: calc.getInterpretation(),
      timestamp: DateTime.now(),
      isSynced: false,
      healthConditions: form.selectedConditions.map((c) => c.name).toList(),
      pregnancyStatus: form.pregnancyStatus.name,
      prePregnancyWeight: form.prePregnancyWeight,
      waistCm: form.waistCm,
      neckCm: form.neckCm,
      hipCm: form.hipCm,
      restingHeartRate: form.restingHeartRate,
    );

    await ref.read(bmiRecordsProvider.notifier).addRecord(record);
    ref.read(inputFormProvider.notifier).setSaving(false);

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsPage(
          bmiResult: calc.calculateBMI(),
          resultText: calc.getResult(),
          interpretation: calc.getInterpretation(),
          calculator: calc,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(inputFormProvider);
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(kSpaceMD, kSpaceMD, kSpaceMD, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Live BMI Preview Bar ──────────────────────────────────────
              _buildLiveBMIBar(context, form),

              const SizedBox(height: kSpaceMD),

              // ── Today's Daily Challenge (Sprint 2.2) ─────────────────────
              const DailyChallengeCard(),
              const SizedBox(height: kSpaceMD),

              // ── Wearable Auto-fill Banner (Sprint 3.1) ──────────────────
              const _WearableAutoFillBanner(),
              const SizedBox(height: kSpaceMD),

              // ── Unit Toggle ───────────────────────────────────────────────
              _UnitToggle(
                isMetric: form.isMetric,
                onToggle: (v) =>
                    ref.read(inputFormProvider.notifier).setIsMetric(v),
                metricLabel: l10n.metricUnits,
                imperialLabel: l10n.imperialUnits,
              ),
              const SizedBox(height: kSpaceMD),

              // ── Health Tracking ─────────────────────────────────────────
              _HealthTrackingCard(
                onBpTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BloodPressureInput()),
                ),
                onGlucoseTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BloodSugarInput()),
                ),
              ),
              const SizedBox(height: kSpaceMD),

              // ── Gender ────────────────────────────────────────────────────
              _SectionLabel(label: l10n.biologicalSex),
              const SizedBox(height: kSpaceSM),
              Row(
                children: [
                  _GenderCard(
                    label: l10n.male,
                    icon: FontAwesomeIcons.mars,
                    selected: form.gender == Gender.male,
                    onTap: () => ref
                        .read(inputFormProvider.notifier)
                        .setGender(Gender.male),
                  ),
                  const SizedBox(width: kSpaceSM),
                  _GenderCard(
                    label: l10n.female,
                    icon: FontAwesomeIcons.venus,
                    selected: form.gender == Gender.female,
                    onTap: () => ref
                        .read(inputFormProvider.notifier)
                        .setGender(Gender.female),
                  ),
                ],
              ),
              const SizedBox(height: kSpaceMD),

              // ── Height ────────────────────────────────────────────────────
              _SectionLabel(label: l10n.height),
              const SizedBox(height: kSpaceSM),
              _MetricCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          form.isMetric
                              ? '${form.heightCm}'
                              : (form.heightCm / 30.48).toStringAsFixed(1),
                          style: kNumberTextStyle.copyWith(
                              color: DynamicColors.textPrimary(context)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          form.isMetric ? 'cm' : 'ft',
                          style: TextStyle(
                              color: DynamicColors.textSecondary(context),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12.0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 22.0),
                        thumbColor: kAccent,
                        activeTrackColor: kAccent,
                        inactiveTrackColor: DynamicColors.border(context),
                        overlayColor: kAccent.withOpacity(0.2),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: form.heightCm.toDouble(),
                        min: 100.0,
                        max: 250.0,
                        onChanged: (v) => ref
                            .read(inputFormProvider.notifier)
                            .setHeight(v.round()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('100 cm',
                            style: TextStyle(
                                fontSize: 11,
                                color: DynamicColors.textSecondary(context))),
                        Text('250 cm',
                            style: TextStyle(
                                fontSize: 11,
                                color: DynamicColors.textSecondary(context))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kSpaceMD),

              // ── Weight & Age ──────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionLabel(label: l10n.weight),
                        const SizedBox(height: kSpaceSM),
                        _MetricCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    form.isMetric
                                        ? '${form.weightKg}'
                                        : (form.weightKg * 2.20462)
                                            .toStringAsFixed(0),
                                    style: kNumberTextStyle.copyWith(
                                      fontSize: 40,
                                      color: DynamicColors.textPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    form.isMetric ? 'kg' : 'lbs',
                                    style: TextStyle(
                                      color:
                                          DynamicColors.textSecondary(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: kSpaceSM),
                              _IncrementRow(
                                onDecrement: () => ref
                                    .read(inputFormProvider.notifier)
                                    .setWeight(
                                        (form.weightKg - 1).clamp(20, 300)),
                                onIncrement: () => ref
                                    .read(inputFormProvider.notifier)
                                    .setWeight(
                                        (form.weightKg + 1).clamp(20, 300)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kSpaceSM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionLabel(label: l10n.age),
                        const SizedBox(height: kSpaceSM),
                        _MetricCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${form.age}',
                                    style: kNumberTextStyle.copyWith(
                                      fontSize: 40,
                                      color: DynamicColors.textPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.years,
                                    style: TextStyle(
                                      color:
                                          DynamicColors.textSecondary(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: kSpaceSM),
                              _IncrementRow(
                                onDecrement: () => ref
                                    .read(inputFormProvider.notifier)
                                    .setAge((form.age - 1).clamp(2, 120)),
                                onIncrement: () => ref
                                    .read(inputFormProvider.notifier)
                                    .setAge((form.age + 1).clamp(2, 120)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kSpaceMD),

              // ── Health Conditions ────────────────────────────────────────────
              _SectionLabel(label: l10n.healthConditions),
              const SizedBox(height: kSpaceSM),
              _buildHealthConditionsSection(context, ref, form),
              const SizedBox(height: kSpaceMD),

              // ── Pregnancy Status (Female Only) ────────────────────────────
              if (form.isFemale)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(label: l10n.pregnancyStatus),
                    const SizedBox(height: kSpaceSM),
                    _buildPregnancySection(context, ref, form),
                    const SizedBox(height: kSpaceMD),
                  ],
                ),

              // ── Advanced Body Metrics (Phase 1) ───────────────────────────
              _SectionLabel(label: l10n.advancedMetricsTitle),
              const SizedBox(height: kSpaceSM),
              _buildAdvancedMetricsSection(context, ref, form),
            ],
          ),
        ),

        // ── Fixed Calculate Button ────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
                kSpaceMD, kSpaceSM, kSpaceMD, kSpaceMD),
            decoration: BoxDecoration(
              color: DynamicColors.bg(context),
              border:
                  Border(top: BorderSide(color: DynamicColors.border(context))),
            ),
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed:
                    form.isSaving ? null : () => _calculate(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: kAccent.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadiusMD)),
                  elevation: 0,
                ),
                child: form.isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(l10n.calculateBmi, style: kLargeButtonTextStyle),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBMIBar(BuildContext context, InputFormState form) {
    final String bmi;
    if (form.heightCm <= 0 || form.weightKg <= 0) {
      bmi = '--';
    } else {
      bmi = CalculatorBrain(
        height: form.heightCm,
        weight: form.weightKg,
        age: form.age,
      ).calculateBMI();
    }
    final v = double.tryParse(bmi);
    final color =
        v == null ? DynamicColors.textSecondary(context) : getBMIColor(v);

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: kSpaceSM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.monitor_heart_outlined, color: color, size: 18),
          const SizedBox(width: kSpaceSM),
          Text(
            AppLocalizations.of(context).liveBmiPreview,
            style: TextStyle(
                color: DynamicColors.textSecondary(context), fontSize: 13),
          ),
          const Spacer(),
          Text(
            bmi,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            bmi == '--' ? '' : _getShortCategory(context, v ?? 0),
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _getShortCategory(BuildContext context, double bmi) {
    final l10n = AppLocalizations.of(context);
    if (bmi < 18.5) return l10n.shortUnderweight;
    if (bmi < 25) return l10n.shortNormal;
    if (bmi < 30) return l10n.shortOverweight;
    return l10n.shortObese;
  }

  Widget _buildHealthConditionsSection(
      BuildContext context, WidgetRef ref, InputFormState form) {
    return _MetricCard(
      child: Wrap(
        spacing: kSpaceSM,
        runSpacing: kSpaceSM,
        children: HealthCondition.values.map((condition) {
          final isSelected = form.selectedConditions.contains(condition);
          return FilterChip(
            label: Text(condition.shortLabel),
            selected: isSelected,
            onSelected: (_) =>
                ref.read(inputFormProvider.notifier).toggleCondition(condition),
            backgroundColor: DynamicColors.card(context),
            selectedColor: kAccent.withOpacity(0.2),
            labelStyle: TextStyle(
              color: isSelected ? kAccent : DynamicColors.textPrimary(context),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPregnancySection(
      BuildContext context, WidgetRef ref, InputFormState form) {
    final l10n = AppLocalizations.of(context);
    return _MetricCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButton<PregnancyStatus>(
            value: form.pregnancyStatus,
            isExpanded: true,
            underline: const SizedBox(),
            items: PregnancyStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.label),
              );
            }).toList(),
            onChanged: (newStatus) => ref
                .read(inputFormProvider.notifier)
                .setPregnancyStatus(newStatus ?? PregnancyStatus.notApplicable),
          ),
          if (form.pregnancyStatus != PregnancyStatus.notApplicable)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: kSpaceSM),
                Container(
                  padding: const EdgeInsets.all(kSpaceSM),
                  decoration: BoxDecoration(
                    color: kAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(kRadiusSM),
                    border: Border.all(color: kAccent.withOpacity(0.3)),
                  ),
                  child: Text(
                    form.pregnancyStatus.guidance,
                    style: TextStyle(
                        fontSize: 12,
                        color: DynamicColors.textSecondary(context)),
                  ),
                ),
                if (form.pregnancyStatus != PregnancyStatus.postpartum)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: kSpaceSM),
                      Text(
                        l10n.prePregnancyWeight,
                        style: TextStyle(
                            fontSize: 12,
                            color: DynamicColors.textSecondary(context)),
                      ),
                      const SizedBox(height: kSpaceSM),
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) => ref
                            .read(inputFormProvider.notifier)
                            .setPrePregnancyWeight(double.tryParse(value)),
                        decoration: InputDecoration(
                          hintText: form.isMetric
                              ? l10n.weightInKg
                              : l10n.weightInLbs,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(kRadiusSM)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: kSpaceSM, vertical: kSpaceSM),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAdvancedMetricsSection(
      BuildContext context, WidgetRef ref, InputFormState form) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(inputFormProvider.notifier);

    Widget field({
      required String label,
      required String hint,
      required String? value,
      required TextInputType keyboardType,
      required void Function(String) onChanged,
      String? suffix,
    }) {
      return TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusSM)),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: kSpaceSM, vertical: kSpaceSM),
        ),
      );
    }

    return _MetricCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.advancedMetricsSubtitle,
            style: TextStyle(
                fontSize: 12, color: DynamicColors.textSecondary(context)),
          ),
          const SizedBox(height: kSpaceMD),
          field(
            label: l10n.waistCircumference,
            hint: l10n.waistHint,
            value: form.waistCm?.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: 'cm',
            onChanged: (v) => notifier.setWaistCm(double.tryParse(v)),
          ),
          const SizedBox(height: kSpaceSM),
          field(
            label: l10n.neckCircumference,
            hint: l10n.neckHint,
            value: form.neckCm?.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: 'cm',
            onChanged: (v) => notifier.setNeckCm(double.tryParse(v)),
          ),
          if (form.isFemale) ...[
            const SizedBox(height: kSpaceSM),
            field(
              label: l10n.hipCircumference,
              hint: l10n.hipHint,
              value: form.hipCm?.toString(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              suffix: 'cm',
              onChanged: (v) => notifier.setHipCm(double.tryParse(v)),
            ),
          ],
          const SizedBox(height: kSpaceSM),
          field(
            label: l10n.restingHeartRate,
            hint: l10n.restingHeartRateHint,
            value: form.restingHeartRate?.toString(),
            keyboardType: TextInputType.number,
            suffix: 'bpm',
            onChanged: (v) => notifier.setRestingHeartRate(int.tryParse(v)),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

/// Auto-fill banner when wearable data is available (Sprint 3.1).
class _WearableAutoFillBanner extends ConsumerWidget {
  const _WearableAutoFillBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = ref.watch(wearableProvider);
    final state = w.value;
    if (state == null || !state.permissionGranted || state.snapshot == null) {
      return const SizedBox.shrink();
    }

    final snap = state.snapshot!;
    final heightCm =
        snap.latestHeightM == null ? null : (snap.latestHeightM! * 100).round();
    final weightKg = snap.latestWeightKg?.round();

    if (heightCm == null && weightKg == null) return const SizedBox.shrink();

    final parts = <String>[];
    if (weightKg != null) parts.add('Weight $weightKg kg');
    if (heightCm != null) parts.add('Height $heightCm cm');

    final l10n = AppLocalizations.of(context);
    return Card(
      color: DynamicColors.surface(context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        side: BorderSide(
          color: kAccent.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kSpaceMD,
          vertical: kSpaceSM,
        ),
        child: Row(
          children: [
            Icon(Icons.monitor_heart, size: 20, color: kAccent),
            const SizedBox(width: kSpaceSM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parts.join(' · '),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    l10n.wearableStepInPerm,
                    style: TextStyle(
                      fontSize: 11,
                      color: DynamicColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(inputFormProvider.notifier).applyWearable(
                      heightCm: heightCm?.toDouble(),
                      weightKg: weightKg?.toDouble(),
                    );
              },
              child: Text(l10n.wearableAutoFillUse),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: DynamicColors.textSecondary(context),
          letterSpacing: 0.5,
        ),
      );
}

class _MetricCard extends StatelessWidget {
  final Widget child;
  const _MetricCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(kSpaceMD),
        decoration: BoxDecoration(
          color: DynamicColors.card(context),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: DynamicColors.border(context)),
        ),
        child: child,
      );
}

class _GenderCard extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: kSpaceMD),
          decoration: BoxDecoration(
            color: selected
                ? kAccent.withOpacity(0.15)
                : DynamicColors.card(context),
            borderRadius: BorderRadius.circular(kRadiusMD),
            border: Border.all(
              color: selected ? kAccent : DynamicColors.border(context),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                color: selected ? kAccent : DynamicColors.iconColor(context),
                size: 28,
              ),
              const SizedBox(height: kSpaceXS),
              Text(
                label,
                style: TextStyle(
                  color:
                      selected ? kAccent : DynamicColors.textSecondary(context),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final bool isMetric;
  final ValueChanged<bool> onToggle;
  final String metricLabel;
  final String imperialLabel;

  const _UnitToggle({
    required this.isMetric,
    required this.onToggle,
    required this.metricLabel,
    required this.imperialLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(color: DynamicColors.border(context)),
      ),
      child: Row(
        children: [
          _Tab(
              label: metricLabel,
              active: isMetric,
              onTap: () => onToggle(true)),
          _Tab(
              label: imperialLabel,
              active: !isMetric,
              onTap: () => onToggle(false)),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? kAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(kRadiusSM),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  active ? Colors.white : DynamicColors.textSecondary(context),
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _IncrementRow extends StatelessWidget {
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _IncrementRow({required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleButton(icon: Icons.remove, onPressed: onDecrement),
        const SizedBox(width: kSpaceMD),
        _CircleButton(icon: Icons.add, onPressed: onIncrement),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: kAccent.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: kAccent.withOpacity(0.3)),
        ),
        child: Icon(icon, color: kAccent, size: 20),
      ),
    );
  }
}

class _HealthTrackingCard extends StatelessWidget {
  final VoidCallback onBpTap;
  final VoidCallback onGlucoseTap;

  const _HealthTrackingCard({
    required this.onBpTap,
    required this.onGlucoseTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kAccent.withOpacity(0.15), kInfoColor.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kAccent.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_outline, color: kAccent, size: 20),
              const SizedBox(width: kSpaceSM),
              Text(
                l10n.trackingSectionTitle,
                style: TextStyle(
                  color: DynamicColors.textPrimary(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            l10n.trackingSectionSubtitle,
            style: TextStyle(
              color: DynamicColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: kSpaceMD),
          Row(
            children: [
              Expanded(
                child: _TrackingTile(
                  icon: Icons.monitor_heart,
                  color: kErrorColor,
                  title: l10n.bpCardTitle,
                  subtitle: l10n.bpCardSubtitle,
                  onTap: onBpTap,
                ),
              ),
              const SizedBox(width: kSpaceSM),
              Expanded(
                child: _TrackingTile(
                  icon: Icons.water_drop,
                  color: kInfoColor,
                  title: l10n.bsCardTitle,
                  subtitle: l10n.bsCardSubtitle,
                  onTap: onGlucoseTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackingTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TrackingTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kSpaceMD),
        decoration: BoxDecoration(
          color: DynamicColors.card(context),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: DynamicColors.border(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: kSpaceSM),
            Text(
              title,
              style: TextStyle(
                color: DynamicColors.textPrimary(context),
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: DynamicColors.textSecondary(context),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
