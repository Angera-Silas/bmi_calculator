import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

/// Security logging service for comprehensive security event tracking and monitoring.
///
/// Provides audit trail for security events, suspicious activity detection,
/// and alert triggering for security incidents.
class SecurityLoggingService {
  static final List<SecurityEvent> _events = [];
  static final Uuid _uuid = const Uuid();

  // Alert thresholds
  static const int _maxFailedLoginAttempts = 5;
  static const int _maxFailedPasswordResetAttempts = 3;
  static const int _maxDataExportAttempts = 10;

  /// Log a security event.
  ///
  /// Stores the event in memory and persists to database for audit trail.
  /// Automatically checks for suspicious patterns and triggers alerts if needed.
  static Future<void> logEvent(SecurityEvent event) async {
    // Add to memory
    _events.add(event);

    // Persist to database for audit trail
    await _persistEvent(event);

    // Check for suspicious patterns and trigger alerts
    await _checkForSecurityAlerts(event);

    // Keep memory usage manageable
    if (_events.length > 1000) {
      _events.removeRange(0, _events.length - 1000);
    }
  }

  /// Persist security event to database.
  static Future<void> _persistEvent(SecurityEvent event) async {
    try {
      await AppDatabase.insertSecurityEvent(event.toMap());
    } catch (e) {
      // Log error but don't fail the operation
      debugPrint('Warning: Failed to persist security event: $e');
    }
  }

  /// Check for security alert conditions based on recent events.
  static Future<void> _checkForSecurityAlerts(SecurityEvent event) async {
    switch (event.type) {
      case SecurityEventType.failedLogin:
        await _checkForBruteForceAttack(event);
        break;
      case SecurityEventType.failedPasswordReset:
        await _checkForPasswordResetAbuse(event);
        break;
      case SecurityEventType.dataExport:
        await _checkForDataExportAbuse(event);
        break;
      case SecurityEventType.suspiciousActivity:
        await _triggerImmediateAlert(
            SecurityAlertType.suspiciousActivityDetected, event);
        break;
      default:
        // No specific check needed for other event types
        break;
    }
  }

  /// Check for brute force attack patterns.
  static Future<void> _checkForBruteForceAttack(SecurityEvent event) async {
    final recentFailures = _events
        .where((e) =>
            e.type == SecurityEventType.failedLogin &&
            e.identifier == event.identifier &&
            DateTime.now().difference(e.timestamp).inMinutes < 15)
        .toList();

    if (recentFailures.length >= _maxFailedLoginAttempts) {
      await _triggerSecurityAlert(
        SecurityAlertType.bruteForceDetected,
        event,
        details: '$_maxFailedLoginAttempts failed login attempts in 15 minutes',
      );
    }
  }

  /// Check for password reset abuse.
  static Future<void> _checkForPasswordResetAbuse(SecurityEvent event) async {
    final recentAttempts = _events
        .where((e) =>
            e.type == SecurityEventType.failedPasswordReset &&
            e.identifier == event.identifier &&
            DateTime.now().difference(e.timestamp).inHours < 1)
        .toList();

    if (recentAttempts.length >= _maxFailedPasswordResetAttempts) {
      await _triggerSecurityAlert(
        SecurityAlertType.passwordResetAbuse,
        event,
        details:
            '$_maxFailedPasswordResetAttempts failed password reset attempts in 1 hour',
      );
    }
  }

  /// Check for data export abuse.
  static Future<void> _checkForDataExportAbuse(SecurityEvent event) async {
    final recentExports = _events
        .where((e) =>
            e.type == SecurityEventType.dataExport &&
            e.identifier == event.identifier &&
            DateTime.now().difference(e.timestamp).inHours < 1)
        .toList();

    if (recentExports.length >= _maxDataExportAttempts) {
      await _triggerSecurityAlert(
        SecurityAlertType.dataExportAbuse,
        event,
        details: '$_maxDataExportAttempts data export attempts in 1 hour',
      );
    }
  }

