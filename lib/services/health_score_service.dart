import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';

/// Health score bands, from worst to best.
enum HealthScoreLabel {
  needsImprovement,
  fair,
  good,
  veryGood,
  excellent;
}

/// Personalized recommendation category — the UI maps these to localized
/// strings and icons.
enum RecommendationCategory {
  healthyWeight,
  hypertension,
  glucoseControl,
  cardioFitness,
  waistReduction,
  onTrack,
}

class PersonalizedRecommendation {
  final RecommendationCategory category;

  const PersonalizedRecommendation(this.category);
}

/// A weighted 0–100 health score across four pillars:
///   BMI 30% · Blood Pressure 25% · Blood Sugar 25% · Advanced Metrics 20%.
///
/// Missing pillars are re-weighted proportionally so a partial profile still
/// yields a meaningful score. Returns null score when no data is available.
class HealthScoreService {
  static const int _wBmi = 30;
  static const int _wBp = 25;
  static const int _wGlucose = 25;
  static const int _wAdvanced = 20;

  static HealthScoreResult compute({
    double? latestBmi,
    BloodPressureCategory? bpCategory,
    BloodSugarStatus? glucoseStatus,
    double? latestWhtr,
    int? restingHeartRate,
  }) {
    final bmiScore = latestBmi != null ? _bmiScore(latestBmi) : null;
    final bpScoreValue = bpCategory != null ? _bpScore(bpCategory) : null;
    final glucoseScoreValue =
        glucoseStatus != null ? _glucoseScore(glucoseStatus) : null;
    final advancedScoreValue = _advancedScore(
        latestWhtr: latestWhtr, restingHeartRate: restingHeartRate);

    final components = <(int weight, double score, ComponentType type)>[
      if (bmiScore != null) (_wBmi, bmiScore, ComponentType.bmi),
      if (bpScoreValue != null) (_wBp, bpScoreValue, ComponentType.bp),
      if (glucoseScoreValue != null)
        (_wGlucose, glucoseScoreValue, ComponentType.glucose),
      if (advancedScoreValue != null)
        (_wAdvanced, advancedScoreValue, ComponentType.advanced),
    ];

    if (components.isEmpty) {
      return const HealthScoreResult(
        score: null,
        label: null,
        bmiScore: null,
        bpScore: null,
        glucoseScore: null,
        advancedScore: null,
      );
    }

    final totalWeight = components.fold<int>(0, (sum, c) => sum + c.$1);
    final weightedSum =
        components.fold<double>(0, (sum, c) => sum + (c.$1 * c.$2));
    final score = (weightedSum / totalWeight).round();

    return HealthScoreResult(
      score: score,
      label: _labelFor(score),
      bmiScore: bmiScore,
      bpScore: bpScoreValue,
      glucoseScore: glucoseScoreValue,
      advancedScore: advancedScoreValue,
    );
  }

  /// Personalized recommendations based on the weakest available pillar(s).
  static List<PersonalizedRecommendation> recommendations({
    double? latestBmi,
    BloodPressureCategory? bpCategory,
    BloodSugarStatus? glucoseStatus,
    double? latestWhtr,
    int? restingHeartRate,
  }) {
    final list = <PersonalizedRecommendation>[];

    if (latestBmi != null) {
      if (latestBmi < 18.5 || latestBmi >= 25) {
        list.add(const PersonalizedRecommendation(
            RecommendationCategory.healthyWeight));
      }
    }
    if (bpCategory != null && bpCategory != BloodPressureCategory.normal) {
      list.add(const PersonalizedRecommendation(
          RecommendationCategory.hypertension));
    }
    if (glucoseStatus != null && glucoseStatus != BloodSugarStatus.normal) {
      list.add(const PersonalizedRecommendation(
          RecommendationCategory.glucoseControl));
    }
    if (latestWhtr != null && latestWhtr > 0.5) {
      list.add(const PersonalizedRecommendation(
          RecommendationCategory.waistReduction));
    }
    if (restingHeartRate != null) {
      if (restingHeartRate > 85 || restingHeartRate < 50) {
        list.add(const PersonalizedRecommendation(
            RecommendationCategory.cardioFitness));
      }
    }

    if (list.isEmpty) {
      list.add(
          const PersonalizedRecommendation(RecommendationCategory.onTrack));
    }
    return list;
  }

  static HealthScoreLabel _labelFor(int score) {
    if (score >= 90) return HealthScoreLabel.excellent;
    if (score >= 75) return HealthScoreLabel.veryGood;
    if (score >= 60) return HealthScoreLabel.good;
    if (score >= 45) return HealthScoreLabel.fair;
    return HealthScoreLabel.needsImprovement;
  }

  /// Public accessor for panel/sub-score labeling on the dashboard.
  static HealthScoreLabel labelForScore(double score) =>
      _labelFor(score.round());

  static double _bmiScore(double bmi) {
    if (bmi < 16.0) return 20;
    if (bmi < 17.0) return 30;
    if (bmi < 18.5) return 45;
    if (bmi < 25.0) return 100;
    if (bmi < 30.0) return 65;
    if (bmi < 35.0) return 40;
    if (bmi < 40.0) return 25;
    return 15;
  }

  static double _bpScore(BloodPressureCategory category) => switch (category) {
        BloodPressureCategory.normal => 100,
        BloodPressureCategory.elevated => 80,
        BloodPressureCategory.stage1 => 60,
        BloodPressureCategory.stage2 => 30,
        BloodPressureCategory.crisis => 10,
      };

  static double _glucoseScore(BloodSugarStatus status) => switch (status) {
        BloodSugarStatus.normal => 100,
        BloodSugarStatus.prediabetes => 60,
        BloodSugarStatus.diabetes => 25,
      };

  /// Advanced metrics: WHtR + resting heart rate (whichever available).
  static double? _advancedScore({double? latestWhtr, int? restingHeartRate}) {
    final scores = <double>[];
    if (latestWhtr != null) {
      if (latestWhtr < 0.4) {
        scores.add(80);
      } else if (latestWhtr <= 0.5) {
        scores.add(100);
      } else if (latestWhtr <= 0.6) {
        scores.add(55);
      } else {
        scores.add(25);
      }
    }
    if (restingHeartRate != null) {
      if (restingHeartRate >= 50 && restingHeartRate <= 70) {
        scores.add(100);
      } else if (restingHeartRate >= 71 && restingHeartRate <= 85) {
        scores.add(70);
      } else if (restingHeartRate < 50) {
        scores.add(60);
      } else if (restingHeartRate <= 100) {
        scores.add(40);
      } else {
        scores.add(20);
      }
    }
    if (scores.isEmpty) return null;
    return scores.reduce((a, b) => a + b) / scores.length;
  }
}

enum ComponentType { bmi, bp, glucose, advanced }

class HealthScoreResult {
  final int? score;
  final HealthScoreLabel? label;
  final double? bmiScore;
  final double? bpScore;
  final double? glucoseScore;
  final double? advancedScore;

  const HealthScoreResult({
    required this.score,
    required this.label,
    required this.bmiScore,
    required this.bpScore,
    required this.glucoseScore,
    required this.advancedScore,
  });
}
