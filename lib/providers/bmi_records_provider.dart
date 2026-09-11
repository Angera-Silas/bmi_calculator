import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/bmi_record.dart';
import '../services/connectivity_service.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';
import 'session_provider.dart';
import 'gamification_provider.dart';

/// Loads and mutates the current user's BMI history.
///
/// Rebuilds automatically when the session changes (e.g. guest → registered
/// migration), and keeps the list in sync with the SQLite source of truth.
class BmiRecordsNotifier extends AsyncNotifier<List<BmiRecord>> {
  @override
  Future<List<BmiRecord>> build() async {
    final session = ref.watch(sessionProvider);
    final userId = session.userId;
    if (userId == null) return const [];
    return AppDatabase.fetchRecords(userId);
  }

  /// The current user id, re-read from the session each time.
  String? _userId() => ref.read(sessionProvider).userId;

  Future<List<BmiRecord>> _fetch() async {
    final userId = _userId();
    if (userId == null) return const [];
    return AppDatabase.fetchRecords(userId);
  }

  /// Re-loads the record list from SQLite.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Persists a new calculation and refreshes the list.
  Future<void> addRecord(BmiRecord record) async {
    await AppDatabase.insertRecord(record);

    // Best-effort background sync for registered users.
    final userId = _userId();
    if (userId != null && userId != SessionService.guestId) {
      final online = await ConnectivityService.isOnline;
      if (online) {
        SyncService.sync(userId); // fire-and-forget
      }
    }

    // Recompute achievements / streak / daily challenge.
    await ref.read(gamificationProvider.notifier).recordActivity();

    await refresh();
  }

  /// Soft-deletes a record locally (propagated to Firestore on next sync).
  Future<void> softDelete(String id) async {
    await AppDatabase.softDeleteRecord(id);
    await refresh();
  }
}

final bmiRecordsProvider =
    AsyncNotifierProvider<BmiRecordsNotifier, List<BmiRecord>>(
        BmiRecordsNotifier.new);
