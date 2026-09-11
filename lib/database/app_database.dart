import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_record.dart';
import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';
import '../models/daily_challenge.dart';
import '../models/reminder.dart';
import '../models/user_streak.dart';
import '../services/secure_config_service.dart';

/// Local SQLite database — the single source of truth for all BMI data.
///
/// Schema version history:
///   v1 — initial: bmi_records, local_users
///   v2 — health context: added health_conditions, pregnancy_status, pre_pregnancy_weight to bmi_records;
///        added health_settings table for persistent user health data
///   v3 — 2FA tables: twofa_config, twofa_backup_codes
///   v4 — security events: security_events, security_alerts
///   v5 — advanced metrics: added waist_cm, neck_cm, hip_cm, resting_hr to bmi_records
///   v6 — SQLCipher encryption: all data encrypted at rest
///   v7 — blood_pressure_records table (Sprint 1.2)
///   v8 — blood_sugar_records table (Sprint 1.3)
///   v9 — gamification tables: streaks, achievements, daily challenges (Sprint 2.1)
///   v10 — reminders table (Sprint 2.3)
///
/// All writes are local-first. [SyncService] handles pushing to / pulling
/// from Firestore in the background.
class AppDatabase {
  static Database? _db;
  static const int _schemaVersion = 10;
  static const String _dbName = 'bmi_app.db';
  static const String _migrationFlag = 'db_encrypted_v1';

  // ── Tables ─────────────────────────────────────────────────────────────────
  static const String _tableBmi = 'bmi_records';
  static const String _tableUsers = 'local_users';
  static const String _tableHealthSettings = 'health_settings';
  static const String _table2faConfig = 'twofa_config';
  static const String _table2faBackupCodes = 'twofa_backup_codes';
  static const String _tableSecurityEvents = 'security_events';
  static const String _tableSecurityAlerts = 'security_alerts';
  static const String _tableBloodPressure = 'blood_pressure_records';
  static const String _tableBloodSugar = 'blood_sugar_records';
  static const String _tableStreaks = 'user_streaks';
  static const String _tableAchievements = 'unlocked_achievements';
  static const String _tableDailyChallenges = 'daily_challenges';
  static const String _tableReminders = 'reminders';

  // ── Singleton access ───────────────────────────────────────────────────────
  static Future<Database> get database async {
    _db ??= await _openDb();
    return _db!;
  }

  static Future<void> closeDb() async {
    await _db?.close();
    _db = null;
  }

  // ── Encryption helpers ─────────────────────────────────────────────────────

  /// Retrieve or generate the database encryption password.
  ///
  /// Priority:
  /// 1. `DB_ENCRYPTION_KEY` from `.env` (production)
  /// 2. Auto-generated key stored in SharedPreferences (first-run fallback)
  static Future<String> _getEncryptionPassword() async {
    // 1. Check .env first
    final envKey = SecureConfigService.getConfig('DB_ENCRYPTION_KEY');
    if (envKey != null && envKey.isNotEmpty) return envKey;

    // 2. Fall back to SharedPreferences-stored key
    final prefs = await SharedPreferences.getInstance();
    var storedKey = prefs.getString('db_encryption_key');

    if (storedKey == null || storedKey.isEmpty) {
      // Generate a new 64-character hex key (32 random bytes)
      storedKey = _generateEncryptionKey();
      await prefs.setString('db_encryption_key', storedKey);
    }

    return storedKey;
  }

