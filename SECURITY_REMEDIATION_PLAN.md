# Security Remediation Plan

**Project:** BMI Calculator Flutter App  
**Date:** September 5, 2026  
**Based on:** Security Audit Findings  
**Timeline:** 8 Weeks  
**Priority:** Critical

---

## Executive Summary

This remediation plan addresses the security vulnerabilities identified in the security audit. The plan prioritizes critical and high-severity vulnerabilities for immediate remediation, followed by systematic implementation of medium and low-priority fixes.

**Remediation Goals:**
- Eliminate all critical and high-severity vulnerabilities
- Achieve GDPR compliance
- Prepare for HIPAA readiness
- Establish ongoing security monitoring
- Reduce overall risk from Moderate to Low

---

## Phase 1: Critical Fixes (Week 2)

### P0-001: Remove Hardcoded Firebase API Keys

**Current Status:** 🔴 Critical  
**Target:** ✅ Resolved  
**Timeline:** Week 2, Days 1-2

#### Implementation Steps

1. **Environment Variable Setup**
   ```bash
   # Create .env file
   echo "FIREBASE_API_KEY_ANDROID=your_android_key" > .env
   echo "FIREBASE_API_KEY_IOS=your_ios_key" >> .env
   echo "FIREBASE_PROJECT_ID=flutterapps-db036" >> .env
   ```

2. **Update Dependencies**
   ```yaml
   # pubspec.yaml
   dependencies:
     flutter_dotenv: ^5.1.0
     flutter_secure_storage: ^9.2.2
   ```

3. **Create Secure Configuration Service**
   ```dart
   // lib/services/secure_config_service.dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';
   import 'package:flutter_secure_storage/flutter_secure_storage.dart';

   class SecureConfigService {
     static const _storage = FlutterSecureStorage();
     
     static Future<void> initialize() async {
       await DotEnv.load(fileName: '.env');
     }
     
     static String get firebaseApiKeyAndroid {
       return DotEnv.env['FIREBASE_API_KEY_ANDROID'] ?? '';
     }
     
     static String get firebaseApiKeyIOS {
       return DotEnv.env['FIREBASE_API_KEY_IOS'] ?? '';
     }
     
     static String get firebaseProjectId {
       return DotEnv.env['FIREBASE_PROJECT_ID'] ?? 'flutterapps-db036';
     }
   }
   ```

4. **Update Firebase Options**
   ```dart
   // lib/firebase_options.dart
   import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
   import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
   import 'secure_config_service.dart';

   class DefaultFirebaseOptions {
     static FirebaseOptions get currentPlatform {
       if (kIsWeb) {
         throw UnsupportedError('DefaultFirebaseOptions have not been configured for web');
       }
       
       switch (defaultTargetPlatform) {
         case TargetPlatform.android:
           return _android;
         case TargetPlatform.iOS:
           return _ios;
         default:
           throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform');
       }
     }
     
     static FirebaseOptions get _android => FirebaseOptions(
       apiKey: SecureConfigService.firebaseApiKeyAndroid,
       appId: '1:1058678501857:android:4070fd457b1589b47fa2a0',
       messagingSenderId: '1058678501857',
       projectId: SecureConfigService.firebaseProjectId,
       databaseURL: 'https://flutterapps-db036-default-rtdb.firebaseio.com',
       storageBucket: 'flutterapps-db036.appspot.com',
     );
     
     static FirebaseOptions get _ios => FirebaseOptions(
       apiKey: SecureConfigService.firebaseApiKeyIOS,
       appId: '1:1058678501857:ios:8dd034c0c52893067fa2a0',
       messagingSenderId: '1058678501857',
       projectId: SecureConfigService.firebaseProjectId,
       databaseURL: 'https://flutterapps-db036-default-rtdb.firebaseio.com',
       storageBucket: 'flutterapps-db036.appspot.com',
       iosClientId: '1058678501857-s7pdncseqdfargpf0ik77a67jdlfurlj.apps.googleusercontent.com',
       iosBundleId: 'com.angerasilas.bmiCalculator',
     );
   }
   ```

5. **Add to .gitignore**
   ```
   # Environment variables
   .env
   .env.local
   .env.*.local
   ```

