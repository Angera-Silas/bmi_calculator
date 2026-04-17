import 'package:flutter/material.dart';
import 'constants.dart';
import 'generated/l10n/app_localizations.dart';
import 'services/auth_service.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final error = await AuthService.sendPasswordReset(_emailController.text);

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
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kSpaceXL),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(kSpaceSM),
                    decoration: BoxDecoration(
                      color: DynamicColors.card(context),
                      borderRadius: BorderRadius.circular(kRadiusSM),
                      border: Border.all(color: DynamicColors.border(context)),
                    ),
                    child: Icon(Icons.arrow_back, color: DynamicColors.textPrimary(context), size: 20),
                  ),
                ),
                const SizedBox(height: kSpaceLG),

                if (!_emailSent) ...[
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: kAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(kRadiusMD),
                    ),
                    child: const Icon(Icons.lock_reset, color: kAccent, size: 32),
                  ),
                  const SizedBox(height: kSpaceLG),
                  Text(
                    AppLocalizations.of(context).resetPasswordTitle,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: DynamicColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: kSpaceXS),
                  Text(
                    AppLocalizations.of(context).resetPasswordSubtitle,
                    style: TextStyle(
                      color: DynamicColors.textSecondary(context),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),

                  Text(
                    AppLocalizations.of(context).emailAddress,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: DynamicColors.textSecondary(context),
                    ),
                  ),
                  const SizedBox(height: kSpaceXS),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: DynamicColors.textPrimary(context)),
                    decoration: InputDecoration(
                      hintText: 'you@example.com',
                      hintStyle: TextStyle(color: DynamicColors.textSecondary(context).withOpacity(0.5)),
                      prefixIcon: Icon(Icons.email_outlined, color: DynamicColors.iconColor(context), size: 20),
                      filled: true,
                      fillColor: DynamicColors.card(context),
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
                  const SizedBox(height: kSpaceXL),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendReset,
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
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(AppLocalizations.of(context).sendResetLink, style: kLargeButtonTextStyle),
                    ),
                  ),
                ] else ...[
                  // Success state
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: kSpaceXL),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: kSuccessColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.mark_email_read_outlined, color: kSuccessColor, size: 40),
                        ),
                        const SizedBox(height: kSpaceLG),
                        Text(
                          AppLocalizations.of(context).checkInbox,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: DynamicColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: kSpaceSM),
                        Text(
                          AppLocalizations.of(context).resetLinkSentTo(_emailController.text.trim()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DynamicColors.textSecondary(context),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: kSpaceXL),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(kRadiusMD),
                              ),
                              elevation: 0,
                            ),
                            child: Text(AppLocalizations.of(context).backToSignIn, style: kLargeButtonTextStyle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
