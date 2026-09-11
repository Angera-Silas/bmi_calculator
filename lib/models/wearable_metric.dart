/// Health metrics the app can read from wearable/health platforms
/// (Google Health Connect on Android, Apple HealthKit on iOS).
///
/// The mapping between [WearableMetric] and the platform `health` package
/// data types lives in `HealthDataMapper` (`lib/services/health_data_service.dart`).
enum WearableMetric {
  steps,
  weight,
  height,
  heartRate,
  restingHeartRate,
  systolic,
  diastolic,
  bloodGlucose,
  hydration,
}

/// A single measured value for a [WearableMetric] over an interval.
///
/// [isAggregated] is true when [value] is a sum/count over the window
/// (e.g. total steps), false when it is the last recorded value in the window
/// (e.g. latest weight or heart rate).
class WearableSample {
  final WearableMetric metric;
  final double value;
  final String unit;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAggregated;

  const WearableSample({
    required this.metric,
    required this.value,
    required this.unit,
    required this.startTime,
    required this.endTime,
    this.isAggregated = false,
  });

  DateTime get timestamp => isAggregated
      ? startTime
      : (endTime.isAfter(startTime) ? endTime : startTime);
}

/// Immutable snapshot of health data read for a time window.
class WearableSnapshot {
  final DateTime from;
  final DateTime to;
  final List<WearableSample> samples;

  const WearableSnapshot({
    required this.from,
    required this.to,
    required this.samples,
  });
  WearableSample? sampleFor(WearableMetric metric) {
    for (final sample in samples) {
      if (sample.metric == metric) return sample;
    }
    return null;
  }

  int get totalSteps => (_aggregated(WearableMetric.steps) ?? 0).round();
  double? get latestWeightKg => _latest(WearableMetric.weight);
  double? get latestHeightM => _latest(WearableMetric.height);
  double? get latestHeartRateBpm => _latest(WearableMetric.heartRate);
  double? get latestRestingHeartRateBpm =>
      _latest(WearableMetric.restingHeartRate);
  double? get latestSystolic => _latest(WearableMetric.systolic);
  double? get latestDiastolic => _latest(WearableMetric.diastolic);
  double? get latestGlucoseMgdl => _latest(WearableMetric.bloodGlucose);
  double? get latestWaterLiters => _latest(WearableMetric.hydration);

  double? _aggregated(WearableMetric metric) {
    final sample = sampleFor(metric);
    if (sample == null || !sample.isAggregated) return null;
    return sample.value;
  }

  double? _latest(WearableMetric metric) {
    final sample = sampleFor(metric);
    if (sample == null || sample.isAggregated) return null;
    return sample.value;
  }
}
