import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/reminder.dart';
import '../services/locale_service.dart';
import '../services/reminder_service.dart';
import '../services/notification_service.dart';
import '../services/challenge_service.dart';
import '../generated/l10n/app_localizations.dart';
import 'session_provider.dart';

/// Notifier tracking user smart reminder preferences (Sprint 2.3).
///
/// Implements background localization, smart suppression checks against today's
/// medical readings, and handles cascading rescheduling on configuration changes.
class ReminderNotifier extends AsyncNotifier<List<Reminder>> {
  @override
  Future<List<Reminder>> build() async {
    final session = ref.watch(sessionProvider);
    final userId = session.userId;
    if (userId == null) return const [];

    return _loadAndSeed(userId);
  }

  Future<List<Reminder>> _loadAndSeed(String userId) async {
    var reminders = await AppDatabase.fetchReminders(userId);
    if (reminders.isEmpty) {
      final defaults = ReminderService.defaultReminders(userId);
      for (final r in defaults) {
        await AppDatabase.insertReminder(r);
      }
      reminders = await AppDatabase.fetchReminders(userId);
      // Trigger rolling-window scheduling for the newly seeded defaults in the background
      Future.microtask(() => rescheduleAll());
    }
    return reminders;
  }

  String? _userId() => ref.read(sessionProvider).userId;

  /// Update an existing reminder and trigger rescheduled queues.
  Future<void> updateReminder(Reminder updated) async {
    final list = state.value ?? [];
    await AppDatabase.updateReminder(updated);

    state = AsyncData(
      list.map((r) => r.id == updated.id ? updated : r).toList(),
    );

    await rescheduleAll();
  }

  /// Create a new custom medication reminder.
  Future<void> addMedication({
    required String label,
    required int hour,
    required int minute,
    required int days,
  }) async {
    final userId = _userId();
    if (userId == null) return;

    final newReminder = Reminder(
      userId: userId,
      type: ReminderType.medication,
      label: label,
      hour: hour,
      minute: minute,
      days: days,
      enabled: true,
      createdAt: DateTime.now(),
    );

    final saved = await AppDatabase.insertReminder(newReminder);
    final current = state.value ?? [];

    state = AsyncData([...current, saved]);
    await rescheduleAll();
  }

  /// Delete a custom medication reminder, cancelling its scheduled occurrences.
  Future<void> deleteReminder(int id) async {
    final current = state.value ?? [];
    final toRemove = current.firstWhere((r) => r.id == id);

    // Cancel queued notification IDs for this specific reminder
    final now = DateTime.now();
    for (int i = 0; i < ReminderService.scheduleWindowDays; i++) {
      final date = DateTime(now.year, now.month, now.day + i);
      final notificationId = ReminderService.notificationIdFor(toRemove, date);
      await NotificationService.cancel(notificationId);
    }

    await AppDatabase.deleteReminder(id);
    state = AsyncData(current.where((r) => r.id != id).toList());
  }

  /// Recomputes and schedules a fresh rolling 14-day window of notifications
  /// for all enabled reminders, dynamically applying smart-suppression.
  Future<void> rescheduleAll() async {
    final userId = _userId();
    if (userId == null) return;

    final reminders = state.value ?? [];

    // 1. Gather logs from today to evaluate suppression criteria
    final today = DateTime.now();
    final todayKey = ReminderService.dateKey(today);

    final bmi = await AppDatabase.fetchRecords(userId);
    final bp = await AppDatabase.fetchBPRecords(userId);
    final glucose = await AppDatabase.fetchBloodSugarRecords(userId);
    final challenge = await AppDatabase.fetchDailyChallenge(userId, todayKey);

    bool isSameDay(DateTime d) => _sameDay(today, d);

    final hasBmiToday = bmi.any((r) => isSameDay(r.timestamp));
    final hasAnyActivityToday = hasBmiToday ||
        bp.any((r) => isSameDay(r.measurementTime)) ||
        glucose.any((r) => isSameDay(r.measurementTime));
    final challengeCompleteToday = challenge?.completed == true;

    // 2. Load the current active localization files without BuildContext
    final savedLocale =
        await LocaleService.getLocale() ?? PlatformDispatcher.instance.locale;
    final l10n = await AppLocalizations.delegate.load(savedLocale);

    // 3. For every reminder, cancel existing 14-day window ids and queue new ones
    for (final r in reminders) {
      // First cancel the historical deterministic IDs to avoid dupes/overlaps
      for (int i = 0; i < ReminderService.scheduleWindowDays; i++) {
        final date = DateTime(today.year, today.month, today.day + i);
        final notificationId = ReminderService.notificationIdFor(r, date);
        await NotificationService.cancel(notificationId);
      }

      if (!r.enabled) continue;

      final suppressToday = ReminderService.shouldSuppressToday(
        r.type,
        hasBmiToday: hasBmiToday,
        hasAnyActivityToday: hasAnyActivityToday,
        challengeCompleteToday: challengeCompleteToday,
      );

      final occurrences = ReminderService.occurrencesForWindow(
        r,
        now: today,
        suppressToday: suppressToday,
      );

      for (final fireTime in occurrences) {
        final notificationId = ReminderService.notificationIdFor(r, fireTime);

        // Resolve localized title & body strings
        String title = '';
        String body = '';

        switch (r.type) {
          case ReminderType.bmiCheck:
            title = l10n.reminderBmiTitle;
            body = l10n.reminderBmiBody;
            break;
          case ReminderType.hydration:
            title = l10n.reminderHydrationTitle;
            body = l10n.reminderHydrationBody;
            break;
          case ReminderType.activity:
            title = l10n.reminderActivityTitle;
            body = l10n.reminderActivityBody;
            break;
          case ReminderType.healthTip:
            title = l10n.reminderHealthTipTitle;
            body = l10n.reminderHealthTipBody;
            break;
          case ReminderType.medication:
            title = r.label ?? l10n.reminderMedicationTitle;
            body = l10n.reminderMedicationBody;
            break;
          case ReminderType.dailyChallenge:
            title = l10n.reminderChallengeTitle;
            body = l10n.reminderChallengeBody;
            break;
        }

        // Construct optional intent payload (from Daily Challenge contract if daily_challenge type)
        String? payloadString;
        if (r.type == ReminderType.dailyChallenge && challenge != null) {
          final payloadMap = ChallengeService.reminderPayload(challenge);
          if (payloadMap != null) {
            // Include challenge payload info
            payloadString = 'challenge:${challenge.definitionId}';
          }
        }

        await NotificationService.schedule(
          notificationId: notificationId,
          fireAt: fireTime,
          title: title,
          body: body,
          payload: payloadString,
        );
      }
    }
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Evaluates and cancels today's active reminder of [type] when the user logs
  /// the required metric. Suppressed once-logged to keep notifications smart.
  Future<void> cancelTodayReminder(ReminderType type) async {
    final list = state.value ?? [];
    final matching = list.where((r) => r.type == type && r.enabled);
    if (matching.isEmpty) return;

    final today = DateTime.now();
    for (final r in matching) {
      final notificationId = ReminderService.notificationIdFor(r, today);
      await NotificationService.cancel(notificationId);
      debugPrint(
          'Smart suppression: cancelled today\'s reminder #${r.id} ($type)');
    }
  }
}

final reminderProvider =
    AsyncNotifierProvider<ReminderNotifier, List<Reminder>>(
        ReminderNotifier.new);
