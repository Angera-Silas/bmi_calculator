import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/app_database.dart';
import '../models/bmi_record.dart';
import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';
import 'connectivity_service.dart';

/// Handles bidirectional sync between local SQLite and Firestore.
///
/// Strategy: **offline-first**.
///   - All writes go to SQLite immediately.
///   - This service pushes pending local records to Firestore when online.
///   - On login / app foreground, it pulls new Firestore records.
///   - Guest records have no remote counterpart until the user registers/logs in,
///     at which point [migrateAndSync] reassigns them to the real UID.
class SyncService {
  static final _db = FirebaseFirestore.instance;
  static bool _isSyncing = false;

  // ── Public entry points ────────────────────────────────────────────────────

  /// Full bidirectional sync for [userId].
  /// Safe to call multiple times — subsequent calls while sync is in progress
  /// are silently dropped.
  static Future<void> sync(String userId) async {
    if (_isSyncing) return;
    if (!(await ConnectivityService.isOnline)) return;
    _isSyncing = true;
    try {
      await _pushDeleted(userId);
      await _pushPending(userId);
      await _pushDeletedBP(userId);
      await _pushPendingBP(userId);
      await _pushDeletedBloodSugar(userId);
      await _pushPendingBloodSugar(userId);
      await _pullNew(userId);
      await _pullNewBP(userId);
      await _pullNewBloodSugar(userId);
      await AppDatabase.updateLastSynced(userId);
    } catch (_) {
      // Sync failures are non-fatal — data is safe locally.
    } finally {
      _isSyncing = false;
    }
  }

  /// Called after a guest registers or logs in to an existing account.
  /// Re-assigns all 'guest' SQLite records to [userId] then syncs.
  static Future<void> migrateAndSync(String userId) async {
    await AppDatabase.migrateGuestRecords(userId);
    await sync(userId);
  }

  // ── Push ───────────────────────────────────────────────────────────────────

  /// Push soft-deleted local records to Firestore, then hard-delete locally.
  static Future<void> _pushDeleted(String userId) async {
    final db = await AppDatabase.database;
    final rows = await db.query(
      'bmi_records',
      where: 'user_id = ? AND is_deleted = 1',
      whereArgs: [userId],
    );

    for (final row in rows) {
      final remoteId = row['remote_id'] as String?;
      if (remoteId != null) {
        try {
          await _db.collection('history').doc(remoteId).delete();
        } on FirebaseException catch (_) {
          // If the doc doesn't exist on the server that's fine.
        }
      }
      await AppDatabase.hardDeleteRecord(row['id'] as String);
    }
  }

  /// Push unsynced local records to Firestore.
  static Future<void> _pushPending(String userId) async {
    final pending = await AppDatabase.fetchUnsynced(userId);

    for (final record in pending) {
      if (record.isDeleted) continue; // handled by _pushDeleted

      try {
        if (record.remoteId != null) {
          // Already exists on Firestore — update it.
          await _db.collection('history').doc(record.remoteId).set(
                record.toFirestoreMap(userId),
                SetOptions(merge: true),
              );
          await AppDatabase.markSynced(record.id, record.remoteId!);
        } else {
          // New record — create it and save the remote ID locally.
          final docRef = await _db
              .collection('history')
              .add(record.toFirestoreMap(userId));
          await AppDatabase.markSynced(record.id, docRef.id);
        }
      } on FirebaseException catch (_) {
        // Skip this record; will retry on next sync.
      }
    }
  }

  // ── Pull ───────────────────────────────────────────────────────────────────

  /// Pull records from Firestore that are newer than the last sync timestamp.
  static Future<void> _pullNew(String userId) async {
    final lastSyncedAt = await AppDatabase.getLastSyncedAt(userId);

    Query<Map<String, dynamic>> query =
        _db.collection('history').where('userId', isEqualTo: userId);

    if (lastSyncedAt != null) {
      query = query.where(
        'timestamp',
        isGreaterThan: lastSyncedAt,
      );
    }

    final snapshot = await query.get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final localId = data['localId'] as String? ?? doc.id;

      final record = BmiRecord(
        id: localId,
        userId: userId,
        height: (data['height'] as num).toInt(),
        weight: (data['weight'] as num).toInt(),
        age: (data['age'] as num).toInt(),
        isMale: data['isMale'] as bool? ?? true,
        bmiValue: double.tryParse(data['bmiResult']?.toString() ?? '') ?? 0.0,
        bmiResult: data['bmiResult'] as String? ?? '',
        resultText: data['resultText'] as String? ?? '',
        interpretation: data['interpretation'] as String? ?? '',
        timestamp: data['timestamp'] is int
            ? DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int)
            : (data['timestamp'] as Timestamp).toDate(),
        isSynced: true,
        remoteId: doc.id,
        waistCm: (data['waistCm'] as num?)?.toDouble(),
        neckCm: (data['neckCm'] as num?)?.toDouble(),
        hipCm: (data['hipCm'] as num?)?.toDouble(),
        restingHeartRate: data['restingHeartRate'] as int?,
      );

