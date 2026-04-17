import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/two_factor_config.dart';
import '../services/two_factor_service.dart';
import '../services/session_service.dart';
import '../screens/totp_setup.dart';
import '../screens/sms_setup.dart';
import '../screens/passkey_setup.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  late TwoFactorConfig? _config;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSecurityConfig();
  }

  Future<void> _loadSecurityConfig() async {
    final userId = SessionService.userId;
    if (userId == null) return;

    setState(() => _isLoading = true);

    try {
      final config = await TwoFactorService.getConfig(userId);
      if (mounted) {
        setState(() {
          _config = config;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load security settings';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshConfig() async {
    await _loadSecurityConfig();
  }

  Future<void> _enrollNewMethod(TwoFactorMethod method) async {
    final userId = SessionService.userId;
    final userEmail = _config?.userId ?? 'user@bmi.app'; // Use a placeholder

    if (userId == null) return;

    switch (method) {
      case TwoFactorMethod.totp:
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => TotpSetupScreen(
              userId: userId,
              userEmail: userEmail,
            ),
          ),
        );
        if (result == true) {
          _refreshConfig();
        }
        break;

      case TwoFactorMethod.sms:
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => SmsSetupScreen(
              userId: userId,
              userEmail: userEmail,
            ),
          ),
        );
        if (result == true) {
          _refreshConfig();
        }
        break;

      case TwoFactorMethod.passkey:
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => PasskeySetupScreen(
              userId: userId,
              userEmail: userEmail,
            ),
          ),
        );
        if (result == true) {
          _refreshConfig();
        }
        break;

      case TwoFactorMethod.email:
        // Email is auto-enrolled
        final result = await TwoFactorService.enrollEmail(userId);
        if (result == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email 2FA enabled')),
            );
          }
          _refreshConfig();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result)),
            );
          }
        }
        break;
    }
  }

  Future<void> _removeMethod(TwoFactorMethod method) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove 2FA Method?'),
        content: Text(
          'Are you sure you want to remove ${_getMethodName(method)}? '
          'You will no longer be able to use this method for authentication.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      String? error;
      switch (method) {
        case TwoFactorMethod.totp:
          error = await TwoFactorService.removeTotpMethod(SessionService.userId!);
          break;
        case TwoFactorMethod.email:
          error = await TwoFactorService.removeEmailMethod(SessionService.userId!);
          break;
        case TwoFactorMethod.sms:
          error = await TwoFactorService.removeSmsMethod(SessionService.userId!);
          break;
        case TwoFactorMethod.passkey:
          error = await TwoFactorService.removePasskeyMethod(SessionService.userId!);
          break;
      }

      if (mounted) {
        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${_getMethodName(method)} removed')),
          );
          _refreshConfig();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      }
    }
  }

  String _getMethodName(TwoFactorMethod method) {
    switch (method) {
      case TwoFactorMethod.totp:
        return 'Authenticator App';
      case TwoFactorMethod.email:
        return 'Email';
      case TwoFactorMethod.sms:
        return 'SMS';
      case TwoFactorMethod.passkey:
        return 'Passkey';
    }
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

  Future<int> _getRemainingTrustDays() async {
    final userId = SessionService.userId;
    if (userId == null) return 0;
    return await TwoFactorService.getRemainingTrustDays(userId);
  }

  Future<void> _removeTrust() async {
    final userId = SessionService.userId;
    if (userId == null) return;

    final result = await TwoFactorService.removeTrustedDevice(userId);
    if (mounted) {
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device trust removed'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {});
      } else {
        _showError(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2FA Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            _config?.isEnabled ?? false ? Icons.verified : Icons.lock_open,
                            color: (_config?.isEnabled ?? false) ? kNormalColor : Colors.grey,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Two-Factor Authentication',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  (_config?.isEnabled ?? false)
                                      ? '${_config?.enrolledMethods.length ?? 0} method(s) enrolled'
                                      : 'Not enabled',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Enrolled Methods
                  if ((_config?.enrolledMethods ?? []).isNotEmpty) ...[
                    Text(
                      'Enrolled Methods',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ...(_config?.enrolledMethods ?? []).map((method) {
                      final isSelected = method == _config?.primaryMethod;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Card(
                          child: ListTile(
                            leading: Icon(_getMethodIcon(method)),
                            title: Text(_getMethodName(method)),
                            subtitle: isSelected ? const Text('Primary method') : null,
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                if (!isSelected && (_config?.enrolledMethods.length ?? 0) > 1)
                                  PopupMenuItem(
                                    child: const Text('Set as primary'),
                                    onTap: () async {
                                      final userId = SessionService.userId;
                                      if (userId == null) return;
                                      final result = await TwoFactorService.setPrimaryMethod(userId, method);
                                      if (mounted) {
                                        if (result == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('${_getMethodName(method)} set as primary')),
                                          );
                                          _refreshConfig();
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(result)),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                PopupMenuItem(
                                  child: const Text('Remove'),
                                  onTap: () => _removeMethod(method),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],

                  const SizedBox(height: 24),

                  // Available Methods to Add
                  Text(
                    'Add More Methods',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...[TwoFactorMethod.totp, TwoFactorMethod.email, TwoFactorMethod.sms, TwoFactorMethod.passkey]
                      .where((method) => !(_config?.enrolledMethods.contains(method) ?? false))
                      .map((method) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(_getMethodIcon(method)),
                          title: Text(_getMethodName(method)),
                          trailing: ElevatedButton(
                            onPressed: () => _enrollNewMethod(method),
                            child: const Text('Add'),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Recovery Codes
                  if ((_config?.recoveryCodesRemaining ?? 0) > 0)
                    Card(
                      color: Colors.blue[50],
                      child: ListTile(
                        leading: Icon(Icons.shield, color: Colors.blue[700]),
                        title: const Text('Recovery Codes'),
                        subtitle: Text(
                          '${_config?.recoveryCodesRemaining ?? 0} code(s) available',
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            // View recovery codes
                            final userId = SessionService.userId;
                            if (userId == null) return;

                            final codes = await TwoFactorService.getRecoveryCodes(userId);
                            if (mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Recovery Codes'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Save these codes in a safe place. Each code can be used once if you lose access to all 2FA methods.',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: SelectableText(
                                            codes.join('\n'),
                                            style: const TextStyle(
                                              fontFamily: 'Courier',
                                              fontSize: 12,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Text('View'),
                        ),
                      ),
                    ),

                  // Device Trust Status
                  const SizedBox(height: 24),
                  Text(
                    'Device Trust',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<int>(
                    future: _getRemainingTrustDays(),
                    builder: (context, snapshot) {
                      final remainingDays = snapshot.data ?? 0;
                      if (remainingDays > 0) {
                        return Card(
                          color: Colors.green[50],
                          child: ListTile(
                            leading: Icon(Icons.verified_user, color: Colors.green[700]),
                            title: const Text('This device is trusted'),
                            subtitle: Text('$remainingDays day(s) remaining'),
                            trailing: TextButton(
                              onPressed: _removeTrust,
                              child: const Text('Remove'),
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.laptop, color: Colors.grey[600]),
                            title: const Text('This device is not trusted'),
                            subtitle: const Text('Trust this device to skip 2FA on next login'),
                          ),
                        );
                      }
                    },
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
