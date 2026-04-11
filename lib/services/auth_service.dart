import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';
import 'session_service.dart';
import 'sync_service.dart';
import '../database/app_database.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Guest ──────────────────────────────────────────────────────────────────

  /// Start a local-only guest session. No Firebase account needed.
  static Future<void> loginAsGuest() async {
    await SessionService.startGuest();
  }

  // ── Registered ────────────────────────────────────────────────────────────

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final wasGuest = SessionService.isGuest;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
      final user = credential.user!;

      // Try to fetch Firestore profile for name/phone (best-effort).
      Map<String, dynamic>? profile;
      try {
        profile = await FirestoreService.getUserProfile(user.uid);
      } catch (_) {}

      await SessionService.startUser(
        uid: user.uid,
        name: profile?['name'] as String? ?? user.displayName ?? '',
        email: user.email ?? email.trim().toLowerCase(),
        phone: profile?['phone'] as String?,
      );

      if (wasGuest) {
        // Reassign guest SQLite records to this UID, then push to Firestore.
        SyncService.migrateAndSync(user.uid); // fire-and-forget
      } else {
        // Pull records created on other devices.
        SyncService.fullPull(user.uid); // fire-and-forget
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (_) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final wasGuest = SessionService.isGuest;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
      final user = credential.user!;
      await user.updateDisplayName(name.trim());

      await FirestoreService.saveUserProfile(
        uid: user.uid,
        name: name.trim().toUpperCase(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
      );

      await SessionService.startUser(
        uid: user.uid,
        name: name.trim().toUpperCase(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
      );

      if (wasGuest) {
        SyncService.migrateAndSync(user.uid); // fire-and-forget
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (_) {
      return 'Registration failed. Please try again.';
    }
  }

  static Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (_) {
      return 'Could not send reset email. Please try again.';
    }
  }

  static Future<void> logout() async {
    if (!SessionService.isGuest) {
      await _auth.signOut();
    }
    await SessionService.clear();
  }

  /// Permanently delete the Firebase account and all local data for the user.
  ///
  /// Firebase requires a recent sign-in; if the token is stale this returns
  /// an error message instead of throwing.
  static Future<String?> deleteAccount() async {
    final user = _auth.currentUser;
    final userId = SessionService.userId;
    try {
      if (user != null) {
        await user.delete();
      }
      if (userId != null) {
        await AppDatabase.deleteAllUserData(userId);
      }
      await SessionService.clear();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Please sign out and sign in again before deleting your account.';
      }
      return _authErrorMessage(e.code);
    } catch (_) {
      return 'Failed to delete account. Please try again.';
    }
  }

  // ── Error mapping ──────────────────────────────────────────────────────────

  static String _authErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
