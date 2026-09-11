import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';
import 'generated/l10n/app_localizations.dart';
import 'services/auth_service.dart';
import 'services/sync_service.dart';
import 'services/connectivity_service.dart';
import 'services/session_service.dart';
import 'services/two_factor_service.dart';
import 'screens/two_factor_verification.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  static const _socialProviders = [
    ('google', 'Google'),
    ('microsoft', 'Microsoft'),
    ('facebook', 'Facebook'),
    ('twitter', 'Twitter'),
    ('apple', 'Apple'),
    ('github', 'GitHub'),
    ('instagram', 'Instagram'),
    ('tiktok', 'TikTok'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Password strength: 0=empty, 1=weak, 2=medium, 3=strong
  int _passwordStrength(String p) {
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(p)) score++;
    if (score <= 1) return 1;
    if (score <= 2) return 2;
    return 3;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final error = await AuthService.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusSM)),
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/input');
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() => _isLoading = true);
    await AuthService.loginAsGuest();
    final isOnline = await ConnectivityService.isOnline;
    if (isOnline && SessionService.userId != null) {
      await SyncService.sync(SessionService.userId!);
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/input');
  }

  Future<void> _checkAndRoute2FA() async {
    final userId = SessionService.userId;
    if (userId == null) {
      Navigator.pushReplacementNamed(context, '/input');
      return;
    }

    final is2faEnabled = await TwoFactorService.isEnabled(userId);
    if (!mounted) return;

    if (!is2faEnabled) {
      Navigator.pushReplacementNamed(context, '/input');
      return;
    }

    final deviceId = await TwoFactorService.getOrCreateDeviceId();
    final isTrusted = await TwoFactorService.isDeviceTrusted(userId, deviceId);
    if (!mounted) return;

    if (isTrusted) {
      await SessionService.verify2fa();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/input');
      return;
    }

    final methods = await TwoFactorService.getEnabledMethods(userId);
    if (!mounted) return;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TwoFactorVerificationScreen(
          enrolledMethods: methods,
        ),
      ),
    );

    if (result == true && mounted) {
      Navigator.pushReplacementNamed(context, '/input');
    } else if (mounted) {
      await AuthService.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('2FA verification failed. Please try again.'),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _socialSignUp(String provider) async {
    setState(() => _isLoading = true);
    final error = await AuthService.loginWithProvider(provider);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusSM)),
        ),
      );
      return;
    }

    final isOnline = await ConnectivityService.isOnline;
    if (isOnline && SessionService.userId != null) {
      await SyncService.sync(SessionService.userId!);
    }
    if (!mounted) return;
    await _checkAndRoute2FA();
  }

  @override
  Widget build(BuildContext context) {
    final pwStrength = _passwordStrength(_passwordController.text);

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
                const SizedBox(height: kSpaceXL),
                // Back button
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: Container(
                    padding: const EdgeInsets.all(kSpaceSM),
                    decoration: BoxDecoration(
                      color: DynamicColors.card(context),
                      borderRadius: BorderRadius.circular(kRadiusSM),
                      border: Border.all(color: DynamicColors.border(context)),
                    ),
                    child: Icon(Icons.arrow_back,
                        color: DynamicColors.textPrimary(context), size: 20),
                  ),
                ),
                const SizedBox(height: kSpaceLG),
                Text(
                  AppLocalizations.of(context).createAccountTitle,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: DynamicColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: kSpaceXS),
                Text(
                  AppLocalizations.of(context).startTrackingToday,
                  style: TextStyle(
                      color: DynamicColors.textSecondary(context),
                      fontSize: 14),
                ),
                const SizedBox(height: kSpaceLG),

                // Full Name
                _buildLabel(context, AppLocalizations.of(context).fullName),
                const SizedBox(height: kSpaceXS),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: DynamicColors.textPrimary(context)),
                  decoration: _inputDecoration(context,
                      hint: 'John Doe', icon: Icons.person_outline),
                  validator: (v) {
                    final l10n = AppLocalizations.of(context);
                    if (v == null || v.trim().isEmpty) return l10n.nameRequired;
                    if (v.trim().length < 2) return l10n.nameShort;
                    return null;
                  },
                ),
                const SizedBox(height: kSpaceMD),

                // Email
                _buildLabel(context, AppLocalizations.of(context).emailAddress),
                const SizedBox(height: kSpaceXS),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: DynamicColors.textPrimary(context)),
                  decoration: _inputDecoration(context,
                      hint: 'you@example.com', icon: Icons.email_outlined),
                  validator: (v) {
                    final l10n = AppLocalizations.of(context);
                    if (v == null || v.trim().isEmpty)
                      return l10n.emailRequired;
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                      return l10n.emailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kSpaceMD),

                // Phone
                _buildLabel(context, AppLocalizations.of(context).phoneNumber),
                const SizedBox(height: kSpaceXS),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: DynamicColors.textPrimary(context)),
                  decoration: _inputDecoration(context,
                      hint: '+1 234 567 8900', icon: Icons.phone_outlined),
                  validator: (v) {
                    final l10n = AppLocalizations.of(context);
                    if (v == null || v.trim().isEmpty)
                      return l10n.phoneRequired;
                    if (v.trim().length < 7) return l10n.phoneInvalid;
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
                  onChanged: (_) => setState(() {}),
                  decoration: _inputDecoration(
                    context,
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: DynamicColors.iconColor(context),
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    final l10n = AppLocalizations.of(context);
                    if (v == null || v.trim().isEmpty)
                      return l10n.passwordRequired;
                    if (v.length < 6) return l10n.passwordTooShort;
                    return null;
                  },
                ),

                // Password strength indicator
                if (_passwordController.text.isNotEmpty) ...[
                  const SizedBox(height: kSpaceSM),
                  _PasswordStrengthBar(strength: pwStrength),
                ],
                const SizedBox(height: kSpaceMD),

                // Confirm Password
                _buildLabel(
                    context, AppLocalizations.of(context).confirmPassword),
                const SizedBox(height: kSpaceXS),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  style: TextStyle(color: DynamicColors.textPrimary(context)),
                  decoration: _inputDecoration(
                    context,
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: DynamicColors.iconColor(context),
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    final l10n = AppLocalizations.of(context);
                    if (v == null || v.trim().isEmpty)
                      return l10n.confirmPasswordRequired;
                    if (v != _passwordController.text)
                      return l10n.passwordsDoNotMatch;
                    return null;
                  },
                ),
                const SizedBox(height: kSpaceXL),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
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
                        : Text(AppLocalizations.of(context).createAccountTitle,
                            style: kLargeButtonTextStyle),
                  ),
                ),
                const SizedBox(height: kSpaceLG),

                // Social Signup Section
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: DynamicColors.border(context),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: kSpaceMD),
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
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: kSpaceSM,
                      runSpacing: kSpaceSM,
                      children: _socialProviders
                          .map(
                            (provider) => _buildSocialButton(
                              icon: _socialIcon(provider.$1),
                              label: provider.$2,
                              onPressed: () => _socialSignUp(provider.$1),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: kSpaceLG),
                  ],
                ),

                // Continue as Guest (optional)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kSpaceMD),
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : _continueAsGuest,
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

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppLocalizations.of(context).alreadyHaveAccount} ',
                      style: TextStyle(
                          color: DynamicColors.textSecondary(context),
                          fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: Text(
                        AppLocalizations.of(context).signInLink,
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
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: DynamicColors.textSecondary(context).withOpacity(0.5)),
      prefixIcon: Icon(icon, color: DynamicColors.iconColor(context), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: DynamicColors.card(context),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: 14),
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
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 88,
      height: 88,
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
                child: IconTheme(
                  data: IconThemeData(
                    size: 24,
                    color: DynamicColors.textPrimary(context),
                  ),
                  child: Center(child: icon),
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

  Widget _socialIcon(String provider) {
    switch (provider) {
      case 'google':
        return const FaIcon(FontAwesomeIcons.google);
      case 'microsoft':
        return const FaIcon(FontAwesomeIcons.microsoft);
      case 'facebook':
        return const FaIcon(FontAwesomeIcons.facebook);
      case 'twitter':
        return const FaIcon(FontAwesomeIcons.xTwitter);
      case 'apple':
        return const FaIcon(FontAwesomeIcons.apple);
      case 'github':
        return const FaIcon(FontAwesomeIcons.github);
      case 'instagram':
        return const FaIcon(FontAwesomeIcons.instagram);
      case 'tiktok':
        return const FaIcon(FontAwesomeIcons.tiktok);
      default:
        return const Icon(Icons.login);
    }
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  final int strength; // 1=weak, 2=medium, 3=strong

  const _PasswordStrengthBar({required this.strength});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final levelLabels = [
      '',
      l10n.passwordWeak,
      l10n.passwordMedium,
      l10n.passwordStrong
    ];
    final colors = [
      Colors.transparent,
      kErrorColor,
      kWarningColor,
      kSuccessColor
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i < strength
                      ? colors[strength]
                      : DynamicColors.border(context),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.passwordStrengthLabel(levelLabels[strength]),
          style: TextStyle(
            fontSize: 12,
            color: colors[strength],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
