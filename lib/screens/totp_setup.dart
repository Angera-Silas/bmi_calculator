import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../constants.dart';
import '../services/two_factor_service.dart';
import '../services/session_service.dart';

class TotpSetupScreen extends StatefulWidget {
  final String? userId;
  final String? userEmail;

  const TotpSetupScreen({
    super.key,
    this.userId,
    this.userEmail,
  });

  @override
  State<TotpSetupScreen> createState() => _TotpSetupScreenState();
}

class _TotpSetupScreenState extends State<TotpSetupScreen> {
  String? _qrCodeUrl;
  List<String>? _backupCodes;
  final _totpController = TextEditingController();
  bool _isLoading = true;
  bool _showBackupCodes = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeTotpSetup();
  }

  Future<void> _initializeTotpSetup() async {
    setState(() => _isLoading = true);
    try {
      final userId = widget.userId ?? SessionService.userId;
      if (userId == null) {
        setState(() {
          _error = 'No user session';
          _isLoading = false;
        });
        return;
      }

      final userEmail = widget.userEmail ?? 'user@example.com';
      final qrUrl =
          await TwoFactorService.generateTotpSecret(userId, userEmail);
      setState(() {
        _qrCodeUrl = qrUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize TOTP: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmTotpSetup() async {
    if (_totpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter the 6-digit code'),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = widget.userId ?? SessionService.userId;
      if (userId == null) {
        setState(() {
          _error = 'No user session';
          _isLoading = false;
        });
        return;
      }

      final result = await TwoFactorService.confirmTotpEnrollment(
        userId,
        _totpController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('TOTP enrollment confirmed!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      } else if (result.startsWith('TOTP_ENROLLED')) {
        // Extract backup codes
        final parts = result.split('|||');
        setState(() {
          _backupCodes = parts.sublist(1);
          _showBackupCodes = true;
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: kErrorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _totpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authenticator Setup'),
        backgroundColor: DynamicColors.bg(context),
        foregroundColor: DynamicColors.textPrimary(context),
        elevation: 0,
      ),
      backgroundColor: DynamicColors.bg(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(kSpaceLG),
              child: _showBackupCodes
                  ? _buildBackupCodesView()
                  : _buildTotpSetupView(),
            ),
    );
  }

  Widget _buildTotpSetupView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instructions
        Text(
          'Step 1: Scan QR Code',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: kSpaceXS),
        Text(
          'Use Google Authenticator, Microsoft Authenticator, or Authy to scan this QR code.',
          style: TextStyle(
              fontSize: 14, color: DynamicColors.textSecondary(context)),
        ),
        const SizedBox(height: kSpaceLG),

        // QR Code
        if (_qrCodeUrl != null)
          Center(
            child: Container(
              padding: const EdgeInsets.all(kSpaceMD),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kRadiusMD),
              ),
              child: SizedBox(
                width: 250,
                height: 250,
                child: QrImageView(
                  data: _qrCodeUrl ?? '',
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  gapless: false,
                ),
              ),
            ),
          )
        else if (_error != null)
          Center(
            child: Text(
              _error!,
              style: TextStyle(color: kErrorColor),
            ),
          ),

        const SizedBox(height: kSpaceLG),

        // Verify Code Input
        Text(
          'Step 2: Verify Code',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: kSpaceXS),
        Text(
          'Enter the 6-digit code from your authenticator app.',
          style: TextStyle(
              fontSize: 14, color: DynamicColors.textSecondary(context)),
        ),
        const SizedBox(height: kSpaceMD),

        TextField(
          controller: _totpController,
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
                color: DynamicColors.textSecondary(context).withOpacity(0.3)),
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

        // Confirm Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _confirmTotpSetup,
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
                : const Text('Confirm & Continue',
                    style: kLargeButtonTextStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildBackupCodesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success message
        Container(
          padding: const EdgeInsets.all(kSpaceMD),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(kRadiusMD),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: kSpaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Authenticator Enabled',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: kSpaceXS),
                    Text(
                      'Save your backup codes below in a safe place.',
                      style: TextStyle(
                          fontSize: 12,
                          color: DynamicColors.textSecondary(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kSpaceLG),

        // Backup Codes Title
        Text(
          'Backup Codes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: DynamicColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: kSpaceXS),
        Text(
          'Keep these codes in a safe place. Use them to access your account if you lose access to your authenticator.',
          style: TextStyle(
              fontSize: 13, color: DynamicColors.textSecondary(context)),
        ),
        const SizedBox(height: kSpaceMD),

        // Backup Codes List
        Container(
          padding: const EdgeInsets.all(kSpaceMD),
          decoration: BoxDecoration(
            color: DynamicColors.isDark(context) ? kDarkCard : kLightCard,
            borderRadius: BorderRadius.circular(kRadiusMD),
            border: Border.all(color: DynamicColors.border(context)),
          ),
          child: Column(
            children: [
              if (_backupCodes != null)
                for (int i = 0; i < _backupCodes!.length; i += 2)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i + 1 < _backupCodes!.length ? kSpaceXS : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBackupCodeTile(_backupCodes![i]),
                        if (i + 1 < _backupCodes!.length)
                          _buildBackupCodeTile(_backupCodes![i + 1])
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: kSpaceLG),

        // Close Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadiusMD),
              ),
            ),
            child: const Text('Done', style: kLargeButtonTextStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildBackupCodeTile(String code) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: kSpaceMD, vertical: kSpaceXS),
        decoration: BoxDecoration(
          color: DynamicColors.bg(context),
          borderRadius: BorderRadius.circular(kRadiusSM),
        ),
        child: Text(
          code,
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: DynamicColors.textPrimary(context),
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
