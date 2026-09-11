import 'dart:ui';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'generated/l10n/app_localizations.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'reset_password.dart';
import 'screens/input_page.dart';
import 'screens/achievements_screen.dart';
import 'screens/export_screen.dart';
import 'screens/profile.dart';
import 'screens/reminder_settings.dart';
import 'screens/security_page.dart';
import 'screens/splash_screen.dart';
import 'screens/wearable_settings.dart';
import 'database/app_database.dart';
import 'services/locale_service.dart';
import 'services/session_service.dart';
import 'services/sync_service.dart';
import 'services/connectivity_service.dart';
import 'services/secure_config_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure configuration first
  await SecureConfigService.initialize();

  // Validate Firebase configuration
  if (!SecureConfigService.isFirebaseConfigured()) {
    debugPrint(
        'Warning: Firebase configuration is incomplete. Using fallback values.');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Enable Firebase App Check (Play Integrity on Android release,
  // DeviceCheck/App Attest on iOS, debug provider for local dev).
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await FirebaseAppCheck.instance.activate(
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    );
  } else if (!kIsWeb) {
    await FirebaseAppCheck.instance.activate();
  }

  // Initialize services before app starts
  await SessionService.initialize();
  await AppDatabase.database; // triggers database creation

  // Initialize local notifications (smart reminders, Sprint 2.3)
  await NotificationService.initialize();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Background sync on connectivity change
  ConnectivityService.onlineStream.listen((isOnline) async {
    if (isOnline && SessionService.isAuthenticated) {
      final userId = SessionService.userId;
      if (userId != null && userId != SessionService.guestId) {
        await SyncService.sync(userId);
      }
    }
  });

  // Load persisted locale before starting app
  final savedLocale = await LocaleService.getLocale();

  runApp(ProviderScope(child: BMICalculatorApp(initialLocale: savedLocale)));
}

class BMICalculatorApp extends StatefulWidget {
  const BMICalculatorApp({super.key, this.initialLocale});

  final Locale? initialLocale;

  /// Call from anywhere to change the app locale at runtime.
  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_BMICalculatorAppState>();
    state?._setLocale(locale);
  }

  @override
  State<BMICalculatorApp> createState() => _BMICalculatorAppState();
}

class _BMICalculatorAppState extends State<BMICalculatorApp> {
  late Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
    LocaleService.saveLocale(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      // ── Localisation ────────────────────────────────────────────────────
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('ar'),
        Locale('hi'),
        Locale('zh'),
        Locale('pt'),
        Locale('ru'),
        Locale('bn'),
        Locale('id'),
        Locale('de'),
        Locale('sw'),
        Locale('ha'),
      ],

      // ── Light Theme ───────────────────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: kLightBg,
        primaryColor: kAccent,
        colorScheme: ColorScheme.light(
          primary: kAccent,
          secondary: kAccentLight,
          surface: kLightSurface,
          surfaceContainerHighest: kLightBg,
          error: kErrorColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kLightBg,
          elevation: 0,
          foregroundColor: Color(0xFF0D1117),
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: kLightSurface,
          selectedItemColor: kAccent,
          unselectedItemColor: kLightLabelColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF0D1117)),
          bodySmall: TextStyle(color: Color(0xFF6B7280)),
          bodyLarge: TextStyle(color: Color(0xFF0D1117)),
        ),
        cardTheme: CardThemeData(
          color: kLightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
            side: const BorderSide(color: kLightBorder),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kLightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
            borderSide: const BorderSide(color: kLightBorder),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusMD),
            ),
          ),
        ),
      ),

      // ── Dark Theme ────────────────────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kDarkBg,
        primaryColor: kAccent,
        colorScheme: ColorScheme.dark(
          primary: kAccent,
          secondary: kAccentLight,
          surface: kDarkSurface,
          surfaceContainerHighest: kDarkBg,
          error: kErrorColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kDarkBg,
          elevation: 0,
          foregroundColor: Color(0xFFE6EDF3),
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: kDarkSurface,
          selectedItemColor: kAccentLight,
          unselectedItemColor: kDarkLabelColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFE6EDF3)),
          bodySmall: TextStyle(color: Color(0xFF8892B0)),
          bodyLarge: TextStyle(color: Color(0xFFE6EDF3)),
        ),
        cardTheme: CardThemeData(
          color: kDarkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
            side: const BorderSide(color: kDarkBorder),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kDarkCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kRadiusMD),
            borderSide: const BorderSide(color: kDarkBorder),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusMD),
            ),
          ),
        ),
      ),

      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/reset-password':
            final args = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (_) => ResetPassword(email: args['email'] ?? ''),
            );
          default:
            return null;
        }
      },
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegistrationPage(),
        '/input': (_) => const InputPage(),
        '/profile': (_) => const ProfilePage(),
        '/security': (_) => const SecurityPage(),
        '/reminders': (_) => const ReminderSettingsScreen(),
        '/achievements': (_) => const AchievementsScreen(),
        '/wearable': (_) => const WearableSettingsScreen(),
        '/export': (_) => const ExportScreen(),
      },
    );
  }
}
