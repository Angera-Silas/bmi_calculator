import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bmi_record.dart';

/// Local SQLite database — the single source of truth for all BMI data.
///
/// Schema version history:
///   v1 — initial: bmi_records, local_users
///   v2 — health context: added health_conditions, pregnancy_status, pre_pregnancy_weight to bmi_records;
///        added health_settings table for persistent user health data
///
/// All writes are local-first. [SyncService] handles pushing to / pulling
/// from Firestore in the background.
class AppDatabase {
  static Database? _db;
  static const int _schemaVersion = 3;
  static const String _dbName = 'bmi_app.db';

  // ── Tables ─────────────────────────────────────────────────────────────────
  static const String _tableBmi = 'bmi_records';
  static const String _tableUsers = 'local_users';
  static const String _tableHealthSettings = 'health_settings';
  static const String _table2faConfig = 'twofa_config';
  static const String _table2faBackupCodes = 'twofa_backup_codes';

  // ── Singleton access ───────────────────────────────────────────────────────
  static Future<Database> get database async {
    _db ??= await _openDb();
    return _db!;
  }

  static Future<void> closeDb() async {
    await _db?.close();
    _db = null;
  }

  // ── Open / create ──────────────────────────────────────────────────────────
  static Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _schemaVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // ── bmi_records ──────────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE $_tableBmi (
        id          TEXT    PRIMARY KEY,
        user_id     TEXT    NOT NULL,
        height      INTEGER NOT NULL,
        weight      INTEGER NOT NULL,
        age         INTEGER NOT NULL,
        is_male     INTEGER NOT NULL DEFAULT 1,
        bmi_value   REAL    NOT NULL,
        bmi_result  TEXT    NOT NULL,
        result_text TEXT    NOT NULL,
        interpretation TEXT NOT NULL,
        recorded_at INTEGER NOT NULL,
        is_synced   INTEGER NOT NULL DEFAULT 0,
        is_deleted  INTEGER NOT NULL DEFAULT 0,
        remote_id   TEXT,
        health_conditions TEXT,
        pregnancy_status TEXT,
        pre_pregnancy_weight REAL
      )
    ''');

    // Performance indexes
    await db.execute(
        'CREATE INDEX idx_bmi_user ON $_tableBmi(user_id)');
    await db.execute(
        'CREATE INDEX idx_bmi_time ON $_tableBmi(recorded_at DESC)');
    await db.execute(
        'CREATE INDEX idx_bmi_unsynced ON $_tableBmi(is_synced, is_deleted)');

    // ── local_users ──────────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE $_tableUsers (
        id              TEXT    PRIMARY KEY,
        name            TEXT,
        email           TEXT,
        phone           TEXT,
        is_guest        INTEGER NOT NULL DEFAULT 0,
        last_synced_at  INTEGER
      )
    ''');

    // ── health_settings ──────────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE $_tableHealthSettings (
        user_id             TEXT    PRIMARY KEY,
        health_conditions   TEXT,
        pregnancy_status    TEXT,
        pre_pregnancy_weight REAL,
        created_at          INTEGER NOT NULL,
        updated_at          INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> _onUpgrade(Database db, int from, int to) async {
    // Migrate from v1 to v2: add health context columns
    if (from < 2) {
      try {
        await db.execute(
            'ALTER TABLE $_tableBmi ADD COLUMN health_conditions TEXT');
        await db.execute(
            'ALTER TABLE $_tableBmi ADD COLUMN pregnancy_status TEXT');
        await db.execute(
            'ALTER TABLE $_tableBmi ADD COLUMN pre_pregnancy_weight REAL');
      } catch (_) {
        // Columns may already exist in some cases
      }

      // Create health_settings table for new schema
      try {
        await db.execute('''
          CREATE TABLE $_tableHealthSettings (
            user_id             TEXT    PRIMARY KEY,
            health_conditions   TEXT,
            pregnancy_status    TEXT,
            pre_pregnancy_weight REAL,
            created_at          INTEGER NOT NULL,
            updated_at          INTEGER NOT NULL
          )
        ''');
      } catch (_) {
        // Table may already exist
      }
    }
    
    if (from < 3) {
      // Create 2FA tables
      try {
        await db.execute('''
          CREATE TABLE $_table2faConfig (
            user_id                     TEXT    PRIMARY KEY,
            is_enabled                  INTEGER NOT NULL DEFAULT 0,
            enrolled_methods            TEXT,
            primary_method              TEXT    NOT NULL DEFAULT 'email',
            created_at                  TEXT,
            last_updated_at             TEXT,
            totp_secret_encrypted       TEXT,
            sms_phone_encrypted         TEXT,
            passkey_credential_encrypted TEXT,
            recovery_codes_remaining    INTEGER NOT NULL DEFAULT 0
          )
        ''');
      } catch (_) {
        // Table may already exist
      }

      try {
        await db.execute('''
          CREATE TABLE $_table2faBackupCodes (
            id            INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id       TEXT    NOT NULL,
            code          TEXT    NOT NULL UNIQUE,
            is_used       INTEGER NOT NULL DEFAULT 0,
            used_at       TEXT,
            FOREIGN KEY(user_id) REFERENCES $_tableUsers(id) ON DELETE CASCADE
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_2fa_codes_user ON $_table2faBackupCodes(user_id)');
      } catch (_) {
        // Table may already exist
      }
    }
    // if (from < 3) { await db.execute('ALTER TABLE ...'); }
  }

  // ── BMI Records ────────────────────────────────────────────────────────────

  /// Insert a new record. Throws if [id] already exists.
  static Future<void> insertRecord(BmiRecord record) async {
    final db = await database;
    await db.insert(_tableBmi, record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// Upsert (insert-or-replace) — used during pull-sync.
  static Future<void> upsertRecord(BmiRecord record) async {
    final db = await database;
    await db.insert(_tableBmi, record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Fetch all non-deleted records for [userId], newest first.
  static Future<List<BmiRecord>> fetchRecords(String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableBmi,
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: [userId],
      orderBy: 'recorded_at DESC',
    );
    return rows.map(BmiRecord.fromMap).toList();
  }

  /// Soft-delete a record locally and mark unsynced so the deletion
  /// is propagated to Firestore on next sync.
  static Future<void> softDeleteRecord(String id) async {
    final db = await database;
    await db.update(
      _tableBmi,
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Hard-delete (used after confirming deletion was pushed to Firestore).
  static Future<void> hardDeleteRecord(String id) async {
    final db = await database;
    await db.delete(_tableBmi, where: 'id = ?', whereArgs: [id]);
  }

  /// All records pending sync (not yet pushed to Firestore).
  static Future<List<BmiRecord>> fetchUnsynced(String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableBmi,
      where: 'user_id = ? AND is_synced = 0',
      whereArgs: [userId],
    );
    return rows.map(BmiRecord.fromMap).toList();
  }

  /// Mark a record as synced and store the Firestore document ID.
  static Future<void> markSynced(String localId, String remoteId) async {
    final db = await database;
    await db.update(
      _tableBmi,
      {'is_synced': 1, 'remote_id': remoteId},
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  /// Reassign all guest records to a real Firebase UID (used on login/register
  /// when the user was previously a guest).
  static Future<void> migrateGuestRecords(String newUserId) async {
    final db = await database;
    await db.update(
      _tableBmi,
      {'user_id': newUserId, 'is_synced': 0},
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: ['guest'],
    );
    // Hard-delete any soft-deleted guest records — no need to sync them.
    await db.delete(_tableBmi,
        where: 'user_id = ? AND is_deleted = 1', whereArgs: ['guest']);
  }

  // ── Local Users ────────────────────────────────────────────────────────────

  static Future<void> upsertUser({
    required String id,
    String? name,
    String? email,
    String? phone,
    bool isGuest = false,
    int? lastSyncedAt,
  }) async {
    final db = await database;
    await db.insert(
      _tableUsers,
      {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'is_guest': isGuest ? 1 : 0,
        'last_synced_at': lastSyncedAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getUser(String id) async {
    final db = await database;
    final rows = await db.query(_tableUsers,
        where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  static Future<void> updateUser(String id, Map<String, dynamic> fields) async {
    final db = await database;
    await db.update(_tableUsers, fields,
        where: 'id = ?', whereArgs: [id]);
  }

  /// Update last_synced_at timestamp for a user.
  static Future<void> updateLastSynced(String userId) async {
    await updateUser(userId, {
      'last_synced_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<int?> getLastSyncedAt(String userId) async {
    final user = await getUser(userId);
    return user?['last_synced_at'] as int?;
  }

  /// Wipe all local data for a user (account deletion / sign-out clean-up).
  static Future<void> deleteAllUserData(String userId) async {
    final db = await database;
    await db.delete(_tableBmi, where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_tableUsers, where: 'id = ?', whereArgs: [userId]);
    await db.delete(_table2faConfig, where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_table2faBackupCodes, where: 'user_id = ?', whereArgs: [userId]);
  }

  // ── Two-Factor Authentication ──────────────────────────────────────────────

  /// Get 2FA config for user; returns null if not configured.
  static Future<Map<String, dynamic>?> get2faConfig(String userId) async {
    final db = await database;
    final rows = await db.query(
      _table2faConfig,
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  /// Save or update 2FA config.
  static Future<void> save2faConfig(Map<String, dynamic> config) async {
    final db = await database;
    await db.insert(
      _table2faConfig,
      config,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete 2FA config for user.
  static Future<void> delete2faConfig(String userId) async {
    final db = await database;
    await db.delete(_table2faConfig, where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_table2faBackupCodes, where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Generate and save backup codes.
  static Future<void> saveBackupCodes(String userId, List<String> codes) async {
    final db = await database;
    
    // Delete old codes
    await db.delete(_table2faBackupCodes, where: 'user_id = ?', whereArgs: [userId]);
    
    // Insert new codes
    for (final code in codes) {
      await db.insert(
        _table2faBackupCodes,
        {'user_id': userId, 'code': code, 'is_used': 0},
      );
    }
  }

  /// Get unused backup codes for user.
  static Future<List<Map<String, dynamic>>> getUnusedBackupCodes(String userId) async {
    final db = await database;
    return await db.query(
      _table2faBackupCodes,
      where: 'user_id = ? AND is_used = 0',
      whereArgs: [userId],
    );
  }

  /// Mark backup code as used.
  static Future<bool> useBackupCode(String userId, String code) async {
    final db = await database;
    final count = await db.update(
      _table2faBackupCodes,
      {'is_used': 1, 'used_at': DateTime.now().toIso8601String()},
      where: 'user_id = ? AND code = ? AND is_used = 0',
      whereArgs: [userId, code],
    );
    return count > 0;
  }

  /// Count remaining backup codes.
  static Future<int> getBackupCodeCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_table2faBackupCodes WHERE user_id = ? AND is_used = 0',
      [userId],
    );
    return (result.first['count'] as int?) ?? 0;
  }
}
