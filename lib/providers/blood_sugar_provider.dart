import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/blood_sugar_record.dart';
import '../services/connectivity_service.dart';
import '../services/session_service.dart';
import '../services/sync_service.dart';
import 'session_provider.dart';
import 'gamification_provider.dart';

/// Loads and mutates the current user's blood sugar history.
class BloodSugarNotifier extends AsyncNotifier<List<BloodSugarRecord>> {
  @override
  Future<List<BloodSugarRecord>> build() async {
    final session = ref.watch(sessionProvider);
    final userId = session.userId;
    if (userId == null) return const [];
    return AppDatabase.fetchBloodSugarRecords(userId);
  }

  /// The current user id, re-read from the session each time.
  String? _userId() => ref.read(sessionProvider).userId;

  Future<List<BloodSugarRecord>> _fetch() async {
    final userId = _userId();
    if (userId == null) return const [];
    return AppDatabase.fetchBloodSugarRecords(userId);
  }

  /// Re-loads the glucose list from SQLite.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Persists a new reading and refreshes the list.
  Future<void> addRecord(BloodSugarRecord record) async {
    await AppDatabase.insertBloodSugarRecord(record);

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
    await AppDatabase.softDeleteBloodSugarRecord(id);
    await refresh();
  }
}

final bloodSugarProvider =
    AsyncNotifierProvider<BloodSugarNotifier, List<BloodSugarRecord>>(
        BloodSugarNotifier.new);
