import 'package:flutter/foundation.dart';

/// Supported 2FA methods
enum TwoFactorMethod { totp, email, sms, passkey }

extension TwoFactorMethodString on TwoFactorMethod {
  String get value {
    switch (this) {
      case TwoFactorMethod.totp:
        return 'totp';
      case TwoFactorMethod.email:
        return 'email';
      case TwoFactorMethod.sms:
        return 'sms';
      case TwoFactorMethod.passkey:
        return 'passkey';
    }
  }

  static TwoFactorMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'totp':
        return TwoFactorMethod.totp;
      case 'email':
        return TwoFactorMethod.email;
      case 'sms':
        return TwoFactorMethod.sms;
      case 'passkey':
        return TwoFactorMethod.passkey;
      default:
        throw ArgumentError('Unknown 2FA method: $value');
    }
  }
}

/// Represents user's 2FA configuration and enrolled methods
class TwoFactorConfig {
  final String userId;
  final bool isEnabled;
  final List<TwoFactorMethod> enrolledMethods;
  final TwoFactorMethod primaryMethod;
  final DateTime? createdAt;
  final DateTime? lastUpdatedAt;

  // Encrypted secrets (never stored plaintext)
  final String? totpSecretEncrypted;
  final String? smsPhoneEncrypted;
  final String? passkeyCredentialEncrypted;

  // Recovery codes
  final int recoveryCodesRemaining;

  TwoFactorConfig({
    required this.userId,
    this.isEnabled = false,
    this.enrolledMethods = const [],
    this.primaryMethod = TwoFactorMethod.email,
    this.createdAt,
    this.lastUpdatedAt,
    this.totpSecretEncrypted,
    this.smsPhoneEncrypted,
    this.passkeyCredentialEncrypted,
    this.recoveryCodesRemaining = 0,
  });

  /// Create from Firestore document
  factory TwoFactorConfig.fromFirestore(Map<String, dynamic> data, String userId) {
    return TwoFactorConfig(
      userId: userId,
      isEnabled: data['isEnabled'] as bool? ?? false,
      enrolledMethods: (data['enrolledMethods'] as List<dynamic>?)
              ?.map((m) => TwoFactorMethodString.fromString(m as String))
              .toList() ??
          [],
      primaryMethod: data['primaryMethod'] != null
          ? TwoFactorMethodString.fromString(data['primaryMethod'] as String)
          : TwoFactorMethod.email,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt'] as String) : null,
      lastUpdatedAt:
          data['lastUpdatedAt'] != null ? DateTime.parse(data['lastUpdatedAt'] as String) : null,
      totpSecretEncrypted: data['totpSecretEncrypted'] as String?,
      smsPhoneEncrypted: data['smsPhoneEncrypted'] as String?,
      passkeyCredentialEncrypted: data['passkeyCredentialEncrypted'] as String?,
      recoveryCodesRemaining: data['recoveryCodesRemaining'] as int? ?? 0,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'isEnabled': isEnabled,
      'enrolledMethods': enrolledMethods.map((m) => m.value).toList(),
      'primaryMethod': primaryMethod.value,
      'createdAt': createdAt?.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      'totpSecretEncrypted': totpSecretEncrypted,
      'smsPhoneEncrypted': smsPhoneEncrypted,
      'passkeyCredentialEncrypted': passkeyCredentialEncrypted,
      'recoveryCodesRemaining': recoveryCodesRemaining,
    };
  }

  /// Create from SQLite row
  factory TwoFactorConfig.fromSqlite(Map<String, dynamic> data) {
    return TwoFactorConfig(
      userId: data['userId'] as String,
      isEnabled: (data['isEnabled'] as int?) == 1,
      enrolledMethods: (data['enrolledMethods'] as String?)
              ?.split(',')
              .map((m) => TwoFactorMethodString.fromString(m.trim()))
              .toList() ??
          [],
      primaryMethod: data['primaryMethod'] != null
          ? TwoFactorMethodString.fromString(data['primaryMethod'] as String)
          : TwoFactorMethod.email,
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt'] as String) : null,
      lastUpdatedAt:
          data['lastUpdatedAt'] != null ? DateTime.parse(data['lastUpdatedAt'] as String) : null,
      totpSecretEncrypted: data['totpSecretEncrypted'] as String?,
      smsPhoneEncrypted: data['smsPhoneEncrypted'] as String?,
      passkeyCredentialEncrypted: data['passkeyCredentialEncrypted'] as String?,
      recoveryCodesRemaining: data['recoveryCodesRemaining'] as int? ?? 0,
    );
  }

  /// Convert to SQLite row
  Map<String, dynamic> toSqlite() {
    return {
      'userId': userId,
      'isEnabled': isEnabled ? 1 : 0,
      'enrolledMethods': enrolledMethods.map((m) => m.value).join(','),
      'primaryMethod': primaryMethod.value,
      'createdAt': createdAt?.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      'totpSecretEncrypted': totpSecretEncrypted,
      'smsPhoneEncrypted': smsPhoneEncrypted,
      'passkeyCredentialEncrypted': passkeyCredentialEncrypted,
      'recoveryCodesRemaining': recoveryCodesRemaining,
    };
  }

  /// Create updated copy
  TwoFactorConfig copyWith({
    bool? isEnabled,
    List<TwoFactorMethod>? enrolledMethods,
    TwoFactorMethod? primaryMethod,
    String? totpSecretEncrypted,
    String? smsPhoneEncrypted,
    String? passkeyCredentialEncrypted,
    int? recoveryCodesRemaining,
  }) {
    return TwoFactorConfig(
      userId: userId,
      isEnabled: isEnabled ?? this.isEnabled,
      enrolledMethods: enrolledMethods ?? this.enrolledMethods,
      primaryMethod: primaryMethod ?? this.primaryMethod,
      createdAt: createdAt,
      lastUpdatedAt: DateTime.now(),
      totpSecretEncrypted: totpSecretEncrypted ?? this.totpSecretEncrypted,
      smsPhoneEncrypted: smsPhoneEncrypted ?? this.smsPhoneEncrypted,
      passkeyCredentialEncrypted:
          passkeyCredentialEncrypted ?? this.passkeyCredentialEncrypted,
      recoveryCodesRemaining: recoveryCodesRemaining ?? this.recoveryCodesRemaining,
    );
  }
}

/// Recovery codes for 2FA backup
class TwoFactorBackupCode {
  final String userId;
  final String code;
  final bool isUsed;
  final DateTime? usedAt;

  TwoFactorBackupCode({
    required this.userId,
    required this.code,
    this.isUsed = false,
    this.usedAt,
  });

  factory TwoFactorBackupCode.fromSqlite(Map<String, dynamic> data) {
    return TwoFactorBackupCode(
      userId: data['userId'] as String,
      code: data['code'] as String,
      isUsed: (data['isUsed'] as int?) == 1,
      usedAt: data['usedAt'] != null ? DateTime.parse(data['usedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toSqlite() {
    return {
      'userId': userId,
      'code': code,
      'isUsed': isUsed ? 1 : 0,
      'usedAt': usedAt?.toIso8601String(),
    };
  }
}

/// Session state for pending 2FA verification
class PendingTwoFactorSession {
  final String userId;
  final TwoFactorMethod method;
  final String? otpCode;
  final DateTime expiresAt;
  final int attemptCount;

  PendingTwoFactorSession({
    required this.userId,
    required this.method,
    this.otpCode,
    required this.expiresAt,
    this.attemptCount = 0,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isAttemptsExceeded => attemptCount >= 5;
}
