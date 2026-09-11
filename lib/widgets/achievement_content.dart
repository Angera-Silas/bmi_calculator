import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/achievement.dart';
import '../models/daily_challenge.dart';

/// Resolves achievement/challenge ids to Material icons and localized copy.
///
/// The achievement model is pure Dart; all Flutter/l10n coupling lives here so
/// the model stays unit-testable without a widget tree.
IconData achievementIcon(String name) => switch (name) {
      'calculate' => Icons.calculate_outlined,
      'functions' => Icons.functions,
      'query_stats' => Icons.query_stats,
      'stacked_line_chart' => Icons.stacked_line_chart,
      'monitor_weight' => Icons.monitor_weight_outlined,
      'favorite' => Icons.favorite,
      'water_drop' => Icons.water_drop,
      'health_and_safety' => Icons.health_and_safety,
      'bloodtype' => Icons.bloodtype,
      'monitor_heart' => Icons.monitor_heart_outlined,
      'water_drop_outlined' => Icons.water_drop_outlined,
      'fact_check' => Icons.fact_check,
      'local_fire_department' => Icons.local_fire_department,
      'auto_awesome' => Icons.auto_awesome,
      'military_tech' => Icons.military_tech,
      'calendar_month' => Icons.calendar_month,
      'bolt' => Icons.bolt,
      'wb_sunny' => Icons.wb_sunny,
      'nights_stay' => Icons.nights_stay,
      'dashboard_customize' => Icons.dashboard_customize,
      'workspace_premium' => Icons.workspace_premium,
      'task_alt' => Icons.task_alt,
      'add_chart' => Icons.add_chart,
      'directions_walk' => Icons.directions_walk,
      'lightbulb' => Icons.lightbulb_outline,
      'medication' => Icons.medication_outlined,
      _ => Icons.emoji_events,
    };

/// Localized achievement title.
String achievementTitle(AppLocalizations l10n, Achievement a) => switch (a.id) {
      'first_calculation' => l10n.achFirstCalculationTitle,
      'ten_calculations' => l10n.achTenCalculationsTitle,
      'fifty_calculations' => l10n.achFiftyCalculationsTitle,
      'hundred_calculations' => l10n.achHundredCalculationsTitle,
      'healthy_bmi' => l10n.achHealthyBmiTitle,
      'healthy_bp' => l10n.achHealthyBpTitle,
      'healthy_glucose' => l10n.achHealthyGlucoseTitle,
      'all_metrics_healthy' => l10n.achAllMetricsHealthyTitle,
      'first_bp' => l10n.achFirstBpTitle,
      'ten_bp' => l10n.achTenBpTitle,
      'first_glucose' => l10n.achFirstGlucoseTitle,
      'ten_glucose' => l10n.achTenGlucoseTitle,
      'three_day_streak' => l10n.achThreeDayStreakTitle,
      'seven_day_streak' => l10n.achSevenDayStreakTitle,
      'fourteen_day_streak' => l10n.achFourteenDayStreakTitle,
      'thirty_day_streak' => l10n.achThirtyDayStreakTitle,
      'perfect_week' => l10n.achPerfectWeekTitle,
      'on_a_roll' => l10n.achOnARollTitle,
      'early_bird' => l10n.achEarlyBirdTitle,
      'night_owl' => l10n.achNightOwlTitle,
      'all_tracker_types' => l10n.achAllTrackerTypesTitle,
      'dashboard_excellent' => l10n.achDashboardExcellentTitle,
      _ => a.id,
    };

/// Localized achievement description.
String achievementDescription(AppLocalizations l10n, Achievement a) =>
    switch (a.id) {
      'first_calculation' => l10n.achFirstCalculationDesc,
      'ten_calculations' => l10n.achTenCalculationsDesc,
      'fifty_calculations' => l10n.achFiftyCalculationsDesc,
      'hundred_calculations' => l10n.achHundredCalculationsDesc,
      'healthy_bmi' => l10n.achHealthyBmiDesc,
      'healthy_bp' => l10n.achHealthyBpDesc,
      'healthy_glucose' => l10n.achHealthyGlucoseDesc,
      'all_metrics_healthy' => l10n.achAllMetricsHealthyDesc,
      'first_bp' => l10n.achFirstBpDesc,
      'ten_bp' => l10n.achTenBpDesc,
      'first_glucose' => l10n.achFirstGlucoseDesc,
      'ten_glucose' => l10n.achTenGlucoseDesc,
      'three_day_streak' => l10n.achThreeDayStreakDesc,
      'seven_day_streak' => l10n.achSevenDayStreakDesc,
      'fourteen_day_streak' => l10n.achFourteenDayStreakDesc,
      'thirty_day_streak' => l10n.achThirtyDayStreakDesc,
      'perfect_week' => l10n.achPerfectWeekDesc,
      'on_a_roll' => l10n.achOnARollDesc,
      'early_bird' => l10n.achEarlyBirdDesc,
      'night_owl' => l10n.achNightOwlDesc,
      'all_tracker_types' => l10n.achAllTrackerTypesDesc,
      'dashboard_excellent' => l10n.achDashboardExcellentDesc,
      _ => a.descriptionKey,
    };

/// Localized challenge title.
String challengeTitle(AppLocalizations l10n, DailyChallenge c) =>
    switch (c.definitionId) {
      'log_bmi' => l10n.challengeLogBmiTitle,
      'log_bp' => l10n.challengeLogBpTitle,
      'log_glucose' => l10n.challengeLogGlucoseTitle,
      'log_any_three' => l10n.challengeLogAnyThreeTitle,
      'log_healthy' => l10n.challengeLogHealthyTitle,
      _ => c.titleKey,
    };

/// Localized challenge description.
String challengeDescription(AppLocalizations l10n, DailyChallenge c) =>
    switch (c.definitionId) {
      'log_bmi' => l10n.challengeLogBmiDesc,
      'log_bp' => l10n.challengeLogBpDesc,
      'log_glucose' => l10n.challengeLogGlucoseDesc,
      'log_any_three' => l10n.challengeLogAnyThreeDesc,
      'log_healthy' => l10n.challengeLogHealthyDesc,
      _ => c.descriptionKey,
    };
