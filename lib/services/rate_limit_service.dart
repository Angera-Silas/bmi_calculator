import 'dart:core';

/// Rate limiting service to prevent brute force attacks and abuse.
///
/// Implements sliding window rate limiting for various operations like
/// login attempts, API calls, and other security-sensitive actions.
class RateLimitService {
  // Store attempts as Map<identifier, List<DateTime>>
  static final Map<String, List<DateTime>> _attempts = {};

  // Configuration for different rate limit types
  static const Map<RateLimitType, RateLimitConfig> _configs = {
    RateLimitType.login: RateLimitConfig(
      maxAttempts: 5,
      windowDuration: Duration(minutes: 15),
      blockDuration: Duration(minutes: 30),
    ),
    RateLimitType.passwordReset: RateLimitConfig(
      maxAttempts: 3,
      windowDuration: Duration(hours: 1),
      blockDuration: Duration(hours: 2),
    ),
    RateLimitType.registration: RateLimitConfig(
      maxAttempts: 3,
      windowDuration: Duration(hours: 1),
      blockDuration: Duration(hours: 2),
    ),
    RateLimitType.apiCall: RateLimitConfig(
      maxAttempts: 100,
      windowDuration: Duration(minutes: 1),
      blockDuration: Duration(minutes: 5),
    ),
  };

  /// Check if an identifier is currently rate limited.
  ///
  /// Returns true if the identifier has exceeded the rate limit, false otherwise.
  static bool isRateLimited(String identifier,
      {RateLimitType type = RateLimitType.login}) {
    final config = _configs[type]!;
    final now = DateTime.now();
    final attempts = _attempts['$type:$identifier'] ?? [];

    // Remove attempts outside the window
    attempts
        .removeWhere((time) => now.difference(time) > config.windowDuration);

    // Check if blocked
    if (attempts.length >= config.maxAttempts) {
      final lastAttempt = attempts.last;
      final blockExpiry = lastAttempt.add(config.blockDuration);
      if (now.isBefore(blockExpiry)) {
        return true;
      }
    }

    return false;
  }

  /// Record an attempt for rate limiting.
  ///
  /// Returns true if this attempt should be blocked due to rate limiting.
  static bool recordAttempt(String identifier,
      {RateLimitType type = RateLimitType.login}) {
    final config = _configs[type]!;
    final key = '$type:$identifier';
    final now = DateTime.now();
    final attempts = _attempts[key] ?? [];

    // Remove attempts outside the window
    attempts
        .removeWhere((time) => now.difference(time) > config.windowDuration);

    // Check if already blocked
    if (attempts.length >= config.maxAttempts) {
      final lastAttempt = attempts.last;
      final blockExpiry = lastAttempt.add(config.blockDuration);
      if (now.isBefore(blockExpiry)) {
        return true; // Still blocked
      }
    }

    // Record this attempt
    attempts.add(now);
    _attempts[key] = attempts;

    // Check if this attempt should be blocked
    return attempts.length > config.maxAttempts;
  }

  /// Reset rate limiting for a specific identifier.
  ///
  /// Useful after successful authentication or when manually clearing limits.
  static void resetAttempts(String identifier, {RateLimitType? type}) {
    if (type != null) {
      _attempts.remove('$type:$identifier');
    } else {
      // Reset all types for this identifier
      _attempts.removeWhere((key, _) => key.endsWith(':$identifier'));
    }
  }

  /// Get the number of remaining attempts before rate limiting kicks in.
  ///
  /// Returns the number of attempts remaining, or 0 if already limited.
  static int getRemainingAttempts(String identifier,
      {RateLimitType type = RateLimitType.login}) {
    final config = _configs[type]!;
    final key = '$type:$identifier';
    final now = DateTime.now();
    final attempts = _attempts[key] ?? [];

    // Remove attempts outside the window
    attempts
        .removeWhere((time) => now.difference(time) > config.windowDuration);

    if (attempts.length >= config.maxAttempts) {
      return 0;
    }

    return config.maxAttempts - attempts.length;
  }

  /// Get the time until rate limit expires for a blocked identifier.
  ///
  /// Returns null if not currently blocked, otherwise the duration until unblock.
  static Duration? getTimeUntilUnblock(String identifier,
      {RateLimitType type = RateLimitType.login}) {
    final config = _configs[type]!;
    final key = '$type:$identifier';
    final attempts = _attempts[key];

    if (attempts == null || attempts.isEmpty) {
      return null;
    }

    final now = DateTime.now();
    final attemptsInWindow = attempts
        .where((time) => now.difference(time) <= config.windowDuration)
        .toList();

    if (attemptsInWindow.length < config.maxAttempts) {
      return null;
    }

    final lastAttempt = attemptsInWindow.last;
    final blockExpiry = lastAttempt.add(config.blockDuration);

    if (now.isAfter(blockExpiry)) {
      return null;
    }

    return blockExpiry.difference(now);
  }

  /// Clean up old rate limit data to prevent memory leaks.
  ///
  /// Should be called periodically (e.g., app startup, daily).
  static void cleanup() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _attempts.entries) {
      entry.value.removeWhere((time) => now.difference(time).inHours > 24);
      if (entry.value.isEmpty) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _attempts.remove(key);
    }
  }

  /// Get rate limit statistics for monitoring.
  ///
  /// Returns statistics about current rate limiting state.
  static Map<String, dynamic> getStatistics() {
    final now = DateTime.now();
    int totalAttempts = 0;
    final typeStats = <String, int>{};

    for (final entry in _attempts.entries) {
      final parts = entry.key.split(':');
      if (parts.length >= 2) {
        final type = parts[0];
        typeStats[type] = (typeStats[type] ?? 0) + entry.value.length;
      }
      totalAttempts += entry.value.length;
    }

    return {
      'total_identifiers': _attempts.length,
      'total_attempts': totalAttempts,
      'type_breakdown': typeStats,
      'timestamp': now.toIso8601String(),
    };
  }
}

/// Types of rate-limited operations.
enum RateLimitType {
  login,
  passwordReset,
  registration,
  apiCall,
  twoFactorVerification,
  dataExport,
}

/// Configuration for rate limiting.
class RateLimitConfig {
  final int maxAttempts;
  final Duration windowDuration;
  final Duration blockDuration;

  const RateLimitConfig({
    required this.maxAttempts,
    required this.windowDuration,
    required this.blockDuration,
  });
}
