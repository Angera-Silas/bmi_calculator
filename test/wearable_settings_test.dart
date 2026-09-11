import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';

import 'package:bmi_calculator/generated/l10n/app_localizations.dart';
import 'package:bmi_calculator/models/wearable_metric.dart';
import 'package:bmi_calculator/providers/wearable_provider.dart';
import 'package:bmi_calculator/screens/wearable_settings.dart';
import 'package:bmi_calculator/services/health_data_service.dart';

class _FakeWearable extends WearableNotifier {
  _FakeWearable(this._initialState, {this.data});
  final WearableState _initialState;
  final HealthDataSource? data;

  bool requested = false;
  bool revoked = false;

  @override
  Future<WearableState> build() async => _initialState;

  @override
  Future<void> requestAccess() async {
    requested = true;
    state = AsyncData(state.value?.copyWith(permissionGranted: true) ??
        const WearableState(configured: true, permissionGranted: true));
    if (data != null) {
      await refresh();
    }
  }

  @override
  Future<void> revoke() async {
    revoked = true;
    state = AsyncData(const WearableState(configured: true));
  }
}

class _EmptyDataSource implements HealthDataSource {
  @override
  Future<void> configure() async {}

  @override
  Future<List<HealthDataPoint>> getHealthDataFromTypes({
    required DateTime startTime,
    required DateTime endTime,
    List<RecordingMethod> recordingMethodsToFilter = const [],
  }) async =>
      [];

  @override
  Future<bool?> hasPermissions() async => true;

  @override
  Future<bool> requestAuthorization() async => true;

  @override
  Future<void> revokePermissions() async {}
}

Widget _wrap(WearableNotifier notifier) => ProviderScope(
      overrides: [
        wearableProvider.overrideWith(() => notifier),
      ],
      child: const MaterialApp(
        home: WearableSettingsScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

void main() {
  testWidgets('shows connect prompt when no permission granted',
      (tester) async {
    final fake = _FakeWearable(const WearableState(configured: true));
    await tester.pumpWidget(_wrap(fake));
    await tester.pumpAndSettle();

    expect(find.text('Connect health data'), findsOneWidget);
    expect(find.text('Grant Access'), findsOneWidget);
    expect(find.text('Permissions'), findsOneWidget);
  });

  testWidgets('granting access calls the notifier and shows metrics',
      (tester) async {
    final fake = _FakeWearable(
      const WearableState(configured: true),
      data: _EmptyDataSource(),
    );
    await tester.pumpWidget(_wrap(fake));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Grant Access'));
    await tester.pumpAndSettle();

    expect(fake.requested, isTrue);
    expect(find.text('Connected'), findsOneWidget);
    // Empty data source → dry-run empty message when refreshed.
    expect(find.text('No measurements found in the last 24 hours.'),
        findsOneWidget);
  });

  testWidgets('connected state shows measurements', (tester) async {
    final snap = WearableSnapshot(
      from: DateTime.utc(2026, 9, 9, 0, 0),
      to: DateTime.utc(2026, 9, 10, 0, 0),
      samples: [
        WearableSample(
          metric: WearableMetric.steps,
          value: 8420,
          unit: 'count',
          startTime: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
          endTime: DateTime.fromMillisecondsSinceEpoch(1000, isUtc: true),
          isAggregated: true,
        ),
        WearableSample(
          metric: WearableMetric.weight,
          value: 69.5,
          unit: 'kg',
          startTime: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
          endTime: DateTime.fromMillisecondsSinceEpoch(1000, isUtc: true),
        ),
      ],
    );
    final fake = _FakeWearable(
      WearableState(
        configured: true,
        permissionGranted: true,
        snapshot: snap,
      ),
    );
    await tester.pumpWidget(_wrap(fake));
    await tester.pumpAndSettle();

    expect(find.text('Connected'), findsOneWidget);
    expect(find.text('8420'), findsOneWidget);
    expect(find.text('69.5 kg'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Disconnect'), 200);
    expect(find.text('Disconnect'), findsOneWidget);
  });
}
