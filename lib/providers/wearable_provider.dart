import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/wearable_metric.dart';
import '../providers/gamification_provider.dart';
import '../providers/session_provider.dart';
import '../providers/blood_pressure_provider.dart';
import '../providers/blood_sugar_provider.dart';
import '../services/connectivity_service.dart';
import '../services/health_data_service.dart';
import '../services/sync_service.dart';
import '../services/wearable_import_service.dart';

/// Connection + snapshot state for the wearable/health platform
/// (Health Connect on Android, HealthKit on iOS).
class WearableState {
  final bool configured;
  final bool permissionGranted;
  final WearableSnapshot? snapshot;
  final String? error;
  final int lastImportedRecords;
  final int lastRejectionCount;
  final DateTime? lastImportTime;

  const WearableState({
    this.configured = false,
    this.permissionGranted = false,
    this.snapshot,
    this.error,
    this.lastImportedRecords = 0,
    this.lastRejectionCount = 0,
    this.lastImportTime,
  });

  WearableState copyWith({
    bool? configured,
    bool? permissionGranted,
    WearableSnapshot? snapshot,
    bool clearSnapshot = false,
    String? error,
    int? lastImportedRecords,
    int? lastRejectionCount,
    DateTime? lastImportTime,
  }) {
    return WearableState(
      configured: configured ?? this.configured,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      snapshot: clearSnapshot ? null : snapshot ?? this.snapshot,
      error: error ?? this.error,
      lastImportedRecords: lastImportedRecords ?? this.lastImportedRecords,
      lastRejectionCount: lastRejectionCount ?? this.lastRejectionCount,
      lastImportTime: lastImportTime ?? this.lastImportTime,
    );
  }
}

/// Manages health-data authorization and the most recent snapshot.
///
/// [HealthDataSource] is injectable so tests can use a fake instead of the
/// platform channels.
class WearableNotifier extends AsyncNotifier<WearableState> {
  WearableNotifier({HealthDataSource? dataSource}) : _dataSource = dataSource;

  final HealthDataSource? _dataSource;

  // Resolve default lazily so the constructor stays test-friendly.
  HealthDataSource get dataSource => _dataSource ?? HealthDataService();

  @override
  Future<WearableState> build() async {
    try {
      await dataSource.configure();
      final granted = await dataSource.hasPermissions();
      if (granted != true) {
        return WearableState(configured: true, permissionGranted: false);
      }
      return await snapshotState();
    } catch (e) {
      return WearableState(configured: false, error: '$e');
    }
  }

  /// Request read authorization from the platform, then refresh.
  Future<void> requestAccess() async {
    try {
      final granted = await dataSource.requestAuthorization();
      state = AsyncData(
        state.value?.copyWith(permissionGranted: granted) ??
            WearableState(configured: true, permissionGranted: granted),
      );
      if (granted) {
        await refresh();
      }
    } catch (e) {
      state = AsyncData(
        WearableState(
          configured: true,
          permissionGranted: false,
          error: '$e',
        ),
      );
    }
  }

  /// Fetch the latest health snapshot for the last 24 hours.
  Future<void> refresh() async {
    try {
      final snap = await _fetchLastDay();
      state = AsyncData(
        state.value?.copyWith(snapshot: snap, error: null) ??
            WearableState(
              configured: true,
              permissionGranted: true,
              snapshot: snap,
            ),
      );
    } catch (e) {
      state = AsyncData(
        state.value?.copyWith(error: '$e') ??
            WearableState(configured: true, error: '$e'),
      );
    }
  }

  /// Revoke granted health permissions and reset to the disconnected state.
  Future<void> revoke() async {
    try {
      await dataSource.revokePermissions();
    } catch (_) {}
    state = AsyncData(const WearableState(configured: true));
  }

  /// Import the current snapshot's BP and glucose readings into the app's
  /// history (deduplicated against existing records), then refresh the
  /// dependent providers and gamification.
  ///
  /// Returns the number of newly inserted records.
  Future<int> importRecords() async {
    final userId = ref.read(sessionProvider).userId;
    final snapshot = state.value?.snapshot;
    if (userId == null || snapshot == null) return 0;

    final existingBp = await AppDatabase.fetchBPRecords(userId);
    final existingGlucose = await AppDatabase.fetchBloodSugarRecords(userId);

    final result = WearableImportService.buildImport(
      snapshot: snapshot,
      userId: userId,
      existingBp: existingBp,
      existingGlucose: existingGlucose,
    );

    for (final record in result.bpRecords) {
      await AppDatabase.insertBPRecord(record);
    }
    for (final record in result.glucoseRecords) {
      await AppDatabase.insertBloodSugarRecord(record);
    }

    if (result.newRecordCount > 0) {
      await ref.read(gamificationProvider.notifier).recordActivity();
    }

    await ref.read(bloodPressureProvider.notifier).refresh();
    await ref.read(bloodSugarProvider.notifier).refresh();

    state = AsyncData(
      state.value?.copyWith(
            lastImportedRecords: result.newRecordCount,
            lastRejectionCount: result.rejections.length,
            lastImportTime: DateTime.now(),
          ) ??
          const WearableState(),
    );

    // Push new records to Firestore if online.
    final isOnline = await ConnectivityService.isOnline;
    if (isOnline) {
      SyncService.sync(userId);
    }

    return result.newRecordCount;
  }

  /// Auto-fill values for the Calculate form (null when unavailable).
  double? get autoFillHeightCm {
    final meters = state.value?.snapshot?.latestHeightM;
    return meters == null ? null : meters * 100;
  }

  double? get autoFillWeightKg => state.value?.snapshot?.latestWeightKg;

  Future<WearableState> snapshotState() async {
    final snap = await _fetchLastDay();
    return WearableState(
      configured: true,
      permissionGranted: true,
      snapshot: snap,
    );
  }

  Future<WearableSnapshot> _fetchLastDay() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 1));
    final points = await dataSource.getHealthDataFromTypes(
      startTime: start,
      endTime: now,
    );
    return HealthDataMapper.toSnapshot(points: points, from: start, to: now);
  }

  /// Reset to a disconnected state (permissions stay revoked only if the
  /// platform supports it; we reflect the re-check instead).
  Future<void> clearError() async {
    state =
        AsyncData(state.value?.copyWith(error: null) ?? const WearableState());
  }
}

final wearableProvider = AsyncNotifierProvider<WearableNotifier, WearableState>(
    WearableNotifier.new);
