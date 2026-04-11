import 'age_group.dart';
import 'health_condition.dart';
import 'pregnancy_status.dart';

/// Comprehensive user profile for BMI calculation and health tracking.
class UserProfile {
  UserProfile({
    required this.age,
    required this.isMale,
    this.healthConditions = const [],
    this.pregnancyStatus = PregnancyStatus.notApplicable,
    this.prePregnancyWeight,
  }) {
    if (age < 0 || age > 150) {
      throw ArgumentError('Age must be between 0 and 150 years.');
    }
    if (!isMale && pregnancyStatus == PregnancyStatus.notApplicable && prePregnancyWeight != null) {
      throw ArgumentError('Pre-pregnancy weight should only be set when pregnant.');
    }
  }

  final int age;
  final bool isMale;
  final List<HealthCondition> healthConditions;
  final PregnancyStatus pregnancyStatus;
  final double? prePregnancyWeight; // kg, only for pregnant users

  /// Get age group classification.
  AgeGroup get ageGroup => age.getAgeGroup();

  /// Check if user is pregnant.
  bool get isPregnant =>
      !isMale &&
      pregnancyStatus != PregnancyStatus.notApplicable &&
      pregnancyStatus != PregnancyStatus.postpartum;

  /// Check if user is in postpartum period.
  bool get isPostpartum =>
      !isMale && pregnancyStatus == PregnancyStatus.postpartum;

  /// Check if user is a child (for BMI percentile interpretation).
  bool get isChild => age < 18;

  /// Check if user is elderly.
  bool get isElderly => age >= 65;

  /// Check if user is adult (18-65).
  bool get isAdult => age >= 18 && age <= 65;

  /// Has any significant health conditions.
  bool get hasHealthConditions =>
      healthConditions.isNotEmpty &&
      !healthConditions.every((c) => c == HealthCondition.none);

  /// Get primary health concern for recommendation priority.
  HealthCondition? get primaryHealthConcern {
    // Prioritize serious conditions
    const priorityOrder = [
      HealthCondition.heartDisease,
      HealthCondition.diabetes,
      HealthCondition.hypertension,
      HealthCondition.metabolicSyndrome,
      HealthCondition.pcos,
      HealthCondition.thyroid,
      HealthCondition.arthritis,
      HealthCondition.asthma,
    ];

    for (final condition in priorityOrder) {
      if (healthConditions.contains(condition)) {
        return condition;
      }
    }
    return null;
  }

  /// Generate a copy with modified fields.
  UserProfile copyWith({
    int? age,
    bool? isMale,
    List<HealthCondition>? healthConditions,
    PregnancyStatus? pregnancyStatus,
    double? prePregnancyWeight,
  }) {
    return UserProfile(
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
      healthConditions: healthConditions ?? this.healthConditions,
      pregnancyStatus: pregnancyStatus ?? this.pregnancyStatus,
      prePregnancyWeight: prePregnancyWeight ?? this.prePregnancyWeight,
    );
  }

  @override
  String toString() =>
      'UserProfile(age: $age, gender: ${isMale ? 'M' : 'F'}, conditions: $healthConditions, pregnancy: $pregnancyStatus)';
}
