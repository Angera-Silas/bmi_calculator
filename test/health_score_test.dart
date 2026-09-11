import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/blood_pressure_record.dart';
import 'package:bmi_calculator/models/blood_sugar_record.dart';
import 'package:bmi_calculator/services/health_score_service.dart';

void main() {
  group('empty data', () {
    test('returns null score and label when nothing provided', () {
      final r = HealthScoreService.compute();
      expect(r.score, isNull);
      expect(r.label, isNull);
    });
  });

  group('BMI pillar', () {
    test('normal BMI scores 100', () {
      final r = HealthScoreService.compute(latestBmi: 22.0);
      expect(r.bmiScore, 100);
      expect(r.score, 100);
      expect(r.label, HealthScoreLabel.excellent);
    });

    test('severe thinness scores 20', () {
      expect(HealthScoreService.compute(latestBmi: 15.0).bmiScore, 20);
    });

    test('obese III scores 15', () {
      expect(HealthScoreService.compute(latestBmi: 42.0).bmiScore, 15);
    });

    test('pre-obese scores 65', () {
      expect(HealthScoreService.compute(latestBmi: 27.0).bmiScore, 65);
    });

    test('boundary: 18.5 is normal (100), 25.0 is pre-obese (65)', () {
      expect(HealthScoreService.compute(latestBmi: 18.5).bmiScore, 100);
      expect(HealthScoreService.compute(latestBmi: 25.0).bmiScore, 65);
    });
  });

  group('BP pillar', () {
    test('normal = 100', () {
      final r =
          HealthScoreService.compute(bpCategory: BloodPressureCategory.normal);
      expect(r.bpScore, 100);
    });

    test('crisis = 10', () {
      expect(
          HealthScoreService.compute(bpCategory: BloodPressureCategory.crisis)
              .bpScore,
          10);
    });

    test('stage2 = 30, elevated = 80', () {
      expect(
          HealthScoreService.compute(bpCategory: BloodPressureCategory.stage2)
              .bpScore,
          30);
      expect(
          HealthScoreService.compute(bpCategory: BloodPressureCategory.elevated)
              .bpScore,
          80);
    });
  });

  group('glucose pillar', () {
    test('normal = 100, prediabetes = 60, diabetes = 25', () {
      expect(
          HealthScoreService.compute(glucoseStatus: BloodSugarStatus.normal)
              .glucoseScore,
          100);
      expect(
          HealthScoreService.compute(
                  glucoseStatus: BloodSugarStatus.prediabetes)
              .glucoseScore,
          60);
      expect(
          HealthScoreService.compute(glucoseStatus: BloodSugarStatus.diabetes)
              .glucoseScore,
          25);
    });
  });

  group('advanced pillar (WHtR)', () {
    test('healthy 0.45 → 100', () {
      expect(HealthScoreService.compute(latestWhtr: 0.45).advancedScore, 100);
    });

    test('risky 0.65 → 25', () {
      expect(HealthScoreService.compute(latestWhtr: 0.65).advancedScore, 25);
    });

    test('resting HR 60 → 100', () {
      expect(
          HealthScoreService.compute(restingHeartRate: 60).advancedScore, 100);
    });

    test('resting HR 110 → 20', () {
      expect(
          HealthScoreService.compute(restingHeartRate: 110).advancedScore, 20);
    });

    test('nil when neither WHtR nor resting HR provided', () {
      expect(HealthScoreService.compute().advancedScore, isNull);
    });

    test('averages WHtR and resting HR when both present', () {
      final r =
          HealthScoreService.compute(latestWhtr: 0.45, restingHeartRate: 60);
      expect(r.advancedScore, 100);
    });
  });

  group('weighted aggregation', () {
    test('all perfect pillars → 100 excellent', () {
      final r = HealthScoreService.compute(
        latestBmi: 22.0,
        bpCategory: BloodPressureCategory.normal,
        glucoseStatus: BloodSugarStatus.normal,
        latestWhtr: 0.45,
        restingHeartRate: 65,
      );
      expect(r.score, 100);
      expect(r.label, HealthScoreLabel.excellent);
    });

    test('partial profile re-weights (only BMI + BP available)', () {
      // BMI-22 → 100, BP-normal → 100 → still 100.
      final r = HealthScoreService.compute(
        latestBmi: 22.0,
        bpCategory: BloodPressureCategory.normal,
      );
      expect(r.score, 100);
    });

    test('mixed: obese + crisis + diabetes + high WHtR → needs improvement',
        () {
      final r = HealthScoreService.compute(
        latestBmi: 33.0, // 40
        bpCategory: BloodPressureCategory.stage2, // 30
        glucoseStatus: BloodSugarStatus.diabetes, // 25
        latestWhtr: 0.7, // 25
        restingHeartRate: 110, // 20 → advanced = 22.5
      );
      // (30*40 + 25*30 + 25*25 + 20*22.5) / 100 = 12 + 7.5 + 6.25 + 4.5 = 30.25
      expect(r.score, 30);
      expect(r.label, HealthScoreLabel.needsImprovement);
    });

    test('label thresholds', () {
      expect(HealthScoreService.compute(latestBmi: 21.0).label,
          HealthScoreLabel.excellent);
      // A mid-grade BMI should land in a mid band.
      final fair = HealthScoreService.compute(latestBmi: 33.0);
      expect(fair.label, isNotNull);
    });
  });

  group('labelForScore', () {
    test('returns matching band for any score', () {
      expect(HealthScoreService.labelForScore(95), HealthScoreLabel.excellent);
      expect(HealthScoreService.labelForScore(80), HealthScoreLabel.veryGood);
      expect(HealthScoreService.labelForScore(65), HealthScoreLabel.good);
      expect(HealthScoreService.labelForScore(50), HealthScoreLabel.fair);
      expect(HealthScoreService.labelForScore(30),
          HealthScoreLabel.needsImprovement);
      // boundaries
      expect(HealthScoreService.labelForScore(90), HealthScoreLabel.excellent);
      expect(HealthScoreService.labelForScore(75), HealthScoreLabel.veryGood);
      expect(HealthScoreService.labelForScore(60), HealthScoreLabel.good);
      expect(HealthScoreService.labelForScore(45), HealthScoreLabel.fair);
    });
  });

  group('recommendations', () {
    test('healthy profile → on-track recommendation only', () {
      final recs = HealthScoreService.recommendations(
        latestBmi: 22.0,
        bpCategory: BloodPressureCategory.normal,
        glucoseStatus: BloodSugarStatus.normal,
        latestWhtr: 0.45,
        restingHeartRate: 60,
      );
      expect(recs, hasLength(1));
      expect(recs.single.category, RecommendationCategory.onTrack);
    });

    test('obesity, hypertension, diabetes, high WHtR, high HR all flagged', () {
      final recs = HealthScoreService.recommendations(
        latestBmi: 33.0,
        bpCategory: BloodPressureCategory.stage1,
        glucoseStatus: BloodSugarStatus.prediabetes,
        latestWhtr: 0.65,
        restingHeartRate: 95,
      );
      final cats = recs.map((r) => r.category).toSet();
      expect(cats, contains(RecommendationCategory.healthyWeight));
      expect(cats, contains(RecommendationCategory.hypertension));
      expect(cats, contains(RecommendationCategory.glucoseControl));
      expect(cats, contains(RecommendationCategory.waistReduction));
      expect(cats, contains(RecommendationCategory.cardioFitness));
      expect(cats, isNot(contains(RecommendationCategory.onTrack)));
    });

    test('no data → on-track fallback', () {
      final recs = HealthScoreService.recommendations();
      expect(recs, hasLength(1));
      expect(recs.single.category, RecommendationCategory.onTrack);
    });
  });
}
