import 'package:bmi_calculator/reset_password.dart';
import 'package:bmi_calculator/screens/profile.dart';
import 'package:bmi_calculator/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'screens/input_page.dart';
import 'screens/results_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BMICalculator());
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BMI Calculator",
      themeMode: ThemeMode.system,
      // Automatically use the system theme
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        // Light theme background
        primaryColor: kLightPrimaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: kLightPrimaryColor,
          foregroundColor: Colors.black, // Text and icon color
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kLightPrimaryColor,
          selectedItemColor: DynamicColors.activeCardColor(context),
          unselectedItemColor: DynamicColors.inactiveCardColor(context),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: kDarkPrimaryColor,
        scaffoldBackgroundColor: kDarkPrimaryColor,
        // Dark theme background
        appBarTheme: const AppBarTheme(
          backgroundColor: kDarkPrimaryColor,
          foregroundColor: Colors.white, // Text and icon color
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kDarkPrimaryColor,
          selectedItemColor: DynamicColors.activeCardColor(context),
          unselectedItemColor: DynamicColors.inactiveCardColor(context),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/splash',
      // Set LoginPage as the initial route
      onGenerateRoute: (settings) {
        if (settings.name == '/results') {
          final args = settings.arguments as Map<String, String>;

          return MaterialPageRoute(
            builder: (context) {
              return ResultsPage(
                bmiResult: args['bmiResult']!,
                resultText: args['resultText']!,
                interpretation: args['interpretation']!,
              );
            },
          );
        }
        if (settings.name == '/reset-password') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return ResetPassword(
                email: args['email']!,
              );
            },
          );
        }
        return null; // Return null for undefined routes
      },
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/input': (context) => const InputPage(),
        '/splash': (context) => const SplashScreen(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
