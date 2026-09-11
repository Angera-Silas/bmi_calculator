import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';

import 'package:bmi_calculator/models/wearable_metric.dart';
import 'package:bmi_calculator/services/health_data_service.dart';

HealthDataPoint _point({
  required String uuid,
  required HealthDataType type,
  required HealthDataUnit unit,
  required num value,
  required DateTime dateFrom,
  required DateTime dateTo,
}) {
  return HealthDataPoint(
    uuid: uuid,
    value: NumericHealthValue(numericValue: value),
    type: type,
    unit: unit,
    dateFrom: dateFrom,
    dateTo: dateTo,
    sourcePlatform: HealthPlatformType.googleHealthConnect,
    sourceDeviceId: 'dev-1',
    sourceId: 'src-1',
    sourceName: 'Test',
  );
}

void main() {
  group('HealthDataMapper.metricForType', () {
    test('maps enabled read types to app metrics', () {
      for (final type in healthReadTypes) {
        final metric = HealthDataMapper.metricForType(type);
        expect(metric, isNotNull, reason: '$type should map to a metric');
      }
    });
    test('returns null for unsupported types', () {
      expect(
          HealthDataMapper.metricForType(HealthDataType.TOTAL_CALORIES_BURNED),
          isNull);
      expect(HealthDataMapper.metricForType(HealthDataType.NUTRITION), isNull);
    });
  });

  group('HealthDataMapper.toSnapshot', () {
    final from = DateTime.utc(2026, 9, 9, 0, 0);
    final to = DateTime.utc(2026, 9, 10, 0, 0);

    test('aggregates steps and picks latest non-steps sample', () {
      final points = [
        _point(
          uuid: 's1',
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          value: 500,
          dateFrom: from,
          dateTo: to,
        ),
        _point(
          uuid: 's2',
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          value: 300,
          dateFrom: from,
          dateTo: to,
        ),
        _point(
          uuid: 'w1',
          type: HealthDataType.WEIGHT,
          unit: HealthDataUnit.KILOGRAM,
          value: 70.0,
          dateFrom: from,
          dateTo: DateTime.utc(2026, 9, 9, 8, 0),
        ),
        _point(
          uuid: 'w2',
          type: HealthDataType.WEIGHT,
          unit: HealthDataUnit.KILOGRAM,
          value: 69.5,
          dateFrom: DateTime.utc(2026, 9, 9, 6, 0),
          dateTo: DateTime.utc(2026, 9, 9, 18, 0),
        ),
      ];

      final snapshot =
          HealthDataMapper.toSnapshot(points: points, from: from, to: to);

      expect(snapshot.totalSteps, 800);
      expect(snapshot.latestWeightKg, 69.5);
    });

    test('picks most recent sample by dateTo', () {
      final points = [
        _point(
          uuid: 'h1',
          type: HealthDataType.HEART_RATE,
          unit: HealthDataUnit.BEATS_PER_MINUTE,
          value: 61,
          dateFrom: DateTime.utc(2026, 9, 9, 9, 0),
          dateTo: DateTime.utc(2026, 9, 9, 9, 0, 30),
        ),
        _point(
          uuid: 'h2',
          type: HealthDataType.HEART_RATE,
          unit: HealthDataUnit.BEATS_PER_MINUTE,
          value: 72,
          dateFrom: DateTime.utc(2026, 9, 9, 12, 0),
          dateTo: DateTime.utc(2026, 9, 9, 12, 0, 30),
        ),
      ];

      final snapshot =
          HealthDataMapper.toSnapshot(points: points, from: from, to: to);

      expect(snapshot.latestHeartRateBpm, 72);
    });

    test('marks systolic/diastolic and glucose correctly', () {
      final points = [
        _point(
          uuid: 'bp1',
          type: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          unit: HealthDataUnit.MILLIMETER_OF_MERCURY,
          value: 120,
          dateFrom: from,
          dateTo: to,
        ),
        _point(
          uuid: 'bp2',
          type: HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
          unit: HealthDataUnit.MILLIMETER_OF_MERCURY,
          value: 80,
          dateFrom: from,
          dateTo: to,
        ),
        _point(
          uuid: 'g1',
          type: HealthDataType.BLOOD_GLUCOSE,
          unit: HealthDataUnit.MILLIGRAM_PER_DECILITER,
          value: 92,
          dateFrom: from,
          dateTo: to,
        ),
      ];

      final snapshot =
          HealthDataMapper.toSnapshot(points: points, from: from, to: to);

      expect(snapshot.latestSystolic, 120);
      expect(snapshot.latestDiastolic, 80);
      expect(snapshot.latestGlucoseMgdl, 92);
    });

    test('is empty when points list is empty', () {
      final snapshot =
          HealthDataMapper.toSnapshot(points: const [], from: from, to: to);
      expect(snapshot.samples, isEmpty);
      expect(snapshot.totalSteps, 0);
    });

    test('ignores unsupported data point types', () {
      final points = [
        _point(
          uuid: 'c1',
          type: HealthDataType.TOTAL_CALORIES_BURNED,
          unit: HealthDataUnit.KILOCALORIE,
          value: 200,
          dateFrom: from,
          dateTo: to,
        ),
      ];

      final snapshot =
          HealthDataMapper.toSnapshot(points: points, from: from, to: to);
      expect(snapshot.samples, isEmpty);
    });
  });

  group('WearableSnapshot accessors', () {
    test('getters null for missing metrics', () {
      final snap = WearableSnapshot(
        from: DateTime.utc(2026, 9, 1),
        to: DateTime.utc(2026, 9, 2),
        samples: const [],
      );
      expect(snap.latestWeightKg, isNull);
      expect(snap.latestHeartRateBpm, isNull);
      expect(snap.latestSystolic, isNull);
    });
  });
}
