import 'age_group.dart';

/// BMI thresholds and ranges for different populations.
/// Based on WHO standards and gender/age research.
class BMIReference {
  /// Get BMI thresholds for a specific age group and gender.
  /// Returns map with category names and their BMI ranges.
  static Map<String, BMIRange> getThresholdsForAge(
    int age, {
    required bool isMale,
  }) {
    final ageGroup = age.getAgeGroup();

    return switch (ageGroup) {
      AgeGroup.infant => _getInfantThresholds(age),
      AgeGroup.toddler => _getToddlerThresholds(age),
      AgeGroup.child => _getChildThresholds(age),
      AgeGroup.teen => _getTeenThresholds(age, isMale),
      AgeGroup.adult => _getAdultThresholds(isMale),
      AgeGroup.elderly => _getElderlyThresholds(isMale),
    };
  }

  /// Infant BMI thresholds (0-2 years) - Weight-for-length percentiles.
  static Map<String, BMIRange> _getInfantThresholds(int age) {
    // Infants don't have traditional BMI; use weight-for-length instead
    return {
      'Severely Underweight': BMIRange(0, 2.5),
      'Underweight': BMIRange(2.5, 5),
      'Normal Range': BMIRange(5, 95),
      'Overweight': BMIRange(95, 97.5),
      'Obese': BMIRange(97.5, 100),
    };
  }

  /// Toddler BMI thresholds (2-5 years) - BMI-for-age percentiles.
  static Map<String, BMIRange> _getToddlerThresholds(int age) {
    return {
      'Underweight': BMIRange(0, 5), // < 5th percentile
      'Normal Weight': BMIRange(5, 85), // 5th to < 85th percentile
      'Overweight': BMIRange(85, 95), // 85th to < 95th percentile
      'Obese': BMIRange(95, 100), // ≥ 95th percentile
    };
  }

  /// Child BMI thresholds (5-12 years) - BMI-for-age percentiles.
  static Map<String, BMIRange> _getChildThresholds(int age) {
    return {
      'Underweight': BMIRange(0, 5), // < 5th percentile
      'Normal Weight': BMIRange(5, 85), // 5th to < 85th percentile
      'Overweight': BMIRange(85, 95), // 85th to < 95th percentile
      'Obese': BMIRange(95, 100), // ≥ 95th percentile
    };
  }

  /// Teen BMI thresholds (12-18 years) - BMI-for-age percentiles.
  static Map<String, BMIRange> _getTeenThresholds(int age, bool isMale) {
    return {
      'Underweight': BMIRange(0, 5), // < 5th percentile
      'Normal Weight': BMIRange(5, 85), // 5th to < 85th percentile
      'Overweight': BMIRange(85, 95), // 85th to < 95th percentile
      'Obese': BMIRange(95, 100), // ≥ 95th percentile
    };
  }

  /// Adult BMI thresholds (18-65 years) - WHO standards with gender variants.
  static Map<String, BMIRange> _getAdultThresholds(bool isMale) {
    // Gender adjustment: females typically have ~0.5-1 BMI point higher healthy range
    final adjustment = isMale ? 0.0 : 0.5;

    return {
      'Severe Thinness': BMIRange(0, 16.0),
      'Moderate Thinness': BMIRange(16.0, 16.99),
      'Mild Thinness': BMIRange(17.0 - adjustment, 18.49 - adjustment),
      'Normal Range': BMIRange(18.5 - adjustment, 24.99),
      'Pre-obese (Overweight)': BMIRange(25.0, 29.99),
      'Obese Class I': BMIRange(30.0, 34.99),
      'Obese Class II': BMIRange(35.0, 39.99),
      'Obese Class III': BMIRange(40.0, 200),
    };
  }

  /// Elderly BMI thresholds (65+ years) - Adjusted ranges (higher BMI may be protective).
  static Map<String, BMIRange> _getElderlyThresholds(bool isMale) {
    // Research suggests higher BMI in elderly may be protective (obesity paradox)
    // But too low is still risky
    const maleAdjustment = 0.0;
    const femaleAdjustment = 0.5;
    final adjustment = isMale ? maleAdjustment : femaleAdjustment;

    return {
      'Underweight': BMIRange(0, 21.0),
      'Normal Range': BMIRange(21.0, 27.99),
      'Overweight': BMIRange(28.0, 31.99),
      'Obese Class I': BMIRange(32.0, 34.99),
      'Obese Class II': BMIRange(35.0, 39.99),
      'Obese Class III': BMIRange(40.0, 200),
    };
  }

  /// Get gender-appropriate healthy BMI range.
  static BMIRange getHealthyRange(int age, bool isMale) {
    final thresholds = getThresholdsForAge(age, isMale: isMale);
    
    // Find "Normal" or "Normal Weight" or "Normal Range" key
    for (final entry in thresholds.entries) {
      if (entry.key.toLowerCase().contains('normal')) {
        return entry.value;
      }
    }
    
    // Fallback to adult range if not found
    return BMIRange(18.5, 24.99);
  }

  /// Get ideal weight range for height (cm) and age/gender.
  static (double min, double max) getIdealWeightRange(
    int heightCm,
    int age,
    bool isMale,
  ) {
    final heightM = heightCm / 100.0;
    final range = getHealthyRange(age, isMale);

    return (
      (range.min * heightM * heightM).roundToDouble(),
      (range.max * heightM * heightM).roundToDouble(),
    );
  }
}

/// Represents a BMI range with min and max values.
class BMIRange {
  const BMIRange(this.min, this.max);

  final double min;
  final double max;

  /// Check if a BMI value falls within this range.
  bool contains(double bmi) => bmi >= min && bmi < max;

  /// Get midpoint of the range.
  double get midpoint => (min + max) / 2;

  @override
  String toString() => 'BMI $min–$max';
}

extension on double {
  double roundToDouble() => double.parse(toStringAsFixed(1));
}