  /// Trigger an immediate security alert.
  static Future<void> _triggerImmediateAlert(
    SecurityAlertType alertType,
    SecurityEvent event,
  ) async {
    await _triggerSecurityAlert(alertType, event,
        details: 'Immediate security alert');
  }

  /// Trigger a security alert with details.
  static Future<void> _triggerSecurityAlert(
    SecurityAlertType alertType,
    SecurityEvent event, {
    String? details,
  }) async {
    final alert = SecurityAlert(
      id: _uuid.v4(),
      type: alertType,
      identifier: event.identifier,
      timestamp: DateTime.now(),
      details: details,
      severity: _getAlertSeverity(alertType),
      status: AlertStatus.active,
    );

    debugPrint('SECURITY ALERT: ${alertType.name} - ${event.identifier}');

    // Persist alert
    await _persistAlert(alert);
  }

  /// Get alert severity based on type.
  static AlertSeverity _getAlertSeverity(SecurityAlertType type) {
    switch (type) {
      case SecurityAlertType.bruteForceDetected:
      case SecurityAlertType.dataExportAbuse:
        return AlertSeverity.high;
      case SecurityAlertType.passwordResetAbuse:
      case SecurityAlertType.suspiciousActivityDetected:
        return AlertSeverity.medium;
      default:
        return AlertSeverity.low;
    }
  }

  /// Persist security alert to database.
  static Future<void> _persistAlert(SecurityAlert alert) async {
    try {
      await AppDatabase.insertSecurityAlert(alert.toMap());
    } catch (e) {
      debugPrint('Warning: Failed to persist security alert: $e');
    }
  }

  /// Get recent security events for an identifier.
  static List<SecurityEvent> getRecentEvents(
    String identifier, {
    Duration duration = const Duration(hours: 24),
  }) {
    final cutoff = DateTime.now().subtract(duration);
    return _events
        .where((e) => e.identifier == identifier && e.timestamp.isAfter(cutoff))
        .toList();
  }

  /// Get security statistics for monitoring.
  static Map<String, dynamic> getSecurityStatistics() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final last7Days = now.subtract(const Duration(days: 7));

    final events24h =
        _events.where((e) => e.timestamp.isAfter(last24Hours)).toList();
    final events7d =
        _events.where((e) => e.timestamp.isAfter(last7Days)).toList();

    final failedLogins24h =
        events24h.where((e) => e.type == SecurityEventType.failedLogin).length;
    final successfulLogins24h = events24h
        .where((e) => e.type == SecurityEventType.successfulLogin)
        .length;
    final passwordResets24h = events24h
        .where((e) => e.type == SecurityEventType.passwordReset)
        .length;
    final accountDeletions24h = events24h
        .where((e) => e.type == SecurityEventType.accountDeletion)
        .length;

    return {
      'total_events_24h': events24h.length,
      'total_events_7d': events7d.length,
      'failed_logins_24h': failedLogins24h,
      'successful_logins_24h': successfulLogins24h,
      'password_resets_24h': passwordResets24h,
      'account_deletions_24h': accountDeletions24h,
      'login_success_rate_24h': successfulLogins24h > 0
          ? (successfulLogins24h /
                  (successfulLogins24h + failedLogins24h) *
                  100)
              .toStringAsFixed(2)
          : '0.00',
      'unique_identifiers_24h':
          events24h.map((e) => e.identifier).toSet().length,
      'timestamp': now.toIso8601String(),
    };
  }

  /// Get all active security alerts.
  static Future<List<SecurityAlert>> getActiveAlerts() async {
    try {
      final alertMaps = await AppDatabase.getActiveSecurityAlerts();
      return alertMaps.map((map) => SecurityAlert.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Warning: Failed to fetch active alerts: $e');
      return [];
    }
  }

  /// Resolve a security alert.
  static Future<void> resolveAlert(String alertId) async {
    try {
      await AppDatabase.resolveSecurityAlert(alertId);
    } catch (e) {
      debugPrint('Warning: Failed to resolve alert: $e');
    }
  }

  /// Clean up old security events to prevent memory issues.
  static void cleanup({Duration olderThan = const Duration(days: 30)}) {
    final cutoff = DateTime.now().subtract(olderThan);
    _events.removeWhere((e) => e.timestamp.isBefore(cutoff));
  }
}

