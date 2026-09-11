import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';

/// Manages the current user session — guest or authenticated.
///
/// Single source of truth for "who is the current user" across the app.
/// Persists sensitive session data via [FlutterSecureStorage] and non-sensitive
/// flags via [SharedPreferences].
class SessionService {
  static const String guestId = 'guest';

  // Secure storage keys (sensitive data)
  static const _keyUserId = 'ss_user_id';
  static const _keyUserEmail = 'ss_user_email';
  static const _keySessionStart = 'ss_session_start';

  // SharedPreferences keys (non-sensitive flags)
  static const _keyIsGuest = 'ss_is_guest';
  static const _key2faVerified = 'ss_2fa_verified';

  static const _secureStorage = FlutterSecureStorage();

  /// Session duration before automatic expiry (24 hours).
  static const _sessionDuration = Duration(hours: 24);

  static String? _userId;
  static bool _isGuest = false;
  static bool _is2faVerified = false;
  static String? _userEmail;
  static DateTime? _sessionStartTime;

  // ── Accessors ──────────────────────────────────────────────────────────────

  static String? get userId => _userId;
  static bool get isGuest => _isGuest;
  static bool get hasSession => _userId != null;
  static bool get isAuthenticated => _userId != null && !_isGuest;
  static bool get is2faVerified => _is2faVerified;
  static String? get userEmail => _userEmail;

  /// Check if 2FA verification is required
  static bool get requires2fa => isAuthenticated && !_is2faVerified;

  // ── Initialization (called once at app startup) ────────────────────────────

  /// Restores the persisted session and reconciles it with Firebase Auth state.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isGuest = prefs.getBool(_keyIsGuest) ?? false;
    _is2faVerified = prefs.getBool(_key2faVerified) ?? false;

    _userId = await _secureStorage.read(key: _keyUserId);
    _userEmail = await _secureStorage.read(key: _keyUserEmail);
    final startStr = await _secureStorage.read(key: _keySessionStart);
    if (startStr != null) {
      _sessionStartTime = DateTime.tryParse(startStr);
    }

    // Expired session — clear it.
    if (_userId != null && !await isSessionValid()) {
      await clear();
      return;
    }

    // Stale Firebase session — token expired.
    if (isAuthenticated && FirebaseAuth.instance.currentUser == null) {
      await clear();
    }
  }

  /// Whether the current session is still within the allowed duration.
  static Future<bool> isSessionValid() async {
    if (_sessionStartTime == null) return false;
    return DateTime.now().difference(_sessionStartTime!) < _sessionDuration;
  }

  // ── Test hooks ─────────────────────────────────────────────────────────────

  /// Resets in-memory state. Test-only; not used in production.
  static void resetForTesting() {
    _userId = null;
    _isGuest = false;
    _is2faVerified = false;
    _userEmail = null;
    _sessionStartTime = null;
  }

  /// Overrides the session start time. Test-only; not used in production.
  static void setSessionStartForTesting(DateTime time) {
    _sessionStartTime = time;
  }

  // ── Session transitions ────────────────────────────────────────────────────

  /// Start a guest session. Creates a local-only user record in SQLite.
  static Future<void> startGuest() async {
    _userId = guestId;
    _isGuest = true;
    _is2faVerified = false;
    _userEmail = null;
    _sessionStartTime = DateTime.now();
    await _persist();

    await AppDatabase.upsertUser(
      id: guestId,
      name: 'Guest',
      isGuest: true,
    );
  }

  /// Start a registered session. Caches user profile locally.
  static Future<void> startUser({
    required String uid,
    required String name,
    required String email,
    String? phone,
  }) async {
    _userId = uid;
    _isGuest = false;
    _is2faVerified = false;
    _userEmail = email;
    _sessionStartTime = DateTime.now();
    await _persist();

    await AppDatabase.upsertUser(
      id: uid,
      name: name,
      email: email,
      phone: phone,
      isGuest: false,
    );
  }

  /// Clear the session (sign-out / account deletion / expiry).
  static Future<void> clear() async {
    _userId = null;
    _isGuest = false;
    _is2faVerified = false;
    _userEmail = null;
    _sessionStartTime = null;

    await _secureStorage.delete(key: _keyUserId);
    await _secureStorage.delete(key: _keyUserEmail);
    await _secureStorage.delete(key: _keySessionStart);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsGuest);
    await prefs.remove(_key2faVerified);
  }

  /// Mark 2FA as verified for current session
  static Future<void> verify2fa() async {
    _is2faVerified = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key2faVerified, true);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static Future<void> _persist() async {
    // Sensitive data → encrypted storage
    await _secureStorage.write(key: _keyUserId, value: _userId!);
    await _secureStorage.write(
      key: _keySessionStart,
      value: _sessionStartTime!.toIso8601String(),
    );
    if (_userEmail != null) {
      await _secureStorage.write(key: _keyUserEmail, value: _userEmail!);
    } else {
      await _secureStorage.delete(key: _keyUserEmail);
    }

    // Non-sensitive flags → SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsGuest, _isGuest);
    await prefs.setBool(_key2faVerified, _is2faVerified);
  }
}
