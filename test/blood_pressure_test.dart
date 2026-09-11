import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/blood_pressure_record.dart';

void main() {
  BloodPressureRecord rec({
    int sys = 120,
    int dia = 80,
    int? pulse,
    bool isSynced = false,
    bool isDeleted = false,
    String? remoteId,
  }) {
    return BloodPressureRecord(
      id: 'bp-1',
      userId: 'user-1',
      systolic: sys,
      diastolic: dia,
      pulse: pulse,
      measurementTime: DateTime(2026, 9, 9, 8, 30),
    );
  }

  group('WHO classification (systolic)', () {
    test('Normal < 120', () {
      expect(rec(sys: 99, dia: 60).category, BloodPressureCategory.normal);
      expect(rec(sys: 119, dia: 79).category, BloodPressureCategory.normal);
    });

    test('Elevated 120 – 129', () {
      expect(rec(sys: 120, dia: 70).category, BloodPressureCategory.elevated);
      expect(rec(sys: 129, dia: 75).category, BloodPressureCategory.elevated);
    });

    test('High Stage 1 130 – 139', () {
      expect(rec(sys: 130, dia: 75).category, BloodPressureCategory.stage1);
      expect(rec(sys: 139, dia: 75).category, BloodPressureCategory.stage1);
    });

    test('High Stage 2 ≥ 140', () {
      expect(rec(sys: 140, dia: 80).category, BloodPressureCategory.stage2);
      expect(rec(sys: 179, dia: 90).category, BloodPressureCategory.stage2);
    });

    test('Crisis > 180', () {
      expect(rec(sys: 181, dia: 100).category, BloodPressureCategory.crisis);
      expect(rec(sys: 220, dia: 120).category, BloodPressureCategory.crisis);
    });
  });

  group('WHO classification (diastolic)', () {
    test('normal diastolic < 80', () {
      expect(rec(sys: 110, dia: 79).category, BloodPressureCategory.normal);
    });

    test('elevated diastolic 80 – 89', () {
      expect(rec(sys: 110, dia: 85).category, BloodPressureCategory.elevated);
    });

    test('stage 1 diastolic 90 – 99', () {
      expect(rec(sys: 118, dia: 95).category, BloodPressureCategory.stage1);
    });

    test('stage 2 diastolic ≥ 100', () {
      expect(rec(sys: 118, dia: 105).category, BloodPressureCategory.stage2);
    });

    test('crisis diastolic > 120', () {
      expect(rec(sys: 118, dia: 125).category, BloodPressureCategory.crisis);
    });
  });

  group('combined systolic + diastolic', () {
    test('takes the worst of the two numbers', () {
      // Normal systolic, elevated diastolic → elevated overall.
      expect(
        rec(sys: 118, dia: 85).category,
        BloodPressureCategory.elevated,
      );
      // Stage-2 systolic, normal diastolic → stage 2 overall.
      expect(
        rec(sys: 150, dia: 79).category,
        BloodPressureCategory.stage2,
      );
      // Both high → high stage 2.
      expect(
        rec(sys: 155, dia: 105).category,
        BloodPressureCategory.stage2,
      );
    });
  });

  group('serialization', () {
    test('toMap / fromMap round trip preserves all fields', () {
      final original = BloodPressureRecord(
        id: 'bp-abc',
        userId: 'guest',
        systolic: 132,
        diastolic: 86,
        pulse: 71,
        measurementTime: DateTime(2026, 9, 9, 8, 30),
        notes: 'after coffee',
        isSynced: true,
        remoteId: 'remote-1',
      );

      final restored = BloodPressureRecord.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.userId, original.userId);
      expect(restored.systolic, original.systolic);
      expect(restored.diastolic, original.diastolic);
      expect(restored.pulse, original.pulse);
      expect(restored.measurementTime, original.measurementTime);
      expect(restored.notes, original.notes);
      expect(restored.isSynced, original.isSynced);
      expect(restored.isDeleted, original.isDeleted);
      expect(restored.remoteId, original.remoteId);
    });

    test('fromMap handles null pulse / notes / remoteId', () {
      final restored = BloodPressureRecord.fromMap(
        rec().toMap(),
      );
      expect(restored.pulse, isNull);
      expect(restored.notes, isNull);
      expect(restored.remoteId, isNull);
      expect(restored.isSynced, isFalse);
    });

    test('toFirestoreMap excludes local-only fields', () {
      final map = rec(remoteId: 'r-1').toFirestoreMap('user-1');
      expect(map['systolic'], 120);
      expect(map['diastolic'], 80);
      expect(map['userId'], 'user-1');
      expect(map['localId'], 'bp-1');
      expect(map.containsKey('is_synced'), isFalse);
      expect(map.containsKey('is_deleted'), isFalse);
      expect(map.containsKey('remote_id'), isFalse);
      expect(map.containsKey('measurement_time'), isFalse);
    });
  });

  group('validation', () {
    test('rejects out-of-range systolic', () {
      expect(() {
        rec(sys: 20);
      }, throwsAssertionError);
      expect(() {
        rec(sys: 320);
      }, throwsAssertionError);
    });

    test('rejects out-of-range diastolic', () {
      expect(() {
        rec(dia: 10);
      }, throwsAssertionError);
      expect(() {
        rec(dia: 250);
      }, throwsAssertionError);
    });
  });

  group('copyWith', () {
    test('updates only provided fields', () {
      final base = rec(pulse: 70);
      final updated = base.copyWith(pulse: 80, notes: 'rested');
      expect(updated.pulse, 80);
      expect(updated.notes, 'rested');
      expect(updated.systolic, base.systolic);
      expect(updated.diastolic, base.diastolic);
      expect(updated.id, base.id);
    });
  });
}
