import '../models/achievement.dart';
import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';
import '../models/bmi_record.dart';
import '../models/daily_challenge.dart';
import '../models/user_streak.dart';

/// Core gamification logic (Sprint 2.1).
///
/// Pure, synchronous, and fully unit-testable — no Flutter or database
/// dependencies. Persistence lives in [AppDatabase]; state wiring lives in the
/// [GamificationNotifier] provider.
class GamificationService {
  /// Builds an [AchievementProgress] snapshot from the user's local records.
  ///
  /// Records lists are expected newest-first (as AppDatabase returns them).
  static AchievementProgress progressFrom({
    List<BmiRecord> bmiRecords = const [],
    List<BloodPressureRecord> bpRecords = const [],
    List<BloodSugarRecord> glucoseRecords = const [],
    int? healthScore,
  }) {
    final activityDays = <String>{};
    var morning = false;
    var evening = false;
    final perDay = <String, int>{};

    void observe(DateTime time) {
      final key = StreakCalculator.dayKey(time);
      activityDays.add(key);
      perDay[key] = (perDay[key] ?? 0) + 1;
      if (time.hour < 9) morning = true;
      if (time.hour >= 21) evening = true;
    }

    for (final r in bmiRecords) {
      observe(r.timestamp);
    }
    for (final r in bpRecords) {
      observe(r.measurementTime);
    }
    for (final r in glucoseRecords) {
      observe(r.measurementTime);
    }

    final streak = StreakCalculator.compute(activityDays);
    var maxRecordsInDay = 0;
    perDay.values.forEach((v) {
      if (v > maxRecordsInDay) maxRecordsInDay = v;
    });

    final hasHealthyBmi =
        bmiRecords.any((r) => r.bmiValue >= 18.5 && r.bmiValue < 25.0);
    final hasHealthyBp =
        bpRecords.any((r) => r.category == BloodPressureCategory.normal);
    final hasHealthyGlucose =
        glucoseRecords.any((r) => r.status == BloodSugarStatus.normal);

    return AchievementProgress(
      bmiCount: bmiRecords.length,
      bpCount: bpRecords.length,
      glucoseCount: glucoseRecords.length,
      hasHealthyBmi: hasHealthyBmi,
      hasHealthyBp: hasHealthyBp,
      hasHealthyGlucose: hasHealthyGlucose,
      currentStreak: streak.current,
      bestStreak: streak.best,
      hasMorningRecord: morning,
      hasEveningRecord: evening,
      maxRecordsInDay: maxRecordsInDay,
      healthScore: healthScore,
    );
  }

  /// Achievements newly earned for [progress] that are not in [alreadyUnlocked].
  static List<Achievement> newlyUnlocked(
    AchievementProgress progress,
    Set<String> alreadyUnlocked,
  ) =>
      unlockedBy(progress, alreadyUnlocked);

  /// Total points for all unlocked achievement ids.
  static int achievementPoints(Set<String> unlockedIds) =>
      pointsFor(unlockedIds);

  /// Deterministic daily challenge for [date] (rotates through the catalog).
  static DailyChallenge challengeFor(DateTime date, String userId) {
    final key = StreakCalculator.dayKey(date);
    final startOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(startOfYear).inDays;
    final def = challengeCatalog[dayOfYear % challengeCatalog.length];
    return DailyChallenge(
      userId: userId,
      dateKey: key,
      definitionId: def.id,
      titleKey: def.titleKey,
      descriptionKey: def.descriptionKey,
      icon: def.icon,
      target: def.target,
      points: def.points,
    );
  }

  /// Progress made on [challenge] given the records logged today (newest-first).
  static int challengeProgress(
    DailyChallenge challenge,
    List<BmiRecord> bmiRecords,
    List<BloodPressureRecord> bpRecords,
    List<BloodSugarRecord> glucoseRecords, {
    DateTime? now,
  }) {
    final today = StreakCalculator.dayKey(now ?? DateTime.now());
    var anyHealthy = false;
    var anyCount = 0;

    for (final r in bmiRecords) {
      if (StreakCalculator.dayKey(r.timestamp) != today) continue;
      anyCount++;
      if (r.bmiValue >= 18.5 && r.bmiValue < 25.0) anyHealthy = true;
    }
    for (final r in bpRecords) {
      if (StreakCalculator.dayKey(r.measurementTime) != today) continue;
      anyCount++;
      if (r.category == BloodPressureCategory.normal) anyHealthy = true;
    }
    for (final r in glucoseRecords) {
      if (StreakCalculator.dayKey(r.measurementTime) != today) continue;
      anyCount++;
      if (r.status == BloodSugarStatus.normal) anyHealthy = true;
    }

    switch (challenge.definitionId) {
      case 'log_bmi':
        return bmiRecords
            .where((r) => StreakCalculator.dayKey(r.timestamp) == today)
            .length;
      case 'log_bp':
        return bpRecords
            .where((r) => StreakCalculator.dayKey(r.measurementTime) == today)
            .length;
      case 'log_glucose':
        return glucoseRecords
            .where((r) => StreakCalculator.dayKey(r.measurementTime) == today)
            .length;
      case 'log_any_three':
        return anyCount;
      case 'log_healthy':
        return anyHealthy ? 1 : 0;
      default:
        return 0;
    }
  }

  /// Whether [challenge]'s target has been reached by [progressValue].
  static bool isChallengeComplete(
          DailyChallenge challenge, int progressValue) =>
      progressValue >= challenge.target;
}