6. **Firebase App Check Integration**
   ```dart
   // lib/main.dart
   import 'package:firebase_app_check/firebase_app_check.dart';

   Future<void> initializeFirebase() async {
     await Firebase.initializeApp();
     
     // Activate App Check
     await FirebaseAppCheck.instance.activate(
       webRecaptchaSiteKey: 'your-recaptcha-site-key',
       androidProvider: AndroidProvider.debug,
     );
   }
   ```

#### Testing Requirements
- [ ] Verify Firebase initialization works with environment variables
- [ ] Test App Check integration
- [ ] Validate .env file is properly excluded from git
- [ ] Test build process with secure configuration

#### Acceptance Criteria
- [ ] No hardcoded API keys in source code
- [ ] Environment variables properly configured
- [ ] Firebase initialization works correctly
- [ ] App Check functional
- [ ] Build process secure

---

## Phase 2: High Priority Fixes (Week 2-3)

### P1-001: Implement Comprehensive Input Validation

**Current Status:** 🟠 High  
**Target:** ✅ Resolved  
**Timeline:** Week 2, Days 3-4

#### Implementation Steps

1. **Create Validation Service**
   ```dart
   // lib/services/validation_service.dart
   class ValidationService {
     static final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
     static final _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
     
     static String? validateEmail(String email) {
       if (email.isEmpty) return 'Email is required';
       if (!_emailRegex.hasMatch(email)) return 'Invalid email format';
       if (email.length > 254) return 'Email too long';
       return null;
     }
     
     static String? validatePassword(String password) {
       if (password.isEmpty) return 'Password is required';
       if (password.length < 8) return 'Password must be at least 8 characters';
       if (!_passwordRegex.hasMatch(password)) {
         return 'Password must contain uppercase, lowercase, number, and special character';
       }
       if (password.length > 128) return 'Password too long';
       return null;
     }
     
     static String? validateHeight(int height) {
       if (height < 50 || height > 300) return 'Height must be between 50-300 cm';
       return null;
     }
     
     static String? validateWeight(int weight) {
       if (weight < 20 || weight > 300) return 'Weight must be between 20-300 kg';
       return null;
     }
     
     static String? validateAge(int age) {
       if (age < 2 || age > 120) return 'Age must be between 2-120 years';
       return null;
     }
   }
   ```

2. **Update Authentication Service**
   ```dart
   // lib/services/auth_service.dart
   static Future<String?> login({
     required String email,
     required String password,
   }) async {
     // Validate input
     final emailError = ValidationService.validateEmail(email);
     if (emailError != null) return emailError;
     
     final passwordError = ValidationService.validatePassword(password);
     if (passwordError != null) return passwordError;
     
     final wasGuest = SessionService.isGuest;
     try {
       final credential = await _auth.signInWithEmailAndPassword(
         email: email.trim().toLowerCase(),
         password: password.trim(),
       );
       // ... rest of the method
     } on FirebaseAuthException catch (e) {
       return _authErrorMessage(e.code);
     } catch (_) {
       return 'An unexpected error occurred. Please try again.';
     }
   }
   ```

3. **Add Rate Limiting**
   ```dart
   // lib/services/rate_limit_service.dart
   class RateLimitService {
     static final Map<String, List<DateTime>> _attempts = {};
     
     static bool isRateLimited(String identifier) {
       final now = DateTime.now();
       final attempts = _attempts[identifier] ?? [];
       
       // Remove attempts older than 15 minutes
       attempts.removeWhere((time) => now.difference(time).inMinutes > 15);
       
       // Check if too many attempts (more than 5 in 15 minutes)
       if (attempts.length >= 5) {
         return true;
       }
       
       return false;
     }
     
     static void recordAttempt(String identifier) {
       final attempts = _attempts[identifier] ?? [];
       attempts.add(DateTime.now());
       _attempts[identifier] = attempts;
     }
     
     static void resetAttempts(String identifier) {
       _attempts.remove(identifier);
     }
   }
   ```

#### Testing Requirements
- [ ] Test all validation functions with valid and invalid inputs
- [ ] Test rate limiting functionality
- [ ] Test edge cases (boundary values)
- [ ] Test with international email formats

#### Acceptance Criteria
- [ ] All input validation functions working
- [ ] Rate limiting prevents brute force attacks
- [ ] Error messages user-friendly
- [ ] Performance not degraded

