import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/achievement.dart';
import 'package:bmi_calculator/models/blood_pressure_record.dart';
import 'package:bmi_calculator/models/blood_sugar_record.dart';
import 'package:bmi_calculator/models/bmi_record.dart';
import 'package:bmi_calculator/models/daily_challenge.dart';
import 'package:bmi_calculator/models/user_streak.dart';
import 'package:bmi_calculator/services/gamification_service.dart';

BmiRecord bmi({double value = 22.0, DateTime? at}) => BmiRecord(
      id: 'b-${value}-${at?.millisecondsSinceEpoch ?? 0}',
      userId: 'u',
      height: 175,
      weight: (value * 3.0625).round(),
      age: 30,
      isMale: true,
      bmiValue: value,
      bmiResult: value.toStringAsFixed(1),
      resultText: 'Normal Range',
      interpretation: 'Normal',
      timestamp: at ?? DateTime(2026, 9, 9, 10),
    );

BloodPressureRecord bp({int sys = 110, int dia = 70, DateTime? at}) =>
    BloodPressureRecord(
      id: 'bp-$sys-$dia-${at?.millisecondsSinceEpoch ?? 0}',
      userId: 'u',
      systolic: sys,
      diastolic: dia,
      measurementTime: at ?? DateTime(2026, 9, 9, 10),
    );

BloodSugarRecord glucose({int level = 95, DateTime? at}) => BloodSugarRecord(
      id: 'g-$level-${at?.millisecondsSinceEpoch ?? 0}',
      userId: 'u',
      glucoseLevel: level,
      measurementTime: at ?? DateTime(2026, 9, 9, 10),
    );

