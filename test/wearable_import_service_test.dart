import 'package:flutter_test/flutter_test.dart';

import 'package:bmi_calculator/models/blood_pressure_record.dart';
import 'package:bmi_calculator/models/blood_sugar_record.dart';
import 'package:bmi_calculator/models/wearable_metric.dart';
import 'package:bmi_calculator/services/wearable_import_service.dart';

const _userId = 'test-user';

WearableSnapshot _snapshot({
  double? systolic,
  double? diastolic,
  double? glucose,
  double? weightKg,
  double? heightM,
  DateTime? bpTime,
  DateTime? glucoseTime,
}) {
  final samples = <WearableSample>[];
  final now = DateTime.utc(2026, 9, 9, 12, 0);
  final from = now.subtract(const Duration(hours: 24));

  if (systolic != null) {
    samples.add(WearableSample(
      metric: WearableMetric.systolic,
      value: systolic,
      unit: 'mmHg',
      startTime: bpTime ?? from,
      endTime: bpTime ?? now,
    ));
  }
  if (diastolic != null) {
    samples.add(WearableSample(
      metric: WearableMetric.diastolic,
      value: diastolic,
      unit: 'mmHg',
      startTime: bpTime ?? from,
      endTime: bpTime ?? now,
    ));
  }
  if (glucose != null) {
    samples.add(WearableSample(
      metric: WearableMetric.bloodGlucose,
      value: glucose,
      unit: 'mg/dL',
      startTime: glucoseTime ?? from,
      endTime: glucoseTime ?? now,
    ));
  }
  if (weightKg != null) {
    samples.add(WearableSample(
      metric: WearableMetric.weight,
      value: weightKg,
      unit: 'kg',
      startTime: from,
      endTime: now,
    ));
  }
  if (heightM != null) {
    samples.add(WearableSample(
      metric: WearableMetric.height,
      value: heightM,
      unit: 'm',
      startTime: from,
      endTime: now,
    ));
  }

  return WearableSnapshot(from: from, to: now, samples: samples);
}

void main() {
  group('WearableImportService.buildImport', () {
    test('creates BP record when systolic + diastolic present', () {
      final snap = _snapshot(systolic: 120, diastolic: 80);
      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: const [],
      );

      expect(result.bpRecords.length, 1);
      final bp = result.bpRecords.first;
      expect(bp.systolic, 120);
      expect(bp.diastolic, 80);
      expect(bp.userId, _userId);
      expect(bp.notes, 'Imported from wearable');
    });

    test('creates glucose record when glucose present', () {
      final snap = _snapshot(glucose: 95);
      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: const [],
      );

      expect(result.glucoseRecords.length, 1);
      expect(result.glucoseRecords.first.glucoseLevel, 95);
    });

    test('exposes auto-fill values', () {
      final snap = _snapshot(weightKg: 68.5, heightM: 1.72);
      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: const [],
      );

      expect(result.autoFillWeightKg, 68.5);
      expect(result.autoFillHeightCm, closeTo(172.0, 0.1));
    });

    test('skips BP when either systolic or diastolic missing', () {
      final snap = _snapshot(systolic: 120);
      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: const [],
      );

      expect(result.bpRecords, isEmpty);
    });

    test('deduplicates BP by time window and value', () {
      final time = DateTime.utc(2026, 9, 9, 12, 0);
      final snap = _snapshot(systolic: 120, diastolic: 80, bpTime: time);

      final existing = [
        BloodPressureRecord(
          id: 'existing-1',
          userId: _userId,
          systolic: 120,
          diastolic: 80,
          measurementTime: time,
        ),
      ];

      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: existing,
        existingGlucose: const [],
      );

      expect(result.bpRecords, isEmpty, reason: 'should dedup existing');
    });

    test('imports BP when time is outside dedup window', () {
      final time = DateTime.utc(2026, 9, 9, 12, 0);
      final snap = _snapshot(systolic: 120, diastolic: 80, bpTime: time);

      final existing = [
        BloodPressureRecord(
          id: 'old-1',
          userId: _userId,
          systolic: 120,
          diastolic: 80,
          measurementTime: time.subtract(const Duration(hours: 2)),
        ),
      ];

      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: existing,
        existingGlucose: const [],
      );

      expect(result.bpRecords.length, 1,
          reason: 'outside dedup window → insert');
    });

    test('deduplicates glucose by time window and value', () {
      final time = DateTime.utc(2026, 9, 9, 10, 0);
      final snap = _snapshot(glucose: 92, glucoseTime: time);

      final existing = [
        BloodSugarRecord(
          id: 'g1',
          userId: _userId,
          glucoseLevel: 92,
          measurementTime: time.add(const Duration(minutes: 2)),
        ),
      ];

      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: existing,
      );

      expect(result.glucoseRecords, isEmpty, reason: 'should dedup glucose');
    });

    test('returns empty plan for empty snapshot', () {
      final snap = WearableSnapshot(
        from: DateTime.utc(2026, 9, 1),
        to: DateTime.utc(2026, 9, 2),
        samples: const [],
      );

      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: const [],
      );

      expect(result.bpRecords, isEmpty);
      expect(result.glucoseRecords, isEmpty);
      expect(result.autoFillWeightKg, isNull);
      expect(result.autoFillHeightCm, isNull);
    });

    test('rejects out-of-range BP and tracks rejection', () {
      final snap = _snapshot(systolic: 400, diastolic: 250);
      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: const [],
      );

      expect(result.bpRecords, isEmpty);
      expect(result.hasRejections, isTrue);
      expect(result.rejections.length, 1);
      expect(result.rejections.first.metric, 'BP');
    });

    test('rejects out-of-range glucose and tracks rejection', () {
      final snap = _snapshot(glucose: 1000);
      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: const [],
      );

      expect(result.glucoseRecords, isEmpty);
      expect(result.hasRejections, isTrue);
      expect(result.rejections.length, 1);
      expect(result.rejections.first.metric, 'Glucose');
    });

    test('valid readings produce no rejections', () {
      final snap = _snapshot(systolic: 120, diastolic: 80, glucose: 95);
      final result = WearableImportService.buildImport(
        snapshot: snap,
        userId: _userId,
        existingBp: const [],
        existingGlucose: const [],
      );

      expect(result.hasRejections, isFalse);
      expect(result.rejections, isEmpty);
    });
  });
}
