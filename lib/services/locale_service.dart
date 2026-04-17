import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const _key = 'app_locale';

  static Future<Locale?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    return code != null ? Locale(code) : null;
  }

  static Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
  }

  /// Language list: code → native display name.
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'ar': 'العربية',
    'hi': 'हिन्दी',
    'zh': '中文',
    'pt': 'Português',
    'ru': 'Русский',
    'bn': 'বাংলা',
    'id': 'Bahasa Indonesia',
    'de': 'Deutsch',
    'sw': 'Kiswahili',
    'ha': 'Hausa',
  };
}
