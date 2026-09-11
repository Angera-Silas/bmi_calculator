import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/two_factor_config.dart';
import '../services/two_factor_service.dart';
import '../services/session_service.dart';

class TwoFactorVerificationScreen extends StatefulWidget {
  final List<TwoFactorMethod> enrolledMethods;
  final TwoFactorMethod? selectedMethod;

  const TwoFactorVerificationScreen({
    super.key,
    required this.enrolledMethods,
    this.selectedMethod,
  });

  @override
  State<TwoFactorVerificationScreen> createState() =>
      _TwoFactorVerificationScreenState();
}

class _TwoFactorVerificationScreenState
    extends State<TwoFactorVerificationScreen> {
  late TwoFactorMethod _selectedMethod;
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _showRecoveryCodeInput = false;
  bool _trustDevice = false;
  int _attemptCount = 0;
  final int _maxAttempts = 5;
  String _deviceId = '';

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod ?? widget.enrolledMethods.first;
    _initializeVerification();
  }

  Future<void> _initializeVerification() async {
    _deviceId = await TwoFactorService.getOrCreateDeviceId();
    if (!mounted) return;
    await _initiateSmsIfNeeded();
  }

  Future<void> _initiateSmsIfNeeded() async {
    if (_selectedMethod == TwoFactorMethod.sms) {
      final userId = SessionService.userId;
      if (userId != null) {
        // Check rate limit first
        final rateLimitError = await TwoFactorService.checkOtpRateLimit(
            userId, TwoFactorMethod.sms);
        if (rateLimitError != null && mounted) {
          _showError(rateLimitError);
          return;
        }

        final verificationId = await TwoFactorService.sendSmsOtp(userId);
        if (verificationId == null && mounted) {
          _showError(
              'Failed to send SMS code. You may have exceeded the rate limit.');
        } else if (verificationId != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('SMS code sent to your registered phone number'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) {
      _showError('Please enter your code');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = SessionService.userId;
      if (userId == null) {
        _showError('No user session');
        setState(() => _isLoading = false);
        return;
      }

      bool isValid = false;

      switch (_selectedMethod) {
        case TwoFactorMethod.totp:
          isValid = await TwoFactorService.verifyTotpCode(
            userId,
            _otpController.text.trim(),
          );
          break;
        case TwoFactorMethod.email:
          isValid = await TwoFactorService.verifyEmailOtp(
            userId,
            _otpController.text.trim(),
          );
          break;
        case TwoFactorMethod.sms:
          isValid = await TwoFactorService.verifySmsOtp(
            userId,
            _otpController.text.trim(),
          );
          break;
        case TwoFactorMethod.passkey:
          // Verify with biometric authentication
          isValid = await TwoFactorService.verifyPasskey(userId);
          break;
      }

      setState(() => _isLoading = false);

      if (isValid) {
        await SessionService.verify2fa();

        // Trust device if user checked the box
        if (_trustDevice) {
          await TwoFactorService.trustDeviceFor30Days(userId, _deviceId);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('2FA verified successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      } else {
        setState(() {
          _attemptCount++;
          if (_attemptCount >= _maxAttempts) {
            _showRecoveryCodeInput = true;
          }
        });
        _showError(
          'Invalid code. ${_maxAttempts - _attemptCount} attempts remaining.',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error: $e');
    }
  }

  Future<void> _selectMethod(TwoFactorMethod method) async {
    setState(() => _selectedMethod = method);
    await _initiateSmsIfNeeded();
  }

  Future<void> _verifyRecoveryCode() async {
    if (_otpController.text.trim().isEmpty) {
      _showError('Please enter a recovery code');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = SessionService.userId;
      if (userId == null) {
        _showError('No user session');
        setState(() => _isLoading = false);
        return;
      }

      final isValid = await TwoFactorService.verifyRecoveryCode(
        userId,
        _otpController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (isValid) {
        await SessionService.verify2fa();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recovery code accepted!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _showError('Invalid recovery code');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kErrorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showAccountRecoveryOptions() async {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Recovery'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you\'ve lost access to your 2FA methods, we can help you recover your account.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: kSpaceMD),
            const Text('Options:'),
            const SizedBox(height: kSpaceXS),
            const Text('• Use a recovery code if you saved one'),
            const SizedBox(height: kSpaceXS),
            const Text('• Contact support via your registered email'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initiateEmailRecovery();
            },
            child: const Text('Start Email Recovery'),
          ),
        ],
      ),
    );
  }

  Future<void> _initiateEmailRecovery() async {
    final userId = SessionService.userId;
    if (userId == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'We\'ll send a recovery link to your registered email address.'),
            const SizedBox(height: kSpaceXL),
            const Text('Processing...'),
          ],
        ),
      ),
    );

    // Initiate recovery (in production, this would send an email)
    final result = await TwoFactorService.initiateAccountRecovery(
      SessionService.userEmail ?? 'user@example.com',
    );

    if (mounted) {
      Navigator.pop(context);

      if (result == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Recovery Email Sent'),
            content: const Text(
              'Check your email for recovery instructions. '
              'Click the link to verify your identity and reset your 2FA.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        _showError(result);
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
        backgroundColor: DynamicColors.bg(context),
        foregroundColor: DynamicColors.textPrimary(context),
        elevation: 0,
      ),
      backgroundColor: DynamicColors.bg(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpaceLG),
        child: _showRecoveryCodeInput
            ? _buildRecoveryCodeView()
            : _buildOtpVerificationView(),
      ),
    );
  }

  Widget _buildOtpVerificationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Method selection (if multiple methods)
        if (widget.enrolledMethods.length > 1) ...[
          Text(
            'Select Verification Method',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: DynamicColors.textSecondary(context),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: kSpaceMD),
          Column(
            children: widget.enrolledMethods.map((method) {
              return Padding(
                padding: const EdgeInsets.only(bottom: kSpaceXS),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectMethod(method),
                    borderRadius: BorderRadius.circular(kRadiusMD),
                    child: Container(
                      padding: const EdgeInsets.all(kSpaceMD),
                      decoration: BoxDecoration(
                        color: _selectedMethod == method
                            ? kAccent.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(kRadiusMD),
                        border: Border.all(
                          color: _selectedMethod == method
                              ? kAccent
                              : DynamicColors.border(context),
                          width: _selectedMethod == method ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio<TwoFactorMethod>(
                            value: method,
                            groupValue: _selectedMethod,
                            onChanged: (value) {
                              if (value != null) {
                                _selectMethod(value);
                              }
                            },
                            activeColor: kAccent,
                          ),
                          const SizedBox(width: kSpaceMD),
                          Icon(
                            _getMethodIcon(method),
                            color: DynamicColors.textPrimary(context),
                          ),
                          const SizedBox(width: kSpaceMD),
                          Text(
                            _getMethodLabel(method),
                            style: TextStyle(
                              color: DynamicColors.textPrimary(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: kSpaceLG),
        ] else ...[
          Center(
            child: Chip(
              label: Text(_getMethodLabel(widget.enrolledMethods.first)),
              avatar: Icon(_getMethodIcon(widget.enrolledMethods.first)),
            ),
          ),
          const SizedBox(height: kSpaceLG),
        ],

        // OTP Input (conditionally show for non-passkey methods)
        if (_selectedMethod != TwoFactorMethod.passkey) ...[
          Text(
            'Enter ${_getMethodLabel(_selectedMethod)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: DynamicColors.textSecondary(context),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: kSpaceXS),
          Text(
            _getOtpHelpText(_selectedMethod),
            style: TextStyle(
                fontSize: 12, color: DynamicColors.textSecondary(context)),
          ),
          const SizedBox(height: kSpaceMD),

          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: DynamicColors.textPrimary(context),
            ),
            decoration: InputDecoration(
              hintText: '000000',
              hintStyle: TextStyle(
                color: DynamicColors.textSecondary(context).withOpacity(0.3),
              ),
              counterText: '',
              filled: true,
              fillColor: DynamicColors.isDark(context) ? kDarkCard : kLightCard,
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
            ),
          ),
          const SizedBox(height: kSpaceLG),

          // Verify Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kRadiusMD),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Verify', style: kLargeButtonTextStyle),
            ),
          ),
          const SizedBox(height: kSpaceMD),

          // Trust this device checkbox
          Container(
            padding: const EdgeInsets.symmetric(horizontal: kSpaceMD),
            decoration: BoxDecoration(
              color: DynamicColors.card(context),
              borderRadius: BorderRadius.circular(kRadiusMD),
              border: Border.all(
                color: DynamicColors.border(context),
              ),
            ),
            child: CheckboxListTile(
              title: const Text('Trust this device for 30 days'),
              subtitle: const Text('Skip 2FA on next login from this device'),
              value: _trustDevice,
              onChanged: (value) {
                setState(() => _trustDevice = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: kSpaceMD),

          // Account Recovery Link
          Center(
            child: TextButton(
              onPressed: _showAccountRecoveryOptions,
              child: Text(
                'Can\'t verify? Account recovery',
                style: TextStyle(
                  color: kAccent,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ] else ...[
          // Passkey verification (biometric)
          Text(
            'Use your device biometric to verify',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: DynamicColors.textSecondary(context),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: kSpaceXS),
          Text(
            'Use your fingerprint or face ID',
            style: TextStyle(
                fontSize: 12, color: DynamicColors.textSecondary(context)),
          ),
          const SizedBox(height: kSpaceLG),

          // Biometric Icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fingerprint,
                size: 48,
                color: kAccent,
              ),
            ),
          ),
          const SizedBox(height: kSpaceLG),

          // Verify with Biometric Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kRadiusMD),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Verify with Biometric',
                      style: kLargeButtonTextStyle),
            ),
          ),
        ],
        if (_attemptCount > 0 && !_showRecoveryCodeInput) ...[
          const SizedBox(height: kSpaceXS),
          Text(
            'Attempts remaining: ${_maxAttempts - _attemptCount}',
            style: TextStyle(
              fontSize: 12,
              color: _attemptCount >= 3
                  ? kErrorColor
                  : DynamicColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: kSpaceXS),
        if (_selectedMethod == TwoFactorMethod.sms) ...[
          TextButton(
            onPressed: _isLoading
                ? null
                : () async {
                    final userId = SessionService.userId;
                    if (userId != null) {
                      await TwoFactorService.sendSmsOtp(userId);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('New SMS code sent'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
            child: const Text('Resend SMS Code'),
          ),
        ],
      ],
    );
  }

  Widget _buildRecoveryCodeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(kSpaceMD),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(kRadiusMD),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange),
                  const SizedBox(width: kSpaceMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Too Many Attempts',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: kSpaceXS),
                        Text(
                          'Enter a backup recovery code to access your account.',
                          style: TextStyle(
                            fontSize: 12,
                            color: DynamicColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: kSpaceLG),

        // Recovery Code Input
        Text(
          'Recovery Code',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: DynamicColors.textSecondary(context),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: kSpaceXS),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: DynamicColors.textPrimary(context)),
          decoration: InputDecoration(
            hintText: 'Enter your backup code',
            hintStyle: TextStyle(
                color: DynamicColors.textSecondary(context).withOpacity(0.5)),
            filled: true,
            fillColor: DynamicColors.isDark(context) ? kDarkCard : kLightCard,
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
          ),
        ),
        const SizedBox(height: kSpaceLG),

        // Verify Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyRecoveryCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadiusMD),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Verify Recovery Code',
                    style: kLargeButtonTextStyle),
          ),
        ),
      ],
    );
  }

  IconData _getMethodIcon(TwoFactorMethod method) {
    switch (method) {
      case TwoFactorMethod.totp:
        return Icons.phone_android;
      case TwoFactorMethod.email:
        return Icons.email_outlined;
      case TwoFactorMethod.sms:
        return Icons.sms_outlined;
      case TwoFactorMethod.passkey:
        return Icons.fingerprint;
    }
  }

  String _getMethodLabel(TwoFactorMethod method) {
    switch (method) {
      case TwoFactorMethod.totp:
        return 'Authenticator App';
      case TwoFactorMethod.email:
        return 'Email Code';
      case TwoFactorMethod.sms:
        return 'SMS Code';
      case TwoFactorMethod.passkey:
        return 'Passkey';
    }
  }

  String _getOtpHelpText(TwoFactorMethod method) {
    switch (method) {
      case TwoFactorMethod.totp:
        return 'Enter the 6-digit code from your authenticator app';
      case TwoFactorMethod.email:
        return 'Enter the code sent to your email';
      case TwoFactorMethod.sms:
        return 'Enter the code sent to your phone';
      case TwoFactorMethod.passkey:
        return 'Use your device biometric or PIN';
    }
  }
}