/// Security event types for classification.
enum SecurityEventType {
  successfulLogin,
  failedLogin,
  passwordChange,
  passwordReset,
  failedPasswordReset,
  accountDeletion,
  dataAccess,
  dataExport,
  suspiciousActivity,
  twoFactorEnabled,
  twoFactorDisabled,
  sessionCreated,
  sessionInvalidated,
}

/// Security alert types for incident classification.
enum SecurityAlertType {
  bruteForceDetected,
  passwordResetAbuse,
  dataExportAbuse,
  suspiciousActivityDetected,
  unusualDataAccess,
  accountCompromise,
}

/// Alert severity levels.
enum AlertSeverity {
  low,
  medium,
  high,
  critical,
}

/// Alert status for tracking.
enum AlertStatus {
  active,
  investigating,
  resolved,
  falsePositive,
}

/// Security event model.
class SecurityEvent {
  final String id;
  final SecurityEventType type;
  final String identifier; // email, user ID, or other identifier
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final String? ipAddress;
  final String? userAgent;

  SecurityEvent({
    required this.type,
    required this.identifier,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? metadata,
  })  : id = const Uuid().v4(),
        timestamp = DateTime.now(),
        metadata = metadata ?? {},
        ipAddress = ipAddress,
        userAgent = userAgent;

  // Private constructor for reconstruction from database
  SecurityEvent._internal({
    required this.id,
    required this.type,
    required this.identifier,
    required this.timestamp,
    required this.metadata,
    this.ipAddress,
    this.userAgent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'identifier': identifier,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'ip_address': ipAddress,
      'user_agent': userAgent,
    };
  }

  static SecurityEvent fromMap(Map<String, dynamic> map) {
    return SecurityEvent._internal(
      id: map['id'] as String,
      type: SecurityEventType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => SecurityEventType.suspiciousActivity,
      ),
      identifier: map['identifier'] as String,
      timestamp: map['timestamp'] is String
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
      ipAddress: map['ip_address'] as String?,
      userAgent: map['user_agent'] as String?,
    );
  }
}

/// Security alert model.
class SecurityAlert {
  final String id;
  final SecurityAlertType type;
  final String identifier;
  final DateTime timestamp;
  final String? details;
  final AlertSeverity severity;
  final AlertStatus status;
  final String? resolvedBy;
  final DateTime? resolvedAt;

  SecurityAlert({
    required this.id,
    required this.type,
    required this.identifier,
    required this.timestamp,
    this.details,
    required this.severity,
    required this.status,
    this.resolvedBy,
    this.resolvedAt,
  });

  // Private constructor for reconstruction from database
  SecurityAlert._internal({
    required this.id,
    required this.type,
    required this.identifier,
    required this.timestamp,
    this.details,
    required this.severity,
    required this.status,
    this.resolvedBy,
    this.resolvedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'identifier': identifier,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
      'severity': severity.name,
      'status': status.name,
      'resolved_by': resolvedBy,
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }

  static SecurityAlert fromMap(Map<String, dynamic> map) {
    return SecurityAlert._internal(
      id: map['id'] as String,
      type: SecurityAlertType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => SecurityAlertType.suspiciousActivityDetected,
      ),
      identifier: map['identifier'] as String,
      timestamp: map['timestamp'] is String
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      details: map['details'] as String?,
      severity: AlertSeverity.values.firstWhere(
        (e) => e.name == map['severity'],
        orElse: () => AlertSeverity.low,
      ),
      status: AlertStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AlertStatus.active,
      ),
      resolvedBy: map['resolved_by'] as String?,
      resolvedAt: map['resolved_at'] != null
          ? (map['resolved_at'] is String
              ? DateTime.parse(map['resolved_at'] as String)
              : DateTime.fromMillisecondsSinceEpoch(map['resolved_at'] as int))
          : null,
    );
  }
}
