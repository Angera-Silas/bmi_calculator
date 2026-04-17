import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'firestore_service.dart';
import 'session_service.dart';
import 'sync_service.dart';
import '../database/app_database.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FacebookAuth _facebookAuth = FacebookAuth.instance;

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

  // ── Social Authentication ──────────────────────────────────────────────

  static Future<String?> loginWithGoogle() async {
    final wasGuest = SessionService.isGuest;
    try {
      await _googleSignIn.signOut(); // Ensure fresh account selection
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Fetch or create Firestore profile
      Map<String, dynamic>? profile;
      try {
        profile = await FirestoreService.getUserProfile(user.uid);
      } catch (_) {
        // First time login: create profile
        await FirestoreService.saveUserProfile(
          uid: user.uid,
          name: user.displayName ?? 'Google User',
          email: user.email ?? '',
          phone: '',
        );
        profile = {
          'name': user.displayName ?? 'Google User',
          'email': user.email ?? '',
          'phone': '',
        };
      }

      await SessionService.startUser(
        uid: user.uid,
        name: profile?['name'] as String? ?? user.displayName ?? '',
        email: user.email ?? '',
        phone: profile?['phone'] as String?,
      );

      if (wasGuest) {
        SyncService.migrateAndSync(user.uid);
      } else {
        SyncService.fullPull(user.uid);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Google sign-in failed: ${e.toString()}';
    }
  }

  static Future<String?> loginWithApple() async {
    final wasGuest = SessionService.isGuest;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);
      final user = userCredential.user!;

      // Update profile with Apple data if first time
      String displayName =
          user.displayName ?? '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
      if (displayName.isEmpty) displayName = 'Apple User';

      if (user.displayName == null) {
        await user.updateDisplayName(displayName);
      }

      // Fetch or create Firestore profile
      Map<String, dynamic>? profile;
      try {
        profile = await FirestoreService.getUserProfile(user.uid);
      } catch (_) {
        await FirestoreService.saveUserProfile(
          uid: user.uid,
          name: displayName,
          email: user.email ?? credential.email ?? '',
          phone: '',
        );
        profile = {
          'name': displayName,
          'email': user.email ?? credential.email ?? '',
          'phone': '',
        };
      }

      await SessionService.startUser(
        uid: user.uid,
        name: profile?['name'] as String? ?? displayName,
        email: user.email ?? credential.email ?? '',
        phone: profile?['phone'] as String?,
      );

      if (wasGuest) {
        SyncService.migrateAndSync(user.uid);
      } else {
        SyncService.fullPull(user.uid);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Apple sign-in failed: ${e.toString()}';
    }
  }

  static Future<String?> loginWithFacebook() async {
    final wasGuest = SessionService.isGuest;
    try {
      final LoginResult result = await _facebookAuth.login();

      if (result.status == LoginStatus.cancelled) {
        return null; // User cancelled
      }

      if (result.status == LoginStatus.failed) {
        return 'Facebook login failed: ${result.message}';
      }

      final AccessToken? accessToken = result.accessToken;
      if (accessToken == null) {
        return 'Failed to get Facebook access token';
      }

      final credential =
          FacebookAuthProvider.credential(accessToken.tokenString);

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Fetch user data from Facebook
      final userData = await _facebookAuth.getUserData(
        fields: 'email,name,picture',
      );

      // Fetch or create Firestore profile
      Map<String, dynamic>? profile;
      try {
        profile = await FirestoreService.getUserProfile(user.uid);
      } catch (_) {
        await FirestoreService.saveUserProfile(
          uid: user.uid,
          name: userData['name'] as String? ?? user.displayName ?? 'Facebook User',
          email: user.email ?? userData['email'] as String? ?? '',
          phone: '',
        );
        profile = {
          'name': userData['name'] as String? ?? user.displayName ?? 'Facebook User',
          'email': user.email ?? userData['email'] as String? ?? '',
          'phone': '',
        };
      }

      await SessionService.startUser(
        uid: user.uid,
        name: profile?['name'] as String? ?? 'Facebook User',
        email: user.email ?? '',
        phone: profile?['phone'] as String?,
      );

      if (wasGuest) {
        SyncService.migrateAndSync(user.uid);
      } else {
        SyncService.fullPull(user.uid);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Facebook sign-in failed: ${e.toString()}';
    }
  }

  static Future<String?> loginWithGitHub() async {
    final wasGuest = SessionService.isGuest;
    try {
      const String callbackUrlScheme = 'bmicalculator';
      final result = await FlutterWebAuth2.authenticate(
        url: 'https://github.com/login/oauth/authorize?client_id=YOUR_GITHUB_CLIENT_ID&scope=user:email',
        callbackUrlScheme: callbackUrlScheme,
      );

      // Extract code from callback URL
      final Uri uri = Uri.parse(result);
      final String? code = uri.queryParameters['code'];

      if (code == null) {
        return 'GitHub authentication failed: No authorization code received';
      }

      // Note: In production, you would exchange this code for an access token
      // on your backend server, then use that to create a Firebase custom token.
      // For now, we'll return an error indicating this needs backend implementation.

      return 'GitHub authentication requires backend implementation';
    } catch (e) {
      if (e.toString().contains('CANCELED')) {
        return null; // User cancelled
      }
      return 'GitHub sign-in failed: ${e.toString()}';
    }
  }

  static Future<String?> linkGoogleAccount() async {
    if (currentUser == null) return 'No user logged in';
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await currentUser!.linkWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        return 'This Google account is already linked to another account.';
      }
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Failed to link Google account: ${e.toString()}';
    }
  }

  static Future<String?> linkAppleAccount() async {
    if (currentUser == null) return 'No user logged in';
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await currentUser!.linkWithCredential(oauthCredential);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        return 'This Apple account is already linked to another account.';
      }
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Failed to link Apple account: ${e.toString()}';
    }
  }

  static Future<String?> unlinkProvider(String providerId) async {
    if (currentUser == null) return 'No user logged in';
    try {
      // Ensure user has other authentication methods before unlinking
      final providers = currentUser!.providerData.map((p) => p.providerId).toList();
      if (providers.length <= 1) {
        return 'Cannot unlink the only authentication method. Add another method first.';
      }

      await currentUser!.unlink(providerId);
      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Failed to unlink provider: ${e.toString()}';
    }
  }

  // ── Registered (Email/Password) ─────────────────────────────────────────

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
