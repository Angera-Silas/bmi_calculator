import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/body_fat_percentage.dart';

void main() {
  group('BodyFatPercentage', () {
    test('male formula (US Navy) produces plausible result', () {
      final bf = BodyFatPercentage(
        waistCm: 90,
        neckCm: 40,
        heightCm: 180,
        isMale: true,
      );
      expect(bf.percent, inInclusiveRange(3, 30));
    });

    test('female formula requires hip circumference', () {
      expect(
        () => BodyFatPercentage(
          waistCm: 85,
          neckCm: 34,
          heightCm: 165,
          isMale: false,
        ),
        throwsArgumentError,
      );
      final bf = BodyFatPercentage(
        waistCm: 65,
        neckCm: 30,
        heightCm: 170,
        isMale: false,
        hipCm: 85,
      );
      expect(bf.percent, inInclusiveRange(3, 50));
    });

    test('rejects invalid geometry', () {
      expect(
        () => BodyFatPercentage(
          waistCm: 30,
          neckCm: 40,
          heightCm: 180,
          isMale: true,
        ),
        throwsArgumentError,
      );
    });

    test('female categories progress with fat mass', () {
      final lean = BodyFatPercentage(
        waistCm: 55,
        neckCm: 30,
        heightCm: 175,
        isMale: false,
        hipCm: 75,
      );
      final heavy = BodyFatPercentage(
        waistCm: 110,
        neckCm: 34,
        heightCm: 160,
        isMale: false,
        hipCm: 120,
      );
      expect(lean.category.index, lessThan(heavy.category.index));
    });

    test('percent clamps to max 65', () {
      final bf = BodyFatPercentage(
        waistCm: 140,
        neckCm: 30,
        heightCm: 150,
        isMale: true,
      );
      expect(bf.percent, lessThanOrEqualTo(65));
    });
  });
}
