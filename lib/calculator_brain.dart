import 'dart:math';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'models/user_profile.dart';
import 'models/age_group.dart';
import 'models/bmi_reference.dart';
import 'models/pregnancy_status.dart';
import 'models/health_condition.dart';

/// WHO BMI classification (age and gender-aware).
///
/// This calculator now supports:
/// - All age groups: infants to elderly (65+)
/// - Gender-specific BMI ranges
/// - Pregnancy tracking with trimester guidance
/// - Health condition context
/// - Age-appropriate interpretations
enum BMICategory {
  /// BMI < 16.0
  severeThinness,
  /// BMI 16.0 – 16.99
  moderateThinness,
  /// BMI 17.0 – 18.49
  mildThinness,
  /// BMI 18.5 – 24.99
  normalRange,
  /// BMI 25.0 – 29.99
  preObese,
  /// BMI 30.0 – 34.99
  obeseClassI,
  /// BMI 35.0 – 39.99
  obeseClassII,
  /// BMI ≥ 40.0
  obeseClassIII,
}

class CalculatorBrain {
  /// Create a calculator with user profile for age/gender/condition-aware BMI.
  /// Modern constructor using UserProfile for comprehensive health context.
  CalculatorBrain.withProfile({
    required this.height,
    required this.weight,
    required this.userProfile,
    this.age = 25,
    this.isMale = true,
  }) {
    if (height <= 0 || weight <= 0) {
      throw ArgumentError('Height and weight must be greater than zero.');
    }
  }

  /// Legacy constructor for backward compatibility (assumes healthy adult male).
  CalculatorBrain({
    required this.height,
    required this.weight,
    this.age = 25,
    this.isMale = true,
  }) : userProfile = UserProfile(age: age, isMale: isMale) {
    if (height <= 0 || weight <= 0) {
      throw ArgumentError('Height and weight must be greater than zero.');
    }
  }

  final int height; // cm
  final int weight; // kg
  final int age; // for backward compatibility
  final bool isMale; // for backward compatibility
  final UserProfile userProfile;

  late final double _bmi = weight / pow(height / 100, 2);

  double get bmiValue => double.parse(_bmi.toStringAsFixed(1));

  String calculateBMI() => _bmi.toStringAsFixed(1);

  // ── Age/Gender-Aware BMI Classification ────────────────────────────────────

  /// Get BMI thresholds for this user's age and gender.
  Map<String, BMIRange> get _thresholds =>
      BMIReference.getThresholdsForAge(userProfile.age, isMale: userProfile.isMale);

  /// Get the category name based on age/gender-specific thresholds.
  String getResult() {
    final thresholds = _thresholds;
    for (final entry in thresholds.entries) {
      if (entry.value.contains(_bmi)) {
        return entry.key;
      }
    }
    // Fallback
    return 'Extreme Value';
  }

  /// Legacy method for backward compatibility (adult-only).
  BMICategory get category {
    if (_bmi >= 40.0) return BMICategory.obeseClassIII;
    if (_bmi >= 35.0) return BMICategory.obeseClassII;
    if (_bmi >= 30.0) return BMICategory.obeseClassI;
    if (_bmi >= 25.0) return BMICategory.preObese;
    if (_bmi >= 18.5) return BMICategory.normalRange;
    if (_bmi >= 17.0) return BMICategory.mildThinness;
    if (_bmi >= 16.0) return BMICategory.moderateThinness;
    return BMICategory.severeThinness;
  }

  /// Comprehensive interpretation considering age, gender, health conditions, and pregnancy.
  String getInterpretation() {
    String baseInterpretation = _getBaseInterpretation();
    String ageNote = _getAgeSpecificNote();
    String pregnancyNote = _getPregnancyNote();
    String conditionNote = _getConditionNote();

    return [baseInterpretation, ageNote, pregnancyNote, conditionNote]
        .where((s) => s.isNotEmpty)
        .join('\n\n');
  }

  /// Base BMI interpretation.
  String _getBaseInterpretation() {
    final result = getResult();

    if (result.toLowerCase().contains('underweight') ||
        result.toLowerCase().contains('thinness')) {
      return 'Your BMI indicates underweight. Medical evaluation and nutritional support are recommended.';
    } else if (result.toLowerCase().contains('normal')) {
      return 'Your BMI is within the healthy range. Maintain your current balanced lifestyle.';
    } else if (result.toLowerCase().contains('overweight') ||
        result.toLowerCase().contains('obese')) {
      return 'Your BMI indicates excess weight. Regular physical activity and a balanced diet are recommended. Consider consulting a healthcare provider.';
    }
    return 'BMI assessment: $result';
  }

  /// Age-specific interpretation and guidance.
  String _getAgeSpecificNote() {
    return switch (userProfile.ageGroup) {
      AgeGroup.infant =>
        '👶 Infant: Growth patterns vary widely. Regular pediatric check-ups are essential to monitor healthy development.',
      AgeGroup.toddler =>
        '👧 Toddler: BMI changes rapidly during growth. Pediatrician guidance on normal development is important.',
      AgeGroup.child =>
        '🧒 Child: BMI should be compared to age and sex-specific growth charts. Ask your pediatrician about healthy growth.',
      AgeGroup.teen =>
        '👦 Teen: Body composition changes during puberty. Growth charts are used for assessment, not adult BMI categories.',
      AgeGroup.adult => 'Adult: Standard BMI categories apply.',
      AgeGroup.elderly =>
        '👴 Elderly: Research suggests slightly higher BMI may be protective. Focus on strength and mobility over weight alone.',
    };
  }

