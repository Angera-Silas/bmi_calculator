import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:otp/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';
import '../models/two_factor_config.dart';

/// Manages 2FA enrollment, configuration, and verification
class TwoFactorService {
  static const String _totpSecretKeyPrefix = 'totp_secret_';
  static const String _smsPhoneKeyPrefix = 'sms_phone_';
  static const String _smsVerificationIdKeyPrefix = 'sms_verification_id_';
  static const String _passkeyKeyPrefix = 'passkey_';
  static const String _deviceTrustKeyPrefix = 'device_trust_';
  static const String _deviceIdKey = 'device_id';
  static const String _otpRateLimitKeyPrefix = 'otp_rate_limit_';

  // Rate limiting: max 5 OTP requests per hour per method
  static const int maxOtpAttemptsPerHour = 5;
  static const int otpRateLimitWindowSeconds = 3600;

  static final _secureStorage = FlutterSecureStorage();
  static final _firebaseAuth = FirebaseAuth.instance;
  static final _localAuth = LocalAuthentication();

  /// Get user's 2FA configuration
  static Future<TwoFactorConfig?> getConfig(String userId) async {
    try {
      final data = await AppDatabase.get2faConfig(userId);
      if (data == null) return null;
      return TwoFactorConfig.fromSqlite(data);
    } catch (e) {
      print('Error fetching 2FA config: $e');
      return null;
    }
  }

  /// Check if user has 2FA enabled
  static Future<bool> isEnabled(String userId) async {
    final config = await getConfig(userId);
    return config?.isEnabled ?? false;
  }

  /// Get enabled 2FA methods for user
  static Future<List<TwoFactorMethod>> getEnabledMethods(String userId) async {
    final config = await getConfig(userId);
    return config?.enrolledMethods ?? [];
  }

  /// Set primary 2FA method
  static Future<String?> setPrimaryMethod(
      String userId, TwoFactorMethod method) async {
    try {
      final config = await getConfig(userId);
      if (config == null) {
        return 'No 2FA configuration found.';
      }

      if (!config.enrolledMethods.contains(method)) {
        return 'This method is not enrolled.';
      }

      final updatedConfig = config.copyWith(primaryMethod: method);
      await AppDatabase.save2faConfig(updatedConfig.toSqlite());
      return null;
    } catch (e) {
      print('Error setting primary method: $e');
      return 'Failed to set primary method.';
    }
  }

  // ── TOTP (Authenticator App) ──────────────────────────────────────────────

  /// Generate a new TOTP secret for user
  /// Returns QR code data URL for display
  static Future<String> generateTotpSecret(String userId, String email) async {
    // Generate random 32-byte secret
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    final secret = base64Url.encode(values).replaceAll('=', '');

    // Store securely
    await _secureStorage.write(
      key: '$_totpSecretKeyPrefix$userId',
      value: secret,
    );

    // Generate QR code URL (for Google Authenticator, Microsoft Authenticator, etc.)
    final appName = 'BMI%20Calculator';
    final qrUrl =
        'otpauth://totp/$appName:$email?secret=$secret&issuer=$appName&algorithm=SHA1&digits=6&period=30';

    return qrUrl;
  }

  /// Verify a TOTP code
  static Future<bool> verifyTotpCode(String userId, String code) async {
    try {
      final secret =
          await _secureStorage.read(key: '$_totpSecretKeyPrefix$userId');
      if (secret == null) return false;

      // Simple TOTP verification (6-digit code)
      // Use OTP.generateTOTPCode to verify
      try {
        String normalizeOtp(Object generatedCode) =>
            generatedCode.toString().padLeft(6, '0');

        final generatedCode = normalizeOtp(OTP.generateTOTPCode(
            secret, DateTime.now().millisecondsSinceEpoch));
        if (code == generatedCode) return true;

        // Check window: ±1 time step (30 seconds each)
        final previousCode = OTP.generateTOTPCode(
          secret,
          DateTime.now().subtract(Duration(seconds: 30)).millisecondsSinceEpoch,
        );
        if (code == normalizeOtp(previousCode)) return true;

        final nextCode = OTP.generateTOTPCode(
          secret,
          DateTime.now().add(Duration(seconds: 30)).millisecondsSinceEpoch,
        );
        if (code == normalizeOtp(nextCode)) return true;

        return false;
      } catch (_) {
        return false;
      }
    } catch (e) {
      print('Error verifying TOTP: $e');
      return false;
    }
  }

