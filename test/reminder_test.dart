import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/reminder.dart';
import 'package:bmi_calculator/services/reminder_service.dart';

Reminder rem({
  int? id,
  String userId = 'u',
  ReminderType type = ReminderType.bmiCheck,
  String? label,
  int hour = 9,
  int minute = 0,
  int days = Reminder.everyDay,
  bool enabled = true,
  DateTime? createdAt,
}) =>
    Reminder(
      id: id,
      userId: userId,
      type: type,
      label: label,
      hour: hour,
      minute: minute,
      days: days,
      enabled: enabled,
      createdAt: createdAt ?? DateTime(2026, 9, 9, 8),
    );

void main() {
  group('Reminder.enabledOn', () {
    test('everyDay fires on every weekday', () {
      final r = rem();
      for (var wd = 1; wd <= 7; wd++) {
        expect(r.enabledOn(wd), isTrue, reason: 'weekday $wd');
      }
    });

    test('bitmask bit 0 = Monday, bit 6 = Sunday', () {
      final weekdayOnly = rem(days: 1 << (DateTime.monday - 1)); // Monday
      expect(weekdayOnly.enabledOn(DateTime.monday), isTrue);
      expect(weekdayOnly.enabledOn(DateTime.tuesday), isFalse);
      expect(weekdayOnly.enabledOn(DateTime.sunday), isFalse);
    });

    test('mixed days respect individual bits', () {
      final weekdays =
          rem(days: (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3) | (1 << 4));
      for (final wd in [1, 2, 3, 4, 5]) {
        expect(weekdays.enabledOn(wd), isTrue);
      }
      expect(weekdays.enabledOn(6), isFalse);
      expect(weekdays.enabledOn(7), isFalse);
    });

    test('empty bitmask fires on nothing', () {
      expect(rem(days: 0).enabledOn(1), isFalse);
      expect(rem(days: 0).enabledOn(7), isFalse);
    });
  });

  group('Reminder serialization', () {
    test('toMap / fromMap round-trips every field', () {
      final original = rem(
        id: 42,
        type: ReminderType.medication,
        label: 'Metformin',
        hour: 7,
        minute: 30,
        days: 1 << 5, // Saturday
        enabled: false,
        createdAt: DateTime(2026, 9, 9, 6, 15),
      );
      final map = original.toMap();
      final restored = Reminder.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.userId, original.userId);
      expect(restored.type, original.type);
      expect(restored.label, original.label);
      expect(restored.hour, original.hour);
      expect(restored.minute, original.minute);
      expect(restored.days, original.days);
      expect(restored.enabled, original.enabled);
      expect(restored.createdAt, original.createdAt);
    });

    test('toMap encodes enabled bool to 1/0 int', () {
      final on = rem(enabled: true).toMap();
      final off = rem(enabled: false).toMap();
      expect(on['enabled'], 1);
      expect(off['enabled'], 0);
    });

    test('fromMap parses disabled bit back to false', () {
      final map = rem(enabled: true).toMap();
      map['enabled'] = 0;
      final restored = Reminder.fromMap(map);
      expect(restored.enabled, isFalse);
    });

    test('omits id when null', () {
      expect(rem().toMap().containsKey('id'), isFalse);
    });

    test('round-trips JSON payload', () {
      final r = rem(type: ReminderType.dailyChallenge, id: 9);
      final withPayload = r.copyWith(
          payload: {'type': 'daily_challenge', 'challengeId': 'log_bmi'});
      final restored = Reminder.fromMap(withPayload.toMap());
      expect(restored.payload,
          {'type': 'daily_challenge', 'challengeId': 'log_bmi'});
    });
  });

  group('Reminder.copyWith', () {
    test('changes only supplied fields', () {
      final r = rem();
      final changed = r.copyWith(hour: 18, enabled: false);
      expect(changed.hour, 18);
      expect(changed.enabled, isFalse);
      expect(changed.userId, r.userId);
      expect(changed.minute, r.minute);
      expect(changed.type, r.type);
    });
  });

  group('ReminderType.fromId', () {
    test('maps ids and falls back to bmiCheck', () {
      expect(ReminderType.fromId('hydration'), ReminderType.hydration);
      expect(ReminderType.fromId('medication'), ReminderType.medication);
      expect(
          ReminderType.fromId('daily_challenge'), ReminderType.dailyChallenge);
      expect(ReminderType.fromId('unknown'), ReminderType.bmiCheck);
    });

    test('every type exposes a stable id', () {
      for (final t in ReminderType.values) {
        expect(t.id, isNotEmpty);
      }
    });
  });

  group('ReminderService.defaultReminders', () {
    test('seeds one reminder per catalog category', () {
      final seeds = ReminderService.defaultReminders('u');
      expect(seeds.length, ReminderService.catalog.length);
      final types = seeds.map((r) => r.type).toSet();
      expect(types.length, ReminderService.catalog.length);
      for (final meta in ReminderService.catalog) {
        expect(types.contains(meta.type), isTrue,
            reason: '${meta.type} seeded');
      }
    });

    test('applies per-category default time and enabled state', () {
      final byType = {
        for (final r in ReminderService.defaultReminders('u')) r.type: r,
      };
      for (final meta in ReminderService.catalog) {
        final r = byType[meta.type]!;
        expect(r.hour, meta.defaultHour, reason: '${meta.type} hour');
        expect(r.minute, meta.defaultMinute, reason: '${meta.type} minute');
        expect(r.enabled, meta.enabledByDefault,
            reason: '${meta.type} enabled');
      }
    });

    test('all seeds share the user id', () {
      final seeds = ReminderService.defaultReminders('abc');
      for (final r in seeds) {
        expect(r.userId, 'abc');
      }
    });
  });

  group('ReminderService.metaFor', () {
    test('resolves each type, unknown falls back to first', () {
      for (final t in ReminderType.values) {
        expect(ReminderService.metaFor(t).type, t);
      }
      expect(ReminderService.metaFor(ReminderType.values.first).type,
          ReminderType.values.first);
    });

    test('smart flag is only on suppression-capable categories', () {
      final smartTypes = ReminderService.catalog
          .where((m) => m.smart)
          .map((m) => m.type)
          .toSet();
      expect(
          smartTypes,
          containsAll([
            ReminderType.bmiCheck,
            ReminderType.activity,
            ReminderType.dailyChallenge
          ]));
      expect(
          smartTypes,
          isNot(containsAll([
            ReminderType.hydration,
            ReminderType.medication,
            ReminderType.healthTip
          ])));
    });
  });

  group('ReminderService.shouldSuppressToday', () {
    test('bmiCheck suppressed only by today BMI', () {
      expect(
          ReminderService.shouldSuppressToday(ReminderType.bmiCheck,
              hasBmiToday: true),
          isTrue);
      expect(
          ReminderService.shouldSuppressToday(ReminderType.bmiCheck,
              hasBmiToday: false),
          isFalse);
      expect(
          ReminderService.shouldSuppressToday(ReminderType.bmiCheck,
              hasAnyActivityToday: true, challengeCompleteToday: true),
          isFalse);
    });

    test('activity suppressed by any logged metric', () {
      expect(
          ReminderService.shouldSuppressToday(ReminderType.activity,
              hasAnyActivityToday: true),
          isTrue);
      expect(
          ReminderService.shouldSuppressToday(ReminderType.activity,
              hasAnyActivityToday: false),
          isFalse);
    });

    test('dailyChallenge suppressed only when completed', () {
      expect(
          ReminderService.shouldSuppressToday(ReminderType.dailyChallenge,
              challengeCompleteToday: true),
          isTrue);
      expect(
          ReminderService.shouldSuppressToday(ReminderType.dailyChallenge,
              challengeCompleteToday: false),
          isFalse);
    });

    test('hydration / medication / healthTips never suppressed', () {
      for (final t in [
        ReminderType.hydration,
        ReminderType.medication,
        ReminderType.healthTip
      ]) {
        expect(
            ReminderService.shouldSuppressToday(t,
                hasBmiToday: true,
                hasAnyActivityToday: true,
                challengeCompleteToday: true),
            isFalse,
            reason: '$t');
      }
    });
  });

  group('ReminderService.occurrencesForWindow', () {
    final now = DateTime(2026, 9, 9, 10); // Wednesday

    test('disabled reminder yields nothing', () {
      expect(
          ReminderService.occurrencesForWindow(rem(enabled: false), now: now),
          isEmpty);
    });

    test('schedules daily across the window', () {
      final r = rem(hour: 18, minute: 30);
      final dates = ReminderService.occurrencesForWindow(r, now: now);
      expect(dates.length, ReminderService.scheduleWindowDays);
      for (final d in dates) {
        expect(d.hour, 18);
        expect(d.minute, 30);
      }
    });

    test('skips days not in bitmask', () {
      final mondayOnly = rem(days: 1 << (DateTime.monday - 1), hour: 8);
      final nowMon = DateTime(2026, 9, 7, 6); // Monday
      final dates =
          ReminderService.occurrencesForWindow(mondayOnly, now: nowMon);
      expect(dates.length, 2); // next two Mondays within 14 days
      for (final d in dates) {
        expect(d.weekday, DateTime.monday);
      }
    });

    test('today occurrence dropped when time already passed', () {
      final r = rem(hour: 9, minute: 0);
      final late = DateTime(2026, 9, 9, 12);
      final dates = ReminderService.occurrencesForWindow(r, now: late);
      expect(dates.first.isAfter(late), isTrue,
          reason: 'first occurrence should be bumped forward, not past');
      expect(dates.first.day, 10); // tomorrow
    });

    test('suppressToday drops only day zero', () {
      final r = rem(hour: 18);
      final dates = ReminderService.occurrencesForWindow(r,
          now: now, suppressToday: true);
      expect(dates.length, ReminderService.scheduleWindowDays - 1);
      for (final d in dates) {
        expect(d.isAfter(DateTime(2026, 9, 9)), isTrue);
      }
    });

    test('today still scheduled if time is ahead of now', () {
      final r = rem(hour: 20, minute: 0);
      final dates = ReminderService.occurrencesForWindow(r, now: now);
      expect(dates.first.day, 9); // same day, still ahead
    });
  });

  group('ReminderService.notificationIdFor', () {
    test('is deterministic and unique per (id, day)', () {
      final r = rem(id: 3);
      final jan1 = DateTime.now();
      final d1 = DateTime(jan1.year, 1, 1);
      final d366 = DateTime(jan1.year, 12, 31);
      final a = ReminderService.notificationIdFor(r, d1);
      final b = ReminderService.notificationIdFor(r, d1);
      final c = ReminderService.notificationIdFor(r, d366);
      expect(a, b);
      expect(c, isNot(a));
    });

    test('different reminder ids produce different ids', () {
      final jan1 = DateTime(2026, 1, 1);
      expect(ReminderService.notificationIdFor(rem(id: 1), jan1),
          isNot(ReminderService.notificationIdFor(rem(id: 2), jan1)));
    });
  });

  group('ReminderService.dateKey', () {
    test('formats yyyy-MM-dd', () {
      expect(ReminderService.dateKey(DateTime(2026, 9, 9)), '2026-09-09');
      expect(ReminderService.dateKey(DateTime(2026, 1, 5)), '2026-01-05');
      expect(ReminderService.dateKey(DateTime(2026, 12, 31)), '2026-12-31');
    });
  });
}
