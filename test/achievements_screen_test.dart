import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bmi_calculator/generated/l10n/app_localizations.dart';
import 'package:bmi_calculator/models/achievement.dart';
import 'package:bmi_calculator/models/user_streak.dart';
import 'package:bmi_calculator/providers/gamification_provider.dart';
import 'package:bmi_calculator/screens/achievements_screen.dart';

class _FakeGamification extends GamificationNotifier {
  _FakeGamification(this._fakeState);

  final GamificationState _fakeState;

  @override
  Future<GamificationState> build() async => _fakeState;
}

Widget _wrap(GamificationState state) => ProviderScope(
      overrides: [
        gamificationProvider.overrideWith(() => _FakeGamification(state)),
      ],
      child: const MaterialApp(
        home: AchievementsScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

const _emptyState = GamificationState(
  unlockedAchievements: {},
  points: 0,
  streak: UserStreak.empty,
);

void main() {
  testWidgets('renders header, streak cards, and the full catalog',
      (tester) async {
    await tester.pumpWidget(_wrap(_emptyState));
    await tester.pumpAndSettle();

    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Total Points'), findsOneWidget);
    expect(find.text('Current Streak'), findsOneWidget);
    expect(find.text('Best Streak'), findsOneWidget);
    expect(find.text('0 of 22 unlocked'), findsOneWidget);

    // Sample tiles from across the catalog resolve to localized titles.
    expect(find.text('First Calculation'), findsOneWidget);
    expect(find.text('Peak Health'), findsOneWidget);

    // Everything locked initially → lock badges for all 22.
    expect(find.byIcon(Icons.lock_rounded),
        findsNWidgets(achievementCatalog.length));
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
  });

  testWidgets('unlocked achievements get a check and correct streak days',
      (tester) async {
    final unlocked = {'first_calculation', 'healthy_bmi', 'thirty_day_streak'};
    final state = GamificationState(
      unlockedAchievements: unlocked,
      points: pointsFor(unlocked),
      streak: const UserStreak(current: 30, best: 45),
    );
    await tester.pumpWidget(_wrap(state));
    await tester.pumpAndSettle();

    expect(find.text('30 days'), findsOneWidget);
    expect(find.text('45 days'), findsOneWidget);
    expect(find.text('3 of 22 unlocked'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(3));
    expect(find.byIcon(Icons.lock_rounded),
        findsNWidgets(achievementCatalog.length - unlocked.length));
  });
}
