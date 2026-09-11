import '../models/reminder.dart';

/// Static metadata for one reminder category.
class ReminderTypeMeta {
  final ReminderType type;
  final String titleKey;
  final String bodyKey;
  final String icon; // Material icon name, resolved by the UI
  final int defaultHour;
  final int defaultMinute;
  final bool enabledByDefault;

  /// True when this reminder auto-skips today's occurrence once the relevant
  /// metric has been logged (smart suppression).
  final bool smart;

  const ReminderTypeMeta({
    required this.type,
    required this.titleKey,
    required this.bodyKey,
    required this.icon,
    required this.defaultHour,
    required this.defaultMinute,
    required this.enabledByDefault,
    this.smart = false,
  });
}

/// Pure scheduling / categorisation logic for smart reminders (Sprint 2.3).
///
/// No Flutter or plugin imports — everything here is unit-testable. The
/// plugin-facing adapter lives in [NotificationService].
class ReminderService {
  /// How many days ahead occurrences are pre-queued. Pre-queueing a rolling
  /// window (rather than one repeating alarm) is what lets today's occurrence
  /// be cancelled independently when the smart condition is met.
  static const int scheduleWindowDays = 14;

  /// Category metadata, in settings-screen display order.
  static const List<ReminderTypeMeta> catalog = [
    ReminderTypeMeta(
      type: ReminderType.bmiCheck,
      titleKey: 'reminderBmiTitle',
      bodyKey: 'reminderBmiBody',
      icon: 'monitor_weight',
      defaultHour: 9,
      defaultMinute: 0,
      enabledByDefault: true,
      smart: true,
    ),
    ReminderTypeMeta(
      type: ReminderType.hydration,
      titleKey: 'reminderHydrationTitle',
      bodyKey: 'reminderHydrationBody',
      icon: 'water_drop',
      defaultHour: 14,
      defaultMinute: 0,
      enabledByDefault: true,
    ),
    ReminderTypeMeta(
      type: ReminderType.activity,
      titleKey: 'reminderActivityTitle',
      bodyKey: 'reminderActivityBody',
      icon: 'directions_walk',
      defaultHour: 18,
      defaultMinute: 0,
      enabledByDefault: true,
      smart: true,
    ),
    ReminderTypeMeta(
      type: ReminderType.healthTip,
      titleKey: 'reminderHealthTipTitle',
      bodyKey: 'reminderHealthTipBody',
      icon: 'lightbulb',
      defaultHour: 20,
      defaultMinute: 0,
      enabledByDefault: true,
    ),
    ReminderTypeMeta(
      type: ReminderType.medication,
      titleKey: 'reminderMedicationTitle',
      bodyKey: 'reminderMedicationBody',
      icon: 'medication',
      defaultHour: 8,
      defaultMinute: 0,
      enabledByDefault: false,
    ),
    ReminderTypeMeta(
      type: ReminderType.dailyChallenge,
      titleKey: 'reminderChallengeTitle',
      bodyKey: 'reminderChallengeBody',
      icon: 'emoji_events',
      defaultHour: 10,
      defaultMinute: 0,
      enabledByDefault: false,
      smart: true,
    ),
  ];

  static ReminderTypeMeta metaFor(ReminderType type) => catalog.firstWhere(
        (m) => m.type == type,
        orElse: () => catalog.first,
      );

  /// Seed set for a fresh user (one entry per category).
  static List<Reminder> defaultReminders(String userId, {DateTime? now}) {
    final created = now ?? DateTime.now();
    return [
      for (final meta in catalog)
        Reminder(
          userId: userId,
          type: meta.type,
          hour: meta.defaultHour,
          minute: meta.defaultMinute,
          enabled: meta.enabledByDefault,
          createdAt: created,
        ),
    ];
  }

  /// Snapshot of "what already happened today" for smart suppression.
  ///
  /// - `hasBmiToday` suppresses BMI-check reminders.
  /// - `hasAnyActivityToday` suppresses activity prompts (any metric counts).
  /// - `challengeCompleteToday` suppresses daily-challenge reminders.
  ///   Hydration, medication and health tips are never suppressed.
  static bool shouldSuppressToday(
    ReminderType type, {
    bool hasBmiToday = false,
    bool hasAnyActivityToday = false,
    bool challengeCompleteToday = false,
  }) {
    switch (type) {
      case ReminderType.bmiCheck:
        return hasBmiToday;
      case ReminderType.activity:
        return hasAnyActivityToday;
      case ReminderType.dailyChallenge:
        return challengeCompleteToday;
      case ReminderType.hydration:
      case ReminderType.medication:
      case ReminderType.healthTip:
        return false;
    }
  }

  /// All local fire-times for [reminder] from [now] (inclusive of today if the
  /// time hasn't passed) through `scheduleWindowDays` ahead.
  ///
  /// Today's occurrence is dropped when the smart-suppression condition nils
  /// it out. Disabled reminders yield an empty list.
  static List<DateTime> occurrencesForWindow(
    Reminder reminder, {
    DateTime? now,
    bool suppressToday = false,
  }) {
    if (!reminder.enabled) return const [];
    final start = now ?? DateTime.now();
    final result = <DateTime>[];
    for (var day = 0; day < scheduleWindowDays; day++) {
      final date = DateTime(start.year, start.month, start.day + day);
      if (!reminder.enabledOn(date.weekday)) continue;
      var fireAt = DateTime(
        date.year,
        date.month,
        date.day,
        reminder.hour,
        reminder.minute,
      );
      if (day == 0) {
        if (suppressToday) continue;
        // If today's time slipped by more than an hour, skip to tomorrow so we
        // don't blast a stale notification the moment the app opens.
        if (start.isAfter(fireAt.add(const Duration(hours: 1)))) continue;
        if (fireAt.isBefore(start)) {
          fireAt = start.add(const Duration(minutes: 1));
        }
      }
      result.add(fireAt);
    }
    return result;
  }

  /// Deterministic notification id for one occurrence: stable so the exact
  /// same (reminder, date) slot can be cancelled without bookkeeping.
  static int notificationIdFor(Reminder reminder, DateTime date) {
    final dayOfYear =
        date.difference(DateTime(date.year, 1, 1)).inDays + 1; // 1–366
    return (reminder.id ?? 0) * 1000 + dayOfYear;
  }

  /// 'yyyy-MM-dd' key for a date (matches [StreakCalculator.dayKey] format).
  static String dateKey(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
