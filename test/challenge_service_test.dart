import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/blood_pressure_record.dart';
import 'package:bmi_calculator/models/blood_sugar_record.dart';
import 'package:bmi_calculator/models/bmi_record.dart';
import 'package:bmi_calculator/models/daily_challenge.dart';
import 'package:bmi_calculator/services/challenge_service.dart';
import 'package:bmi_calculator/services/gamification_service.dart';

BmiRecord bmi({double value = 22.0, DateTime? at}) => BmiRecord(
      id: 'b-${value.toInt()}',
      userId: 'u',
      height: 175,
      weight: 75,
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
      id: 'bp-$sys-$dia',
      userId: 'u',
      systolic: sys,
      diastolic: dia,
      measurementTime: at ?? DateTime(2026, 9, 9, 10),
    );

BloodSugarRecord glucose({int level = 95, DateTime? at}) => BloodSugarRecord(
      id: 'g-$level',
      userId: 'u',
      glucoseLevel: level,
      measurementTime: at ?? DateTime(2026, 9, 9, 10),
    );

void main() {
  group('ChallengeService.generate', () {
    test('is deterministic for the same user and date', () {
      final a = ChallengeService.generate(DateTime(2026, 9, 9), 'u');
      final b = ChallengeService.generate(DateTime(2026, 9, 9), 'u');
      expect(a.definitionId, b.definitionId);
      expect(a.titleKey, b.titleKey);
      expect(a.target, b.target);
      expect(a.points, b.points);
    });

    test('rotates through catalog for variety across days', () {
      final ids = <String>{};
      for (var day = 1; day <= 11; day++) {
        ids.add(ChallengeService.generate(DateTime(2026, 9, day), 'u')
            .definitionId);
      }
      expect(ids.length, greaterThanOrEqualTo(3),
          reason: 'varied challenges across days');
    });

    test('easy tier matches the base catalog definition', () {
      final easy = ChallengeService.generate(DateTime(2026, 9, 9), 'u');
      final base = GamificationService.challengeFor(DateTime(2026, 9, 9), 'u');
      expect(easy.definitionId, base.definitionId);
      expect(easy.target, base.target);
      expect(easy.points, base.points);
    });

    test('harder tiers raise target and points', () {
      final easy = ChallengeService.generate(DateTime(2026, 9, 9), 'u');
      final medium = ChallengeService.generate(DateTime(2026, 9, 9), 'u',
          tier: ChallengeTier.medium);
      final hard = ChallengeService.generate(DateTime(2026, 9, 9), 'u',
          tier: ChallengeTier.hard);
      expect(medium.target, greaterThan(easy.target));
      expect(hard.target, greaterThan(medium.target));
      expect(medium.points, greaterThan(easy.points));
      expect(hard.points, greaterThan(medium.points));
    });

    test('points scale to clean multiples of 5', () {
      for (final tier in ChallengeTier.values) {
        final c =
            ChallengeService.generate(DateTime(2026, 9, 12), 'u', tier: tier);
        expect(c.points % 5, 0, reason: 'points ${c.points} for $tier');
      }
    });
  });

  group('ChallengeService.tierFor', () {
    test('engagement boundaries map to tiers', () {
      expect(ChallengeService.tierFor(streak: 0, totalLogs: 0),
          ChallengeTier.easy);
      expect(ChallengeService.tierFor(streak: 2, totalLogs: 19),
          ChallengeTier.easy);
      expect(ChallengeService.tierFor(streak: 3, totalLogs: 0),
          ChallengeTier.medium);
      expect(ChallengeService.tierFor(streak: 0, totalLogs: 20),
          ChallengeTier.medium);
      expect(ChallengeService.tierFor(streak: 14, totalLogs: 0),
          ChallengeTier.hard);
      expect(ChallengeService.tierFor(streak: 0, totalLogs: 100),
          ChallengeTier.hard);
    });
  });

  group('ChallengeService.tierOf', () {
    test('round-trips a generated challenge back to its tier', () {
      for (final tier in ChallengeTier.values) {
        final c =
            ChallengeService.generate(DateTime(2026, 9, 9), 'u', tier: tier);
        expect(ChallengeService.tierOf(c), tier);
      }
    });
  });

  group('ChallengeService.progressFor / completeIfDone', () {
    final easy = ChallengeService.generate(DateTime(2026, 9, 9), 'u',
        tier: ChallengeTier.easy);
    final medium = ChallengeService.generate(DateTime(2026, 9, 9), 'u',
        tier: ChallengeTier.medium);

    test('measures today-only progress per definition', () {
      final yesterday = DateTime(2026, 9, 8, 10);
      final today = DateTime(2026, 9, 9, 10);

      if (easy.definitionId == 'log_bmi') {
        final p = ChallengeService.progressFor(
            easy,
            [
              bmi(at: today),
              bmi(value: 23, at: yesterday), // outside today, must not count
            ],
            [],
            [],
            now: today);
        expect(p, 1);
      }

      if (easy.definitionId == 'log_any_three') {
        final p = ChallengeService.progressFor(
            easy, [bmi(at: today)], [bp(at: today)], [glucose(at: today)],
            now: today);
        expect(p, 3);
      }
    });

    test('completeIfDone marks complete only at target', () {
      final fixed = DateTime(2026, 9, 9, 12);
      final done = ChallengeService.completeIfDone(medium, 2, now: fixed);
      if (medium.target <= 2) {
        expect(done.completed, isTrue);
        expect(done.completedAt, fixed);
        expect(done.progress, 2);
        expect(ChallengeService.isComplete(medium, 2), isTrue);
      } else {
        expect(done.completed, isFalse);
        expect(done.progress, 2);
      }
    });

    test('completeIfDone leaves an open challenge unchanged', () {
      final c = ChallengeService.completeIfDone(easy, 0);
      expect(c.completed, isFalse);
      expect(c.progress, 0);
      expect(ChallengeService.isComplete(easy, 0), isFalse);
    });
  });

  group('ChallengeService.reminderPayload', () {
    test('exports a notification data contract', () {
      final c = ChallengeService.generate(DateTime(2026, 9, 9), 'u');
      final payload = ChallengeService.reminderPayload(c);
      expect(payload, isNotNull);
      expect(payload!['type'], 'daily_challenge');
      expect(payload['challengeId'], c.definitionId);
      expect(payload['dateKey'], c.dateKey);
    });
  });

  group('DailyChallenge catalog integrity', () {
    test('every catalog id resolves to a definition', () {
      for (final def in challengeCatalog) {
        expect(def.points, greaterThan(0), reason: def.id);
        expect(def.target, greaterThan(0), reason: def.id);
      }
    });
  });
}
