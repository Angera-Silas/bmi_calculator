/// Metabolic age — an estimate of the age whose "average" resting metabolism
/// matches the user's own BMR.
///
/// Methodology (clearly an estimate, not a clinical value):
///  1. The user's BMR is computed with the Mifflin-St Jeor equation.
///  2. A reference average BMR is computed for every age 15–80 using a simple
///     reference body-weight model for that age/gender.
///  3. Metabolic age = the reference age whose BMR is closest to the user's.
///
/// A metabolic age **lower** than chronological age indicates a faster-than-
/// average resting metabolism for the user's age (often from more lean mass).
class MetabolicAge {
  MetabolicAge._(this.value, this.chronologicalAge);

  /// Estimated metabolic age, clamped to the 15–80 supported range.
  final int value;

  /// The user's chronological age.
  final int chronologicalAge;

  /// Estimate from a user BMR (kcal/day).
  factory MetabolicAge.estimate({
    required double bmr,
    required int age,
    required bool isMale,
  }) {
    if (bmr <= 0) {
      throw ArgumentError('BMR must be greater than zero.');
    }
    if (age < 1 || age > 120) {
      throw ArgumentError('Age must be between 1 and 120.');
    }

    int bestAge = age;
    double bestDelta = double.infinity;
    for (var candidate = 15; candidate <= 80; candidate++) {
      final delta = (_referenceBmr(candidate, isMale) - bmr).abs();
      if (delta < bestDelta) {
        bestDelta = delta;
        bestAge = candidate;
      }
    }
    return MetabolicAge._(bestAge, age);
  }

  /// Number of years the metabolic age differs from chronological age.
  int get difference => value - chronologicalAge;

  /// Convenience classification.
  MetabolicAgeStatus get status {
    if (difference <= -2) return MetabolicAgeStatus.faster;
    if (difference >= 2) return MetabolicAgeStatus.slower;
    return MetabolicAgeStatus.normal;
  }

  String get category => switch (status) {
        MetabolicAgeStatus.faster => 'Younger than your age',
        MetabolicAgeStatus.normal => 'Matches your age',
        MetabolicAgeStatus.slower => 'Older than your age',
      };

  String get recommendation => switch (status) {
        MetabolicAgeStatus.faster =>
          'Your resting metabolism tracks a younger profile — likely from good muscle mass. Keep strength training.',
        MetabolicAgeStatus.normal =>
          'Your metabolic age is in line with your chronological age.',
        MetabolicAgeStatus.slower =>
          'A higher metabolic age suggests a lower resting metabolic rate. Increasing lean muscle mass can help.',
      };

  /// Reference average BMR (Mifflin-St Jeor) for a given age using a
  /// population-average body model:
  ///   male weight:   70 kg + 0.15·(age − 25), height 172 cm
  ///   female weight: 60 kg + 0.12·(age − 25), height 160 cm
  static double _referenceBmr(int age, bool isMale) {
    final weight = isMale ? 70.0 + 0.15 * (age - 25) : 60.0 + 0.12 * (age - 25);
    final height = isMale ? 172.0 : 160.0;
    return (10 * weight) + (6.25 * height) - (5 * age) + (isMale ? 5 : -161);
  }
}

enum MetabolicAgeStatus { faster, normal, slower }
