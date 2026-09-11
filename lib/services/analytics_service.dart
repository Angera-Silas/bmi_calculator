import 'dart:math';

import '../models/bmi_record.dart';
import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';

/// Pure, testable analytics computations for the BMI Calculator app.
///
/// All methods are static and stateless — they accept data and return results.
/// No database, network, or platform dependencies.
class AnalyticsService {
  const AnalyticsService._();

  // ── Trend analysis ─────────────────────────────────────────────────────

  /// Compute a simple moving average of BMI values over [window] records.
  /// Returns one entry per window position (sliding window).
  static List<double> movingAverage(List<BmiRecord> records, {int window = 3}) {
    if (records.length < window) return [];
    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final result = <double>[];
    for (var i = window - 1; i < sorted.length; i++) {
      var sum = 0.0;
      for (var j = i - window + 1; j <= i; j++) {
        sum += sorted[j].bmiValue;
      }
      result.add(sum / window);
    }
    return result;
  }

  /// Linear regression slope (kg/day) for weight values.
  /// Positive = gaining, negative = losing.
  /// Returns (slope, intercept) or null if fewer than 2 records.
  static (double slope, double intercept)? weightRegression(
      List<BmiRecord> records) {
    if (records.length < 2) return null;
    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final t0 = sorted.first.timestamp.millisecondsSinceEpoch;
    final n = sorted.length;
    var sumX = 0.0, sumY = 0.0, sumXY = 0.0, sumX2 = 0.0;
    for (final r in sorted) {
      final x = (r.timestamp.millisecondsSinceEpoch - t0) / 86400000.0;
      final y = r.weight.toDouble();
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }
    final denom = n * sumX2 - sumX * sumX;
    if (denom == 0) return null;
    final slope = (n * sumXY - sumX * sumY) / denom;
    final intercept = (sumY - slope * sumX) / n;
    return (slope, intercept);
  }

  /// Linear regression slope for BMI values (BMI/day).
  static (double slope, double intercept)? bmiRegression(
      List<BmiRecord> records) {
    if (records.length < 2) return null;
    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final t0 = sorted.first.timestamp.millisecondsSinceEpoch;
    final n = sorted.length;
    var sumX = 0.0, sumY = 0.0, sumXY = 0.0, sumX2 = 0.0;
    for (final r in sorted) {
      final x = (r.timestamp.millisecondsSinceEpoch - t0) / 86400000.0;
      final y = r.bmiValue;
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }
    final denom = n * sumX2 - sumX * sumX;
    if (denom == 0) return null;
    final slope = (n * sumXY - sumX * sumY) / denom;
    final intercept = (sumY - slope * sumX) / n;
    return (slope, intercept);
  }

  // ── Correlation ────────────────────────────────────────────────────────

