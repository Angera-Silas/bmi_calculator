import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginState();
  }

  Future<void> checkLoginState() async {
    // Simulate splash screen delay
    await Future.delayed(const Duration(seconds: 5));

    // Check if a user is already signed in via Firebase Auth
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User is signed in, replace splash screen with HomePage
      Navigator.pushReplacementNamed(context, '/input');
      return;
    }

    // Check shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {
      // Replace splash screen with HomePage
      Navigator.pushReplacementNamed(context, '/input');
    } else {
      // Replace splash screen with LoginPage
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add a logo or illustration
              Image.asset(
                'images/logo.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText(
                    'Welcome to BMI Calculator',
                    textStyle: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Source Sans Pro',
                    ),
                  ),
                  FadeAnimatedText(
                    'Track Your Health',
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white70,
                      fontFamily: 'Source Sans Pro',
                    ),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