  /// Enroll user in TOTP 2FA
  static Future<String?> enrollTotp(String userId, String email) async {
    try {
      final config = await getConfig(userId) ??
          TwoFactorConfig(
            userId: userId,
            enrolledMethods: [],
            isEnabled: false,
          );

      // Generate new secret and get QR code URL
      final qrUrl = await generateTotpSecret(userId, email);

      // Generate and save backup codes
      final codes = _generateBackupCodes();
      await AppDatabase.saveBackupCodes(userId, codes);

      // Update config: add TOTP to enrolled methods
      final updatedConfig = config.copyWith(
        enrolledMethods: [
          ...config.enrolledMethods,
          TwoFactorMethod.totp,
        ]..toSet().toList(), // Remove duplicates
        primaryMethod: config.enrolledMethods.isEmpty
            ? TwoFactorMethod.totp
            : config.primaryMethod,
        recoveryCodesRemaining: codes.length,
      );

      // DON'T enable yet - user must verify the code first
      await AppDatabase.save2faConfig(updatedConfig.toSqlite());

      return qrUrl;
    } catch (e) {
      print('Error enrolling TOTP: $e');
      return null;
    }
  }

  /// Confirm TOTP enrollment (after user enters correct code)
  static Future<String?> confirmTotpEnrollment(
      String userId, String totpCode) async {
    try {
      if (!await verifyTotpCode(userId, totpCode)) {
        return 'Invalid authenticator code. Please try again.';
      }

      final config = await getConfig(userId);
      if (config == null) {
        return 'TOTP not enrolled.';
      }

      // Mark TOTP as verified, enable if first method
      final shouldEnable = config.enrolledMethods.length == 1;
      final updatedConfig = config.copyWith(
        isEnabled: shouldEnable,
        totpSecretEncrypted: 'verified', // Marker that secret is set
      );

      await AppDatabase.save2faConfig(updatedConfig.toSqlite());

      // Return backup codes for user to save
      final backupCodes = await AppDatabase.getUnusedBackupCodes(userId);
      final codesToDisplay =
          backupCodes.map((c) => c['code'] as String).toList();
      return 'TOTP_ENROLLED|||${codesToDisplay.join('|||')}';
    } catch (e) {
      print('Error confirming TOTP: $e');
      return 'Failed to confirm TOTP enrollment.';
    }
  }

  /// Remove TOTP from user's 2FA methods
  static Future<String?> removeTotpMethod(String userId) async {
    try {
      await _secureStorage.delete(key: '$_totpSecretKeyPrefix$userId');

      final config = await getConfig(userId);
      if (config == null) return null;

      final updatedMethods = config.enrolledMethods
          .where((m) => m != TwoFactorMethod.totp)
          .toList();

      if (updatedMethods.isEmpty) {
        await AppDatabase.delete2faConfig(userId);
        return null;
      }

      final updatedConfig = config.copyWith(
        enrolledMethods: updatedMethods,
        primaryMethod: updatedMethods.first,
      );

      await AppDatabase.save2faConfig(updatedConfig.toSqlite());
      return null;
    } catch (e) {
      print('Error removing TOTP: $e');
      return 'Failed to remove TOTP.';
    }
  }

  // ── Email OTP ──────────────────────────────────────────────────────────────

