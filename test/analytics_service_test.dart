import 'package:flutter_test/flutter_test.dart';

import 'package:bmi_calculator/models/bmi_record.dart';
import 'package:bmi_calculator/models/blood_pressure_record.dart';
import 'package:bmi_calculator/models/blood_sugar_record.dart';
import 'package:bmi_calculator/services/analytics_service.dart';

const _userId = 'test-user';

BmiRecord _bmi({
  required double bmiValue,
  required int weight,
  required DateTime timestamp,
}) {
  return BmiRecord(
    id: 'id-${bmiValue.hashCode}',
    userId: _userId,
    height: 170,
    weight: weight,
    age: 30,
    isMale: true,
    bmiValue: bmiValue,
    bmiResult: bmiValue.toStringAsFixed(1),
    resultText: 'Normal',
    interpretation: '',
    timestamp: timestamp,
  );
}

BloodPressureRecord _bp({required int sys, required int dia, DateTime? time}) {
  return BloodPressureRecord(
    id: 'bp-$sys-$dia',
    userId: _userId,
    systolic: sys,
    diastolic: dia,
    measurementTime: time ?? DateTime(2026, 9, 1),
  );
}

BloodSugarRecord _glucose({required int level, DateTime? time}) {
  return BloodSugarRecord(
    id: 'gl-$level',
    userId: _userId,
    glucoseLevel: level,
    measurementType: GlucoseMeasurementType.fasting,
    measurementTime: time ?? DateTime(2026, 9, 1),
  );
}

