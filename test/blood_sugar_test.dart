import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/blood_sugar_record.dart';

void main() {
  BloodSugarRecord rec({
    int level = 95,
    GlucoseMeasurementType type = GlucoseMeasurementType.fasting,
    String? mealContext,
    bool isSynced = false,
    bool isDeleted = false,
    String? remoteId,
  }) {
    return BloodSugarRecord(
      id: 'bs-1',
      userId: 'user-1',
      glucoseLevel: level,
      measurementType: type,
      mealContext: mealContext,
      measurementTime: DateTime(2026, 9, 9, 8, 30),
      isSynced: isSynced,
      isDeleted: isDeleted,
      remoteId: remoteId,
    );
  }

  group('ADA classification — fasting', () {
    test('Normal < 100', () {
      expect(rec(level: 80).status, BloodSugarStatus.normal);
      expect(rec(level: 99).status, BloodSugarStatus.normal);
    });

    test('Prediabetes 100 – 125', () {
      expect(rec(level: 100).status, BloodSugarStatus.prediabetes);
      expect(rec(level: 125).status, BloodSugarStatus.prediabetes);
    });

    test('Diabetes ≥ 126', () {
      expect(rec(level: 126).status, BloodSugarStatus.diabetes);
      expect(rec(level: 200).status, BloodSugarStatus.diabetes);
    });
  });

  group('ADA classification — post-meal / random', () {
    test('Normal < 140', () {
      expect(rec(level: 139, type: GlucoseMeasurementType.postMeal).status,
          BloodSugarStatus.normal);
      expect(rec(level: 110, type: GlucoseMeasurementType.random).status,
          BloodSugarStatus.normal);
    });

    test('Prediabetes 140 – 199', () {
      expect(rec(level: 140, type: GlucoseMeasurementType.postMeal).status,
          BloodSugarStatus.prediabetes);
      expect(rec(level: 199, type: GlucoseMeasurementType.random).status,
          BloodSugarStatus.prediabetes);
    });

    test('Diabetes ≥ 200', () {
      expect(rec(level: 200, type: GlucoseMeasurementType.postMeal).status,
          BloodSugarStatus.diabetes);
      expect(rec(level: 260, type: GlucoseMeasurementType.random).status,
          BloodSugarStatus.diabetes);
    });
  });

  group('measurement type storage mapping', () {
    test('storageValue round trips', () {
      for (final type in GlucoseMeasurementType.values) {
        expect(
          GlucoseMeasurementType.fromStorage(type.storageValue),
          type,
        );
      }
    });

    test('unknown / null falls back to fasting', () {
      expect(GlucoseMeasurementType.fromStorage(null),
          GlucoseMeasurementType.fasting);
      expect(GlucoseMeasurementType.fromStorage('lunch'),
          GlucoseMeasurementType.fasting);
    });
  });

  group('A1C estimation', () {
    test('empty list returns null', () {
      expect(A1CEstimator.fromRecords([]), isNull);
    });

    test('ADA eAG formula: avg 100 mg/dL → 5.1% A1C', () {
      final a1c = A1CEstimator.fromAverageGlucose(100);
      expect((a1c * 10).roundToDouble() / 10, 5.1);
    });

    test('avg 170 mg/dL → 7.6% A1C (diabetes range)', () {
      final a1c = A1CEstimator.fromAverageGlucose(170);
      expect((a1c * 10).roundToDouble() / 10, 7.6);
    });

    test('fromRecords averages multiple readings', () {
      final records = [
        rec(level: 90),
        rec(level: 110),
        rec(level: 100),
      ];
      final a1c = A1CEstimator.fromRecords(records);
      // average = 100 → 5.1%
      expect((a1c! * 10).roundToDouble() / 10, 5.1);
    });

    test('statusForA1C boundaries', () {
      expect(A1CEstimator.statusForA1C(5.6), BloodSugarStatus.normal);
      expect(A1CEstimator.statusForA1C(5.7), BloodSugarStatus.prediabetes);
      expect(A1CEstimator.statusForA1C(6.4), BloodSugarStatus.prediabetes);
      expect(A1CEstimator.statusForA1C(6.5), BloodSugarStatus.diabetes);
    });
  });

  group('serialization', () {
    test('toMap / fromMap round trip preserves all fields', () {
      final original = BloodSugarRecord(
        id: 'bs-abc',
        userId: 'guest',
        glucoseLevel: 145,
        measurementType: GlucoseMeasurementType.postMeal,
        mealContext: 'after lunch',
        measurementTime: DateTime(2026, 9, 9, 13, 5),
        notes: 'post meal',
        isSynced: true,
        remoteId: 'remote-9',
      );

      final restored = BloodSugarRecord.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.userId, original.userId);
      expect(restored.glucoseLevel, original.glucoseLevel);
      expect(restored.measurementType, original.measurementType);
      expect(restored.mealContext, original.mealContext);
      expect(restored.measurementTime, original.measurementTime);
      expect(restored.notes, original.notes);
      expect(restored.isSynced, original.isSynced);
      expect(restored.isDeleted, original.isDeleted);
      expect(restored.remoteId, original.remoteId);
    });

    test('fromMap handles null optional fields', () {
      final restored = BloodSugarRecord.fromMap(rec().toMap());
      expect(restored.mealContext, isNull);
      expect(restored.notes, isNull);
      expect(restored.remoteId, isNull);
      expect(restored.isSynced, isFalse);
      expect(restored.measurementType, GlucoseMeasurementType.fasting);
    });

    test('toFirestoreMap excludes local-only fields', () {
      final map = rec(remoteId: 'r-1').toFirestoreMap('user-1');
      expect(map['glucoseLevel'], 95);
      expect(map['measurementType'], 'fasting');
      expect(map['userId'], 'user-1');
      expect(map['localId'], 'bs-1');
      expect(map.containsKey('is_synced'), isFalse);
      expect(map.containsKey('is_deleted'), isFalse);
      expect(map.containsKey('remote_id'), isFalse);
      expect(map.containsKey('measurement_time'), isFalse);
    });
  });

  group('validation', () {
    test('rejects out-of-range glucose', () {
      expect(() => rec(level: 10), throwsAssertionError);
      expect(() => rec(level: 900), throwsAssertionError);
    });
  });

  group('copyWith', () {
    test('updates only provided fields', () {
      final base = rec(level: 95);
      final updated = base.copyWith(
        glucoseLevel: 130,
        measurementType: GlucoseMeasurementType.random,
      );
      expect(updated.glucoseLevel, 130);
      expect(updated.measurementType, GlucoseMeasurementType.random);
      expect(updated.id, base.id);
      expect(updated.measurementTime, base.measurementTime);
    });
  });
}
