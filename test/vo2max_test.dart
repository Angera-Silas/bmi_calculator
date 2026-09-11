import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/vo2max.dart';

void main() {
  group('Vo2Max', () {
    test('lower resting heart rate yields higher VO2max', () {
      final fit = Vo2Max(restingHeartRateBpm: 50, age: 25, isMale: true);
      final lessFit = Vo2Max(restingHeartRateBpm: 90, age: 25, isMale: true);
      expect(fit.value, greaterThan(lessFit.value));
      expect(fit.category.index, greaterThan(lessFit.category.index));
    });

    test('age-adjusted classification uses correct band', () {
      final older = Vo2Max(restingHeartRateBpm: 70, age: 65, isMale: true);
      final younger = Vo2Max(restingHeartRateBpm: 70, age: 25, isMale: true);
      // Same RHR but the older band has easier thresholds.
      expect(
          older.category.index, greaterThanOrEqualTo(younger.category.index));
    });

    test('female thresholds are easier than male', () {
      final male = Vo2Max(restingHeartRateBpm: 70, age: 30, isMale: true);
      final female = Vo2Max(restingHeartRateBpm: 70, age: 30, isMale: false);
      expect(female.category.index, greaterThanOrEqualTo(male.category.index));
    });

    test('value rounds to one decimal', () {
      final v = Vo2Max(restingHeartRateBpm: 70, age: 30, isMale: true);
      final raw = 15.3 * (208.0 - 0.7 * 30) / 70;
      expect(v.value, (raw * 10).roundToDouble() / 10);
    });

    test('rejects out-of-range heart rates', () {
      expect(() => Vo2Max(restingHeartRateBpm: 10, age: 30, isMale: true),
          throwsArgumentError);
      expect(() => Vo2Max(restingHeartRateBpm: 250, age: 30, isMale: true),
          throwsArgumentError);
    });
  });
}