---

### P1-002: Enhance Error Handling and Security Logging

**Current Status:** 🟠 High  
**Target:** ✅ Resolved  
**Timeline:** Week 2, Days 5-6

#### Implementation Steps

1. **Create Security Logging Service**
   ```dart
   // lib/services/security_logging_service.dart
   class SecurityLoggingService {
     static final List<SecurityEvent> _events = [];
     
     static void logEvent(SecurityEvent event) {
       _events.add(event);
       _persistEvent(event);
       _checkForAlerts(event);
     }
     
     static Future<void> _persistEvent(SecurityEvent event) async {
       // Store in database for audit trail
       await AppDatabase.insertSecurityEvent(event);
     }
     
     static void _checkForAlerts(SecurityEvent event) {
       // Check for suspicious patterns
       if (event.type == SecurityEventType.failedLogin) {
         _checkForBruteForce(event);
       }
     }
     
     static void _checkForBruteForce(SecurityEvent event) {
       final recentFailures = _events.where((e) => 
         e.type == SecurityEventType.failedLogin &&
         e.identifier == event.identifier &&
         DateTime.now().difference(e.timestamp).inMinutes < 15
       ).length;
       
       if (recentFailures >= 5) {
         _triggerSecurityAlert(SecurityAlertType.bruteForceDetected, event);
       }
     }
     
     static void _triggerSecurityAlert(SecurityAlertType type, SecurityEvent event) {
       // Send alert to monitoring system
       // Notify security team
       // Implement account lockout if needed
     }
   }
   
   enum SecurityEventType {
     successfulLogin,
     failedLogin,
     passwordChange,
     accountDeletion,
     dataAccess,
     suspiciousActivity,
   }
   
   class SecurityEvent {
     final SecurityEventType type;
     final String identifier;
     final DateTime timestamp;
     final Map<String, dynamic> metadata;
     
     SecurityEvent({
       required this.type,
       required this.identifier,
     }) : timestamp = DateTime.now(), metadata = {};
   }
   ```

2. **Update Error Handling**
   ```dart
   // lib/services/auth_service.dart
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
       
       SecurityLoggingService.logEvent(SecurityEvent(
         type: SecurityEventType.successfulLogin,
         identifier: email,
       ));
       
       // ... rest of the method
     } on FirebaseAuthException catch (e) {
       SecurityLoggingService.logEvent(SecurityEvent(
         type: SecurityEventType.failedLogin,
         identifier: email,
       ));
       
       return _authErrorMessage(e.code);
     } catch (e) {
       SecurityLoggingService.logEvent(SecurityEvent(
         type: SecurityEventType.suspiciousActivity,
         identifier: email,
       ));
       
       return 'An unexpected error occurred. Please try again.';
     }
   }
   ```

#### Testing Requirements
- [ ] Test security event logging
- [ ] Test alert triggering
- [ ] Test log persistence
- [ ] Test error handling with various scenarios

#### Acceptance Criteria
- [ ] Security events logged properly
- [ ] Alerts triggered for suspicious activities
- [ ] Error messages don't expose sensitive information
- [ ] Audit trail functional

---

### P1-003: Implement Secure Session Management

**Current Status:** 🟠 High  
**Target:** ✅ Resolved  
**Timeline:** Week 3, Days 1-2

#### Implementation Steps

1. **Update Session Service with Secure Storage**
   ```dart
   // lib/services/session_service.dart
   import 'package:flutter_secure_storage/flutter_secure_storage.dart';

   class SessionService {
     static const _storage = FlutterSecureStorage();
     static const _sessionDuration = Duration(hours: 24);
     
     static Future<void> _persistSecurely(String key, String value) async {
       await _storage.write(key: key, value: value);
     }
     
     static Future<String?> _readSecurely(String key) async {
       return await _storage.read(key: key);
     }
     
     static Future<void> _deleteSecurely(String key) async {
       await _storage.delete(key: key);
     }
     
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
       
       await _persistSecurely(_keyUserId, uid);
       await _persistSecurely(_keyIsGuest, 'false');
       await _persistSecurely(_key2faVerified, 'false');
       await _persistSecurely(_keyUserEmail, email);
       await _persistSecurely(_keySessionStart, _sessionStartTime!.toIso8601String());
       
       await AppDatabase.upsertUser(
         id: uid,
         name: name,
         email: email,
         phone: phone,
         isGuest: false,
       );
     }
     
     static Future<bool> isSessionValid() async {
       if (_sessionStartTime == null) {
         final startTimeStr = await _readSecurely(_keySessionStart);
         if (startTimeStr != null) {
           _sessionStartTime = DateTime.parse(startTimeStr);
         }
       }
       
       if (_sessionStartTime == null) return false;
       
       return DateTime.now().difference(_sessionStartTime!) < _sessionDuration;
     }
     
     static Future<void> invalidateSession() async {
       await clear();
       SecurityLoggingService.logEvent(SecurityEvent(
         type: SecurityEventType.suspiciousActivity,
         identifier: _userId ?? 'unknown',
       ));
     }
   }
   ```

