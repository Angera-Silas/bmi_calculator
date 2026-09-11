import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/metabolic_age.dart';

void main() {
  group('MetabolicAge', () {
    test('high BMR yields a younger metabolic age', () {
      // A 40-year-old man with a very high BMR.
      final ma = MetabolicAge.estimate(bmr: 2200, age: 40, isMale: true);
      expect(ma.difference, lessThan(0));
      expect(ma.status, MetabolicAgeStatus.faster);
    });

    test('low BMR yields an older metabolic age', () {
      final ma = MetabolicAge.estimate(bmr: 1000, age: 30, isMale: false);
      expect(ma.difference, greaterThan(0));
      expect(ma.status, MetabolicAgeStatus.slower);
    });

    test('matched BMR is within normal band', () {
      // Reference BMR for a 30-year-old woman = 10·60.6 + 6.25·160 − 5·30
      // − 161 = 1295 kcal/day (see metabolic_age.dart reference model).
      final ma = MetabolicAge.estimate(bmr: 1295, age: 30, isMale: false);
      expect(ma.difference.abs(), lessThanOrEqualTo(2));
      expect(ma.status, MetabolicAgeStatus.normal);
    });

    test('value is clamped to the 15–80 supported range', () {
      final ma = MetabolicAge.estimate(bmr: 9000, age: 25, isMale: true);
      expect(ma.value, lessThanOrEqualTo(80));
      expect(ma.value, greaterThanOrEqualTo(15));
    });

    test('rejects invalid inputs', () {
      expect(() => MetabolicAge.estimate(bmr: 0, age: 30, isMale: true),
          throwsArgumentError);
      expect(() => MetabolicAge.estimate(bmr: 1500, age: 0, isMale: true),
          throwsArgumentError);
    });

    test('category and recommendation strings present', () {
      final ma = MetabolicAge.estimate(bmr: 1500, age: 30, isMale: false);
      expect(ma.category, isNotEmpty);
      expect(ma.recommendation, isNotEmpty);
    });
  });
}
