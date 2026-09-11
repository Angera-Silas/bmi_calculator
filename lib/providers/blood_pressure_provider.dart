import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/blood_pressure_record.dart';
import '../services/connectivity_service.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';
import 'session_provider.dart';
import 'gamification_provider.dart';

/// Loads and mutates the current user's blood pressure history.
///
/// Tracks the session so the list rebuilds automatically on guest →
/// registered migration, mirroring [BmiRecordsNotifier].
class BloodPressureNotifier extends AsyncNotifier<List<BloodPressureRecord>> {
  @override
  Future<List<BloodPressureRecord>> build() async {
    final session = ref.watch(sessionProvider);
    final userId = session.userId;
    if (userId == null) return const [];
    return AppDatabase.fetchBPRecords(userId);
  }

  /// The current user id, re-read from the session each time.
  String? _userId() => ref.read(sessionProvider).userId;

  Future<List<BloodPressureRecord>> _fetch() async {
    final userId = _userId();
    if (userId == null) return const [];
    return AppDatabase.fetchBPRecords(userId);
  }

  /// Re-loads the BP list from SQLite.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Persists a new reading and refreshes the list.
  Future<void> addRecord(BloodPressureRecord record) async {
    await AppDatabase.insertBPRecord(record);

    final userId = _userId();
    if (userId != null && userId != SessionService.guestId) {
      final online = await ConnectivityService.isOnline;
      if (online) {
        SyncService.sync(userId); // fire-and-forget
      }
    }

    await ref.read(gamificationProvider.notifier).recordActivity();

    await refresh();
  }

  /// Soft-deletes a reading locally (propagated to Firestore on next sync).
  Future<void> softDelete(String id) async {
    await AppDatabase.softDeleteBPRecord(id);
    await refresh();
  }
}

final bloodPressureProvider =
    AsyncNotifierProvider<BloodPressureNotifier, List<BloodPressureRecord>>(
        BloodPressureNotifier.new);
