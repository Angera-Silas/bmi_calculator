import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';
import '../models/bmi_record.dart';
import '../models/daily_challenge.dart';
import '../models/user_streak.dart';
import 'gamification_service.dart';

/// Difficulty tiers scale a daily challenge's target and points to the user's
/// engagement level. Stored challenges keep the tier baked into their
/// target/points, so historical rows render their tier without extra columns.
enum ChallengeTier {
  easy('easy', 0, 1),
  medium('medium', 1, 1.5),
  hard('hard', 2, 2);

  final String id;
  final int targetBonus;
  final double pointMultiplier;

  const ChallengeTier(this.id, this.targetBonus, this.pointMultiplier);
}

/// Owns daily-challenge generation, difficulty scaling, progress tracking,
/// completion detection, and (in Sprint 2.3) notification scheduling hooks.
///
/// Pure Dart — no Flutter or database dependencies. Persistence stays in
/// [AppDatabase]; state wiring stays in the [GamificationNotifier] provider.
class ChallengeService {
  /// Picks a difficulty tier from the user's engagement. Longer streaks and
  /// heavier logging unlock progressively harder (and more rewarding)
  /// challenges.
  static ChallengeTier tierFor({int streak = 0, int totalLogs = 0}) {
    if (streak >= 14 || totalLogs >= 100) return ChallengeTier.hard;
    if (streak >= 3 || totalLogs >= 20) return ChallengeTier.medium;
    return ChallengeTier.easy;
  }

  /// Generates the challenge for [date], rotating deterministically through the
  /// catalog (so the same day always yields the same base for a user) and
  /// scaling target/points by [tier].
  ///
  /// The easy tier is the raw catalog definition; medium/hard add to the target
  /// and multiply points (rounded to 5 for display friendliness).
  static DailyChallenge generate(
    DateTime date,
    String userId, {
    ChallengeTier tier = ChallengeTier.easy,
  }) {
    final key = StreakCalculator.dayKey(date);
    final startOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(startOfYear).inDays;
    final def = challengeCatalog[dayOfYear % challengeCatalog.length];

    final target = def.target + tier.targetBonus;
    final points = tier == ChallengeTier.easy
        ? def.points
        : _roundToFive(def.points * tier.pointMultiplier);

    return DailyChallenge(
      userId: userId,
      dateKey: key,
      definitionId: def.id,
      titleKey: def.titleKey,
      descriptionKey: def.descriptionKey,
      icon: def.icon,
      target: target,
      points: points,
    );
  }

  /// The tier a stored challenge was generated at, derived from its points
  /// relative to the base definition (no schema column needed).
  static ChallengeTier tierOf(DailyChallenge challenge) {
    final def = _definitionFor(challenge.definitionId);
    if (def == null) return ChallengeTier.easy;
    final base = def.points;
    if (challenge.points >= _roundToFive(base * 2)) return ChallengeTier.hard;
    if (challenge.points > base) return ChallengeTier.medium;
    return ChallengeTier.easy;
  }

  /// Progress made on [challenge] from today's records.
  static int progressFor(
    DailyChallenge challenge,
    List<BmiRecord> bmiRecords,
    List<BloodPressureRecord> bpRecords,
    List<BloodSugarRecord> glucoseRecords, {
    DateTime? now,
  }) =>
      GamificationService.challengeProgress(
          challenge, bmiRecords, bpRecords, glucoseRecords,
          now: now);

  /// Returns the challenge marked completed (with [completedAt]) when
  /// [progress] reaches its target, otherwise an unchanged in-progress copy.
  static DailyChallenge completeIfDone(
    DailyChallenge challenge,
    int progress, {
    DateTime? now,
  }) {
    if (progress >= challenge.target) {
      return challenge.copyWith(
        progress: progress,
        completed: true,
        completedAt: now ?? DateTime.now(),
      );
    }
    return challenge.copyWith(progress: progress);
  }

  /// Whether the challenge's target has been reached.
  static bool isComplete(DailyChallenge challenge, int progress) =>
      progress >= challenge.target;

  /// Reminder intent payload for [challenge]. Sprint 2.3 builds the
  /// [NotificationService] (flutter_local_notifications) that consumes this;
  /// ChallengeService exposes the data contract now so the UI + scheduling UI
  /// are ready to wire up.
  ///
  /// Returns null when no reminder is configured (default), letting callers
  /// skip scheduling entirely.
  static Map<String, dynamic>? reminderPayload(DailyChallenge challenge) => {
        'type': 'daily_challenge',
        'challengeId': challenge.definitionId,
        'dateKey': challenge.dateKey,
        'titleKey': challenge.titleKey,
      };

  static ChallengeDefinition? _definitionFor(String id) {
    for (final def in challengeCatalog) {
      if (def.id == id) return def;
    }
    return null;
  }

  static int _roundToFive(double v) => (v / 5).round() * 5;
}
