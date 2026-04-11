/// Health conditions that affect BMI interpretation.
enum HealthCondition {
  none,
  diabetes,
  hypertension,
  heartDisease,
  metabolicSyndrome,
  pcos, // Polycystic Ovary Syndrome
  thyroid,
  arthritis,
  asthma,
}

/// Extension for user-friendly labels.
extension HealthConditionExtension on HealthCondition {
  String get label {
    return switch (this) {
      HealthCondition.none => 'None',
      HealthCondition.diabetes => 'Type 2 Diabetes',
      HealthCondition.hypertension => 'Hypertension (High Blood Pressure)',
      HealthCondition.heartDisease => 'Heart Disease',
      HealthCondition.metabolicSyndrome => 'Metabolic Syndrome',
      HealthCondition.pcos => 'PCOS (Polycystic Ovary Syndrome)',
      HealthCondition.thyroid => 'Thyroid Disorder',
      HealthCondition.arthritis => 'Arthritis',
      HealthCondition.asthma => 'Asthma',
    };
  }

  String get description {
    return switch (this) {
      HealthCondition.none => 'No known health conditions',
      HealthCondition.diabetes => 'Requires careful weight management and regular monitoring',
      HealthCondition.hypertension => 'Weight reduction is key to managing blood pressure',
      HealthCondition.heartDisease => 'Weight management reduces cardiovascular strain',
      HealthCondition.metabolicSyndrome => 'Combined metabolic risk factors require holistic management',
      HealthCondition.pcos => 'Weight management helps regulate hormones and fertility',
      HealthCondition.thyroid => 'Thyroid function affects metabolism and weight',
      HealthCondition.arthritis => 'Weight reduction reduces joint stress',
      HealthCondition.asthma => 'Weight management can improve respiratory function',
    };
  }

  /// Short label for UI chips/badges.
  String get shortLabel {
    return switch (this) {
      HealthCondition.none => 'None',
      HealthCondition.diabetes => 'Diabetes',
      HealthCondition.hypertension => 'Hypertension',
      HealthCondition.heartDisease => 'Heart Disease',
      HealthCondition.metabolicSyndrome => 'Metabolic Syndrome',
      HealthCondition.pcos => 'PCOS',
      HealthCondition.thyroid => 'Thyroid',
      HealthCondition.arthritis => 'Arthritis',
      HealthCondition.asthma => 'Asthma',
    };
  }
}
