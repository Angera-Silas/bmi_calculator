import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/two_factor_service.dart';

class SmsSetupScreen extends StatefulWidget {
  final String userId;
  final String userEmail;

  const SmsSetupScreen({
    Key? key,
    required this.userId,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<SmsSetupScreen> createState() => _SmsSetupScreenState();
}

class _SmsSetupScreenState extends State<SmsSetupScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  String? _verificationId;
  bool _showCodeInput = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _initiateSmsVerification() async {
    setState(() {
      _error = null;
      _isLoading = true;
    });

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        _error = 'Please enter your phone number';
        _isLoading = false;
      });
      return;
    }

    // Format phone with + if not present
    final formattedPhone = phone.startsWith('+') ? phone : '+$phone';

    final verificationId = await TwoFactorService.initiateSmsVerification(formattedPhone);

    if (verificationId == null) {
      setState(() {
        _error = 'Failed to send verification code. Please check your phone number.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _verificationId = verificationId;
      _showCodeInput = true;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code sent to your phone')),
    );
  }

  Future<void> _confirmSmsEnrollment() async {
    if (_verificationId == null) {
      setState(() => _error = 'Verification ID not found. Please start over.');
      return;
    }

    final code = _codeController.text.trim();
    if (code.isEmpty || code.length != 6) {
      setState(() => _error = 'Please enter the 6-digit code');
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    final phone = _phoneController.text.trim();
    final formattedPhone = phone.startsWith('+') ? phone : '+$phone';

    final result = await TwoFactorService.confirmSmsEnrollment(
      widget.userId,
      formattedPhone,
      _verificationId!,
      code,
    );

    if (result == null) {
      // Success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SMS 2FA successfully enabled')),
        );
        Navigator.pop(context, true);
      }
    } else {
      setState(() {
        _error = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enable SMS Authentication'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📱 SMS Authentication',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'You will receive a 6-digit code via SMS for verification. '
                      'Make sure you have access to this phone number.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              enabled: !_showCodeInput && !_isLoading,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '+1 (555) 123-4567',
                prefixText: _showCodeInput ? null : '+',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            if (!_showCodeInput) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _initiateSmsVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNormalColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Send Verification Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 24),
              const Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _codeController,
                enabled: !_isLoading,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '000000',
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Check your phone for the 6-digit code',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmSmsEnrollment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNormalColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Verify and Enable SMS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _showCodeInput = false;
                            _codeController.clear();
                            _error = null;
                          });
                        },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Change Phone Number'),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