  /// Pearson correlation coefficient between two value lists.
  /// Returns null if lists differ in length or have < 2 entries.
  static double? pearsonR(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 2) return null;
    final n = x.length;
    var sumX = 0.0, sumY = 0.0, sumXY = 0.0, sumX2 = 0.0, sumY2 = 0.0;
    for (var i = 0; i < n; i++) {
      sumX += x[i];
      sumY += y[i];
      sumXY += x[i] * y[i];
      sumX2 += x[i] * x[i];
      sumY2 += y[i] * y[i];
    }
    final denom = sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));
    if (denom == 0) return 0;
    return (n * sumXY - sumX * sumY) / denom;
  }

  /// Correlation between weight and days-since-first-record.
  static double? weightTimeCorrelation(List<BmiRecord> records) {
    if (records.length < 2) return null;
    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final t0 = sorted.first.timestamp.millisecondsSinceEpoch;
    final days = sorted
        .map((r) => (r.timestamp.millisecondsSinceEpoch - t0) / 86400000.0)
        .toList();
    final weights = sorted.map((r) => r.weight.toDouble()).toList();
    return pearsonR(days, weights);
  }

  // ── Prediction ─────────────────────────────────────────────────────────

  /// Predict BMI [daysAhead] from now using linear regression.
  /// Returns null if insufficient data.
  static double? predictBMI(List<BmiRecord> records, {int daysAhead = 30}) {
    final reg = bmiRegression(records);
    if (reg == null) return null;
    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final t0 = sorted.first.timestamp.millisecondsSinceEpoch;
    final nowDays =
        (sorted.last.timestamp.millisecondsSinceEpoch - t0) / 86400000.0;
    return reg.$1 * (nowDays + daysAhead) + reg.$2;
  }

  /// Predict weight [daysAhead] from now using linear regression.
  static double? predictWeight(List<BmiRecord> records, {int daysAhead = 30}) {
    final reg = weightRegression(records);
    if (reg == null) return null;
    final sorted = [...records]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final t0 = sorted.first.timestamp.millisecondsSinceEpoch;
    final nowDays =
        (sorted.last.timestamp.millisecondsSinceEpoch - t0) / 86400000.0;
    return reg.$1 * (nowDays + daysAhead) + reg.$2;
  }

  // ── Health score (0–100) ──────────────────────────────────────────────

  /// Composite health score from multiple record types.
  ///
  /// Components (weights sum to 1.0):
  ///   - BMI distance from normal range (40%)
  ///   - Blood pressure (30%)
  ///   - Blood glucose (15%)
  ///   - Trend stability (15%)
  static HealthScore computeHealthScore({
    required List<BmiRecord> bmiRecords,
    List<BloodPressureRecord> bpRecords = const [],
    List<BloodSugarRecord> glucoseRecords = const [],
  }) {
    final bmiScore = _bmiScore(bmiRecords);
    final bpScore = _bpScore(bpRecords);
    final glucoseScore = _glucoseScore(glucoseRecords);
    final trendScore = _trendScore(bmiRecords);

    final total = bmiScore * 0.4 +
        bpScore * 0.3 +
        glucoseScore * 0.15 +
        trendScore * 0.15;

    return HealthScore(
      overall: total.round().clamp(0, 100),
      bmiComponent: bmiScore.round().clamp(0, 100),
      bpComponent: bpScore.round().clamp(0, 100),
      glucoseComponent: glucoseScore.round().clamp(0, 100),
      trendComponent: trendScore.round().clamp(0, 100),
    );
  }

  static double _bmiScore(List<BmiRecord> records) {
    if (records.isEmpty) return 50;
    final latest = records.last.bmiValue;
    // WHO normal range 18.5–24.9 → score 100; further from range → lower score.
    if (latest >= 18.5 && latest <= 24.9) return 100;
    final dist = latest < 18.5 ? 18.5 - latest : latest - 24.9;
    return (100 - dist * 5).clamp(0, 100).toDouble();
  }

  static double _bpScore(List<BloodPressureRecord> records) {
    if (records.isEmpty) return 50;
    final latest = records.last;
    final systolicOk = latest.systolic >= 90 && latest.systolic <= 120;
    final diastolicOk = latest.diastolic >= 60 && latest.diastolic <= 80;
    if (systolicOk && diastolicOk) return 100;
    var penalty = 0.0;
    if (latest.systolic > 120) penalty += (latest.systolic - 120) * 1.5;
    if (latest.systolic < 90) penalty += (90 - latest.systolic) * 2;
    if (latest.diastolic > 80) penalty += (latest.diastolic - 80) * 2;
    if (latest.diastolic < 60) penalty += (60 - latest.diastolic) * 2.5;
    return (100 - penalty).clamp(0, 100).toDouble();
  }

  static double _glucoseScore(List<BloodSugarRecord> records) {
    if (records.isEmpty) return 50;
    final latest = records.last.glucoseLevel;
    // Normal fasting: 70–100 mg/dL → 100 score.
    if (latest >= 70 && latest <= 100) return 100;
    var penalty = 0.0;
    if (latest > 100) penalty += (latest - 100) * 0.8;
    if (latest < 70) penalty += (70 - latest) * 1.5;
    return (100 - penalty).clamp(0, 100).toDouble();
  }

  static double _trendScore(List<BmiRecord> records) {
    if (records.length < 3) return 75;
    final reg = bmiRegression(records);
    if (reg == null) return 75;
    // Stable = slope near zero → high score; large positive slope (gaining) → lower.
    final absSlope = reg.$1.abs();
    // 0.0 BMI/day = 0.0 kg/month → 100 score; 0.05 BMI/day → ~35 score.
    return (100 - absSlope * 1300).clamp(0, 100).toDouble();
  }

  // ── Population comparison ──────────────────────────────────────────────

  /// Simplified WHO BMI percentile label for adults (20+).
  /// Returns a human-readable label like "5th percentile" or "85th percentile".
  static PopulationComparison compareWithPopulation({
    required double bmi,
    required int age,
    required bool isMale,
  }) {
    // Simplified adult percentiles based on NHANES/WHO distributions.
    // These are approximations — the real calculation uses full z-tables.
    final p5 = isMale ? 18.5 : 17.8;
    final p15 = isMale ? 20.0 : 19.5;
    final p50 = isMale ? 26.0 : 26.5;
    final p85 = isMale ? 31.0 : 32.0;
    final p95 = isMale ? 35.0 : 36.5;

    if (bmi < p5)
      return PopulationComparison(percentile: 5, label: 'Underweight (5th)');
    if (bmi < p15)
      return PopulationComparison(
          percentile: 15, label: 'Healthy weight (15th)');
    if (bmi < p50)
      return PopulationComparison(
          percentile: 50, label: 'Healthy weight (50th)');
    if (bmi < p85)
      return PopulationComparison(percentile: 85, label: 'Overweight (85th)');
    if (bmi < p95)
      return PopulationComparison(percentile: 95, label: 'Obese (95th)');
    return PopulationComparison(percentile: 99, label: 'Severely obese (99th)');
  }
}

/// Result of [AnalyticsService.computeHealthScore].
class HealthScore {
  final int overall;
  final int bmiComponent;
  final int bpComponent;
  final int glucoseComponent;
  final int trendComponent;

  const HealthScore({
    required this.overall,
    required this.bmiComponent,
    required this.bpComponent,
    required this.glucoseComponent,
    required this.trendComponent,
  });
}

/// Result of [AnalyticsService.compareWithPopulation].
class PopulationComparison {
  final int percentile;
  final String label;

  const PopulationComparison({required this.percentile, required this.label});
}
