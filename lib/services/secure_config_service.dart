import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Secure configuration service that loads sensitive data from environment variables.
///
/// This service ensures that Firebase API keys and other sensitive configuration
/// are not hardcoded in the source code, reducing the risk of exposure.
class SecureConfigService {
  static bool _initialized = false;

  /// Initialize the secure configuration service by loading environment variables.
  ///
  /// Must be called before accessing any configuration values.
  /// Returns true if initialization was successful, false otherwise.
  static Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      await dotenv.load(fileName: '.env');
      _initialized = true;
      return true;
    } catch (e) {
      // Fall back to default values — do not crash
      _initialized = true;
      return false;
    }
  }

  static String get firebaseApiKeyAndroid =>
      dotenv.env['FIREBASE_API_KEY_ANDROID'] ?? '';

  static String get firebaseApiKeyIOS =>
      dotenv.env['FIREBASE_API_KEY_IOS'] ?? '';

  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? 'flutterapps-db036';

  static String get firebaseAppIdAndroid =>
      dotenv.env['FIREBASE_APP_ID_ANDROID'] ??
      '1:1058678501857:android:4070fd457b1589b47fa2a0';

  static String get firebaseAppIdIOS =>
      dotenv.env['FIREBASE_APP_ID_IOS'] ??
      '1:1058678501857:ios:8dd034c0c52893067fa2a0';

  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '1058678501857';

  static String get firebaseDatabaseUrl =>
      dotenv.env['FIREBASE_DATABASE_URL'] ??
      'https://flutterapps-db036-default-rtdb.firebaseio.com';

  static String get firebaseStorageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'flutterapps-db036.appspot.com';

  static String get firebaseAppCheckRecaptchaSiteKey =>
      dotenv.env['FIREBASE_APP_CHECK_WEB_RECAPTCHA_SITE_KEY'] ?? '';

  /// 64-character hex key used to encrypt the SQLite database via SQLCipher.
  static String? get dbEncryptionKey => dotenv.env['DB_ENCRYPTION_KEY'];

  static bool isFirebaseConfigured() =>
      firebaseApiKeyAndroid.isNotEmpty &&
      firebaseApiKeyIOS.isNotEmpty &&
      firebaseProjectId.isNotEmpty;

  static String? getConfig(String key, {String? defaultValue}) =>
      dotenv.env[key] ?? defaultValue;

  static bool hasConfig(String key) => dotenv.env.containsKey(key);
}
