import 'dart:math';

/// Body fat percentage estimated with the **US Navy circumference method**.
///
/// Male:   %BF = 86.010·log₁₀(waist − neck) − 70.041·log₁₀(height) + 36.76
/// Female: %BF = 163.205·log₁₀(waist + hip − neck) − 97.684·log₁₀(height) − 78.387
///
/// All lengths in centimetres. This is an estimate (±3–4%), not a clinical
/// measurement.
class BodyFatPercentage {
  BodyFatPercentage({
    required double waistCm,
    required double neckCm,
    required double heightCm,
    required bool isMale,
    double? hipCm,
  })  : _isMale = isMale,
        _percent = _compute(waistCm, neckCm, heightCm, hipCm, isMale) {
    if (waistCm <= 0 || neckCm <= 0 || heightCm <= 0) {
      throw ArgumentError(
          'Circumference/height values must be greater than zero.');
    }
    if (!isMale && (hipCm == null || hipCm <= 0)) {
      throw ArgumentError(
          'Hip circumference is required for the female formula.');
    }
    if (isMale && waistCm <= neckCm) {
      throw ArgumentError('Waist must exceed neck for the male formula.');
    }
    if (!isMale && (waistCm + hipCm!) <= neckCm) {
      throw ArgumentError(
          'Waist + hip must exceed neck for the female formula.');
    }
  }

  final bool _isMale;
  final double _percent;

  /// Body fat percentage clamped to a plausible 3–65% display range.
  double get percent =>
      double.parse(_percent.clamp(3.0, 65.0).toStringAsFixed(1));

  /// Raw (unclamped) estimate.
  double get rawPercent => _percent;

  BodyFatCategory get category {
    final p = _percent;
    if (_isMale) {
      if (p < 6) return BodyFatCategory.essentialFat;
      if (p < 14) return BodyFatCategory.athlete;
      if (p < 18) return BodyFatCategory.fitness;
      if (p <= 24) return BodyFatCategory.acceptable;
      return BodyFatCategory.obese;
    }
    if (p < 14) return BodyFatCategory.essentialFat;
    if (p < 21) return BodyFatCategory.athlete;
    if (p < 25) return BodyFatCategory.fitness;
    if (p <= 31) return BodyFatCategory.acceptable;
    return BodyFatCategory.obese;
  }

  /// Stable display key (English default).
  String get categoryLabel => switch (category) {
        BodyFatCategory.essentialFat => 'Essential fat',
        BodyFatCategory.athlete => 'Athletes',
        BodyFatCategory.fitness => 'Fitness',
        BodyFatCategory.acceptable => 'Acceptable',
        BodyFatCategory.obese => 'Obese',
      };

  String get recommendation => switch (category) {
        BodyFatCategory.essentialFat =>
          'Essential fat range is the minimum required for health. Do not attempt to lose more.',
        BodyFatCategory.athlete =>
          'Athletic body fat level. Excellent body composition.',
        BodyFatCategory.fitness =>
          'Fit body composition. Keep up the good habits.',
        BodyFatCategory.acceptable =>
          'Acceptable but could be improved. Aim for the fitness range.',
        BodyFatCategory.obese =>
          'Elevated body fat. Consider a structured plan with diet and activity.',
      };

  static double _compute(
    double waist,
    double neck,
    double height,
    double? hip,
    bool isMale,
  ) {
    if (isMale) {
      return 86.010 * log(waist - neck) / ln10 -
          70.041 * log(height) / ln10 +
          36.76;
    }
    if (hip == null) {
      throw ArgumentError(
          'Hip circumference is required for the female formula.');
    }
    return 163.205 * log(waist + hip - neck) / ln10 -
        97.684 * log(height) / ln10 -
        78.387;
  }
}

enum BodyFatCategory { essentialFat, athlete, fitness, acceptable, obese }