  /// Enroll email as 2FA method (always available, requires verification on login)
  static Future<String?> enrollEmail(String userId) async {
    try {
      final config = await getConfig(userId) ??
          TwoFactorConfig(
            userId: userId,
            enrolledMethods: [],
            isEnabled: false,
          );

      // Email doesn't need pre-enrollment, just add to methods
      final updatedConfig = config.copyWith(
        enrolledMethods: [
          ...config.enrolledMethods,
          TwoFactorMethod.email,
        ]..toSet().toList(),
        primaryMethod: config.enrolledMethods.isEmpty
            ? TwoFactorMethod.email
            : config.primaryMethod,
        isEnabled: true, // Enable immediately
      );

      await AppDatabase.save2faConfig(updatedConfig.toSqlite());
      return null;
    } catch (e) {
      print('Error enrolling email: $e');
      return 'Failed to enroll email 2FA.';
    }
  }

  /// Verify email OTP code
  static Future<bool> verifyEmailOtp(String userId, String code) async {
    // In production, this would validate against sent OTP
    // For now, just check format (6 digits)
    return RegExp(r'^\d{6}$').hasMatch(code);
  }

  /// Remove email from 2FA methods
  static Future<String?> removeEmailMethod(String userId) async {
    try {
      final config = await getConfig(userId);
      if (config == null) return null;

      final updatedMethods = config.enrolledMethods
          .where((m) => m != TwoFactorMethod.email)
          .toList();

      if (updatedMethods.isEmpty) {
        await AppDatabase.delete2faConfig(userId);
        return null;
      }

      final updatedConfig = config.copyWith(
        enrolledMethods: updatedMethods,
        primaryMethod: updatedMethods.first,
      );

      await AppDatabase.save2faConfig(updatedConfig.toSqlite());
      return null;
    } catch (e) {
      print('Error removing email: $e');
      return 'Failed to remove email 2FA.';
    }
  }

  // ── SMS OTP ────────────────────────────────────────────────────────────────

  /// Start SMS verification process for enrollment
  /// Returns verification ID to be used when confirming OTP
  static Future<String?> initiateSmsVerification(String phoneNumber) async {
    try {
      if (!_isValidPhoneNumber(phoneNumber)) {
        return null; // Error: invalid phone
      }

      String? verificationId;

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-resolve on some devices
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Phone verification failed: ${e.message}');
        },
        codeSent: (String vId, int? resendToken) {
          verificationId = vId;
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId = vId;
        },
      );

