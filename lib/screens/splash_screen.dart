import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // Check auth state after animation settles
    Future.delayed(const Duration(milliseconds: 2000), _checkAuthState);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthState() async {
    if (!mounted) return;
    await SessionService.initialize();
    if (!mounted) return;
    final hasSession = SessionService.hasSession;
    Navigator.pushReplacementNamed(context, hasSession ? '/input' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kAccent, kAccentLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(kRadiusLG),
                    boxShadow: [
                      BoxShadow(
                        color: kAccent.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.monitor_weight_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: kSpaceLG),
              Text(
                'BMI Calculator',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: DynamicColors.textPrimary(context),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: kSpaceXS),
              Text(
                'Track · Understand · Improve',
                style: TextStyle(
                  fontSize: 14,
                  color: DynamicColors.textSecondary(context),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: kSpaceXXL),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: kAccent,
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
