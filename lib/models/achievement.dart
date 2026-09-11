/// Beat any predicate over {AchievementProgress}.
typedef AchievementPredicate = bool Function(AchievementProgress progress);

/// Serialized stats snapshot used to evaluate achievement predicates.
class AchievementProgress {
  final int bmiCount;
  final int bpCount;
  final int glucoseCount;
  final bool hasHealthyBmi;
  final bool hasHealthyBp;
  final bool hasHealthyGlucose;
  final int currentStreak;
  final int bestStreak;
  final bool hasMorningRecord; // before 9:00
  final bool hasEveningRecord; // after 21:00
  final int maxRecordsInDay;
  final int? healthScore; // 0–100 dashboard score, null if unavailable

  const AchievementProgress({
    required this.bmiCount,
    required this.bpCount,
    required this.glucoseCount,
    this.hasHealthyBmi = false,
    this.hasHealthyBp = false,
    this.hasHealthyGlucose = false,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.hasMorningRecord = false,
    this.hasEveningRecord = false,
    this.maxRecordsInDay = 0,
    this.healthScore,
  });
}

/// A single unlockable achievement.
///
/// Pure Dart (no Flutter imports): [icon] is a Material icon *name* that the
/// UI maps to an [IconData]; [titleKey] / [descriptionKey] are `app_en.arb`
/// keys resolved through [AppLocalizations] by the presentation layer.
class Achievement {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String icon;
  final int points;
  final AchievementPredicate predicate;

  const Achievement({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.points,
    required this.predicate,
  });
}

