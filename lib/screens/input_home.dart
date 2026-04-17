import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../calculator_brain.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/bmi_record.dart';
import '../models/user_profile.dart';
import '../models/health_condition.dart';
import '../models/pregnancy_status.dart';
import '../database/app_database.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';
import 'results_page.dart';

enum Gender { male, female }

class InputHome extends StatefulWidget {
  const InputHome({super.key});

  @override
  State<InputHome> createState() => _InputHomeState();
}

class _InputHomeState extends State<InputHome> {
  Gender? _selectedGender;
  bool _isMetric = true; // true=cm/kg, false=ft/lbs

  // Metric values
  int _heightCm = 170;
  int _weightKg = 70;
  int _age = 25;
  
  // New health fields
  final List<HealthCondition> _selectedConditions = [];
  PregnancyStatus _pregnancyStatus = PregnancyStatus.notApplicable;
  double? _prePregnancyWeight;

  bool _isSaving = false;

  // Imperial helpers
  double get _heightFt => _heightCm / 30.48;
  double get _weightLbs => _weightKg * 2.20462;

  // Live BMI preview
  String get _liveBMI {
    if (_heightCm <= 0 || _weightKg <= 0) return '--';
    try {
      final calc = CalculatorBrain(height: _heightCm, weight: _weightKg, age: _age);
      return calc.calculateBMI();
    } catch (_) {
      return '--';
    }
  }

  Color get _liveBMIColor {
    final v = double.tryParse(_liveBMI);
    if (v == null) return DynamicColors.textSecondary(context);
    return getBMIColor(v);
  }

