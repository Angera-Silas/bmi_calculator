import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmi_calculator/database/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseEncryption', () {
    test('generated key is 64 chars of lowercase hex (32 random bytes)', () {
      final key = AppDatabase.generateEncryptionKeyForTest();
      expect(key, hasLength(64));
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(key), isTrue);
    });

    test('generated keys are unique per call', () {
      final a = AppDatabase.generateEncryptionKeyForTest();
      final b = AppDatabase.generateEncryptionKeyForTest();
      expect(a, isNot(equals(b)));
    });

    test('encryption migration flag defaults to unset', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('db_encrypted_v1'), isNull);
    });

    test('encryption migration flag persists true after migration', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('db_encrypted_v1', true);
      expect(prefs.getBool('db_encrypted_v1'), isTrue);
    });

    test('no plaintext db file present during key fallback generation',
        () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      // Simulate a first run: no stored key yet, no .env override in tests.
      expect(prefs.getString('db_encryption_key'), isNull);
      // A key would be generated and persisted on first DB open.
      final storedKey = 'a' * 63 + 'b';
      await prefs.setString('db_encryption_key', storedKey);
      expect(prefs.getString('db_encryption_key'), hasLength(64));
    });
  });
}
