import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/services/validation_service.dart';

void main() {
  group('ValidationService.validateEmail', () {
    test('accepts valid emails', () {
      expect(ValidationService.validateEmail('user@example.com'), isNull);
      expect(ValidationService.validateEmail('a.b+tag@sub.domain.co'), isNull);
    });

    test('rejects empty / formats', () {
      expect(ValidationService.validateEmail(''), isNotNull);
      expect(ValidationService.validateEmail('not-an-email'), isNotNull);
      expect(ValidationService.validateEmail('a@b'), isNotNull);
      expect(ValidationService.validateEmail('  '), isNotNull);
    });

    test('rejects suspicious patterns', () {
      expect(ValidationService.validateEmail('x@y.com<script>'), isNotNull);
    });
  });

  group('ValidationService.validatePassword', () {
    test('accepts strong passwords', () {
      expect(ValidationService.validatePassword('Str0ng!Pass'), isNull);
    });

    test('rejects weak passwords', () {
      expect(ValidationService.validatePassword('short'), isNotNull);
      expect(ValidationService.validatePassword('alllowercase1!'), isNotNull);
      expect(ValidationService.validatePassword('12345678'), isNotNull);
      expect(ValidationService.validatePassword('password1'), isNotNull);
    });
  });

  group('ValidationService health metrics', () {
    test('height bounds', () {
      expect(ValidationService.validateHeight(49), isNotNull);
      expect(ValidationService.validateHeight(50), isNull);
      expect(ValidationService.validateHeight(300), isNull);
      expect(ValidationService.validateHeight(301), isNotNull);
    });

    test('weight bounds', () {
      expect(ValidationService.validateWeight(19), isNotNull);
      expect(ValidationService.validateWeight(20), isNull);
      expect(ValidationService.validateWeight(300), isNull);
    });

    test('age bounds', () {
      expect(ValidationService.validateAge(1), isNotNull);
      expect(ValidationService.validateAge(2), isNull);
      expect(ValidationService.validateAge(120), isNull);
      expect(ValidationService.validateAge(121), isNotNull);
    });
  });

  group('ValidationService.sanitizeString', () {
    test('removes injection patterns', () {
      expect(ValidationService.sanitizeString("x'; DROP TABLE users;--"),
          isNot(contains('DROP')));
      expect(ValidationService.sanitizeString('<script>alert(1)</script>'),
          isNot(contains('<')));
      expect(ValidationService.sanitizeString('javascript:alert(1)'),
          isNot(contains('javascript:')));
    });
  });
}
