import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/achievement.dart';
import '../models/daily_challenge.dart';
import '../models/reminder.dart';
import '../models/user_streak.dart';
import '../services/challenge_service.dart';
import '../services/gamification_service.dart';
import 'reminder_provider.dart';
import 'session_provider.dart';

/// Gamification state for the current session.
class GamificationState {
  final Set<String> unlockedAchievements;
  final int points;
  final UserStreak streak;
  final DailyChallenge? todayChallenge;
  final int todayChallengeProgress;

  /// Achievements unlocked by the most recent [GamificationNotifier.recordActivity]
  /// call — the UI celebrates these.
  final List<Achievement> recentUnlocks;

  const GamificationState({
    this.unlockedAchievements = const {},
    this.points = 0,
    this.streak = UserStreak.empty,
    this.todayChallenge,
    this.todayChallengeProgress = 0,
    this.recentUnlocks = const [],
  });

  int get achievementCount => unlockedAchievements.length;

  GamificationState copyWith({
    Set<String>? unlockedAchievements,
    int? points,
    UserStreak? streak,
    DailyChallenge? todayChallenge,
    bool clearChallenge = false,
    int? todayChallengeProgress,
    List<Achievement>? recentUnlocks,
  }) =>
      GamificationState(
        unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
        points: points ?? this.points,
        streak: streak ?? this.streak,
        todayChallenge:
            clearChallenge ? null : (todayChallenge ?? this.todayChallenge),
        todayChallengeProgress:
            todayChallengeProgress ?? this.todayChallengeProgress,
        recentUnlocks: recentUnlocks ?? this.recentUnlocks,
      );
}

/// Loads and mutates the current user's gamification state (Sprint 2.1).
class GamificationNotifier extends AsyncNotifier<GamificationState> {
  @override
  Future<GamificationState> build() async {
    final session = ref.watch(sessionProvider);
    final userId = session.userId;
    if (userId == null) return const GamificationState();
    return _loadState(userId);
  }

  String? _userId() => ref.read(sessionProvider).userId;

  static Future<GamificationState> _loadState(String userId) async {
    final unlocked = await AppDatabase.fetchUnlockedAchievements(userId);
    final streak = await AppDatabase.fetchStreak(userId);
    final todayKey = StreakCalculator.dayKey(DateTime.now());

    // Ensure today's challenge exists up-front so the Calculate tab always has
    // something to show, even before the user logs the first reading of the day.
    var today = await AppDatabase.fetchDailyChallenge(userId, todayKey);
    if (today == null) {
      today = ChallengeService.generate(
        DateTime.now(),
        userId,
        tier: ChallengeService.tierFor(streak: streak.current),
      );
      await AppDatabase.saveDailyChallenge(today);
    }

    final challengePoints = today.completed ? today.points : 0;
    final points =
        GamificationService.achievementPoints(unlocked) + challengePoints;
    return GamificationState(
      unlockedAchievements: unlocked,
      points: points,
      streak: streak,
      todayChallenge: today,
      todayChallengeProgress: today.progress,
    );
  }

  /// Re-computes achievements, streak, and today's challenge progress from the
  /// current records. Called after every record write. Returns the newly
  /// unlocked achievements (possibly empty).
  Future<List<Achievement>> recordActivity({int? healthScore}) async {
    final userId = _userId();
    if (userId == null) return const [];

    final bmi = await AppDatabase.fetchRecords(userId);
    final bp = await AppDatabase.fetchBPRecords(userId);
    final glucose = await AppDatabase.fetchBloodSugarRecords(userId);

    final progress = GamificationService.progressFrom(
      bmiRecords: bmi,
      bpRecords: bp,
      glucoseRecords: glucose,
      healthScore: healthScore,
    );

    // 1. Streak
    final activityDays = <String>{
      for (final r in bmi) StreakCalculator.dayKey(r.timestamp),
      for (final r in bp) StreakCalculator.dayKey(r.measurementTime),
      for (final r in glucose) StreakCalculator.dayKey(r.measurementTime),
    };
    final streak = StreakCalculator.compute(activityDays);
    await AppDatabase.saveStreak(userId, streak);

    // 2. Achievements
    final unlocked = await AppDatabase.fetchUnlockedAchievements(userId);
    final newUnlocks = GamificationService.newlyUnlocked(progress, unlocked);
    for (final a in newUnlocks) {
      await AppDatabase.insertUnlockedAchievement(userId, a.id);
    }

    // 3. Daily challenge
    var challenge = await AppDatabase.fetchDailyChallenge(
        userId, StreakCalculator.dayKey(DateTime.now()));
    if (challenge == null) {
      challenge = ChallengeService.generate(
        DateTime.now(),
        userId,
        tier: ChallengeService.tierFor(
          streak: streak.current,
          totalLogs:
              progress.bmiCount + progress.bpCount + progress.glucoseCount,
        ),
      );
      await AppDatabase.saveDailyChallenge(challenge);
    }
    final challengeProgress =
        ChallengeService.progressFor(challenge, bmi, bp, glucose);
    final updatedChallenge =
        ChallengeService.completeIfDone(challenge, challengeProgress);
    await AppDatabase.saveDailyChallenge(updatedChallenge);

    // 4. Update state
    final finalUnlocked = await AppDatabase.fetchUnlockedAchievements(userId);
    final points = GamificationService.achievementPoints(finalUnlocked) +
        (updatedChallenge.completed ? updatedChallenge.points : 0);

    state = AsyncData(GamificationState(
      unlockedAchievements: finalUnlocked,
      points: points,
      streak: streak,
      todayChallenge: updatedChallenge,
      todayChallengeProgress: challengeProgress,
      recentUnlocks: newUnlocks,
    ));

    // Smart reminder cancellations (Sprint 2.3)
    try {
      final notifier = ref.read(reminderProvider.notifier);
      // Suppress activity reminder (any log counts as activity)
      await notifier.cancelTodayReminder(ReminderType.activity);

      // Check if a BMI was logged today to suppress BMI check reminder
      final today = DateTime.now();
      final isSameDay = (DateTime d) =>
          d.year == today.year && d.month == today.month && d.day == today.day;
      if (bmi.any((r) => isSameDay(r.timestamp))) {
        await notifier.cancelTodayReminder(ReminderType.bmiCheck);
      }

      // Suppress daily challenge reminder if completed
      if (updatedChallenge.completed) {
        await notifier.cancelTodayReminder(ReminderType.dailyChallenge);
      }
    } catch (e) {
      debugPrint('Reminder suppression background fail: $e');
    }

    return newUnlocks;
  }
}

final gamificationProvider =
    AsyncNotifierProvider<GamificationNotifier, GamificationState>(
        GamificationNotifier.new);

/// Newest-first list of the user's past daily challenges (history screen).
final challengeHistoryProvider =
    FutureProvider<List<DailyChallenge>>((ref) async {
  final userId = ref.watch(sessionProvider).userId;
  if (userId == null) return const [];
  return AppDatabase.fetchRecentDailyChallenges(userId);
});
