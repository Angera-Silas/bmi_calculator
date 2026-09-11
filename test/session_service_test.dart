import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/services/session_service.dart';

void main() {
  setUp(SessionService.resetForTesting);
  tearDown(SessionService.resetForTesting);

  group('SessionService.isSessionValid', () {
    test('returns false when no session start recorded', () async {
      SessionService.resetForTesting();
      expect(await SessionService.isSessionValid(), isFalse);
    });

    test('returns true for a fresh session', () async {
      SessionService.setSessionStartForTesting(DateTime.now());
      expect(await SessionService.isSessionValid(), isTrue);
    });

    test('returns false for an expired session', () async {
      SessionService.setSessionStartForTesting(
        DateTime.now().subtract(const Duration(hours: 25)),
      );
      expect(await SessionService.isSessionValid(), isFalse);
    });
  });

  group('SessionService accessors', () {
    test('defaults to no session', () {
      expect(SessionService.hasSession, isFalse);
      expect(SessionService.isAuthenticated, isFalse);
      expect(SessionService.userId, isNull);
    });

    test('guest flags are correct', () {
      expect(SessionService.guestId, 'guest');
      expect(SessionService.isGuest, isFalse);
      expect(SessionService.requires2fa, isFalse);
    });
  });
}
