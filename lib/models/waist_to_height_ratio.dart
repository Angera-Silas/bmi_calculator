/// Waist-to-Height Ratio (WHtR) — a simple screen for central adiposity.
///
/// Widely used as a cardiometabolic-risk indicator. A ratio of ≥ 0.5 is the
/// accepted "keep your waist to less than half your height" threshold.
/// Guidance reference: Ashwell et al. / WHO waist circumference thresholds.
class WaistToHeightRatio {
  /// Guards against nonsense input.
  WaistToHeightRatio({
    required double waistCm,
    required double heightCm,
  }) : _ratio = waistCm / heightCm {
    if (waistCm <= 0) {
      throw ArgumentError('Waist circumference must be greater than zero.');
    }
    if (heightCm <= 0) {
      throw ArgumentError('Height must be greater than zero.');
    }
  }

  final double _ratio;

  /// The ratio rounded to two decimals (typical display precision).
  double get value => double.parse(_ratio.toStringAsFixed(2));

  /// The raw (unrounded) ratio for calculation.
  double get raw => _ratio;

  WaistToHeightRiskLevel get riskLevel {
    if (_ratio < 0.40) return WaistToHeightRiskLevel.lean;
    if (_ratio < 0.50) return WaistToHeightRiskLevel.healthy;
    if (_ratio < 0.60) return WaistToHeightRiskLevel.increased;
    return WaistToHeightRiskLevel.high;
  }

  /// Stable display key (English default; translatable at the widget layer).
  String get category => switch (riskLevel) {
        WaistToHeightRiskLevel.lean => 'Lean',
        WaistToHeightRiskLevel.healthy => 'Healthy',
        WaistToHeightRiskLevel.increased => 'Increased risk',
        WaistToHeightRiskLevel.high => 'High risk',
      };

  /// Actionable guidance for the category.
  String get recommendation => switch (riskLevel) {
        WaistToHeightRiskLevel.lean =>
          'Low central fat. Focus on overall health and keep a balanced lifestyle.',
        WaistToHeightRiskLevel.healthy =>
          'Healthy waist-to-height ratio. Maintain your current lifestyle.',
        WaistToHeightRiskLevel.increased =>
          'Elevated central adiposity. Moderate exercise and portion control can help reduce waist circumference.',
        WaistToHeightRiskLevel.high =>
          'High waist-to-height ratio — strong cardiometabolic risk signal. Consider consulting a healthcare provider.',
      };

  @override
  String toString() => 'WHtR ${value.toStringAsFixed(2)} ($category)';
}

enum WaistToHeightRiskLevel { lean, healthy, increased, high }