/// The full achievement catalog (Sprint 2.1). 22 achievements.
final List<Achievement> achievementCatalog = [
  // ── Calculation milestones ─────────────────────────────────────────────────
  Achievement(
    id: 'first_calculation',
    titleKey: 'achFirstCalculationTitle',
    descriptionKey: 'achFirstCalculationDesc',
    icon: 'calculate',
    points: 10,
    predicate: (p) => p.bmiCount >= 1,
  ),
  Achievement(
    id: 'ten_calculations',
    titleKey: 'achTenCalculationsTitle',
    descriptionKey: 'achTenCalculationsDesc',
    icon: 'functions',
    points: 25,
    predicate: (p) => p.bmiCount >= 10,
  ),
  Achievement(
    id: 'fifty_calculations',
    titleKey: 'achFiftyCalculationsTitle',
    descriptionKey: 'achFiftyCalculationsDesc',
    icon: 'query_stats',
    points: 60,
    predicate: (p) => p.bmiCount >= 50,
  ),
  Achievement(
    id: 'hundred_calculations',
    titleKey: 'achHundredCalculationsTitle',
    descriptionKey: 'achHundredCalculationsDesc',
    icon: 'stacked_line_chart',
    points: 120,
    predicate: (p) => p.bmiCount >= 100,
  ),

  // ── Health milestones ──────────────────────────────────────────────────────
  Achievement(
    id: 'healthy_bmi',
    titleKey: 'achHealthyBmiTitle',
    descriptionKey: 'achHealthyBmiDesc',
    icon: 'monitor_weight',
    points: 20,
    predicate: (p) => p.hasHealthyBmi,
  ),
  Achievement(
    id: 'healthy_bp',
    titleKey: 'achHealthyBpTitle',
    descriptionKey: 'achHealthyBpDesc',
    icon: 'favorite',
    points: 20,
    predicate: (p) => p.hasHealthyBp,
  ),
  Achievement(
    id: 'healthy_glucose',
    titleKey: 'achHealthyGlucoseTitle',
    descriptionKey: 'achHealthyGlucoseDesc',
    icon: 'water_drop',
    points: 20,
    predicate: (p) => p.hasHealthyGlucose,
  ),
  Achievement(
    id: 'all_metrics_healthy',
    titleKey: 'achAllMetricsHealthyTitle',
    descriptionKey: 'achAllMetricsHealthyDesc',
    icon: 'health_and_safety',
    points: 50,
    predicate: (p) => p.hasHealthyBmi && p.hasHealthyBp && p.hasHealthyGlucose,
  ),

  // ── Tracking volume ────────────────────────────────────────────────────────
  Achievement(
    id: 'first_bp',
    titleKey: 'achFirstBpTitle',
    descriptionKey: 'achFirstBpDesc',
    icon: 'bloodtype',
    points: 10,
    predicate: (p) => p.bpCount >= 1,
  ),
  Achievement(
    id: 'ten_bp',
    titleKey: 'achTenBpTitle',
    descriptionKey: 'achTenBpDesc',
    icon: 'monitor_heart',
    points: 25,
    predicate: (p) => p.bpCount >= 10,
  ),
  Achievement(
    id: 'first_glucose',
    titleKey: 'achFirstGlucoseTitle',
    descriptionKey: 'achFirstGlucoseDesc',
    icon: 'water_drop_outlined',
    points: 10,
    predicate: (p) => p.glucoseCount >= 1,
  ),
  Achievement(
    id: 'ten_glucose',
    titleKey: 'achTenGlucoseTitle',
    descriptionKey: 'achTenGlucoseDesc',
    icon: 'fact_check',
    points: 25,
    predicate: (p) => p.glucoseCount >= 10,
  ),

  // ── Streaks ────────────────────────────────────────────────────────────────
  Achievement(
    id: 'three_day_streak',
    titleKey: 'achThreeDayStreakTitle',
    descriptionKey: 'achThreeDayStreakDesc',
    icon: 'local_fire_department',
    points: 10,
    predicate: (p) => p.currentStreak >= 3,
  ),
  Achievement(
    id: 'seven_day_streak',
    titleKey: 'achSevenDayStreakTitle',
    descriptionKey: 'achSevenDayStreakDesc',
    icon: 'local_fire_department',
    points: 30,
    predicate: (p) => p.currentStreak >= 7,
  ),
  Achievement(
    id: 'fourteen_day_streak',
    titleKey: 'achFourteenDayStreakTitle',
    descriptionKey: 'achFourteenDayStreakDesc',
    icon: 'auto_awesome',
    points: 60,
    predicate: (p) => p.currentStreak >= 14,
  ),
  Achievement(
    id: 'thirty_day_streak',
    titleKey: 'achThirtyDayStreakTitle',
    descriptionKey: 'achThirtyDayStreakDesc',
    icon: 'military_tech',
    points: 120,
    predicate: (p) => p.currentStreak >= 30,
  ),
  Achievement(
    id: 'perfect_week',
    titleKey: 'achPerfectWeekTitle',
    descriptionKey: 'achPerfectWeekDesc',
    icon: 'calendar_month',
    points: 40,
    predicate: (p) => p.bestStreak >= 7,
  ),
  Achievement(
    id: 'on_a_roll',
    titleKey: 'achOnARollTitle',
    descriptionKey: 'achOnARollDesc',
    icon: 'bolt',
    points: 15,
    predicate: (p) => p.maxRecordsInDay >= 5,
  ),

  // ── Lifestyle ──────────────────────────────────────────────────────────────
  Achievement(
    id: 'early_bird',
    titleKey: 'achEarlyBirdTitle',
    descriptionKey: 'achEarlyBirdDesc',
    icon: 'wb_sunny',
    points: 15,
    predicate: (p) => p.hasMorningRecord,
  ),
  Achievement(
    id: 'night_owl',
    titleKey: 'achNightOwlTitle',
    descriptionKey: 'achNightOwlDesc',
    icon: 'nights_stay',
    points: 15,
    predicate: (p) => p.hasEveningRecord,
  ),
  Achievement(
    id: 'all_tracker_types',
    titleKey: 'achAllTrackerTypesTitle',
    descriptionKey: 'achAllTrackerTypesDesc',
    icon: 'dashboard_customize',
    points: 30,
    predicate: (p) => p.bmiCount >= 1 && p.bpCount >= 1 && p.glucoseCount >= 1,
  ),
  Achievement(
    id: 'dashboard_excellent',
    titleKey: 'achDashboardExcellentTitle',
    descriptionKey: 'achDashboardExcellentDesc',
    icon: 'workspace_premium',
    points: 40,
    predicate: (p) => (p.healthScore ?? 0) >= 90,
  ),
];

/// Looks up an achievement definition by id.
Achievement? achievementById(String id) {
  for (final a in achievementCatalog) {
    if (a.id == id) return a;
  }
  return null;
}

/// Achievements whose predicate is satisfied and that are not yet unlocked.
List<Achievement> unlockedBy(
  AchievementProgress progress,
  Set<String> alreadyUnlocked,
) =>
    [
      for (final a in achievementCatalog)
        if (!alreadyUnlocked.contains(a.id) && a.predicate(progress)) a,
    ];

/// Total points for a set of unlocked achievement ids.
int pointsFor(Set<String> unlockedIds) {
  var total = 0;
  for (final id in unlockedIds) {
    final a = achievementById(id);
    if (a != null) total += a.points;
  }
  return total;
}
