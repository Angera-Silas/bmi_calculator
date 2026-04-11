import 'package:flutter/material.dart';
import 'constants.dart';
import 'services/auth_service.dart';
import 'services/sync_service.dart';
import 'services/connectivity_service.dart';
import 'services/session_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final error = await AuthService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusSM)),
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/input');
    }
  }

  Future<void> _loginAsGuest() async {
    setState(() => _isLoading = true);
    await AuthService.loginAsGuest();
    // Sync if online
    final isOnline = await ConnectivityService.isOnline;
    if (isOnline && SessionService.userId != null) {
      await SyncService.sync(SessionService.userId!);
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/input');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kSpaceXXL),
                // Logo + Brand
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kAccent, kAccentLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(kRadiusMD),
                    ),
                    child: const Icon(Icons.monitor_weight_outlined, color: Colors.white, size: 38),
                  ),
                ),
                const SizedBox(height: kSpaceLG),
                Center(
                  child: Text(
                    'BMI Calculator',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                ),
                const SizedBox(height: kSpaceXS),
                Center(
                  child: Text(
                    'Track your health journey',
                    style: TextStyle(
                      fontSize: 14,
                      color: DynamicColors.textSecondary(context),
                    ),
                  ),
                ),
                const SizedBox(height: kSpaceXXL),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: DynamicColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: kSpaceXS),
                Text(
                  'Sign in to continue',
                  style: TextStyle(color: DynamicColors.textSecondary(context), fontSize: 14),
                ),
                const SizedBox(height: kSpaceLG),

                // Email
                _buildLabel(context, 'Email address'),
                const SizedBox(height: kSpaceXS),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: DynamicColors.textPrimary(context)),
                  decoration: _inputDecoration(
                    context,
                    hint: 'you@example.com',
                    icon: Icons.email_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email is required';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kSpaceMD),

                // Password
                _buildLabel(context, 'Password'),
                const SizedBox(height: kSpaceXS),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: DynamicColors.textPrimary(context)),
                  decoration: _inputDecoration(
                    context,
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: DynamicColors.iconColor(context),
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/reset-password',
                      arguments: {'email': _emailController.text.trim()},
                    ),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: kAccent, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: kSpaceMD),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: kAccent.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRadiusMD),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Sign In', style: kLargeButtonTextStyle),
                  ),
                ),
                const SizedBox(height: kSpaceLG),

                // Continue as Guest
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kSpaceMD),
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : _loginAsGuest,
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: kAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: DynamicColors.textSecondary(context), fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                      child: const Text(
                        'Create one',
                        style: TextStyle(
                          color: kAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceLG),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) => Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: DynamicColors.textSecondary(context),
          letterSpacing: 0.3,
        ),
      );

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    final isDark = DynamicColors.isDark(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: DynamicColors.textSecondary(context).withOpacity(0.5)),
      prefixIcon: Icon(icon, color: DynamicColors.iconColor(context), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark ? kDarkCard : kLightCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        borderSide: BorderSide(color: DynamicColors.border(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        borderSide: BorderSide(color: DynamicColors.border(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        borderSide: const BorderSide(color: kAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        borderSide: const BorderSide(color: kErrorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadiusMD),
        borderSide: const BorderSide(color: kErrorColor, width: 2),
      ),
    );
  }
}
