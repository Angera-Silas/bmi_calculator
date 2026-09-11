import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/services/rate_limit_service.dart';

void main() {
  tearDown(() => RateLimitService.cleanup());

  group('RateLimitService login', () {
    test('allows attempts under the limit', () {
      final id = 'user@example.com';
      for (var i = 0; i < 5; i++) {
        expect(RateLimitService.recordAttempt(id), isFalse);
      }
    });

    test('blocks after exceeding the limit', () {
      final id = 'blocked@example.com';
      for (var i = 0; i < 5; i++) {
        RateLimitService.recordAttempt(id);
      }
      expect(RateLimitService.isRateLimited(id), isTrue);
      expect(RateLimitService.getRemainingAttempts(id), 0);
      expect(RateLimitService.getTimeUntilUnblock(id), isNotNull);
    });

    test('reset clears limits', () {
      final id = 'reset@example.com';
      for (var i = 0; i < 5; i++) {
        RateLimitService.recordAttempt(id);
      }
      expect(RateLimitService.isRateLimited(id), isTrue);
      RateLimitService.resetAttempts(id);
      expect(RateLimitService.isRateLimited(id), isFalse);
    });

    test('isolates identifiers', () {
      final a = 'a@example.com';
      final b = 'b@example.com';
      for (var i = 0; i < 5; i++) {
        RateLimitService.recordAttempt(a);
      }
      expect(RateLimitService.isRateLimited(a), isTrue);
      expect(RateLimitService.isRateLimited(b), isFalse);
    });
  });

  group('RateLimitService per-type isolation', () {
    test('login attempts do not affect password reset', () {
      final id = 'type-test@example.com';
      for (var i = 0; i < 5; i++) {
        RateLimitService.recordAttempt(id, type: RateLimitType.login);
      }
      expect(RateLimitService.isRateLimited(id), isTrue);
      expect(
        RateLimitService.isRateLimited(id, type: RateLimitType.passwordReset),
        isFalse,
      );
    });

    test('reset with type only clears that type', () {
      final id = 'partial@example.com';
      for (var i = 0; i < 5; i++) {
        RateLimitService.recordAttempt(id, type: RateLimitType.login);
      }
      RateLimitService.resetAttempts(id, type: RateLimitType.registration);
      expect(RateLimitService.isRateLimited(id), isTrue);
      RateLimitService.resetAttempts(id, type: RateLimitType.login);
      expect(RateLimitService.isRateLimited(id), isFalse);
    });
  });

  group('RateLimitService statistics', () {
    test('reports attempt counts', () {
      RateLimitService.recordAttempt('stat@example.com');
      RateLimitService.recordAttempt('stat@example.com');
      final stats = RateLimitService.getStatistics();
      expect(stats['total_attempts'], greaterThanOrEqualTo(2));
      expect(stats['type_breakdown'], contains('RateLimitType.login'));
    });
  });
}