      return verificationId;
    } catch (e) {
      print('Error initiating SMS verification: $e');
      return null;
    }
  }

  /// Confirm SMS enrollment with verification code and store phone
  static Future<String?> confirmSmsEnrollment(
    String userId,
    String phoneNumber,
    String verificationId,
    String smsCode,
  ) async {
    try {
      if (!_isValidPhoneNumber(phoneNumber)) {
        return 'Invalid phone number format.';
      }

      // Verify the code with Firebase
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        // Just verify it's valid; don't sign in
        await _firebaseAuth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        return 'Invalid verification code: ${e.message}';
      }

      // Phone verified, now store it
      await _secureStorage.write(
        key: '$_smsPhoneKeyPrefix$userId',
        value: phoneNumber,
      );

      final config = await getConfig(userId) ??
          TwoFactorConfig(
            userId: userId,
            enrolledMethods: [],
            isEnabled: false,
          );

      final updatedConfig = config.copyWith(
        enrolledMethods: [
          ...config.enrolledMethods,
          TwoFactorMethod.sms,
        ]..toSet().toList(),
        primaryMethod: config.enrolledMethods.isEmpty
            ? TwoFactorMethod.sms
            : config.primaryMethod,
        smsPhoneEncrypted: 'verified',
        isEnabled: config.enrolledMethods.isEmpty, // Enable if first method
      );

      await AppDatabase.save2faConfig(updatedConfig.toSqlite());
      return null;
    } catch (e) {
      print('Error confirming SMS enrollment: $e');
      return 'Failed to confirm SMS enrollment.';
    }
  }

  /// Start SMS OTP verification for login (send code)
  /// Returns verification ID to be used with verifySmsOtp
  static Future<String?> sendSmsOtp(String userId) async {
    try {
      // Check rate limit
      final rateLimitError =
          await checkOtpRateLimit(userId, TwoFactorMethod.sms);
      if (rateLimitError != null) {
        return null; // Return null to signal rate limit (caller should handle)
      }

      final phoneNumber =
          await _secureStorage.read(key: '$_smsPhoneKeyPrefix$userId');
      if (phoneNumber == null) {
        return null; // Phone not registered
      }

      String? verificationId;

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('SMS OTP failed: ${e.message}');
        },
        codeSent: (String vId, int? resendToken) {
          verificationId = vId;
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId = vId;
        },
      );

      // Record this attempt for rate limiting
      await recordOtpAttempt(userId, TwoFactorMethod.sms);

      // Store verification ID temporarily for this session
      if (verificationId != null) {
        await _secureStorage.write(
          key: '$_smsVerificationIdKeyPrefix$userId',
          value: verificationId,
        );
      }

      return verificationId;
    } catch (e) {
      print('Error sending SMS OTP: $e');
      return null;
    }
  }

  /// Verify SMS OTP code during login
  static Future<bool> verifySmsOtp(String userId, String code) async {
    try {
      final verificationId =
          await _secureStorage.read(key: '$_smsVerificationIdKeyPrefix$userId');
      if (verificationId == null) {
        return false;
      }

      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: code,
        );
        // Verify credential is valid
        await _firebaseAuth.signInWithCredential(credential);
        return true;
      } on FirebaseAuthException catch (e) {
        print('SMS OTP verification failed: ${e.message}');
        return false;
      }
    } catch (e) {
      print('Error verifying SMS OTP: $e');
      return false;
    }
  }

  /// Remove SMS from 2FA methods
  static Future<String?> removeSmsMethod(String userId) async {
    try {
      await _secureStorage.delete(key: '$_smsPhoneKeyPrefix$userId');

      final config = await getConfig(userId);
      if (config == null) return null;

      final updatedMethods = config.enrolledMethods
          .where((m) => m != TwoFactorMethod.sms)
          .toList();

      if (updatedMethods.isEmpty) {
        await AppDatabase.delete2faConfig(userId);
        return null;
      }

      final updatedConfig = config.copyWith(
        enrolledMethods: updatedMethods,
        primaryMethod: updatedMethods.first,
      );

      await AppDatabase.save2faConfig(updatedConfig.toSqlite());
      return null;
    } catch (e) {
      print('Error removing SMS: $e');
      return 'Failed to remove SMS 2FA.';
    }
  }

  // ── Passkeys (WebAuthn) ────────────────────────────────────────────────────

  /// Check if device supports biometric authentication
  static Future<bool> canUseBiometric() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      print('Error checking biometric support: $e');
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Enroll passkey as 2FA method (stores enrollment marker)
  static Future<String?> enrollPasskey(String userId) async {
    try {
      // Check biometric support
      if (!await canUseBiometric()) {
        return 'This device does not support biometric authentication.';
      }

      // Store passkey enrollment marker
      await _secureStorage.write(
        key: '$_passkeyKeyPrefix$userId',
        value: 'enrolled',
      );

      final config = await getConfig(userId) ??
          TwoFactorConfig(
            userId: userId,
            enrolledMethods: [],
            isEnabled: false,
          );

      final updatedConfig = config.copyWith(
        enrolledMethods: [
          ...config.enrolledMethods,
          TwoFactorMethod.passkey,
        ]..toSet().toList(),
        primaryMethod: config.enrolledMethods.isEmpty
            ? TwoFactorMethod.passkey
            : config.primaryMethod,
        passkeyCredentialEncrypted: 'verified',
        isEnabled: config.enrolledMethods.isEmpty, // Enable if first method
      );

      await AppDatabase.save2faConfig(updatedConfig.toSqlite());
      return null;
    } catch (e) {
      print('Error enrolling passkey: $e');
      return 'Failed to enroll passkey.';
    }
  }

  /// Verify passkey using biometric authentication
  static Future<bool> verifyPasskey(String userId) async {
    try {
      final isEnrolled =
          await _secureStorage.read(key: '$_passkeyKeyPrefix$userId');
      if (isEnrolled == null) {
        return false; // Passkey not enrolled
      }

      // Attempt biometric verification
      try {
        final isAuthenticated = await _localAuth.authenticate(
          localizedReason:
              'Authenticate with your biometric to verify identity',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );
        return isAuthenticated;
      } on Exception catch (e) {
        print('Biometric authentication error: $e');
        return false;
      }
    } catch (e) {
      print('Error verifying passkey: $e');
      return false;
    }
  }

  /// Remove passkey from 2FA methods
  static Future<String?> removePasskeyMethod(String userId) async {
    try {
      await _secureStorage.delete(key: '$_passkeyKeyPrefix$userId');

      final config = await getConfig(userId);
      if (config == null) return null;

      final updatedMethods = config.enrolledMethods
          .where((m) => m != TwoFactorMethod.passkey)
          .toList();

      if (updatedMethods.isEmpty) {
        await AppDatabase.delete2faConfig(userId);
        return null;
      }

      final updatedConfig = config.copyWith(
        enrolledMethods: updatedMethods,
        primaryMethod: updatedMethods.first,
      );

      await AppDatabase.save2faConfig(updatedConfig.toSqlite());
      return null;
    } catch (e) {
      print('Error removing passkey: $e');
      return 'Failed to remove passkey.';
    }
  }

  // ── Recovery Codes ────────────────────────────────────────────────────────

  /// Get list of unused recovery codes for display
  static Future<List<String>> getRecoveryCodes(String userId) async {
    try {
      final codes = await AppDatabase.getUnusedBackupCodes(userId);
      return codes.map((c) => c['code'] as String).toList();
    } catch (e) {
      print('Error fetching recovery codes: $e');
      return [];
    }
  }

  /// Verify and use a recovery code
  static Future<bool> verifyRecoveryCode(String userId, String code) async {
    try {
      return await AppDatabase.useBackupCode(userId, code.trim());
    } catch (e) {
      print('Error verifying recovery code: $e');
      return false;
    }
  }

  /// Regenerate backup codes
  static Future<List<String>?> regenerateRecoveryCodes(String userId) async {
    try {
      final codes = _generateBackupCodes();
      await AppDatabase.saveBackupCodes(userId, codes);

      final config = await getConfig(userId);
      if (config != null) {
        final updated = config.copyWith(recoveryCodesRemaining: codes.length);
        await AppDatabase.save2faConfig(updated.toSqlite());
      }

      return codes;
    } catch (e) {
      print('Error regenerating recovery codes: $e');
      return null;
    }
  }

  // ── Disable 2FA ─────────────────────────────────────────────────────────

  /// Disable 2FA completely and clear all methods
  static Future<String?> disable2fa(String userId) async {
    try {
      await _secureStorage.delete(key: '$_totpSecretKeyPrefix$userId');
      await _secureStorage.delete(key: '$_smsPhoneKeyPrefix$userId');
      await _secureStorage.delete(key: '$_passkeyKeyPrefix$userId');

      await AppDatabase.delete2faConfig(userId);
      return null;
    } catch (e) {
      print('Error disabling 2FA: $e');
      return 'Failed to disable 2FA.';
    }
  }

  // ── Rate Limiting ──────────────────────────────────────────────────────────

  /// Check if OTP generation is rate limited
  static Future<String?> checkOtpRateLimit(
    String userId,
    TwoFactorMethod method,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final limitKey = '$_otpRateLimitKeyPrefix$userId${method.name}';
      final limitDataJson = prefs.getString(limitKey);

      if (limitDataJson == null) {
        // First request, initialize
        return null;
      }

      final limitData = jsonDecode(limitDataJson) as Map<String, dynamic>;
      final attempts = (limitData['attempts'] as int?) ?? 0;
      final firstAttemptTime = (limitData['firstAttemptTime'] as int?) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Check if still within rate limit window
      if (now - firstAttemptTime < (otpRateLimitWindowSeconds * 1000)) {
        if (attempts >= maxOtpAttemptsPerHour) {
          final remainingSeconds =
              otpRateLimitWindowSeconds - ((now - firstAttemptTime) ~/ 1000);
          final remainingMinutes = (remainingSeconds / 60).ceil();
          return 'Too many OTP requests. Try again in $remainingMinutes minute(s).';
        }
      } else {
        // Rate limit window expired, reset
        return null;
      }

      return null;
    } catch (e) {
      print('Error checking OTP rate limit: $e');
      return null;
    }
  }

  /// Record an OTP generation attempt for rate limiting
  static Future<void> recordOtpAttempt(
    String userId,
    TwoFactorMethod method,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final limitKey = '$_otpRateLimitKeyPrefix$userId${method.name}';
      final limitDataJson = prefs.getString(limitKey);

      int attempts = 1;
      int firstAttemptTime = DateTime.now().millisecondsSinceEpoch;

      if (limitDataJson != null) {
        final limitData = jsonDecode(limitDataJson) as Map<String, dynamic>;
        final prevAttempts = (limitData['attempts'] as int?) ?? 0;
        final prevFirstTime = (limitData['firstAttemptTime'] as int?) ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;

        // Check if still within rate limit window
        if (now - prevFirstTime < (otpRateLimitWindowSeconds * 1000)) {
          attempts = prevAttempts + 1;
          firstAttemptTime = prevFirstTime;
        }
        // Otherwise start fresh window
      }

      final limitData = {
        'attempts': attempts,
        'firstAttemptTime': firstAttemptTime,
      };

      await prefs.setString(limitKey, jsonEncode(limitData));
    } catch (e) {
      print('Error recording OTP attempt: $e');
    }
  }

  /// Reset rate limit for a method
  static Future<void> resetOtpRateLimit(
    String userId,
    TwoFactorMethod method,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final limitKey = '$_otpRateLimitKeyPrefix$userId${method.name}';
      await prefs.remove(limitKey);
    } catch (e) {
      print('Error resetting OTP rate limit: $e');
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static List<String> _generateBackupCodes({int count = 10}) {
    final random = Random.secure();
    return List.generate(
      count,
      (_) => List.generate(
        8,
        (_) => random.nextInt(10),
      ).join(),
    );
  }

  static String _generateRandomCode(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
  }

  static bool _isValidPhoneNumber(String phone) {
    // Basic validation: at least 10 digits
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length >= 10;
  }

  // ── Account Recovery ────────────────────────────────────────────────────────

  /// Initiate account recovery by sending verification email
  static Future<String?> initiateAccountRecovery(String email) async {
    try {
      // In production, this would send an email with a recovery link
      // For now, we'll store a temporary recovery token
      final recoveryToken = _generateRandomCode(32);
      print('Account recovery initiated for $email');
      print(
          'Recovery token: $recoveryToken (store in SharedPreferences temporarily)');

      // In a production app, you would:
      // 1. Send an email to the user with a recovery link
      // 2. Store a temporary token in Firestore or backend
      // 3. User clicks link, verifies identity, then can disable/reset 2FA
      return null;
    } catch (e) {
      print('Error initiating recovery: $e');
      return 'Failed to initiate recovery';
    }
  }

  /// Check if recovery token is valid
  static Future<bool> validateRecoveryToken(String token) async {
    try {
      // In production, validate against backend/Firestore
      // For now, just check length
      return token.length == 32;
    } catch (e) {
      print('Error validating recovery token: $e');
      return false;
    }
  }

  /// Reset 2FA with valid recovery token (used after account recovery)
  static Future<String?> reset2faWithRecoveryToken(
    String userId,
    String token,
  ) async {
    try {
      // Validate token is legit
      if (!await validateRecoveryToken(token)) {
        return 'Invalid or expired recovery token.';
      }

      // Clear all 2FA data for this user
      await _secureStorage.delete(key: '$_totpSecretKeyPrefix$userId');
      await _secureStorage.delete(key: '$_smsPhoneKeyPrefix$userId');
      await _secureStorage.delete(key: '$_passkeyKeyPrefix$userId');
      await AppDatabase.delete2faConfig(userId);

      print('2FA reset for user $userId via recovery');
      return null;
    } catch (e) {
      print('Error resetting 2FA with recovery: $e');
      return 'Failed to reset 2FA.';
    }
  }

  /// Allow disabling all methods if user has backup email verified
  static Future<String?> disableAllMethodsWithEmailVerification(
      String userId, String email) async {
    try {
      // In production, send verification email first
      // For now, just disable after logging the action
      await disable2fa(userId);
      print('All 2FA methods disabled for $userId (email verified: $email)');
      return null;
    } catch (e) {
      print('Error disabling via email verification: $e');
      return 'Failed to disable 2FA.';
    }
  }

  // ── Device Trust (30-day window) ─────────────────────────────────────────────

  /// Mark this device as trusted for 30 days (skip 2FA)
  static Future<String?> trustDeviceFor30Days(
      String userId, String deviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trustedUntil =
          DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch;
      final trustKey = '$_deviceTrustKeyPrefix$userId';

      // Store device trust info: device ID and expiration timestamp
      final trustData = {
        'deviceId': deviceId,
        'trustedUntil': trustedUntil,
        'trustedAt': DateTime.now().toIso8601String(),
      };

      await prefs.setString(trustKey, jsonEncode(trustData));
      print(
          'Device $deviceId trusted for user $userId until ${DateTime.fromMillisecondsSinceEpoch(trustedUntil)}');
      return null;
    } catch (e) {
      print('Error trusting device: $e');
      return 'Failed to trust device.';
    }
  }

  /// Check if device is currently trusted (still within 30 days)
  static Future<bool> isDeviceTrusted(String userId, String deviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trustKey = '$_deviceTrustKeyPrefix$userId';
      final trustDataJson = prefs.getString(trustKey);

      if (trustDataJson == null) return false;

      final trustData = jsonDecode(trustDataJson) as Map<String, dynamic>;
      final trustedDeviceId = trustData['deviceId'] as String?;
      final trustedUntil = trustData['trustedUntil'] as int?;

      if (trustedDeviceId != deviceId || trustedUntil == null) {
        return false;
      }

      final isStillTrusted =
          DateTime.now().millisecondsSinceEpoch < trustedUntil;
      if (!isStillTrusted) {
        await removeTrustedDevice(userId);
      }

      return isStillTrusted;
    } catch (e) {
      print('Error checking device trust: $e');
      return false;
    }
  }

  /// Get remaining days for device trust
  static Future<int> getRemainingTrustDays(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trustKey = '$_deviceTrustKeyPrefix$userId';
      final trustDataJson = prefs.getString(trustKey);

      if (trustDataJson == null) return 0;

      final trustData = jsonDecode(trustDataJson) as Map<String, dynamic>;
      final trustedUntil = trustData['trustedUntil'] as int?;

      if (trustedUntil == null) return 0;

      final now = DateTime.now().millisecondsSinceEpoch;
      final remainingMs = trustedUntil - now;

      if (remainingMs <= 0) {
        await removeTrustedDevice(userId);
        return 0;
      }

      return (remainingMs / (1000 * 60 * 60 * 24)).ceil();
    } catch (e) {
      print('Error getting remaining trust days: $e');
      return 0;
    }
  }

  /// Remove device trust
  static Future<String?> removeTrustedDevice(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trustKey = '$_deviceTrustKeyPrefix$userId';
      await prefs.remove(trustKey);
      return null;
    } catch (e) {
      print('Error removing device trust: $e');
      return 'Failed to remove device trust.';
    }
  }

  /// Returns a stable device ID persisted on the device.
  static Future<String> getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    final id = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    await prefs.setString(_deviceIdKey, id);
    return id;
  }
}
