import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';

/// Manages the current user session — guest or authenticated.
///
/// Single source of truth for "who is the current user" across the app.
/// Persists session state across cold starts via [SharedPreferences].
class SessionService {
  static const String guestId = 'guest';

  static const _keyUserId = 'ss_user_id';
  static const _keyIsGuest = 'ss_is_guest';
  static const _key2faVerified = 'ss_2fa_verified';

  static String? _userId;
  static bool _isGuest = false;
  static bool _is2faVerified = false;

  // ── Accessors ──────────────────────────────────────────────────────────────

  static String? get userId => _userId;
  static bool get isGuest => _isGuest;
  static bool get hasSession => _userId != null;
  static bool get isAuthenticated => _userId != null && !_isGuest;
  static bool get is2faVerified => _is2faVerified;

  /// Check if 2FA verification is required
  static bool get requires2fa => isAuthenticated && !_is2faVerified;

  // ── Initialization (called once at app startup) ────────────────────────────

  /// Restores the persisted session and reconciles it with Firebase Auth state.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString(_keyUserId);
    _isGuest = prefs.getBool(_keyIsGuest) ?? false;
    _is2faVerified = prefs.getBool(_key2faVerified) ?? false;

    // If we had a registered session but Firebase Auth has no current user,
    // the token has expired — clear the stale session.
    if (isAuthenticated && FirebaseAuth.instance.currentUser == null) {
      await clear();
    }
  }

  // ── Session transitions ────────────────────────────────────────────────────

  /// Start a guest session. Creates a local-only user record in SQLite.
  static Future<void> startGuest() async {
    _userId = guestId;
    _isGuest = true;
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
    await _persist();

    await AppDatabase.upsertUser(
      id: uid,
      name: name,
      email: email,
      phone: phone,
      isGuest: false,
    );
  }

  /// Clear the session (sign-out / account deletion).
  static Future<void> clear() async {
    _userId = null;
    _isGuest = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyIsGuest);
    await prefs.remove(_key2faVerified);
  }

  /// Mark 2FA as verified for current session
  static Future<void> verify2fa() async {
    _is2faVerified = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key2faVerified, true);
  }

  /// Reset 2FA verification (for logout or session expiry)
  static Future<void> _reset2fa() async {
    _is2faVerified = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key2faVerified);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, _userId!);
    await prefs.setBool(_keyIsGuest, _isGuest);
    await prefs.setBool(_key2faVerified, _is2faVerified);
  }
}
