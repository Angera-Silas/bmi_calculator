import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'firestore_service.dart';
import 'session_service.dart';
import 'sync_service.dart';
import 'validation_service.dart';
import 'rate_limit_service.dart';
import 'security_logging_service.dart';
import 'notification_service.dart';
import '../database/app_database.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static final FacebookAuth _facebookAuth = FacebookAuth.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  static List<String> get linkedProviderIds =>
      (currentUser?.providerData ?? []).map((p) => p.providerId).toList();

  // ── Guest ──────────────────────────────────────────────────────────────────

  /// Start a local-only guest session. No Firebase account needed.
  static Future<void> loginAsGuest() async {
    await SessionService.startGuest();
    await SecurityLoggingService.logEvent(SecurityEvent(
      type: SecurityEventType.sessionCreated,
      identifier: SessionService.guestId,
      metadata: {'mode': 'guest'},
    ));
  }

  // ── Registered ────────────────────────────────────────────────────────────

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final identifier = email.trim().toLowerCase();

    // Rate limiting — block brute force attempts
    if (RateLimitService.isRateLimited(identifier)) {
      final wait = RateLimitService.getTimeUntilUnblock(identifier);
      final msg = wait != null
          ? 'Too many attempts. Try again in ${wait.inMinutes + 1} min.'
          : 'Too many attempts. Please try again later.';
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.suspiciousActivity,
        identifier: identifier,
        metadata: {'reason': 'rate_limit_blocked'},
      ));
      return msg;
    }

    // Validate input before processing
    final emailError = ValidationService.validateEmail(email);
    if (emailError != null) return emailError;

    final passwordError = ValidationService.validatePassword(password);
    if (passwordError != null) return passwordError;

    final wasGuest = SessionService.isGuest;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: identifier,
        password: password.trim(),
      );
      final user = credential.user!;

      RateLimitService.resetAttempts(identifier);
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.successfulLogin,
        identifier: identifier,
      ));

      // Try to fetch Firestore profile for name/phone (best-effort).
      Map<String, dynamic>? profile;
      try {
        profile = await FirestoreService.getUserProfile(user.uid);
      } catch (_) {}

      await SessionService.startUser(
        uid: user.uid,
        name: profile?['name'] as String? ?? user.displayName ?? '',
        email: user.email ?? identifier,
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
      RateLimitService.recordAttempt(identifier);
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.failedLogin,
        identifier: identifier,
        metadata: {'code': e.code},
      ));
      return _authErrorMessage(e.code);
    } catch (_) {
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.suspiciousActivity,
        identifier: identifier,
      ));
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // ── Social Authentication ──────────────────────────────────────────────

  static Future<String?> loginWithProvider(String provider) async {
    switch (provider) {
      case 'google':
        return loginWithGoogle();
      case 'apple':
        return loginWithApple();
      case 'facebook':
        return loginWithFacebook();
      case 'twitter':
        return loginWithTwitter();
      case 'microsoft':
        return loginWithMicrosoft();
      case 'github':
        return loginWithGitHub();
      case 'instagram':
      case 'tiktok':
        return '$provider sign-in requires a custom OAuth backend and is not configured yet.';
      default:
        return '$provider sign-in is not supported.';
    }
  }

  static Future<String?> loginWithGoogle() async {
    final wasGuest = SessionService.isGuest;
    try {
      await _googleSignIn.signOut(); // Ensure fresh account selection
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      await _completeSocialSignIn(
        user,
        wasGuest: wasGuest,
        defaultName: 'Google User',
      );

      return null;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      return 'Google sign-in failed: ${e.description ?? e.code.name}';
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
      String displayName = user.displayName ??
          '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
      if (displayName.isEmpty) displayName = 'Apple User';

      if (user.displayName == null) {
        await user.updateDisplayName(displayName);
      }
      await _completeSocialSignIn(
        user,
        wasGuest: wasGuest,
        defaultName: displayName,
      );

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

      await _completeSocialSignIn(
        user,
        wasGuest: wasGuest,
        defaultName:
            userData['name'] as String? ?? user.displayName ?? 'Facebook User',
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Facebook sign-in failed: ${e.toString()}';
    }
  }

  static Future<String?> loginWithGitHub() async {
    final provider = OAuthProvider('github.com');
    return _loginWithOAuthProvider(
      provider: provider,
      providerName: 'GitHub',
      defaultName: 'GitHub User',
    );
  }

  static Future<String?> loginWithTwitter() async {
    final provider = OAuthProvider('twitter.com');
    return _loginWithOAuthProvider(
      provider: provider,
      providerName: 'Twitter',
      defaultName: 'Twitter User',
    );
  }

  static Future<String?> loginWithMicrosoft() async {
    final provider = OAuthProvider('microsoft.com');
    return _loginWithOAuthProvider(
      provider: provider,
      providerName: 'Microsoft',
      defaultName: 'Microsoft User',
    );
  }

  static Future<String?> _loginWithOAuthProvider({
    required OAuthProvider provider,
    required String providerName,
    required String defaultName,
  }) async {
    final wasGuest = SessionService.isGuest;
    try {
      final userCredential = await _auth.signInWithProvider(provider);
      final user = userCredential.user;
      if (user == null) {
        return '$providerName sign-in failed. Please try again.';
      }
      await _completeSocialSignIn(
        user,
        wasGuest: wasGuest,
        defaultName: defaultName,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _authErrorMessage(e.code);
    } catch (e) {
      if (e.toString().contains('CANCELED')) {
        return null; // User cancelled
      }
      return '$providerName sign-in failed: ${e.toString()}';
    }
  }

  static Future<String?> linkGoogleAccount() async {
    if (currentUser == null) return 'No user logged in';
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await currentUser!.linkWithCredential(credential);
      return null;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      return 'Failed to link Google account: ${e.description ?? e.code.name}';
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

  static Future<String?> linkFacebookAccount() async {
    if (currentUser == null) return 'No user logged in';
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.cancelled) return null;
      if (result.status == LoginStatus.failed) {
        return 'Facebook login failed: ${result.message}';
      }

      final accessToken = result.accessToken;
      if (accessToken == null) {
        return 'Failed to get Facebook access token';
      }

      final credential =
          FacebookAuthProvider.credential(accessToken.tokenString);
      await currentUser!.linkWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        return 'This Facebook account is already linked to another account.';
      }
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Failed to link Facebook account: ${e.toString()}';
    }
  }

  static Future<String?> linkTwitterAccount() async {
    return _linkWithOAuthProvider('twitter.com', 'Twitter');
  }

  static Future<String?> linkMicrosoftAccount() async {
    return _linkWithOAuthProvider('microsoft.com', 'Microsoft');
  }

  static Future<String?> linkGitHubAccount() async {
    return _linkWithOAuthProvider('github.com', 'GitHub');
  }

  static Future<String?> linkSocialProvider(String provider) async {
    switch (provider) {
      case 'google':
        return linkGoogleAccount();
      case 'apple':
        return linkAppleAccount();
      case 'facebook':
        return linkFacebookAccount();
      case 'twitter':
        return linkTwitterAccount();
      case 'microsoft':
        return linkMicrosoftAccount();
      case 'github':
        return linkGitHubAccount();
      case 'instagram':
      case 'tiktok':
        return '$provider linking requires custom OAuth backend and is not configured yet.';
      default:
        return '$provider linking is not supported.';
    }
  }

  static Future<String?> _linkWithOAuthProvider(
    String providerId,
    String providerName,
  ) async {
    if (currentUser == null) return 'No user logged in';
    try {
      final provider = OAuthProvider(providerId);
      await currentUser!.linkWithProvider(provider);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        return 'This $providerName account is already linked to another account.';
      }
      return _authErrorMessage(e.code);
    } catch (e) {
      return 'Failed to link $providerName account: ${e.toString()}';
    }
  }

  static Future<String?> unlinkProvider(String providerId) async {
    if (currentUser == null) return 'No user logged in';
    try {
      // Ensure user has other authentication methods before unlinking
      final providers =
          currentUser!.providerData.map((p) => p.providerId).toList();
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
    final identifier = email.trim().toLowerCase();

    // Rate limiting — prevent registration abuse
    if (RateLimitService.isRateLimited(identifier,
        type: RateLimitType.registration)) {
      return 'Too many registration attempts. Please try again later.';
    }

    // Validate input before processing
    final nameError = ValidationService.validateName(name);
    if (nameError != null) return nameError;

    final emailError = ValidationService.validateEmail(email);
    if (emailError != null) return emailError;

    final phoneError = ValidationService.validatePhone(phone);
    if (phoneError != null) return phoneError;

    final passwordError = ValidationService.validatePassword(password);
    if (passwordError != null) return passwordError;

    final wasGuest = SessionService.isGuest;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: identifier,
        password: password.trim(),
      );
      final user = credential.user!;
      await user.updateDisplayName(name.trim());

      RateLimitService.resetAttempts(identifier,
          type: RateLimitType.registration);
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.successfulLogin,
        identifier: identifier,
        metadata: {'action': 'register'},
      ));

      await FirestoreService.saveUserProfile(
        uid: user.uid,
        name: name.trim().toUpperCase(),
        email: identifier,
        phone: phone.trim(),
      );

      await SessionService.startUser(
        uid: user.uid,
        name: name.trim().toUpperCase(),
        email: identifier,
        phone: phone.trim(),
      );

      if (wasGuest) {
        SyncService.migrateAndSync(user.uid); // fire-and-forget
      }

      return null;
    } on FirebaseAuthException catch (e) {
      RateLimitService.recordAttempt(identifier,
          type: RateLimitType.registration);
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.suspiciousActivity,
        identifier: identifier,
        metadata: {'code': e.code, 'action': 'register'},
      ));
      return _authErrorMessage(e.code);
    } catch (_) {
      return 'Registration failed. Please try again.';
    }
  }

  static Future<String?> sendPasswordReset(String email) async {
    final identifier = email.trim().toLowerCase();

    // Rate limiting — block password reset abuse
    if (RateLimitService.isRateLimited(identifier,
        type: RateLimitType.passwordReset)) {
      return 'Too many reset requests. Please try again later.';
    }

    final emailError = ValidationService.validateEmail(email);
    if (emailError != null) return emailError;

    try {
      await _auth.sendPasswordResetEmail(email: identifier);
      RateLimitService.resetAttempts(identifier,
          type: RateLimitType.passwordReset);
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.passwordReset,
        identifier: identifier,
      ));
      return null;
    } on FirebaseAuthException catch (e) {
      RateLimitService.recordAttempt(identifier,
          type: RateLimitType.passwordReset);
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.failedPasswordReset,
        identifier: identifier,
        metadata: {'code': e.code},
      ));
      return _authErrorMessage(e.code);
    } catch (_) {
      return 'Could not send reset email. Please try again.';
    }
  }

  static Future<void> logout() async {
    await SecurityLoggingService.logEvent(SecurityEvent(
      type: SecurityEventType.sessionInvalidated,
      identifier: SessionService.userId ?? SessionService.guestId,
    ));
    if (!SessionService.isGuest) {
      await _auth.signOut();
    }
    await NotificationService.cancelAll();
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
      await SecurityLoggingService.logEvent(SecurityEvent(
        type: SecurityEventType.accountDeletion,
        identifier: userId ?? SessionService.guestId,
      ));
      await NotificationService.cancelAll();
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

  static Future<void> _completeSocialSignIn(
    User user, {
    required bool wasGuest,
    required String defaultName,
  }) async {
    Map<String, dynamic>? profile;
    try {
      profile = await FirestoreService.getUserProfile(user.uid);
    } catch (_) {
      final email = user.email ?? '';
      final name = (user.displayName ?? defaultName).trim();
      await FirestoreService.saveUserProfile(
        uid: user.uid,
        name: name.isEmpty ? defaultName : name,
        email: email,
        phone: '',
      );
      profile = {
        'name': name.isEmpty ? defaultName : name,
        'email': email,
        'phone': '',
      };
    }

    await SessionService.startUser(
      uid: user.uid,
      name: profile?['name'] as String? ?? user.displayName ?? defaultName,
      email: user.email ?? (profile?['email'] as String? ?? ''),
      phone: profile?['phone'] as String?,
    );

    if (wasGuest) {
      SyncService.migrateAndSync(user.uid);
    } else {
      SyncService.fullPull(user.uid);
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