  Future<void> _calculate() async {
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).selectGenderError),
          backgroundColor: kWarningColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusSM)),
        ),
      );
      return;
    }

    // Build UserProfile with health context
    final userProfile = UserProfile(
      age: _age,
      isMale: _selectedGender == Gender.male,
      healthConditions: _selectedConditions,
      pregnancyStatus: _pregnancyStatus,
      prePregnancyWeight: _prePregnancyWeight,
    );

    final calc = CalculatorBrain.withProfile(
      height: _heightCm,
      weight: _weightKg,
      userProfile: userProfile,
    );

    final userId = SessionService.userId;
    if (userId == null) {
      // Should not happen - splash screen handles this, but safety check
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).signInToSave),
          backgroundColor: kErrorColor,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Create local record with new health fields
    final record = BmiRecord(
      id: const Uuid().v4(),
      userId: userId,
      height: _heightCm,
      weight: _weightKg,
      age: _age,
      isMale: _selectedGender == Gender.male,
      bmiValue: calc.bmiValue,
      bmiResult: calc.calculateBMI(),
      resultText: calc.getResult(),
      interpretation: calc.getInterpretation(),
      timestamp: DateTime.now(),
      isSynced: false,
      healthConditions: _selectedConditions.map((c) => c.name).toList(),
      pregnancyStatus: _pregnancyStatus.name,
      prePregnancyWeight: _prePregnancyWeight,
    );

    await AppDatabase.insertRecord(record);

    if (!mounted) return;
    setState(() => _isSaving = false);

    // Attempt background sync if online (fire-and-forget before context use)
    if (userId != SessionService.guestId) {
      ConnectivityService.isOnline.then((online) {
        if (online) SyncService.sync(userId);
      });
    }

    if (!mounted) return;

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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(kSpaceMD, kSpaceMD, kSpaceMD, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Live BMI Preview Bar ──────────────────────────────────────
              _buildLiveBMIBar(),

              const SizedBox(height: kSpaceMD),

              // ── Unit Toggle ───────────────────────────────────────────────
              _UnitToggle(
                isMetric: _isMetric,
                onToggle: (v) => setState(() => _isMetric = v),
                metricLabel: AppLocalizations.of(context).metricUnits,
                imperialLabel: AppLocalizations.of(context).imperialUnits,
              ),
              const SizedBox(height: kSpaceMD),

              // ── Gender ────────────────────────────────────────────────────
              _SectionLabel(label: AppLocalizations.of(context).biologicalSex),
              const SizedBox(height: kSpaceSM),
              Row(
                children: [
                  _GenderCard(
                    label: AppLocalizations.of(context).male,
                    icon: FontAwesomeIcons.mars,
                    selected: _selectedGender == Gender.male,
                    onTap: () => setState(() => _selectedGender = Gender.male),
                  ),
                  const SizedBox(width: kSpaceSM),
                  _GenderCard(
                    label: AppLocalizations.of(context).female,
                    icon: FontAwesomeIcons.venus,
                    selected: _selectedGender == Gender.female,
                    onTap: () => setState(() => _selectedGender = Gender.female),
                  ),
                ],
              ),
              const SizedBox(height: kSpaceMD),

              // ── Height ────────────────────────────────────────────────────
              _SectionLabel(label: AppLocalizations.of(context).height),
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
                          _isMetric ? '$_heightCm' : _heightFt.toStringAsFixed(1),
                          style: kNumberTextStyle.copyWith(color: DynamicColors.textPrimary(context)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isMetric ? 'cm' : 'ft',
                          style: TextStyle(color: DynamicColors.textSecondary(context), fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22.0),
                        thumbColor: kAccent,
                        activeTrackColor: kAccent,
                        inactiveTrackColor: DynamicColors.border(context),
                        overlayColor: kAccent.withOpacity(0.2),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: _heightCm.toDouble(),
                        min: 100.0,
                        max: 250.0,
                        onChanged: (v) => setState(() => _heightCm = v.round()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('100 cm', style: TextStyle(fontSize: 11, color: DynamicColors.textSecondary(context))),
                        Text('250 cm', style: TextStyle(fontSize: 11, color: DynamicColors.textSecondary(context))),
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
                        _SectionLabel(label: AppLocalizations.of(context).weight),
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
                                    _isMetric ? '$_weightKg' : _weightLbs.toStringAsFixed(0),
                                    style: kNumberTextStyle.copyWith(
                                      fontSize: 40,
                                      color: DynamicColors.textPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isMetric ? 'kg' : 'lbs',
                                    style: TextStyle(
                                      color: DynamicColors.textSecondary(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: kSpaceSM),
                              _IncrementRow(
                                onDecrement: () => setState(() {
                                  if (_weightKg > 20) _weightKg--;
                                }),
                                onIncrement: () => setState(() {
                                  if (_weightKg < 300) _weightKg++;
                                }),
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
                        _SectionLabel(label: AppLocalizations.of(context).age),
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
                                    '$_age',
                                    style: kNumberTextStyle.copyWith(
                                      fontSize: 40,
                                      color: DynamicColors.textPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context).years,
                                    style: TextStyle(
                                      color: DynamicColors.textSecondary(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: kSpaceSM),
                              _IncrementRow(
                                onDecrement: () => setState(() {
                                  if (_age > 2) _age--;
                                }),
                                onIncrement: () => setState(() {
                                  if (_age < 120) _age++;
                                }),
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
              _SectionLabel(label: AppLocalizations.of(context).healthConditions),
              const SizedBox(height: kSpaceSM),
              _buildHealthConditionsSection(),
              const SizedBox(height: kSpaceMD),

              // ── Pregnancy Status (Female Only) ────────────────────────────
              if (_selectedGender == Gender.female)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(label: AppLocalizations.of(context).pregnancyStatus),
                    const SizedBox(height: kSpaceSM),
                    _buildPregnancySection(),
                    const SizedBox(height: kSpaceMD),
                  ],
                ),
            ],
          ),
        ),

        // ── Fixed Calculate Button ────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(kSpaceMD, kSpaceSM, kSpaceMD, kSpaceMD),
            decoration: BoxDecoration(
              color: DynamicColors.bg(context),
              border: Border(top: BorderSide(color: DynamicColors.border(context))),
            ),
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: kAccent.withOpacity(0.6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMD)),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(AppLocalizations.of(context).calculateBmi, style: kLargeButtonTextStyle),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBMIBar() {
    final bmi = _liveBMI;
    final color = _liveBMIColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: kSpaceSM),
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
            style: TextStyle(color: DynamicColors.textSecondary(context), fontSize: 13),
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
            bmi == '--' ? '' : _getShortCategory(context, double.tryParse(bmi) ?? 0),
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
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

  Widget _buildHealthConditionsSection() {
    return _MetricCard(
      child: Wrap(
        spacing: kSpaceSM,
        runSpacing: kSpaceSM,
        children: HealthCondition.values.map((condition) {
          final isSelected = _selectedConditions.contains(condition);
          return FilterChip(
            label: Text(condition.shortLabel),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedConditions.add(condition);
                } else {
                  _selectedConditions.remove(condition);
                }
              });
            },
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

  Widget _buildPregnancySection() {
    return _MetricCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButton<PregnancyStatus>(
            value: _pregnancyStatus,
            isExpanded: true,
            underline: const SizedBox(),
            items: PregnancyStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.label),
              );
            }).toList(),
            onChanged: (newStatus) {
              setState(() {
                _pregnancyStatus = newStatus ?? PregnancyStatus.notApplicable;
              });
            },
          ),
          if (_pregnancyStatus != PregnancyStatus.notApplicable)
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
                    _pregnancyStatus.guidance,
                    style: TextStyle(fontSize: 12, color: DynamicColors.textSecondary(context)),
                  ),
                ),
                if (_pregnancyStatus != PregnancyStatus.postpartum)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: kSpaceSM),
                      Text(
                        AppLocalizations.of(context).prePregnancyWeight,
                        style: TextStyle(fontSize: 12, color: DynamicColors.textSecondary(context)),
                      ),
                      const SizedBox(height: kSpaceSM),
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          setState(() {
                            _prePregnancyWeight = double.tryParse(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: _isMetric
                              ? AppLocalizations.of(context).weightInKg
                              : AppLocalizations.of(context).weightInLbs,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(kRadiusSM)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: kSpaceSM, vertical: kSpaceSM),
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
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

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
            color: selected ? kAccent.withOpacity(0.15) : DynamicColors.card(context),
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
                  color: selected ? kAccent : DynamicColors.textSecondary(context),
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
          _Tab(label: metricLabel, active: isMetric, onTap: () => onToggle(true)),
          _Tab(label: imperialLabel, active: !isMetric, onTap: () => onToggle(false)),
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
              color: active ? Colors.white : DynamicColors.textSecondary(context),
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
