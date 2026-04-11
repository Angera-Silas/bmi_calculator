/// Pregnancy status for female users.
enum PregnancyStatus {
  notApplicable, // Male or non-pregnant female
  firstTrimester, // 0-13 weeks
  secondTrimester, // 14-26 weeks
  thirdTrimester, // 27+ weeks
  postpartum, // Within 1 year after delivery
}

/// Extension for user-friendly labels and info.
extension PregnancyStatusExtension on PregnancyStatus {
  String get label {
    return switch (this) {
      PregnancyStatus.notApplicable => 'Not Applicable',
      PregnancyStatus.firstTrimester => 'First Trimester (0-13 weeks)',
      PregnancyStatus.secondTrimester => 'Second Trimester (14-26 weeks)',
      PregnancyStatus.thirdTrimester => 'Third Trimester (27+ weeks)',
      PregnancyStatus.postpartum => 'Postpartum (within 1 year)',
    };
  }

  /// Recommended total weight gain in kg based on pre-pregnancy BMI (IOM guidelines).
  Map<String, double> getRecommendedWeightGain() {
    return switch (this) {
      PregnancyStatus.notApplicable => {},
      PregnancyStatus.firstTrimester => {
        'underweight': 0.5, // kg/week average
        'normal': 0.4,
        'overweight': 0.3,
        'obese': 0.2,
      },
      PregnancyStatus.secondTrimester => {
        'underweight': 0.5,
        'normal': 0.4,
        'overweight': 0.3,
        'obese': 0.2,
      },
      PregnancyStatus.thirdTrimester => {
        'underweight': 0.5,
        'normal': 0.4,
        'overweight': 0.3,
        'obese': 0.2,
      },
      PregnancyStatus.postpartum => {},
    };
  }

  /// Total recommended weight gain for entire pregnancy by pre-pregnancy BMI.
  Map<String, String> getTotalRecommendedGain() {
    return switch (this) {
      PregnancyStatus.notApplicable => {},
      PregnancyStatus.firstTrimester ||
      PregnancyStatus.secondTrimester ||
      PregnancyStatus.thirdTrimester =>
        {
          'underweight': '12.5-18 kg (27-40 lbs)', // BMI < 18.5
          'normal': '11.5-16 kg (25-35 lbs)', // BMI 18.5-24.9
          'overweight': '7-11.5 kg (15-25 lbs)', // BMI 25-29.9
          'obese': '5-9 kg (11-20 lbs)', // BMI ≥ 30
        },
      PregnancyStatus.postpartum => {},
    };
  }

  /// Get interpretation info for pregnancy BMI.
  String getPregnancyInterpretation(double prePregnancyBmi) {
    final bmiCategory = _getBmiCategory(prePregnancyBmi);
    return switch (this) {
      PregnancyStatus.notApplicable => '',
      PregnancyStatus.firstTrimester =>
        'First trimester: Focus on prenatal vitamins, especially folic acid. Nausea is common.',
      PregnancyStatus.secondTrimester =>
        'Second trimester: Most women feel their best. Energy levels usually improve. Continue balanced nutrition.',
      PregnancyStatus.thirdTrimester =>
        'Third trimester: Weight gain accelerates. Most weight is baby, placenta, and amniotic fluid. Rest is important.',
      PregnancyStatus.postpartum =>
        'Postpartum recovery varies. Breastfeeding can help with weight loss. Be patient with your body.',
    };
  }

  /// Guidance text for each pregnancy status.
  String get guidance {
    return switch (this) {
      PregnancyStatus.notApplicable => 'Not pregnant or not applicable',
      PregnancyStatus.firstTrimester => 'Weeks 0-13: Focus on prenatal care and nutrient intake',
      PregnancyStatus.secondTrimester => 'Weeks 14-26: Most active period of weight gain',
      PregnancyStatus.thirdTrimester => 'Weeks 27+: Final preparation period for delivery',
      PregnancyStatus.postpartum => 'Within 1 year after delivery: Recovery and adjustments',
    };
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'underweight';
    if (bmi < 25) return 'normal';
    if (bmi < 30) return 'overweight';
    return 'obese';
  }