void main() {
  group('StreakCalculator.dayKey', () {
    test('formats yyyy-MM-dd', () {
      expect(StreakCalculator.dayKey(DateTime(2026, 9, 9)), '2026-09-09');
      expect(StreakCalculator.dayKey(DateTime(2026, 1, 5)), '2026-01-05');
      expect(StreakCalculator.dayKey(DateTime(2026, 12, 31)), '2026-12-31');
    });
  });

  group('StreakCalculator.compute', () {
    test('empty set yields empty streak', () {
      final s = StreakCalculator.compute({}, now: DateTime(2026, 9, 9));
      expect(s.current, 0);
      expect(s.best, 0);
    });

    test('anchors current streak on today and counts backwards', () {
      final s = StreakCalculator.compute(
        {'2026-09-07', '2026-09-08', '2026-09-09'},
        now: DateTime(2026, 9, 9),
      );
      expect(s.current, 3);
      expect(s.best, 3);
    });

    test('yesterday keeps the streak alive (grace day)', () {
      final s = StreakCalculator.compute(
        {'2026-09-07', '2026-09-08'},
        now: DateTime(2026, 9, 9),
      );
      expect(s.current, 2, reason: 'no activity today but logged yesterday');
    });

    test('gap resets the current streak but keeps the best', () {
      final s = StreakCalculator.compute(
        {'2026-09-01', '2026-09-02', '2026-09-03', '2026-09-08'},
        now: DateTime(2026, 9, 8, 23),
      );
      expect(s.current, 1);
      expect(s.best, 3);
    });

    test('two days ago does not count as grace', () {
      final s = StreakCalculator.compute(
        {'2026-09-07'},
        now: DateTime(2026, 9, 9),
      );
      expect(s.current, 0);
    });

    test('best reflects the longest historical run', () {
      final s = StreakCalculator.compute(
        {
          '2026-01-01',
          '2026-01-02',
          '2026-01-03',
          '2026-01-04',
          '2026-04-10',
          '2026-04-11',
        },
        now: DateTime(2026, 4, 11),
      );
      expect(s.current, 2);
      expect(s.best, 4);
    });
  });

  group('achievement catalog', () {
    test('contains 20+ achievements', () {
      expect(achievementCatalog.length, greaterThanOrEqualTo(20));
    });

    test('ids are unique', () {
      final ids = achievementCatalog.map((a) => a.id).toSet();
      expect(ids.length, achievementCatalog.length);
    });

    test('all achievements have positive points and icons', () {
      for (final a in achievementCatalog) {
        expect(a.points, greaterThan(0), reason: '${a.id} points');
        expect(a.icon, isNotEmpty, reason: '${a.id} icon');
      }
    });

    test('achievementById finds known and returns null for unknown', () {
      expect(achievementById('first_calculation'), isNotNull);
      expect(achievementById('does_not_exist'), isNull);
    });
  });

  group('predicates', () {
    const base = AchievementProgress(
      bmiCount: 0,
      bpCount: 0,
      glucoseCount: 0,
    );

    test('calculation milestones unlock at thresholds', () {
      expect(
          achievementById('first_calculation')!
              .predicate(base.copyOf(bmiCount: 1)),
          isTrue);
      expect(
          achievementById('ten_calculations')!
              .predicate(base.copyOf(bmiCount: 9)),
          isFalse);
      expect(
          achievementById('ten_calculations')!
              .predicate(base.copyOf(bmiCount: 10)),
          isTrue);
      expect(
          achievementById('fifty_calculations')!
              .predicate(base.copyOf(bmiCount: 50)),
          isTrue);
      expect(
          achievementById('hundred_calculations')!
              .predicate(base.copyOf(bmiCount: 100)),
          isTrue);
    });

    test('healthy metrics unlock', () {
      expect(
          achievementById('healthy_bmi')!
              .predicate(base.copyOf(hasHealthyBmi: true)),
          isTrue);
      expect(
          achievementById('healthy_bp')!
              .predicate(base.copyOf(hasHealthyBp: true)),
          isTrue);
      expect(
          achievementById('healthy_glucose')!
              .predicate(base.copyOf(hasHealthyGlucose: true)),
          isTrue);
      expect(
        achievementById('all_metrics_healthy')!.predicate(base.copyOf(
          hasHealthyBmi: true,
          hasHealthyBp: true,
          hasHealthyGlucose: true,
        )),
        isTrue,
      );
      expect(
          achievementById('all_metrics_healthy')!
              .predicate(base.copyOf(hasHealthyBmi: true)),
          isFalse);
    });

    test('volume thresholds unlock', () {
      expect(achievementById('first_bp')!.predicate(base.copyOf(bpCount: 1)),
          isTrue);
      expect(achievementById('ten_bp')!.predicate(base.copyOf(bpCount: 10)),
          isTrue);
      expect(
          achievementById('ten_glucose')!
              .predicate(base.copyOf(glucoseCount: 10)),
          isTrue);
    });

    test('streak thresholds unlock', () {
      expect(
          achievementById('three_day_streak')!
              .predicate(base.copyOf(currentStreak: 3)),
          isTrue);
      expect(
          achievementById('seven_day_streak')!
              .predicate(base.copyOf(currentStreak: 7)),
          isTrue);
      expect(
          achievementById('fourteen_day_streak')!
              .predicate(base.copyOf(currentStreak: 14)),
          isTrue);
      expect(
          achievementById('thirty_day_streak')!
              .predicate(base.copyOf(currentStreak: 30)),
          isTrue);
      expect(
          achievementById('thirty_day_streak')!
              .predicate(base.copyOf(currentStreak: 29)),
          isFalse);
      expect(
          achievementById('perfect_week')!
              .predicate(base.copyOf(bestStreak: 7)),
          isTrue);
      expect(
          achievementById('on_a_roll')!
              .predicate(base.copyOf(maxRecordsInDay: 5)),
          isTrue);
    });

    test('lifestyle thresholds unlock', () {
      expect(
          achievementById('early_bird')!
              .predicate(base.copyOf(hasMorningRecord: true)),
          isTrue);
      expect(
          achievementById('night_owl')!
              .predicate(base.copyOf(hasEveningRecord: true)),
          isTrue);
      expect(
        achievementById('all_tracker_types')!.predicate(base.copyOf(
          bmiCount: 1,
          bpCount: 1,
          glucoseCount: 1,
        )),
        isTrue,
      );
      expect(
          achievementById('dashboard_excellent')!
              .predicate(base.copyOf(healthScore: 92)),
          isTrue);
      expect(
          achievementById('dashboard_excellent')!
              .predicate(base.copyOf(healthScore: 89)),
          isFalse);
    });
  });

  group('unlockedBy / points', () {
    final fresh = GamificationService.progressFrom(
      bmiRecords: [bmi(value: 22.0)],
    );

    test('newlyUnlocked does not repeat already-unlocked ids', () {
      final first = GamificationService.newlyUnlocked(fresh, {});
      expect(first.map((a) => a.id), contains('first_calculation'));
      final second =
          GamificationService.newlyUnlocked(fresh, {'first_calculation'});
      expect(second.map((a) => a.id), isNot(contains('first_calculation')));
    });

    test('pointsFor sums definition points', () {
      final all = GamificationService.progressFrom(
        bmiRecords: [bmi(value: 22.0)],
        bpRecords: [bp()],
        glucoseRecords: [glucose()],
      );
      final unlocked =
          GamificationService.newlyUnlocked(all, {}).map((a) => a.id).toSet();
      expect(unlocked,
          containsAll(['first_calculation', 'first_bp', 'first_glucose']));
      final expected = unlocked
          .map((id) => achievementById(id)!.points)
          .fold(0, (a, b) => a + b);
      expect(GamificationService.achievementPoints(unlocked), expected);
    });
  });

  group('GamificationService.progressFrom', () {
    test('counts records and detects healthy readings', () {
      final p = GamificationService.progressFrom(
        bmiRecords: [
          bmi(value: 22.0),
          bmi(value: 30.0, at: DateTime(2026, 9, 8))
        ],
        bpRecords: [bp()],
        glucoseRecords: [glucose(level: 95)],
      );
      expect(p.bmiCount, 2);
      expect(p.bpCount, 1);
      expect(p.glucoseCount, 1);
      expect(p.hasHealthyBmi, isTrue);
      expect(p.hasHealthyBp, isTrue);
      expect(p.hasHealthyGlucose, isTrue);
    });

    test('flags morning and evening records', () {
      final p = GamificationService.progressFrom(
        bmiRecords: [bmi(value: 22.0, at: DateTime(2026, 9, 9, 7))],
      );
      expect(p.hasMorningRecord, isTrue);
      expect(p.hasEveningRecord, isFalse);
      final q = GamificationService.progressFrom(
        bmiRecords: [bmi(value: 22.0, at: DateTime(2026, 9, 9, 22))],
      );
      expect(q.hasEveningRecord, isTrue);
    });

    test('maxRecordsInDay tracks the busiest day', () {
      final p = GamificationService.progressFrom(
        bmiRecords: [
          bmi(value: 22.0, at: DateTime(2026, 9, 9, 8)),
          bmi(value: 22.1, at: DateTime(2026, 9, 9, 12)),
          bmi(value: 22.2, at: DateTime(2026, 9, 9, 18)),
          bmi(value: 23.0, at: DateTime(2026, 9, 10, 9)),
        ],
      );
      expect(p.maxRecordsInDay, 3);
    });

    test('passes through healthScore', () {
      final p = GamificationService.progressFrom(healthScore: 93);
      expect(p.healthScore, 93);
      expect(achievementById('dashboard_excellent')!.predicate(p), isTrue);
    });
  });

  group('daily challenge', () {
    test('rotates deterministically through the catalog', () {
      final a = GamificationService.challengeFor(DateTime(2026, 9, 9), 'u');
      final b = GamificationService.challengeFor(DateTime(2026, 9, 9), 'u');
      final c = GamificationService.challengeFor(DateTime(2026, 9, 10), 'u');
      expect(a.definitionId, b.definitionId);
      expect(a.dateKey, '2026-09-09');
      expect(c.definitionId, isNot(a.definitionId));
    });

    test('log_bmi challenge counts today\'s BMI records only', () {
      final challenge =
          GamificationService.challengeFor(DateTime(2026, 9, 9), 'u');
      if (challenge.definitionId != 'log_bmi') return;
      final progress = GamificationService.challengeProgress(
        challenge,
        [
          bmi(value: 22, at: DateTime(2026, 9, 9, 8)),
          bmi(value: 23, at: DateTime(2026, 9, 8, 8)),
        ],
        [],
        [],
        now: DateTime(2026, 9, 9),
      );
      expect(progress, 1);
      expect(
          GamificationService.isChallengeComplete(challenge, progress), isTrue);
    });

    test('log_bp challenge counts today\'s BP records only', () {
      final challenge =
          GamificationService.challengeFor(DateTime(2026, 9, 9), 'u');
      if (challenge.definitionId != 'log_bp') return;
      final progress = GamificationService.challengeProgress(
        challenge,
        [],
        [bp(at: DateTime(2026, 9, 9, 9))],
        [],
        now: DateTime(2026, 9, 9),
      );
      expect(progress, 1);
      expect(
          GamificationService.isChallengeComplete(challenge, progress), isTrue);
    });

    test('log_glucose challenge counts today\'s glucose records only', () {
      final challenge =
          GamificationService.challengeFor(DateTime(2026, 9, 9), 'u');
      if (challenge.definitionId != 'log_glucose') return;
      final progress = GamificationService.challengeProgress(
        challenge,
        [],
        [],
        [glucose(level: 95, at: DateTime(2026, 9, 9, 9))],
        now: DateTime(2026, 9, 9),
      );
      expect(progress, 1);
      expect(
          GamificationService.isChallengeComplete(challenge, progress), isTrue);
    });

    test('log_any_three counts any three logs today', () {
      final challenge =
          GamificationService.challengeFor(DateTime(2026, 9, 9), 'u');
      if (challenge.definitionId != 'log_any_three') return;
      final progress = GamificationService.challengeProgress(
        challenge,
        [bmi(value: 22, at: DateTime(2026, 9, 9, 8))],
        [bp(at: DateTime(2026, 9, 9, 9))],
        [glucose(level: 95, at: DateTime(2026, 9, 9, 10))],
        now: DateTime(2026, 9, 9),
      );
      expect(progress, 3);
      expect(
          GamificationService.isChallengeComplete(challenge, progress), isTrue);
    });

    test('log_healthy completes only on a normal-range reading today', () {
      final challenge =
          GamificationService.challengeFor(DateTime(2026, 9, 9), 'u');
      if (challenge.definitionId != 'log_healthy') return;
      final bad = GamificationService.challengeProgress(
        challenge,
        [bmi(value: 31, at: DateTime(2026, 9, 9, 8))],
        [],
        [],
        now: DateTime(2026, 9, 9),
      );
      expect(bad, 0);
      final good = GamificationService.challengeProgress(
        challenge,
        [],
        [bp(at: DateTime(2026, 9, 9, 9))],
        [],
        now: DateTime(2026, 9, 9),
      );
      expect(good, 1);
    });
  });

  group('DailyChallenge serialization', () {
    test('round-trips through toMap/fromMap', () {
      final c = GamificationService.challengeFor(DateTime(2026, 9, 9), 'u')
          .copyWith(
              progress: 1,
              completed: true,
              completedAt: DateTime(2026, 9, 9, 9));
      final back = DailyChallenge.fromMap(c.toMap());
      expect(back.definitionId, c.definitionId);
      expect(back.progress, 1);
      expect(back.completed, isTrue);
      expect(back.completedAt, isNotNull);
    });
  });

  group('UserStreak serialization', () {
    test('round-trips through toMap/fromMap', () {
      final s = const UserStreak(current: 4, best: 9);
      final back = UserStreak.fromMap(s.toMap());
      expect(back.current, 4);
      expect(back.best, 9);
    });
  });
}

extension on AchievementProgress {
  AchievementProgress copyOf({
    int? bmiCount,
    int? bpCount,
    int? glucoseCount,
    bool hasHealthyBmi = false,
    bool hasHealthyBp = false,
    bool hasHealthyGlucose = false,
    int? currentStreak,
    int? bestStreak,
    bool hasMorningRecord = false,
    bool hasEveningRecord = false,
    int? maxRecordsInDay,
    int? healthScore,
  }) =>
      AchievementProgress(
        bmiCount: bmiCount ?? this.bmiCount,
        bpCount: bpCount ?? this.bpCount,
        glucoseCount: glucoseCount ?? this.glucoseCount,
        hasHealthyBmi: hasHealthyBmi,
        hasHealthyBp: hasHealthyBp,
        hasHealthyGlucose: hasHealthyGlucose,
        currentStreak: currentStreak ?? this.currentStreak,
        bestStreak: bestStreak ?? this.bestStreak,
        hasMorningRecord: hasMorningRecord,
        hasEveningRecord: hasEveningRecord,
        maxRecordsInDay: maxRecordsInDay ?? this.maxRecordsInDay,
        healthScore: healthScore ?? this.healthScore,
      );
}