  /// Generate a cryptographically random 64-char hex string (32 bytes).
  static String _generateEncryptionKey() {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Exposed for tests — a freshly generated 64-char hex encryption key.
  @visibleForTesting
  static String generateEncryptionKeyForTest() => _generateEncryptionKey();

  /// Check if the legacy unencrypted database exists and needs migration.
  static Future<bool> _needsEncryptionMigration() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_migrationFlag) == true) return false;

    // Check if the legacy DB file exists on disk
    final dbPath = await getDatabasesPath();
    final legacyPath = join(dbPath, _dbName);
    if (!File(legacyPath).existsSync()) return false;

    // Try opening without password — if it succeeds, it's unencrypted
    try {
      final db = await openDatabase(legacyPath, readOnly: true);
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM sqlite_master'),
      );
      await db.close();
      return (count ?? 0) > 0;
    } catch (_) {
      // Opening without password failed — DB is already encrypted
      return false;
    }
  }

  /// Migrate data from the legacy unencrypted DB to the new encrypted DB.
  static Future<void> _migrateToEncrypted() async {
    final dbPath = await getDatabasesPath();
    final legacyPath = join(dbPath, _dbName);
    final password = await _getEncryptionPassword();

    Database? legacyDb;
    Database? encryptedDb;

    try {
      // Open the existing unencrypted database
      legacyDb = await openDatabase(legacyPath, readOnly: true);

      // Create the new encrypted database
      final newPath = join(dbPath, _dbName);
      encryptedDb = await openDatabase(
        newPath,
        password: password,
        version: _schemaVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );

      // Copy all table data
      final tables = [
        _tableBmi,
        _tableUsers,
        _tableHealthSettings,
        _table2faConfig,
        _table2faBackupCodes,
        _tableSecurityEvents,
        _tableSecurityAlerts,
        _tableBloodPressure,
        _tableBloodSugar,
      ];

      for (final table in tables) {
        try {
          final rows = await legacyDb.query(table);
          for (final row in rows) {
            await encryptedDb.insert(table, row,
                conflictAlgorithm: ConflictAlgorithm.replace);
          }
        } catch (_) {
          // Table might not exist in legacy DB
        }
      }

      await encryptedDb.close();
      encryptedDb = null;

      // Delete legacy unencrypted DB file
      try {
        await deleteDatabase(legacyPath);
      } catch (_) {
        // Best-effort cleanup — legacy DB left behind is safe at this point
      }

      // Mark migration as complete
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_migrationFlag, true);

      debugPrint('AppDatabase: Successfully migrated to encrypted database');
    } catch (e) {
      debugPrint('AppDatabase: Encryption migration failed: $e');
      // Re-throw so the app can fall back gracefully
      rethrow;
    } finally {
      await legacyDb?.close();
      await encryptedDb?.close();
    }
  }

  // ── Open / create ──────────────────────────────────────────────────────────
  static Future<Database> _openDb() async {
    // Check if we need to migrate from unencrypted to encrypted
    if (await _needsEncryptionMigration()) {
      await _migrateToEncrypted();
    }

    final password = await _getEncryptionPassword();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      password: password,
      version: _schemaVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
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
        pre_pregnancy_weight REAL,
        waist_cm    REAL,
        neck_cm     REAL,
        hip_cm      REAL,
        resting_hr  INTEGER
      )
    ''');

    // Performance indexes
    await db.execute('CREATE INDEX idx_bmi_user ON $_tableBmi(user_id)');
    await db
        .execute('CREATE INDEX idx_bmi_time ON $_tableBmi(recorded_at DESC)');
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

    // ── blood_pressure_records ───────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE $_tableBloodPressure (
        id              TEXT    PRIMARY KEY,
        user_id         TEXT    NOT NULL,
        systolic        INTEGER NOT NULL,
        diastolic       INTEGER NOT NULL,
        pulse           INTEGER,
        measurement_time INTEGER NOT NULL,
        notes           TEXT,
        is_synced       INTEGER NOT NULL DEFAULT 0,
        is_deleted      INTEGER NOT NULL DEFAULT 0,
        remote_id       TEXT
      )
    ''');

    await db
        .execute('CREATE INDEX idx_bp_user ON $_tableBloodPressure(user_id)');
    await db.execute(
        'CREATE INDEX idx_bp_time ON $_tableBloodPressure(measurement_time DESC)');
    await db.execute(
        'CREATE INDEX idx_bp_unsynced ON $_tableBloodPressure(is_synced, is_deleted)');

    // ── blood_sugar_records ──────────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE $_tableBloodSugar (
        id               TEXT    PRIMARY KEY,
        user_id          TEXT    NOT NULL,
        glucose_level    INTEGER NOT NULL,
        measurement_type TEXT    NOT NULL DEFAULT 'fasting',
        meal_context     TEXT,
        measurement_time INTEGER NOT NULL,
        notes            TEXT,
        is_synced        INTEGER NOT NULL DEFAULT 0,
        is_deleted       INTEGER NOT NULL DEFAULT 0,
        remote_id        TEXT
      )
    ''');

    await db.execute('CREATE INDEX idx_bs_user ON $_tableBloodSugar(user_id)');
    await db.execute(
        'CREATE INDEX idx_bs_time ON $_tableBloodSugar(measurement_time DESC)');
    await db.execute(
        'CREATE INDEX idx_bs_unsynced ON $_tableBloodSugar(is_synced, is_deleted)');

    // ── gamification (Sprint 2.1) ────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE $_tableStreaks (
        user_id   TEXT    PRIMARY KEY,
        current   INTEGER NOT NULL DEFAULT 0,
        best      INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableAchievements (
        user_id      TEXT    NOT NULL,
        achievement_id TEXT  NOT NULL,
        unlocked_at  INTEGER NOT NULL,
        PRIMARY KEY (user_id, achievement_id)
      )
    ''');
    await db
        .execute('CREATE INDEX idx_ach_user ON $_tableAchievements(user_id)');

    await db.execute('''
      CREATE TABLE $_tableDailyChallenges (
        user_id      TEXT    NOT NULL,
        date_key     TEXT    NOT NULL,
        definition_id TEXT   NOT NULL,
        title_key    TEXT,
        description_key TEXT,
        icon         TEXT,
        target       INTEGER NOT NULL,
        points       INTEGER NOT NULL DEFAULT 10,
        progress     INTEGER NOT NULL DEFAULT 0,
        completed    INTEGER NOT NULL DEFAULT 0,
        completed_at INTEGER,
        PRIMARY KEY (user_id, date_key)
      )
    ''');
    await db.execute(
        'CREATE INDEX idx_challenge_user ON $_tableDailyChallenges(user_id)');

    // ── reminders (Sprint 2.3) ──────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE $_tableReminders (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id    TEXT    NOT NULL,
        type       TEXT    NOT NULL,
        label      TEXT,
        hour       INTEGER NOT NULL,
        minute     INTEGER NOT NULL,
        days       INTEGER NOT NULL DEFAULT 127,
        enabled    INTEGER NOT NULL DEFAULT 1,
        payload    TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
    await db
        .execute('CREATE INDEX idx_reminder_user ON $_tableReminders(user_id)');
  }

  static Future<void> _onUpgrade(Database db, int from, int to) async {
    // Migrate from v1 to v2: add health context columns
    if (from < 2) {
      try {
        await db.execute(
            'ALTER TABLE $_tableBmi ADD COLUMN health_conditions TEXT');
        await db
            .execute('ALTER TABLE $_tableBmi ADD COLUMN pregnancy_status TEXT');
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

    if (from < 4) {
      // Create security event tables
      try {
        await db.execute('''
          CREATE TABLE $_tableSecurityEvents (
            id            TEXT    PRIMARY KEY,
            type          TEXT    NOT NULL,
            identifier    TEXT    NOT NULL,
            timestamp     INTEGER NOT NULL,
            metadata      TEXT,
            ip_address    TEXT,
            user_agent    TEXT
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_security_events_user ON $_tableSecurityEvents(identifier)');
        await db.execute(
            'CREATE INDEX idx_security_events_time ON $_tableSecurityEvents(timestamp DESC)');
      } catch (_) {
        // Table may already exist
      }

      try {
        await db.execute('''
          CREATE TABLE $_tableSecurityAlerts (
            id            TEXT    PRIMARY KEY,
            type          TEXT    NOT NULL,
            identifier    TEXT    NOT NULL,
            timestamp     INTEGER NOT NULL,
            details       TEXT,
            severity      TEXT    NOT NULL,
            status        TEXT    NOT NULL DEFAULT 'active',
            resolved_by   TEXT,
            resolved_at   INTEGER
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_security_alerts_status ON $_tableSecurityAlerts(status)');
        await db.execute(
            'CREATE INDEX idx_security_alerts_time ON $_tableSecurityAlerts(timestamp DESC)');
      } catch (_) {
        // Table may already exist
      }
    }

    if (from < 5) {
      // Advanced body metrics (Phase 1) — add optional columns to bmi_records.
      try {
        await db.execute('ALTER TABLE $_tableBmi ADD COLUMN waist_cm REAL');
        await db.execute('ALTER TABLE $_tableBmi ADD COLUMN neck_cm REAL');
        await db.execute('ALTER TABLE $_tableBmi ADD COLUMN hip_cm REAL');
        await db
            .execute('ALTER TABLE $_tableBmi ADD COLUMN resting_hr INTEGER');
      } catch (_) {
        // Columns may already exist (e.g. re-running a partial migration)
      }
    }

    if (from < 7) {
      // Blood pressure tracking (Sprint 1.2).
      try {
        await db.execute('''
          CREATE TABLE $_tableBloodPressure (
            id              TEXT    PRIMARY KEY,
            user_id         TEXT    NOT NULL,
            systolic        INTEGER NOT NULL,
            diastolic       INTEGER NOT NULL,
            pulse           INTEGER,
            measurement_time INTEGER NOT NULL,
            notes           TEXT,
            is_synced       INTEGER NOT NULL DEFAULT 0,
            is_deleted      INTEGER NOT NULL DEFAULT 0,
            remote_id       TEXT
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_bp_user ON $_tableBloodPressure(user_id)');
        await db.execute(
            'CREATE INDEX idx_bp_time ON $_tableBloodPressure(measurement_time DESC)');
        await db.execute(
            'CREATE INDEX idx_bp_unsynced ON $_tableBloodPressure(is_synced, is_deleted)');
      } catch (_) {
        // Table may already exist
      }
    }

    if (from < 8) {
      // Blood sugar tracking (Sprint 1.3).
      try {
        await db.execute('''
          CREATE TABLE $_tableBloodSugar (
            id               TEXT    PRIMARY KEY,
            user_id          TEXT    NOT NULL,
            glucose_level    INTEGER NOT NULL,
            measurement_type TEXT    NOT NULL DEFAULT 'fasting',
            meal_context     TEXT,
            measurement_time INTEGER NOT NULL,
            notes            TEXT,
            is_synced        INTEGER NOT NULL DEFAULT 0,
            is_deleted       INTEGER NOT NULL DEFAULT 0,
            remote_id        TEXT
          )
        ''');
        await db
            .execute('CREATE INDEX idx_bs_user ON $_tableBloodSugar(user_id)');
        await db.execute(
            'CREATE INDEX idx_bs_time ON $_tableBloodSugar(measurement_time DESC)');
        await db.execute(
            'CREATE INDEX idx_bs_unsynced ON $_tableBloodSugar(is_synced, is_deleted)');
      } catch (_) {
        // Table may already exist
      }
    }

    if (from < 9) {
      // Gamification tables (Sprint 2.1).
      try {
        await db.execute('''
          CREATE TABLE $_tableStreaks (
            user_id   TEXT    PRIMARY KEY,
            current   INTEGER NOT NULL DEFAULT 0,
            best      INTEGER NOT NULL DEFAULT 0,
            updated_at INTEGER
          )
        ''');
      } catch (_) {
        // Table may already exist
      }

      try {
        await db.execute('''
          CREATE TABLE $_tableAchievements (
            user_id      TEXT    NOT NULL,
            achievement_id TEXT  NOT NULL,
            unlocked_at  INTEGER NOT NULL,
            PRIMARY KEY (user_id, achievement_id)
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_ach_user ON $_tableAchievements(user_id)');
      } catch (_) {
        // Table may already exist
      }

      try {
        await db.execute('''
          CREATE TABLE $_tableDailyChallenges (
            user_id      TEXT    NOT NULL,
            date_key     TEXT    NOT NULL,
            definition_id TEXT   NOT NULL,
            title_key    TEXT,
            description_key TEXT,
            icon         TEXT,
            target       INTEGER NOT NULL,
            points       INTEGER NOT NULL DEFAULT 10,
            progress     INTEGER NOT NULL DEFAULT 0,
            completed    INTEGER NOT NULL DEFAULT 0,
            completed_at INTEGER,
            PRIMARY KEY (user_id, date_key)
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_challenge_user ON $_tableDailyChallenges(user_id)');
      } catch (_) {
        // Table may already exist
      }
    }

    if (from < 10) {
      // Smart reminders (Sprint 2.3).
      try {
        await db.execute('''
          CREATE TABLE $_tableReminders (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id    TEXT    NOT NULL,
            type       TEXT    NOT NULL,
            label      TEXT,
            hour       INTEGER NOT NULL,
            minute     INTEGER NOT NULL,
            days       INTEGER NOT NULL DEFAULT 127,
            enabled    INTEGER NOT NULL DEFAULT 1,
            payload    TEXT,
            created_at INTEGER NOT NULL
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_reminder_user ON $_tableReminders(user_id)');
      } catch (_) {
        // Table may already exist
      }
    }
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

    await db.update(
      _tableBloodPressure,
      {'user_id': newUserId, 'is_synced': 0},
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: ['guest'],
    );
    await db.delete(_tableBloodPressure,
        where: 'user_id = ? AND is_deleted = 1', whereArgs: ['guest']);

    await db.update(
      _tableBloodSugar,
      {'user_id': newUserId, 'is_synced': 0},
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: ['guest'],
    );
    await db.delete(_tableBloodSugar,
        where: 'user_id = ? AND is_deleted = 1', whereArgs: ['guest']);

    // Gamification data carries over to the new account.
    await db.update(_tableStreaks, {'user_id': newUserId},
        where: 'user_id = ?', whereArgs: ['guest']);
    await db.update(_tableAchievements, {'user_id': newUserId},
        where: 'user_id = ?', whereArgs: ['guest']);
    await db.update(_tableDailyChallenges, {'user_id': newUserId},
        where: 'user_id = ?', whereArgs: ['guest']);

    // Reminder preferences carry over (local-only, no sync flag needed).
    await db.update(_tableReminders, {'user_id': newUserId},
        where: 'user_id = ?', whereArgs: ['guest']);
  }

  // ── Blood Pressure Records ──────────────────────────────────────────────────

  /// Insert a new BP record. Throws if [id] already exists.
  static Future<void> insertBPRecord(BloodPressureRecord record) async {
    final db = await database;
    await db.insert(_tableBloodPressure, record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// Upsert (insert-or-replace) — used during pull-sync.
  static Future<void> upsertBPRecord(BloodPressureRecord record) async {
    final db = await database;
    await db.insert(_tableBloodPressure, record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Fetch all non-deleted BP records for [userId], newest first.
  static Future<List<BloodPressureRecord>> fetchBPRecords(String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableBloodPressure,
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: [userId],
      orderBy: 'measurement_time DESC',
    );
    return rows.map(BloodPressureRecord.fromMap).toList();
  }

  /// Soft-delete a BP record locally so the deletion syncs to Firestore.
  static Future<void> softDeleteBPRecord(String id) async {
    final db = await database;
    await db.update(
      _tableBloodPressure,
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Hard-delete (used after confirming deletion was pushed to Firestore).
  static Future<void> hardDeleteBPRecord(String id) async {
    final db = await database;
    await db.delete(_tableBloodPressure, where: 'id = ?', whereArgs: [id]);
  }

  /// All unsynced (pending-push) BP records for [userId].
  static Future<List<BloodPressureRecord>> fetchUnsyncedBP(
      String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableBloodPressure,
      where: 'user_id = ? AND is_synced = 0',
      whereArgs: [userId],
    );
    return rows.map(BloodPressureRecord.fromMap).toList();
  }

  /// Mark a BP record as synced and store its Firestore document ID.
  static Future<void> markBPSynced(String localId, String remoteId) async {
    final db = await database;
    await db.update(
      _tableBloodPressure,
      {'is_synced': 1, 'remote_id': remoteId},
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  // ── Blood Sugar Records ─────────────────────────────────────────────────────

  /// Insert a new glucose record. Throws if [id] already exists.
  static Future<void> insertBloodSugarRecord(BloodSugarRecord record) async {
    final db = await database;
    await db.insert(_tableBloodSugar, record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// Upsert (insert-or-replace) — used during pull-sync.
  static Future<void> upsertBloodSugarRecord(BloodSugarRecord record) async {
    final db = await database;
    await db.insert(_tableBloodSugar, record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Fetch all non-deleted glucose records for [userId], newest first.
  static Future<List<BloodSugarRecord>> fetchBloodSugarRecords(
      String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableBloodSugar,
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: [userId],
      orderBy: 'measurement_time DESC',
    );
    return rows.map(BloodSugarRecord.fromMap).toList();
  }

  /// Soft-delete a glucose record locally so the deletion syncs to Firestore.
  static Future<void> softDeleteBloodSugarRecord(String id) async {
    final db = await database;
    await db.update(
      _tableBloodSugar,
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Hard-delete (used after confirming deletion was pushed to Firestore).
  static Future<void> hardDeleteBloodSugarRecord(String id) async {
    final db = await database;
    await db.delete(_tableBloodSugar, where: 'id = ?', whereArgs: [id]);
  }

  /// All unsynced (pending-push) glucose records for [userId].
  static Future<List<BloodSugarRecord>> fetchUnsyncedBloodSugar(
      String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableBloodSugar,
      where: 'user_id = ? AND is_synced = 0',
      whereArgs: [userId],
    );
    return rows.map(BloodSugarRecord.fromMap).toList();
  }

  /// Mark a glucose record as synced and store its Firestore document ID.
  static Future<void> markBloodSugarSynced(
      String localId, String remoteId) async {
    final db = await database;
    await db.update(
      _tableBloodSugar,
      {'is_synced': 1, 'remote_id': remoteId},
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  // ── Gamification (Sprint 2.1) ─────────────────────────────────────────────

  static Future<void> saveStreak(String userId, UserStreak streak) async {
    final db = await database;
    await db.insert(
      _tableStreaks,
      {
        'user_id': userId,
        'current': streak.current,
        'best': streak.best,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserStreak> fetchStreak(String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableStreaks,
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return UserStreak.empty;
    return UserStreak(
      current: rows.first['current'] as int? ?? 0,
      best: rows.first['best'] as int? ?? 0,
    );
  }

  static Future<void> insertUnlockedAchievement(
      String userId, String achievementId) async {
    final db = await database;
    await db.insert(
      _tableAchievements,
      {
        'user_id': userId,
        'achievement_id': achievementId,
        'unlocked_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<Set<String>> fetchUnlockedAchievements(String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableAchievements,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return rows.map((r) => r['achievement_id'] as String).toSet();
  }

  static Future<void> saveDailyChallenge(DailyChallenge challenge) async {
    final db = await database;
    await db.insert(
      _tableDailyChallenges,
      challenge.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<DailyChallenge?> fetchDailyChallenge(
      String userId, String dateKey) async {
    final db = await database;
    final rows = await db.query(
      _tableDailyChallenges,
      where: 'user_id = ? AND date_key = ?',
      whereArgs: [userId, dateKey],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DailyChallenge.fromMap(rows.first);
  }

  /// Newest-first challenge history for the user (challenge history screen).
  static Future<List<DailyChallenge>> fetchRecentDailyChallenges(String userId,
      {int limit = 30}) async {
    final db = await database;
    final rows = await db.query(
      _tableDailyChallenges,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date_key DESC',
      limit: limit,
    );
    return rows.map(DailyChallenge.fromMap).toList();
  }

  // ── Reminders (Sprint 2.3) ────────────────────────────────────────────────

  /// Insert a reminder; the AUTOINCREMENT id is written back onto the model.
  static Future<Reminder> insertReminder(Reminder reminder) async {
    final db = await database;
    final id = await db.insert(_tableReminders, reminder.toMap());
    return reminder.copyWith(id: id);
  }

  /// Update all fields of an existing reminder.
  static Future<void> updateReminder(Reminder reminder) async {
    final db = await database;
    await db.update(_tableReminders, reminder.toMap(),
        where: 'id = ?', whereArgs: [reminder.id]);
  }

  /// All reminders configured by [userId], in creation order.
  static Future<List<Reminder>> fetchReminders(String userId) async {
    final db = await database;
    final rows = await db.query(
      _tableReminders,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id ASC',
    );
    return rows.map(Reminder.fromMap).toList();
  }

  static Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete(_tableReminders, where: 'id = ?', whereArgs: [id]);
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
    final rows =
        await db.query(_tableUsers, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  static Future<void> updateUser(String id, Map<String, dynamic> fields) async {
    final db = await database;
    await db.update(_tableUsers, fields, where: 'id = ?', whereArgs: [id]);
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
    await db
        .delete(_tableBloodPressure, where: 'user_id = ?', whereArgs: [userId]);
    await db
        .delete(_tableBloodSugar, where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_tableUsers, where: 'id = ?', whereArgs: [userId]);
    await db.delete(_table2faConfig, where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_table2faBackupCodes,
        where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_tableStreaks, where: 'user_id = ?', whereArgs: [userId]);
    await db
        .delete(_tableAchievements, where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_tableDailyChallenges,
        where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_tableReminders, where: 'user_id = ?', whereArgs: [userId]);
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
    await db.delete(_table2faBackupCodes,
        where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Generate and save backup codes.
  static Future<void> saveBackupCodes(String userId, List<String> codes) async {
    final db = await database;

    // Delete old codes
    await db.delete(_table2faBackupCodes,
        where: 'user_id = ?', whereArgs: [userId]);

    // Insert new codes
    for (final code in codes) {
      await db.insert(
        _table2faBackupCodes,
        {'user_id': userId, 'code': code, 'is_used': 0},
      );
    }
  }

  /// Get unused backup codes for user.
  static Future<List<Map<String, dynamic>>> getUnusedBackupCodes(
      String userId) async {
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

  // ── Security Events ──────────────────────────────────────────────────────

  /// Insert a security event for audit trail.
  static Future<void> insertSecurityEvent(Map<String, dynamic> eventMap) async {
    final db = await database;

    await db.insert(
      _tableSecurityEvents,
      {
        'id': eventMap['id'],
        'type': eventMap['type'],
        'identifier': eventMap['identifier'],
        'timestamp': eventMap['timestamp'] is String
            ? DateTime.parse(eventMap['timestamp']).millisecondsSinceEpoch
            : eventMap['timestamp'],
        'metadata': eventMap['metadata'] != null
            ? _encodeMap(eventMap['metadata'])
            : null,
        'ip_address': eventMap['ip_address'],
        'user_agent': eventMap['user_agent'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Insert a security alert.
  static Future<void> insertSecurityAlert(Map<String, dynamic> alertMap) async {
    final db = await database;

    await db.insert(
      _tableSecurityAlerts,
      {
        'id': alertMap['id'],
        'type': alertMap['type'],
        'identifier': alertMap['identifier'],
        'timestamp': alertMap['timestamp'] is String
            ? DateTime.parse(alertMap['timestamp']).millisecondsSinceEpoch
            : alertMap['timestamp'],
        'details': alertMap['details'],
        'severity': alertMap['severity'],
        'status': alertMap['status'],
        'resolved_by': alertMap['resolved_by'],
        'resolved_at': alertMap['resolved_at'] != null
            ? (alertMap['resolved_at'] is String
                ? DateTime.parse(alertMap['resolved_at']).millisecondsSinceEpoch
                : alertMap['resolved_at'])
            : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get active security alerts.
  static Future<List<Map<String, dynamic>>> getActiveSecurityAlerts() async {
    final db = await database;
    final results = await db.query(
      _tableSecurityAlerts,
      where: 'status = ?',
      whereArgs: ['active'],
      orderBy: 'timestamp DESC',
    );
    return results;
  }

  /// Resolve a security alert.
  static Future<void> resolveSecurityAlert(String alertId,
      {String? resolvedBy}) async {
    final db = await database;
    await db.update(
      _tableSecurityAlerts,
      {
        'status': 'resolved',
        'resolved_by': resolvedBy,
        'resolved_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [alertId],
    );
  }

  /// Get recent security events for a user.
  static Future<List<Map<String, dynamic>>> getSecurityEvents(
    String identifier, {
    int limit = 100,
  }) async {
    final db = await database;
    final results = await db.query(
      _tableSecurityEvents,
      where: 'identifier = ?',
      whereArgs: [identifier],
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return results;
  }

  /// Helper method to encode Map to JSON string for storage.
  static String _encodeMap(Map<String, dynamic> map) {
    return jsonEncode(map);
  }
}
