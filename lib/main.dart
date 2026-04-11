import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'reset_password.dart';
import 'screens/input_page.dart';
import 'screens/profile.dart';
import 'screens/splash_screen.dart';
import 'database/app_database.dart';
import 'services/session_service.dart';
import 'services/sync_service.dart';
import 'services/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize services before app starts
  await SessionService.initialize();
  await AppDatabase.database; // triggers database creation

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

  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

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
      },
    );
  }
}
