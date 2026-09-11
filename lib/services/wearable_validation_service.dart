/// Validation rules for health readings pulled from wearable platforms
/// (Health Connect / HealthKit).
///
/// Outlier readings (sensor glitches, unit errors) are rejected before import
/// so they don't poison History, Dashboard or Insights. All bounds are chosen
/// to be wider than any plausible real-world value.
class WearableValidationService {
  const WearableValidationService._();

  // ── Blood pressure ──────────────────────────────────────────────────────

  /// Systolic range (mmHg). WHO: crisis > 180, but sensor errors can report
  /// wildly high/low values. We keep a generous guard.
  static const double systolicMin = 50;
  static const double systolicMax = 300;

  /// Diastolic range (mmHg).
  static const double diastolicMin = 30;
  static const double diastolicMax = 200;

  /// Diastolic must always be < systolic.
  static bool validBp(double systolic, double diastolic) {
    if (systolic < systolicMin || systolic > systolicMax) return false;
    if (diastolic < diastolicMin || diastolic > diastolicMax) return false;
    return diastolic < systolic;
  }

  // ── Glucose ─────────────────────────────────────────────────────────────

  /// Glucose range (mg/dL). Matches BloodSugarRecord's assertion range.
  static const double glucoseMin = 20;
  static const double glucoseMax = 800;

  static bool validGlucose(double mgdl) =>
      mgdl >= glucoseMin && mgdl <= glucoseMax;

  // ── Weight ──────────────────────────────────────────────────────────────

  /// Weight range (kg). Covers neonates to extreme obesity.
  static const double weightMin = 20;
  static const double weightMax = 300;

  static bool validWeight(double kg) => kg >= weightMin && kg <= weightMax;

  // ── Height ──────────────────────────────────────────────────────────────

  /// Height range (cm).
  static const double heightMin = 50;
  static const double heightMax = 250;

  static bool validHeight(double cm) => cm >= heightMin && cm <= heightMax;
}

/// Tracks which samples from a wearable snapshot were rejected by validation
/// and why.
class WearableRejection {
  final String metric;
  final double value;
  final String reason;

  const WearableRejection({
    required this.metric,
    required this.value,
    required this.reason,
  });

  @override
  String toString() => '$metric=$value rejected: $reason';
}