2. **Add Session Expiration Check**
   ```dart
   // lib/main.dart
   Future<void> checkSessionValidity() async {
     if (!await SessionService.isSessionValid()) {
       await SessionService.invalidateSession();
       Navigator.pushReplacementNamed(context, '/login');
     }
   }
   ```

#### Testing Requirements
- [ ] Test secure storage functionality
- [ ] Test session expiration
- [ ] Test session invalidation
- [ ] Test session persistence across app restarts

#### Acceptance Criteria
- [ ] Session data stored securely
- [ ] Session expiration functional
- [ ] Session invalidation works properly
- [ ] Performance not degraded

---

## Phase 3: Medium Priority Fixes (Week 3-4)

### P2-001 to P2-005: Medium Priority Vulnerabilities

**Timeline:** Week 3-4  
**Implementation:** Sequential approach following similar patterns to high-priority fixes

#### Key Areas:
1. **Strengthen 2FA Security** - Encrypt TOTP secrets, secure backup codes
2. **Database Encryption** - Implement SQLCipher for health data
3. **Certificate Pinning** - Add SSL pinning for Firebase APIs
4. **Authorization Enhancement** - Strengthen Firebase rules and client-side checks

---

## Phase 4: Low Priority & Compliance (Week 5-8)

### P3-001 to P3-008: Low Priority Vulnerabilities

**Timeline:** Week 5-6  
**Focus:** Security hardening and device integrity

### Compliance Achievement

**Timeline:** Week 7-8  
**GDPR Compliance:** Week 7  
**HIPAA Readiness:** Week 8

---

## Success Metrics

### Pre-Remediation Baseline
- Critical Vulnerabilities: 1
- High Vulnerabilities: 3
- Medium Vulnerabilities: 5
- Low Vulnerabilities: 8
- Security Posture: Moderate Risk (5.5/10)

### Post-Remediation Targets
- Critical Vulnerabilities: 0
- High Vulnerabilities: 0
- Medium Vulnerabilities: <3
- Low Vulnerabilities: <5
- Security Posture: Low Risk (8.5/10)

---

## Testing Strategy

### Security Testing
- [ ] Penetration testing (Strix cloud)
- [ ] Vulnerability scanning
- [ ] Dependency security scanning
- [ ] Configuration security review

### Functional Testing
- [ ] All authentication flows
- [ ] Session management
- [ ] Input validation
- [ ] Error handling

### Performance Testing
- [ ] Impact of security measures on performance
- [ ] Memory usage with encryption
- [ ] Network latency with certificate pinning

---

## Rollback Plan

### If Critical Issues Arise
1. Immediate rollback to previous stable version
2. Security team assessment
3. Fix implementation
4. Redeploy with additional testing

### Rollback Triggers
- Authentication failures > 5%
- Performance degradation > 30%
- Critical user complaints
- Security regressions detected

---

## Next Steps

1. ✅ **Week 2:** Begin critical fixes
2. ⏳ **Week 3:** Complete high-priority fixes
3. ⏳ **Week 4:** Complete medium-priority fixes
4. ⏳ **Week 5-6:** Complete low-priority fixes
5. ⏳ **Week 7-8:** Achieve compliance
6. ⏳ **Week 9:** Security audit verification

---

**Remediation Plan Version:** 1.0  
**Last Updated:** September 5, 2026  
**Owner:** Senior Mobile Developer  
**Approval Required:** Security Team Lead