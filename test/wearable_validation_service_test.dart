import 'package:flutter_test/flutter_test.dart';

import 'package:bmi_calculator/services/wearable_validation_service.dart';

void main() {
  group('WearableValidationService.validBp', () {
    test('accepts normal BP', () {
      expect(WearableValidationService.validBp(120, 80), isTrue);
    });

    test('rejects systolic below minimum', () {
      expect(WearableValidationService.validBp(40, 80), isFalse);
    });

    test('rejects systolic above maximum', () {
      expect(WearableValidationService.validBp(310, 120), isFalse);
    });

    test('rejects diastolic below minimum', () {
      expect(WearableValidationService.validBp(120, 20), isFalse);
    });

    test('rejects diastolic above maximum', () {
      expect(WearableValidationService.validBp(120, 210), isFalse);
    });

    test('rejects when diastolic >= systolic', () {
      expect(WearableValidationService.validBp(120, 120), isFalse);
      expect(WearableValidationService.validBp(80, 120), isFalse);
    });

    test('accepts boundary values', () {
      expect(WearableValidationService.validBp(50, 30), isTrue);
      expect(WearableValidationService.validBp(300, 199), isTrue);
    });
  });

  group('WearableValidationService.validGlucose', () {
    test('accepts normal glucose', () {
      expect(WearableValidationService.validGlucose(95), isTrue);
    });

    test('rejects below minimum', () {
      expect(WearableValidationService.validGlucose(10), isFalse);
    });

    test('rejects above maximum', () {
      expect(WearableValidationService.validGlucose(900), isFalse);
    });

    test('accepts boundary values', () {
      expect(WearableValidationService.validGlucose(20), isTrue);
      expect(WearableValidationService.validGlucose(800), isTrue);
    });
  });

  group('WearableValidationService.validWeight', () {
    test('accepts normal weight', () {
      expect(WearableValidationService.validWeight(70), isTrue);
    });

    test('rejects below minimum', () {
      expect(WearableValidationService.validWeight(10), isFalse);
    });

    test('rejects above maximum', () {
      expect(WearableValidationService.validWeight(350), isFalse);
    });

    test('accepts boundary values', () {
      expect(WearableValidationService.validWeight(20), isTrue);
      expect(WearableValidationService.validWeight(300), isTrue);
    });
  });

  group('WearableValidationService.validHeight', () {
    test('accepts normal height', () {
      expect(WearableValidationService.validHeight(170), isTrue);
    });

    test('rejects below minimum', () {
      expect(WearableValidationService.validHeight(40), isFalse);
    });

    test('rejects above maximum', () {
      expect(WearableValidationService.validHeight(260), isFalse);
    });

    test('accepts boundary values', () {
      expect(WearableValidationService.validHeight(50), isTrue);
      expect(WearableValidationService.validHeight(250), isTrue);
    });
  });
}
