/// Age groups for BMI classification.
enum AgeGroup {
  infant, // 0-2 years
  toddler, // 2-5 years
  child, // 5-12 years
  teen, // 12-18 years
  adult, // 18-65 years
  elderly, // 65+ years
}

/// Extension to get age group from age in years.
extension AgeGroupExtension on int {
  AgeGroup getAgeGroup() {
    if (this < 2) return AgeGroup.infant;
    if (this < 5) return AgeGroup.toddler;
    if (this < 12) return AgeGroup.child;
    if (this < 18) return AgeGroup.teen;
    if (this <= 65) return AgeGroup.adult;
    return AgeGroup.elderly;
  }

  String getAgeGroupLabel() {
    return switch (getAgeGroup()) {
      AgeGroup.infant => 'Infant (0-2)',
      AgeGroup.toddler => 'Toddler (2-5)',
      AgeGroup.child => 'Child (5-12)',
      AgeGroup.teen => 'Teen (12-18)',
      AgeGroup.adult => 'Adult (18-65)',
      AgeGroup.elderly => 'Elderly (65+)',
    };
  }
}
