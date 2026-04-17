import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../calculator_brain.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/diet_recommendation.dart';
import '../widgets/bmi_gauge.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({
    super.key,
    required this.bmiResult,
    required this.resultText,
    required this.interpretation,
    required this.calculator,
  });

  final String bmiResult;
  final String resultText;
  final String interpretation;
  final CalculatorBrain calculator;

  void _share(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = l10n.shareText(bmiResult, resultText, interpretation);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.resultCopied),
        backgroundColor: kSuccessColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusSM)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = DynamicColors.isDark(context);
    final bmiVal = double.tryParse(bmiResult) ?? 0.0;
    final categoryColor = getBMIColor(bmiVal);
    final idealRange = calculator.getIdealWeightRange();
    final calories = calculator.getEstimatedDailyCalories();
    final water = calculator.getWaterIntake();
    final weightDelta = calculator.getWeightDelta();
    final dietRec = DietRecommendation.getForBMI(bmiVal);

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────────────────
            SliverAppBar(
              backgroundColor: DynamicColors.bg(context),
              elevation: 0,
              pinned: true,
              automaticallyImplyLeading: false,
              title: Text(
                l10n.yourResults,
                style: TextStyle(
                  color: DynamicColors.textPrimary(context),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.ios_share_outlined, color: DynamicColors.textSecondary(context)),
                  onPressed: () => _share(context),
                  tooltip: l10n.copyToClipboard,
                ),
                const SizedBox(width: 4),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: kSpaceMD),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── Category Badge ────────────────────────────────────────
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: kSpaceXS),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(kRadiusXL),
                        border: Border.all(color: categoryColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        resultText.toUpperCase(),
                        style: TextStyle(
                          color: categoryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: kSpaceMD),

                  // ── Gauge ────────────────────────────────────────────────
                  Center(
                    child: BMIGauge(
                      bmi: bmiVal,
                      categoryColor: categoryColor,
                      categoryLabel: resultText,
                    ),
                  ),
                  const SizedBox(height: kSpaceXS),

                  // ── BMI Number ───────────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Text(
                          bmiResult,
                          style: kBMITextStyle.copyWith(
                            color: categoryColor,
                          ),
                        ),
                        Text(
                          l10n.bodyMassIndex,
                          style: TextStyle(
                            color: DynamicColors.textSecondary(context),
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),

                  // ── Interpretation Card ──────────────────────────────────
                  _SectionCard(
                    isDark: isDark,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(kRadiusSM),
                          ),
                          child: Icon(Icons.info_outline, color: categoryColor, size: 18),
                        ),
                        const SizedBox(width: kSpaceMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.whatThisMeans,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: DynamicColors.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: kSpaceXS),
                              Text(
                                interpretation,
                                style: TextStyle(
                                  color: DynamicColors.textSecondary(context),
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceMD),

                  // ── Ideal Weight Card ─────────────────────────────────────
                  _SectionCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                          context: context,
                          icon: Icons.scale_outlined,
                          iconColor: kInfoColor,
                          title: l10n.idealWeightRange,
                        ),
                        const SizedBox(height: kSpaceMD),
                        Row(
                          children: [
                            _StatChip(
                              label: l10n.minLabel,
                              value: '${idealRange['min']!.toStringAsFixed(1)} kg',
                              color: kUnderweightColor,
                            ),
                            const SizedBox(width: kSpaceSM),
                            _StatChip(
                              label: l10n.maxLabel,
                              value: '${idealRange['max']!.toStringAsFixed(1)} kg',
                              color: kOverweightColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: kSpaceSM),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: kSpaceSM, vertical: kSpaceXS),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(kRadiusSM),
                          ),
                          child: Text(
                            weightDelta,
                            style: TextStyle(
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceMD),

                  // ── Health Metrics Row ────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _SectionCard(
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: kWarningColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(kRadiusSM),
                                    ),
                                    child: const Icon(Icons.local_fire_department_outlined, color: kWarningColor, size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.dailyCalories,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: DynamicColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: kSpaceSM),
                              Text(
                                '$calories',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: DynamicColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                l10n.kcalPerDay,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: DynamicColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: _SectionCard(
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: kInfoColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(kRadiusSM),
                                    ),
                                    child: const Icon(Icons.water_drop_outlined, color: kInfoColor, size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.waterIntake,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: DynamicColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: kSpaceSM),
                              Text(
                                water,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: DynamicColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                l10n.litresPerDay,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: DynamicColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSpaceMD),

                  // ── Health Warning (if applicable) ────────────────────────
                  if ((calculator.getHealthWarning() ?? '').isNotEmpty)
                    _SectionCard(
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: kErrorColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(kRadiusSM),
                                ),
                                child: const Icon(Icons.warning_outlined, color: kErrorColor, size: 18),
                              ),
                              const SizedBox(width: kSpaceMD),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.healthConsideration,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: DynamicColors.textPrimary(context),
                                      ),
                                    ),
                                    const SizedBox(height: kSpaceXS),
                                    Text(
                                      calculator.getHealthWarning() ?? '',
                                      style: TextStyle(
                                        color: DynamicColors.textSecondary(context),
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if ((calculator.getHealthWarning() ?? '').isNotEmpty)
                    const SizedBox(height: kSpaceMD),

                  // ── Diet Recommendations ──────────────────────────────────
                  _SectionCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                          context: context,
                          icon: Icons.restaurant_outlined,
                          iconColor: kWarningColor,
                          title: l10n.nutritionRecommendations,
                        ),
                        const SizedBox(height: kSpaceMD),
                        Text(
                          dietRec.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: DynamicColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: kSpaceXS),
                        Text(
                          dietRec.description,
                          style: TextStyle(
                            color: DynamicColors.textSecondary(context),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: kSpaceMD),
                        // Meal frequency
                        Container(
                          padding: const EdgeInsets.all(kSpaceSM),
                          decoration: BoxDecoration(
                            color: kWarningColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(kRadiusSM),
                            border: Border.all(color: kWarningColor.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dailyMealPlan,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: DynamicColors.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: kSpaceXS),
                              ...dietRec.mealsPerDay.map((meal) =>
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      '• $meal',
                                      style: TextStyle(
                                        color: DynamicColors.textSecondary(context),
                                        fontSize: 12,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: kSpaceMD),
                        // Macro balance
                        Container(
                          padding: const EdgeInsets.all(kSpaceSM),
                          decoration: BoxDecoration(
                            color: kInfoColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(kRadiusSM),
                            border: Border.all(color: kInfoColor.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.macronutrientBalance,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: DynamicColors.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: kSpaceXS),
                              Text(
                                dietRec.macroBalance,
                                style: TextStyle(
                                  color: DynamicColors.textSecondary(context),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: kSpaceMD),
                        // Food groups
                        Text(
                          l10n.focusFoods,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: DynamicColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: kSpaceXS),
                        Wrap(
                          spacing: kSpaceSM,
                          runSpacing: kSpaceXS,
                          children: dietRec.foodGroups.map((food) =>
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kSpaceSM, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(kRadiusSM),
                                  border: Border.all(
                                      color: kAccent.withOpacity(0.3)),
                                ),
                                child: Text(
                                  food,
                                  style: TextStyle(
                                    color: kAccent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )).toList(),
                        ),
                        const SizedBox(height: kSpaceMD),
                        // Key recommendations
                        Text(
                          l10n.keyRecommendations,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: DynamicColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: kSpaceXS),
                        ...dietRec.recommendations
                            .take(5) // Show top 5 recommendations
                            .map((rec) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '✓ ',
                                        style: TextStyle(
                                          color: kSuccessColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          rec,
                                          style: TextStyle(
                                            color: DynamicColors.textSecondary(context),
                                            fontSize: 11,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        if (dietRec.recommendations.length > 5)
                          Padding(
                            padding: const EdgeInsets.only(top: kSpaceXS),
                            child: Text(
                              l10n.moreRecommendations(dietRec.recommendations.length - 5),
                              style: TextStyle(
                                color: DynamicColors.textSecondary(context),
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceMD),

                  // ── BMI Scale Reference ───────────────────────────────────
                  _SectionCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                          context: context,
                          icon: Icons.bar_chart_outlined,
                          iconColor: kAccent,
                          title: l10n.bmiScale,
                        ),
                        const SizedBox(height: kSpaceMD),
                        ..._bmiScaleRows(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),

                  // ── Re-calculate Button ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kRadiusMD),
                        ),
                        elevation: 0,
                      ),
                      child: Text(l10n.reCalculate, style: kLargeButtonTextStyle),
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _bmiScaleRows(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = [
      ('< 16.0', l10n.bmiSeverelyUnderweight, kSeverelyUnderweightColor),
      ('16 – 18.4', l10n.bmiUnderweight, kUnderweightColor),
      ('18.5 – 24.9', l10n.bmiNormalWeight, kNormalColor),
      ('25 – 29.9', l10n.bmiOverweight, kOverweightColor),
      ('30 – 34.9', l10n.bmiObeseI, kObeseIColor),
      ('35 – 39.9', l10n.bmiObeseII, kObeseIIColor),
      ('≥ 40', l10n.bmiSeverelyObese, kObeseIIIColor),
    ];
    return rows.map((row) {
      final isActive = row.$2 == resultText;
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: kSpaceSM, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? row.$3.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(kRadiusSM),
          border: isActive ? Border.all(color: row.$3.withOpacity(0.4)) : null,
        ),
        child: Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: row.$3, shape: BoxShape.circle)),
            const SizedBox(width: kSpaceSM),
            SizedBox(
              width: 88,
              child: Text(
                row.$1,
                style: TextStyle(
                  fontSize: 12,
                  color: DynamicColors.textSecondary(context),
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Expanded(
              child: Text(
                row.$2,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? row.$3 : DynamicColors.textPrimary(context),
                ),
              ),
            ),
            if (isActive)
              const Icon(Icons.arrow_left, color: kAccent, size: 16),
          ],
        ),
      );
    }).toList();
  }
}

// ─── Helper Widgets ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _SectionCard({required this.child, required this.isDark});

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

class _CardTitle extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final Color iconColor;
  final String title;

  const _CardTitle({
    required this.context,
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(kRadiusSM),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: kSpaceSM),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: DynamicColors.textPrimary(context),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kSpaceSM, vertical: kSpaceSM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(kRadiusSM),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
