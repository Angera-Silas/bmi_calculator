import 'package:flutter/material.dart';
import 'constants.dart';
import 'generated/l10n/app_localizations.dart';
import 'services/auth_service.dart';
import 'services/sync_service.dart';
import 'services/connectivity_service.dart';
import 'services/session_service.dart';
import 'services/two_factor_service.dart';
import 'screens/two_factor_verification.dart';

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
      // Check if 2FA is enabled
      await _checkAndRoute2FA();
    }
  }

  Future<void> _checkAndRoute2FA() async {
    final userId = SessionService.userId;
    if (userId == null) {
      Navigator.pushReplacementNamed(context, '/input');
      return;
    }

    // Check if 2FA is enabled for this user
    final is2faEnabled = await TwoFactorService.isEnabled(userId);

    if (!mounted) return;

    if (is2faEnabled) {
      // Generate device ID for device trust checking
      final deviceId = '${DateTime.now().millisecondsSinceEpoch}_device';

      // Check if this device is trusted
      final isTrusted = await TwoFactorService.isDeviceTrusted(userId, deviceId);

      if (isTrusted && mounted) {
        // Device is trusted, skip 2FA and go directly to input
        await SessionService.verify2fa();
        Navigator.pushReplacementNamed(context, '/input');
        return;
      }

      // Get enabled methods
      final methods = await TwoFactorService.getEnabledMethods(userId);

      if (!mounted) return;

      // Route to 2FA verification screen
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => TwoFactorVerificationScreen(
            enrolledMethods: methods,
          ),
        ),
      );

      if (result == true && mounted) {
        // User successfully verified 2FA
        Navigator.pushReplacementNamed(context, '/input');
      } else if (mounted) {
        // 2FA verification failed/cancelled
        await AuthService.logout();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('2FA verification failed. Please try again.'),
            backgroundColor: kErrorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // No 2FA required, go directly to input
      Navigator.pushReplacementNamed(context, '/input');
    }
  }

  Future<void> _socialLogin(String provider) async {
    setState(() => _isLoading = true);
    String? error;

    switch (provider) {
      case 'google':
        error = await AuthService.loginWithGoogle();
        break;
      case 'apple':
        error = await AuthService.loginWithApple();
        break;
      case 'facebook':
        error = await AuthService.loginWithFacebook();
        break;
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error == null) {
      // Sync if online
      final isOnline = await ConnectivityService.isOnline;
      if (isOnline && SessionService.userId != null) {
        await SyncService.sync(SessionService.userId!);
      }
      // Check if 2FA is enabled
      await _checkAndRoute2FA();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusSM)),
        ),
      );
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
                    AppLocalizations.of(context).appTitle,
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
                    AppLocalizations.of(context).trackHealthJourney,
                    style: TextStyle(
                      fontSize: 14,
                      color: DynamicColors.textSecondary(context),
                    ),
                  ),
                ),
                const SizedBox(height: kSpaceXXL),
                Text(
                  AppLocalizations.of(context).welcomeBack,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: DynamicColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: kSpaceXS),
                Text(
                  AppLocalizations.of(context).signInToContinue,
                  style: TextStyle(color: DynamicColors.textSecondary(context), fontSize: 14),
                ),
                const SizedBox(height: kSpaceLG),

                // Email
                _buildLabel(context, AppLocalizations.of(context).emailAddress),
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
                    final l10n = AppLocalizations.of(context);
                    if (v == null || v.trim().isEmpty) return l10n.emailRequired;
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                      return l10n.emailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kSpaceMD),

                // Password
                _buildLabel(context, AppLocalizations.of(context).password),
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
                    final l10n = AppLocalizations.of(context);
                    if (v == null || v.trim().isEmpty) return l10n.passwordRequired;
                    if (v.length < 6) return l10n.passwordTooShort;
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
                      AppLocalizations.of(context).forgotPassword,
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
                        : Text(AppLocalizations.of(context).signIn, style: kLargeButtonTextStyle),
                  ),
                ),
                const SizedBox(height: kSpaceLG),

                // Social Login Section
                Column(
                  children: [
                    // Divider with text
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: DynamicColors.border(context),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kSpaceMD),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: DynamicColors.textSecondary(context),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: DynamicColors.border(context),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kSpaceMD),

                    // Social buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialButton(
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                          onPressed: () => _socialLogin('google'),
                        ),
                        _buildSocialButton(
                          icon: Icons.apple,
                          label: 'Apple',
                          onPressed: () => _socialLogin('apple'),
                        ),
                        _buildSocialButton(
                          icon: Icons.facebook,
                          label: 'Facebook',
                          onPressed: () => _socialLogin('facebook'),
                        ),
                      ],
                    ),
                    const SizedBox(height: kSpaceLG),
                  ],
                ),

                // Continue as Guest
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kSpaceMD),
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : _loginAsGuest,
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: Text(
                      AppLocalizations.of(context).continueAsGuest,
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
                      '${AppLocalizations.of(context).dontHaveAccount} ',
                      style: TextStyle(color: DynamicColors.textSecondary(context), fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                      child: Text(
                        AppLocalizations.of(context).createOne,
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

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(kRadiusMD),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: DynamicColors.isDark(context) ? kDarkCard : kLightCard,
                  borderRadius: BorderRadius.circular(kRadiusMD),
                  border: Border.all(
                    color: DynamicColors.border(context),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: DynamicColors.textPrimary(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: kSpaceXS),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: DynamicColors.textSecondary(context),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