      await AppDatabase.upsertRecord(record);
    }
  }

  // ── Blood Pressure sync ────────────────────────────────────────────────────

  /// Push soft-deleted BP records to Firestore, then hard-delete locally.
  static Future<void> _pushDeletedBP(String userId) async {
    final db = await AppDatabase.database;
    final rows = await db.query(
      'blood_pressure_records',
      where: 'user_id = ? AND is_deleted = 1',
      whereArgs: [userId],
    );

    for (final row in rows) {
      final remoteId = row['remote_id'] as String?;
      if (remoteId != null) {
        try {
          await _db.collection('blood_pressure').doc(remoteId).delete();
        } on FirebaseException catch (_) {
          // If the doc doesn't exist on the server that's fine.
        }
      }
      await AppDatabase.hardDeleteBPRecord(row['id'] as String);
    }
  }

  /// Push unsynced local BP records to Firestore.
  static Future<void> _pushPendingBP(String userId) async {
    final pending = await AppDatabase.fetchUnsyncedBP(userId);

    for (final record in pending) {
      if (record.isDeleted) continue; // handled by _pushDeletedBP

      try {
        if (record.remoteId != null) {
          await _db.collection('blood_pressure').doc(record.remoteId).set(
                record.toFirestoreMap(userId),
                SetOptions(merge: true),
              );
          await AppDatabase.markBPSynced(record.id, record.remoteId!);
        } else {
          final docRef = await _db
              .collection('blood_pressure')
              .add(record.toFirestoreMap(userId));
          await AppDatabase.markBPSynced(record.id, docRef.id);
        }
      } on FirebaseException catch (_) {
        // Skip this record; will retry on next sync.
      }
    }
  }

  /// Pull BP records from Firestore newer than the last sync timestamp.
  static Future<void> _pullNewBP(String userId) async {
    final lastSyncedAt = await AppDatabase.getLastSyncedAt(userId);

    Query<Map<String, dynamic>> query =
        _db.collection('blood_pressure').where('userId', isEqualTo: userId);

    if (lastSyncedAt != null) {
      query = query.where('measurementTime', isGreaterThan: lastSyncedAt);
    }

    final snapshot = await query.get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final localId = data['localId'] as String? ?? doc.id;

      final record = BloodPressureRecord(
        id: localId,
        userId: userId,
        systolic: (data['systolic'] as num).toInt(),
        diastolic: (data['diastolic'] as num).toInt(),
        pulse: (data['pulse'] as num?)?.toInt(),
        measurementTime: data['measurementTime'] is int
            ? DateTime.fromMillisecondsSinceEpoch(
                data['measurementTime'] as int)
            : (data['measurementTime'] as Timestamp).toDate(),
        notes: data['notes'] as String?,
        isSynced: true,
        remoteId: doc.id,
      );

      await AppDatabase.upsertBPRecord(record);
    }
  }

  /// Pulls ALL BP records for [userId] from Firestore into the local DB.
  /// Should be called once immediately after login on a new device.
  static Future<void> fullPullBP(String userId) async {
    if (!(await ConnectivityService.isOnline)) return;

    try {
      final snapshot = await _db
          .collection('blood_pressure')
          .where('userId', isEqualTo: userId)
          .orderBy('measurementTime', descending: false)
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final localId = data['localId'] as String? ?? doc.id;

        final record = BloodPressureRecord(
          id: localId,
          userId: userId,
          systolic: (data['systolic'] as num).toInt(),
          diastolic: (data['diastolic'] as num).toInt(),
          pulse: (data['pulse'] as num?)?.toInt(),
          measurementTime: data['measurementTime'] is int
              ? DateTime.fromMillisecondsSinceEpoch(
                  data['measurementTime'] as int)
              : (data['measurementTime'] as Timestamp).toDate(),
          notes: data['notes'] as String?,
          isSynced: true,
          remoteId: doc.id,
        );

        await AppDatabase.upsertBPRecord(record);
      }
    } catch (_) {
      // Non-fatal — user can still use local data.
    }
  }

  // ── Blood Sugar sync ──────────────────────────────────────────────────────

  /// Push soft-deleted glucose records to Firestore, then hard-delete locally.
  static Future<void> _pushDeletedBloodSugar(String userId) async {
    final db = await AppDatabase.database;
    final rows = await db.query(
      'blood_sugar_records',
      where: 'user_id = ? AND is_deleted = 1',
      whereArgs: [userId],
    );

    for (final row in rows) {
      final remoteId = row['remote_id'] as String?;
      if (remoteId != null) {
        try {
          await _db.collection('blood_sugar').doc(remoteId).delete();
        } on FirebaseException catch (_) {
          // If the doc doesn't exist on the server that's fine.
        }
      }
      await AppDatabase.hardDeleteBloodSugarRecord(row['id'] as String);
    }
  }

  /// Push unsynced local glucose records to Firestore.
  static Future<void> _pushPendingBloodSugar(String userId) async {
    final pending = await AppDatabase.fetchUnsyncedBloodSugar(userId);

    for (final record in pending) {
      if (record.isDeleted) continue; // handled by _pushDeletedBloodSugar

      try {
        if (record.remoteId != null) {
          await _db.collection('blood_sugar').doc(record.remoteId).set(
                record.toFirestoreMap(userId),
                SetOptions(merge: true),
              );
          await AppDatabase.markBloodSugarSynced(record.id, record.remoteId!);
        } else {
          final docRef = await _db
              .collection('blood_sugar')
              .add(record.toFirestoreMap(userId));
          await AppDatabase.markBloodSugarSynced(record.id, docRef.id);
        }
      } on FirebaseException catch (_) {
        // Skip this record; will retry on next sync.
      }
    }
  }

  /// Pull glucose records from Firestore newer than the last sync timestamp.
  static Future<void> _pullNewBloodSugar(String userId) async {
    final lastSyncedAt = await AppDatabase.getLastSyncedAt(userId);

    Query<Map<String, dynamic>> query =
        _db.collection('blood_sugar').where('userId', isEqualTo: userId);

    if (lastSyncedAt != null) {
      query = query.where('measurementTime', isGreaterThan: lastSyncedAt);
    }

    final snapshot = await query.get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final localId = data['localId'] as String? ?? doc.id;

      final record = BloodSugarRecord(
        id: localId,
        userId: userId,
        glucoseLevel: (data['glucoseLevel'] as num).toInt(),
        measurementType: GlucoseMeasurementType.fromStorage(
            data['measurementType'] as String?),
        mealContext: data['mealContext'] as String?,
        measurementTime: data['measurementTime'] is int
            ? DateTime.fromMillisecondsSinceEpoch(
                data['measurementTime'] as int)
            : (data['measurementTime'] as Timestamp).toDate(),
        notes: data['notes'] as String?,
        isSynced: true,
        remoteId: doc.id,
      );

      await AppDatabase.upsertBloodSugarRecord(record);
    }
  }

  /// Pulls ALL glucose records for [userId] from Firestore into the local DB.
  /// Should be called once immediately after login on a new device.
  static Future<void> fullPullBloodSugar(String userId) async {
    if (!(await ConnectivityService.isOnline)) return;

    try {
      final snapshot = await _db
          .collection('blood_sugar')
          .where('userId', isEqualTo: userId)
          .orderBy('measurementTime', descending: false)
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final localId = data['localId'] as String? ?? doc.id;

        final record = BloodSugarRecord(
          id: localId,
          userId: userId,
          glucoseLevel: (data['glucoseLevel'] as num).toInt(),
          measurementType: GlucoseMeasurementType.fromStorage(
              data['measurementType'] as String?),
          mealContext: data['mealContext'] as String?,
          measurementTime: data['measurementTime'] is int
              ? DateTime.fromMillisecondsSinceEpoch(
                  data['measurementTime'] as int)
              : (data['measurementTime'] as Timestamp).toDate(),
          notes: data['notes'] as String?,
          isSynced: true,
          remoteId: doc.id,
        );

        await AppDatabase.upsertBloodSugarRecord(record);
      }
    } catch (_) {
      // Non-fatal — user can still use local data.
    }
  }

  // ── Initial full pull on login ─────────────────────────────────────────────

  /// Pulls ALL records for [userId] from Firestore into the local DB.
  /// Should be called once immediately after login on a new device.
  static Future<void> fullPull(String userId) async {
    if (!(await ConnectivityService.isOnline)) return;

    try {
      final snapshot = await _db
          .collection('history')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final localId = data['localId'] as String? ?? doc.id;

        final record = BmiRecord(
          id: localId,
          userId: userId,
          height: (data['height'] as num).toInt(),
          weight: (data['weight'] as num).toInt(),
          age: (data['age'] as num).toInt(),
          isMale: data['isMale'] as bool? ?? true,
          bmiValue: double.tryParse(data['bmiResult']?.toString() ?? '') ?? 0.0,
          bmiResult: data['bmiResult'] as String? ?? '',
          resultText: data['resultText'] as String? ?? '',
          interpretation: data['interpretation'] as String? ?? '',
          timestamp: data['timestamp'] is int
              ? DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int)
              : (data['timestamp'] as Timestamp).toDate(),
          isSynced: true,
          remoteId: doc.id,
          waistCm: (data['waistCm'] as num?)?.toDouble(),
          neckCm: (data['neckCm'] as num?)?.toDouble(),
          hipCm: (data['hipCm'] as num?)?.toDouble(),
          restingHeartRate: data['restingHeartRate'] as int?,
        );

        await AppDatabase.upsertRecord(record);
      }

      await fullPullBP(userId);
      await fullPullBloodSugar(userId);

      await AppDatabase.updateLastSynced(userId);
    } catch (_) {
      // Non-fatal — user can still use local data.
    }
  }
}
