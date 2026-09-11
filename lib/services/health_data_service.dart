import 'package:health/health.dart';

import '../models/wearable_metric.dart';

/// Health data types the app reads from the wearable platform.
///
/// READ-only — the app never writes health data. Each type maps to an
/// Android Health Connect permission and an iOS HealthKit share type.
const healthReadTypes = <HealthDataType>[
  HealthDataType.STEPS,
  HealthDataType.WEIGHT,
  HealthDataType.HEIGHT,
  HealthDataType.HEART_RATE,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.WATER,
];

/// Preferred read units, matching the app's display units.
const healthReadUnits = <HealthDataType, HealthDataUnit>{
  HealthDataType.STEPS: HealthDataUnit.COUNT,
  HealthDataType.WEIGHT: HealthDataUnit.KILOGRAM,
  HealthDataType.HEIGHT: HealthDataUnit.METER,
  HealthDataType.HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.RESTING_HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC: HealthDataUnit.MILLIMETER_OF_MERCURY,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC: HealthDataUnit.MILLIMETER_OF_MERCURY,
  HealthDataType.BLOOD_GLUCOSE: HealthDataUnit.MILLIGRAM_PER_DECILITER,
  HealthDataType.WATER: HealthDataUnit.LITER,
};

/// Abstraction over the `health` plugin so callers and tests can provide a
/// fake implementation (the plugin needs platform channels).
abstract class HealthDataSource {
  Future<void> configure();
  Future<bool?> hasPermissions();
  Future<bool> requestAuthorization();
  Future<void> revokePermissions();
  Future<List<HealthDataPoint>> getHealthDataFromTypes({
    required DateTime startTime,
    required DateTime endTime,
    List<RecordingMethod> recordingMethodsToFilter = const [],
  });
}

/// Thin wrapper over the `health` plugin.
class HealthDataService implements HealthDataSource {
  HealthDataService({Health? health}) : _health = health ?? Health();

  final Health _health;

  @override
  Future<void> configure() => _health.configure();

  @override
  Future<bool?> hasPermissions() => _health.hasPermissions(healthReadTypes);

  @override
  Future<bool> requestAuthorization() =>
      _health.requestAuthorization(healthReadTypes);

  @override
  Future<void> revokePermissions() => _health.revokePermissions();

  @override
  Future<List<HealthDataPoint>> getHealthDataFromTypes({
    required DateTime startTime,
    required DateTime endTime,
    List<RecordingMethod> recordingMethodsToFilter = const [],
  }) {
    return _health.getHealthDataFromTypes(
      types: healthReadTypes,
      preferredUnits: healthReadUnits,
      startTime: startTime,
      endTime: endTime,
      recordingMethodsToFilter: recordingMethodsToFilter,
    );
  }
}

/// Pure mapping between raw [HealthDataPoint]s and the app's [WearableMetric]
/// model. Free of platform calls so it is unit-testable.
class HealthDataMapper {
  const HealthDataMapper._();

  /// Map a [HealthDataType] to its app metric, or null if unsupported.
  static WearableMetric? metricForType(HealthDataType type) {
    switch (type) {
      case HealthDataType.STEPS:
        return WearableMetric.steps;
      case HealthDataType.WEIGHT:
        return WearableMetric.weight;
      case HealthDataType.HEIGHT:
        return WearableMetric.height;
      case HealthDataType.HEART_RATE:
        return WearableMetric.heartRate;
      case HealthDataType.RESTING_HEART_RATE:
        return WearableMetric.restingHeartRate;
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
        return WearableMetric.systolic;
      case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
        return WearableMetric.diastolic;
      case HealthDataType.BLOOD_GLUCOSE:
        return WearableMetric.bloodGlucose;
      case HealthDataType.WATER:
        return WearableMetric.hydration;
      default:
        return null;
    }
  }

  /// Convert a batch of raw points into a [WearableSnapshot] for [from]..[to].
  ///
  /// Aggregates the interval for [WearableMetric.steps] (sum of counts) and
  /// picks the most recent sample for all other metrics (by [HealthDataPoint.dateTo]).
  static WearableSnapshot toSnapshot({
    required List<HealthDataPoint> points,
    required DateTime from,
    required DateTime to,
  }) {
    final byMetric = <WearableMetric, List<HealthDataPoint>>{};
    for (final point in points) {
      final metric = metricForType(point.type);
      if (metric == null) continue;
      byMetric.putIfAbsent(metric, () => []).add(point);
    }

    final samples = <WearableSample>[];
    final validFrom = from.toUtc();
    final validTo = to.toUtc();

    for (final entry in byMetric.entries) {
      final metric = entry.key;
      final metricPoints = entry.value;
      if (metricPoints.isEmpty) continue;

      final isAggregated = metric == WearableMetric.steps;
      if (isAggregated) {
        var total = 0.0;
        for (final point in metricPoints) {
          final value = point.value;
          if (value is NumericHealthValue) {
            total += value.numericValue.toDouble();
          }
        }
        samples.add(WearableSample(
          metric: metric,
          value: total,
          unit: metricPoints.first.unit.name,
          startTime: validFrom,
          endTime: validTo,
          isAggregated: true,
        ));
      } else {
        HealthDataPoint? latest;
        for (final point in metricPoints) {
          if (latest == null || point.dateTo.isAfter(latest.dateTo)) {
            latest = point;
          }
        }
        if (latest == null || latest.value is! NumericHealthValue) continue;
        samples.add(WearableSample(
          metric: metric,
          value: (latest.value as NumericHealthValue).numericValue.toDouble(),
          unit: latest.unit.name,
          startTime: latest.dateFrom,
          endTime: latest.dateTo,
        ));
      }
    }

    samples.sort((a, b) => a.metric.index.compareTo(b.metric.index));
    return WearableSnapshot(from: validFrom, to: validTo, samples: samples);
  }
}
