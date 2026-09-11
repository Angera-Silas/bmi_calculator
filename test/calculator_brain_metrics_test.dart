import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/calculator_brain.dart';
import 'package:bmi_calculator/models/user_profile.dart';

void main() {
  group('CalculatorBrain advanced metrics', () {
    CalculatorBrain brain({
      int? waist,
      int? neck,
      int? hip,
      int? rhr,
      bool isMale = true,
    }) {
      return CalculatorBrain.withProfile(
        height: 175,
        weight: 75,
        age: 30,
        isMale: isMale,
        userProfile: UserProfile(age: 30, isMale: isMale),
        waistCircumferenceCm: waist?.toDouble(),
        neckCircumferenceCm: neck?.toDouble(),
        hipCircumferenceCm: hip?.toDouble(),
        restingHeartRateBpm: rhr,
      );
    }

    test('waistToHeightRatio is null without waist input', () {
      expect(brain().waistToHeightRatio, isNull);
    });

    test('waistToHeightRatio computed when waist provided', () {
      final w = brain(waist: 80).waistToHeightRatio;
      expect(w, isNotNull);
      expect(w!.raw, closeTo(80 / 175, 0.001));
      expect(w.value, closeTo(0.46, 0.01));
    });

    test('bodyFatPercentage null without waist/neck', () {
      expect(brain().bodyFatPercentage, isNull);
    });

    test('male bodyFatPercentage computed with waist + neck', () {
      final bf = brain(waist: 90, neck: 40).bodyFatPercentage;
      expect(bf, isNotNull);
      expect(bf!.percent, inInclusiveRange(3, 40));
    });

    test('female bodyFatPercentage null without hip', () {
      expect(
        brain(waist: 85, neck: 34, isMale: false).bodyFatPercentage,
        isNull,
      );
    });

    test('female bodyFatPercentage computed with hip', () {
      final bf =
          brain(waist: 65, neck: 30, hip: 85, isMale: false).bodyFatPercentage;
      expect(bf, isNotNull);
      expect(bf!.percent, inInclusiveRange(3, 50));
    });

    test('invalid body-fat geometry returns null (not throws)', () {
      // waist (80) <= neck (85) triggers the guard — must be swallowed.
      expect(brain(waist: 80, neck: 85).bodyFatPercentage, isNull);
    });

    test('metabolicAge always available for a valid profile', () {
      final ma = brain().metabolicAge;
      expect(ma, isNotNull);
      expect(ma!.value, inInclusiveRange(15, 80));
    });

    test('vo2max null without resting heart rate', () {
      expect(brain().vo2max, isNull);
    });

    test('vo2max computed when RHR provided', () {
      final v = brain(rhr: 60).vo2max;
      expect(v, isNotNull);
      expect(v!.value, greaterThan(0));
    });
  });
}