  /// Pregnancy-specific guidance.
  String _getPregnancyNote() {
    if (!userProfile.isPregnant) return '';

    final prePregnancyBmi = userProfile.prePregnancyWeight != null
        ? userProfile.prePregnancyWeight! / pow(height / 100, 2)
        : null;

    String note =
        '🤰 Pregnancy: ${userProfile.pregnancyStatus.label}\n${userProfile.pregnancyStatus.getPregnancyInterpretation(prePregnancyBmi ?? 22.0)}';

    if (prePregnancyBmi != null) {
      final gainRecs = userProfile.pregnancyStatus.getTotalRecommendedGain();
      final category = _categorizePregnancyBmi(prePregnancyBmi);
      if (gainRecs.containsKey(category)) {
        note += '\nRecommended total weight gain: ${gainRecs[category]}';
      }
    }

    return note;
  }

  String _categorizePregnancyBmi(double bmi) {
    if (bmi < 18.5) return 'underweight';
    if (bmi < 25) return 'normal';
    if (bmi < 30) return 'overweight';
    return 'obese';
  }

  /// Health condition-specific recommendations.
  String _getConditionNote() {
    if (!userProfile.hasHealthConditions) return '';

    final primaryCondition = userProfile.primaryHealthConcern;
    if (primaryCondition == null) return '';

    return '⚕️ Health Consideration: ${primaryCondition.description}\nConsult your healthcare provider for personalized management.';
  }

  Color getResultColor() => getBMIColor(_bmi);

  // ── Ideal Weight (Age and Gender-Aware) ─────────────────────────────────────

  Map<String, double> getIdealWeightRange() {
    final (min, max) = BMIReference.getIdealWeightRange(
      height,
      userProfile.age,
      userProfile.isMale,
    );
    return {'min': min, 'max': max};
  }

  String getWeightDelta() {
    final range = getIdealWeightRange();
    final minW = range['min']!;
    final maxW = range['max']!;
    if (weight < minW) {
      return '+${(minW - weight).toStringAsFixed(1)} kg to gain';
    } else if (weight > maxW) {
      return '${(weight - maxW).toStringAsFixed(1)} kg to lose';
    }
    return 'Within the ideal range';
  }

  // ── Energy & hydration estimates ───────────────────────────────────────────

  /// Basal Metabolic Rate via Mifflin-St Jeor equation (±10% accuracy).
  double calculateBMR() {
    if (isMale) {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  /// Estimated sedentary daily caloric need (BMR × 1.2).
  int getEstimatedDailyCalories() => (calculateBMR() * 1.2).round();

  /// Recommended daily water intake in litres (weight × 0.033).
  String getWaterIntake() => (weight * 0.033).toStringAsFixed(1);

  // ── Gauge helper ───────────────────────────────────────────────────────────

  /// Normalised 0.0–1.0 position on the 15–40 BMI arc.
  double get gaugeProgress =>
      ((_bmi - 15.0) / (40.0 - 15.0)).clamp(0.0, 1.0);

  // ── Age-appropriateness note ───────────────────────────────────────────────

  /// Returns contextual disclaimers and considerations for reliability.
  String? getAgeDisclaimer() {
    return switch (userProfile.ageGroup) {
      AgeGroup.infant =>
        '⚠️ BMI is not recommended for infants. Use weight-for-length and pediatric growth charts.',
      AgeGroup.toddler =>
        '⚠️ BMI-for-age charts are used. Consult a pediatrician for interpretation.',
      AgeGroup.child =>
        '⚠️ BMI should be compared to age and sex-specific percentiles. See your pediatrician.',
      AgeGroup.teen =>
        '⚠️ BMI-for-age charts apply. Growth varies significantly during puberty; pediatric guidance is recommended.',
      AgeGroup.adult => null,
      AgeGroup.elderly =>
        '💡 For 65+: Higher BMI may be protective. Consider overall health, strength, and mobility.',
    };
  }

  /// Get health warning if there are dangerous combinations.
  String? getHealthWarning() {
    if (!userProfile.hasHealthConditions) return null;

    final warnings = <String>[];
    final bmi = _bmi;

    if (bmi > 30 && userProfile.healthConditions.toString().contains('Diabetes')) {
      warnings.add('⚠️ High BMI with diabetes requires close medical monitoring.');
    }

    if (bmi > 25 && userProfile.healthConditions.toString().contains('Heart')) {
      warnings.add('⚠️ Excess weight combined with heart disease requires medical oversight.');
    }

    if (userProfile.isPregnant && bmi < 16) {
      warnings.add('⚠️ Severe underweight during pregnancy requires immediate medical attention.');
    }

    return warnings.isNotEmpty ? warnings.join('\n') : null;
  }
}