void main() {
  group('movingAverage', () {
    test('returns empty when fewer records than window', () {
      final records = [
        _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
      ];
      expect(AnalyticsService.movingAverage(records, window: 3), isEmpty);
    });

    test('computes sliding window average', () {
      final records = List.generate(
        5,
        (i) => _bmi(
          bmiValue: 20.0 + i,
          weight: 70,
          timestamp: DateTime(2026, 1, i + 1),
        ),
      );
      final ma = AnalyticsService.movingAverage(records, window: 3);
      expect(ma.length, 3);
      // First window: (20+21+22)/3 = 21.0
      expect(ma[0], closeTo(21.0, 0.01));
      // Second: (21+22+23)/3 = 22.0
      expect(ma[1], closeTo(22.0, 0.01));
      // Third: (22+23+24)/3 = 23.0
      expect(ma[2], closeTo(23.0, 0.01));
    });
  });

  group('weightRegression', () {
    test('returns null with fewer than 2 records', () {
      expect(
        AnalyticsService.weightRegression([
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        ]),
        isNull,
      );
    });

    test('detects gaining trend', () {
      final records = [
        _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        _bmi(bmiValue: 23, weight: 72, timestamp: DateTime(2026, 1, 11)),
        _bmi(bmiValue: 24, weight: 74, timestamp: DateTime(2026, 1, 21)),
      ];
      final reg = AnalyticsService.weightRegression(records);
      expect(reg, isNotNull);
      expect(reg!.$1, greaterThan(0), reason: 'positive slope = gaining');
    });

    test('detects losing trend', () {
      final records = [
        _bmi(bmiValue: 26, weight: 85, timestamp: DateTime(2026, 1, 1)),
        _bmi(bmiValue: 25, weight: 82, timestamp: DateTime(2026, 1, 11)),
        _bmi(bmiValue: 24, weight: 79, timestamp: DateTime(2026, 1, 21)),
      ];
      final reg = AnalyticsService.weightRegression(records);
      expect(reg, isNotNull);
      expect(reg!.$1, lessThan(0), reason: 'negative slope = losing');
    });
  });

  group('bmiRegression', () {
    test('returns null with fewer than 2 records', () {
      expect(
        AnalyticsService.bmiRegression([
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        ]),
        isNull,
      );
    });

    test('computes slope and intercept', () {
      final records = [
        _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        _bmi(bmiValue: 24, weight: 74, timestamp: DateTime(2026, 1, 11)),
      ];
      final reg = AnalyticsService.bmiRegression(records);
      expect(reg, isNotNull);
      expect(reg!.$1, greaterThan(0));
    });
  });

  group('pearsonR', () {
    test('returns null for mismatched lengths', () {
      expect(AnalyticsService.pearsonR([1, 2], [1]), isNull);
    });

    test('returns 1.0 for perfect positive correlation', () {
      expect(
          AnalyticsService.pearsonR([1, 2, 3], [2, 4, 6]), closeTo(1.0, 0.01));
    });

    test('returns -1.0 for perfect negative correlation', () {
      expect(
          AnalyticsService.pearsonR([1, 2, 3], [6, 4, 2]), closeTo(-1.0, 0.01));
    });

    test('returns 0 for no correlation', () {
      expect(
          AnalyticsService.pearsonR([1, 2, 3], [5, 5, 5]), closeTo(0.0, 0.01));
    });
  });

  group('weightTimeCorrelation', () {
    test('returns null with fewer than 2 records', () {
      expect(
        AnalyticsService.weightTimeCorrelation([
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        ]),
        isNull,
      );
    });

    test('returns positive r when weight increases over time', () {
      final records = [
        _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        _bmi(bmiValue: 23, weight: 72, timestamp: DateTime(2026, 1, 11)),
        _bmi(bmiValue: 24, weight: 74, timestamp: DateTime(2026, 1, 21)),
      ];
      final r = AnalyticsService.weightTimeCorrelation(records);
      expect(r, isNotNull);
      expect(r!, greaterThan(0.9));
    });
  });

  group('predictBMI', () {
    test('returns null with fewer than 2 records', () {
      expect(
        AnalyticsService.predictBMI([
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        ]),
        isNull,
      );
    });

    test('projects upward for gaining trend', () {
      final records = [
        _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        _bmi(bmiValue: 23, weight: 72, timestamp: DateTime(2026, 1, 11)),
        _bmi(bmiValue: 24, weight: 74, timestamp: DateTime(2026, 1, 21)),
      ];
      final predicted = AnalyticsService.predictBMI(records, daysAhead: 30);
      expect(predicted, isNotNull);
      expect(predicted!, greaterThan(24));
    });

    test('projects downward for losing trend', () {
      final records = [
        _bmi(bmiValue: 28, weight: 85, timestamp: DateTime(2026, 1, 1)),
        _bmi(bmiValue: 26, weight: 80, timestamp: DateTime(2026, 1, 11)),
        _bmi(bmiValue: 24, weight: 75, timestamp: DateTime(2026, 1, 21)),
      ];
      final predicted = AnalyticsService.predictBMI(records, daysAhead: 30);
      expect(predicted, isNotNull);
      expect(predicted!, lessThan(24));
    });
  });

  group('predictWeight', () {
    test('returns null with fewer than 2 records', () {
      expect(
        AnalyticsService.predictWeight([
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        ]),
        isNull,
      );
    });

    test('projects forward correctly', () {
      final records = [
        _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, 1)),
        _bmi(bmiValue: 23, weight: 72, timestamp: DateTime(2026, 1, 11)),
      ];
      final predicted = AnalyticsService.predictWeight(records, daysAhead: 10);
      expect(predicted, isNotNull);
      expect(predicted!, closeTo(74.0, 0.5));
    });
  });

  group('computeHealthScore', () {
    test('returns baseline score with no records', () {
      final score = AnalyticsService.computeHealthScore(bmiRecords: []);
      // Defaults: bmi=50*0.4 + bp=50*0.3 + glucose=50*0.15 + trend=75*0.15 ≈ 54
      expect(score.overall, 54);
    });

    test('rewards normal BMI', () {
      final records = [
        _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1)),
      ];
      final score = AnalyticsService.computeHealthScore(bmiRecords: records);
      expect(score.bmiComponent, 100);
      expect(score.overall, greaterThanOrEqualTo(50));
    });

    test('penalizes obese BMI', () {
      final records = [
        _bmi(bmiValue: 35, weight: 100, timestamp: DateTime(2026, 9, 1)),
      ];
      final score = AnalyticsService.computeHealthScore(bmiRecords: records);
      expect(score.bmiComponent, lessThan(50));
    });

    test('rewards normal BP', () {
      final score = AnalyticsService.computeHealthScore(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        bpRecords: [_bp(sys: 115, dia: 75)],
      );
      expect(score.bpComponent, 100);
    });

    test('penalizes high BP', () {
      final score = AnalyticsService.computeHealthScore(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        bpRecords: [_bp(sys: 150, dia: 95)],
      );
      expect(score.bpComponent, lessThan(50));
    });

    test('rewards normal glucose', () {
      final score = AnalyticsService.computeHealthScore(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        glucoseRecords: [_glucose(level: 90)],
      );
      expect(score.glucoseComponent, 100);
    });

    test('penalizes high glucose', () {
      final score = AnalyticsService.computeHealthScore(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        glucoseRecords: [_glucose(level: 180)],
      );
      expect(score.glucoseComponent, lessThan(50));
    });

    test('trend score rewards stability', () {
      final stable = List.generate(
        5,
        (i) =>
            _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 1, i + 1)),
      );
      final score = AnalyticsService.computeHealthScore(bmiRecords: stable);
      expect(score.trendComponent, greaterThanOrEqualTo(75));
    });
  });

  group('compareWithPopulation', () {
    test('normal BMI maps to 50th percentile', () {
      final comp = AnalyticsService.compareWithPopulation(
        bmi: 24,
        age: 30,
        isMale: true,
      );
      expect(comp.percentile, 50);
    });

    test('high BMI maps to 85th+ percentile', () {
      final comp = AnalyticsService.compareWithPopulation(
        bmi: 33,
        age: 30,
        isMale: true,
      );
      expect(comp.percentile, greaterThanOrEqualTo(85));
    });

    test('low BMI maps to low percentile', () {
      final comp = AnalyticsService.compareWithPopulation(
        bmi: 17,
        age: 30,
        isMale: false,
      );
      expect(comp.percentile, 5);
    });

    test('extreme BMI maps to 99th', () {
      final comp = AnalyticsService.compareWithPopulation(
        bmi: 40,
        age: 30,
        isMale: true,
      );
      expect(comp.percentile, 99);
    });
  });
}
