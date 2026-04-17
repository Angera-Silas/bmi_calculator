import 'package:flutter/material.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../main.dart';
import '../models/bmi_record.dart';
import '../services/auth_service.dart';
import '../services/locale_service.dart';
import '../services/session_service.dart';
import '../database/app_database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  int _totalChecks = 0;
  double? _avgBMI;

  bool get _isGuest => SessionService.isGuest;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final userId = SessionService.userId;
    if (userId == null) return;

    final userData = await AppDatabase.getUser(userId);
    final List<BmiRecord> history = await AppDatabase.fetchRecords(userId);

    double? avg;
    if (history.isNotEmpty) {
      avg = history.map((r) => r.bmiValue).reduce((a, b) => a + b) /
          history.length;
    }

    if (!mounted) return;
    setState(() {
      _userData = userData;
      _totalChecks = history.length;
      _avgBMI = avg;
      _isLoading = false;
      _nameController.text = userData?['name'] ?? '';
      _phoneController.text = userData?['phone'] ?? '';
    });
  }

  Future<void> _saveProfile() async {
    final userId = SessionService.userId;
    if (userId == null) return;

    setState(() => _isSaving = true);

    final newName = _nameController.text.trim().toUpperCase();
    final newPhone = _phoneController.text.trim();

    await AppDatabase.updateUser(userId, {'name': newName, 'phone': newPhone});

    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _isEditing = false;
      _userData?['name'] = newName;
      _userData?['phone'] = newPhone;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).profileUpdated),
        backgroundColor: kSuccessColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusSM)),
      ),
    );
  }

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context);
    final isGuest = _isGuest;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DynamicColors.card(context),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD)),
        title: Text(
          isGuest ? l10n.leaveGuestTitle : l10n.signOutTitle,
          style: TextStyle(color: DynamicColors.textPrimary(context)),
        ),
        content: Text(
          isGuest ? l10n.leaveGuestContent : l10n.signOutContent,
          style: TextStyle(color: DynamicColors.textSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel,
                style:
                    TextStyle(color: DynamicColors.textSecondary(context))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isGuest ? l10n.leave : l10n.signOut,
              style: const TextStyle(
                  color: kErrorColor, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (isGuest) {
        final userId = SessionService.userId;
        if (userId != null) await AppDatabase.deleteAllUserData(userId);
      }
      await AuthService.logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DynamicColors.card(context),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD)),
        title: Text(l10n.deleteAccountTitle,
            style: const TextStyle(color: kErrorColor)),
        content: Text(
          l10n.deleteAccountContent,
          style: TextStyle(color: DynamicColors.textSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel,
                style:
                    TextStyle(color: DynamicColors.textSecondary(context))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete,
                style: const TextStyle(
                    color: kErrorColor, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final error = await AuthService.deleteAccount();
      if (!mounted) return;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
        ));
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: DynamicColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: kSpaceMD),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: DynamicColors.border(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: kSpaceMD),
              Text(
                l10n.selectLanguage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: DynamicColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: kSpaceSM),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: LocaleService.supportedLanguages.entries.map((entry) {
                    return ListTile(
                      title: Text(
                        entry.value,
                        style: TextStyle(
                          color: DynamicColors.textPrimary(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        entry.key.toUpperCase(),
                        style: TextStyle(
                          color: DynamicColors.textSecondary(context),
                          fontSize: 11,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(ctx);
                        BMICalculatorApp.setLocale(context, Locale(entry.key));
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.profile,
          style: TextStyle(
            color: DynamicColors.textPrimary(context),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          if (!_isLoading && !_isEditing && !_isGuest)
            IconButton(
              icon: Icon(Icons.edit_outlined,
                  color: DynamicColors.textSecondary(context)),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing) ...[
            TextButton(
              onPressed: () => setState(() => _isEditing = false),
              child: Text(l10n.cancel,
                  style:
                      TextStyle(color: DynamicColors.textSecondary(context))),
            ),
            TextButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: Text(l10n.save,
                  style: const TextStyle(
                      color: kAccent, fontWeight: FontWeight.w700)),
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kAccent))
          : RefreshIndicator(
              color: kAccent,
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(kSpaceMD),
                children: [
                  // ── Guest banner ──────────────────────────────────────────
                  if (_isGuest) ...[
                    Container(
                      padding: const EdgeInsets.all(kSpaceMD),
                      decoration: BoxDecoration(
                        color: kAccent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(kRadiusMD),
                        border: Border.all(color: kAccent.withOpacity(0.25)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.cloud_off_outlined,
                              color: kAccent, size: 20),
                          const SizedBox(width: kSpaceSM),
                          Expanded(
                            child: Text(
                              l10n.guestModeBanner,
                              style: TextStyle(
                                fontSize: 12,
                                color: DynamicColors.textPrimary(context),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kSpaceLG),
                  ],

                  // ── Avatar ──────────────────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isGuest
                                  ? [const Color(0xFF607D8B), const Color(0xFF90A4AE)]
                                  : [kAccent, kAccentLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: kSpaceSM),
                        Text(
                          _isGuest
                              ? l10n.guestUser
                              : (_userData?['name'] ?? 'User'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: DynamicColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          _isGuest
                              ? l10n.guestModeLocal
                              : (_userData?['email'] ?? ''),
                          style: TextStyle(
                            fontSize: 13,
                            color: DynamicColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),

                  // ── Stats Row ───────────────────────────────────────────────
                  if (_totalChecks > 0) ...[
                    Row(
                      children: [
                        _StatCard(
                          label: l10n.totalChecks,
                          value: '$_totalChecks',
                          icon: Icons.history,
                          color: kAccent,
                        ),
                        const SizedBox(width: kSpaceSM),
                        _StatCard(
                          label: l10n.averageBmi,
                          value: _avgBMI?.toStringAsFixed(1) ?? '--',
                          icon: Icons.monitor_weight_outlined,
                          color:
                              _avgBMI != null ? getBMIColor(_avgBMI!) : kAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: kSpaceLG),
                  ],

                  // ── Personal Info (authenticated only) ──────────────────────
                  if (!_isGuest) ...[
                    _SectionHeader(context: context, title: l10n.personalInformation),
                    const SizedBox(height: kSpaceSM),
                    _InfoCard(
                      child: Column(
                        children: [
                          _isEditing
                              ? _EditableField(
                                  controller: _nameController,
                                  label: l10n.fullName,
                                  icon: Icons.person_outline,
                                )
                              : _InfoRow(
                                  icon: Icons.person_outline,
                                  label: l10n.fullName,
                                  value: _userData?['name'] ?? l10n.notAvailable,
                                ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: l10n.email,
                            value: _userData?['email'] ?? l10n.notAvailable,
                          ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                          _isEditing
                              ? _EditableField(
                                  controller: _phoneController,
                                  label: l10n.phone,
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                )
                              : _InfoRow(
                                  icon: Icons.phone_outlined,
                                  label: l10n.phone,
                                  value: _userData?['phone'] ?? l10n.notAvailable,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kSpaceLG),
                  ],

                  // ── Account Actions ─────────────────────────────────────────
                  _SectionHeader(context: context, title: l10n.account),
                  const SizedBox(height: kSpaceSM),

                  _InfoCard(
                    child: Column(
                      children: [
                        if (_isGuest) ...[
                          _ActionRow(
                            icon: Icons.person_add_outlined,
                            label: l10n.createAccount,
                            onTap: () =>
                                Navigator.pushReplacementNamed(context, '/register'),
                          ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                          _ActionRow(
                            icon: Icons.login,
                            label: l10n.signIn,
                            onTap: () =>
                                Navigator.pushReplacementNamed(context, '/login'),
                          ),
                        ] else ...[
                          _ActionRow(
                            icon: Icons.lock_outline,
                            label: l10n.changePassword,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/reset-password',
                              arguments: {'email': _userData?['email'] ?? ''},
                            ),
                          ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                          _ActionRow(
                            icon: Icons.delete_outline,
                            label: l10n.deleteAccount,
                            color: kErrorColor,
                            onTap: _deleteAccount,
                          ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                        ],
                        _ActionRow(
                          icon: Icons.logout,
                          label: _isGuest ? l10n.leaveGuestMode : l10n.signOut,
                          color: kErrorColor,
                          onTap: _signOut,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),

                  // ── Language ─────────────────────────────────────────────────
                  _SectionHeader(context: context, title: l10n.language),
                  const SizedBox(height: kSpaceSM),
                  _InfoCard(
                    child: _ActionRow(
                      icon: Icons.language_outlined,
                      label: l10n.selectLanguage,
                      onTap: _showLanguagePicker,
                    ),
                  ),
                  const SizedBox(height: kSpaceXXL),
                ],
              ),
            ),
    );
  }

  String _getInitials() {
    if (_isGuest) return 'G';
    final name = _userData?['name'] as String? ?? '';
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return name[0];
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(kSpaceMD),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: kSpaceSM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w900, color: color),
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: DynamicColors.card(context),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: DynamicColors.border(context)),
        ),
        child: child,
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: DynamicColors.iconColor(context), size: 18),
          const SizedBox(width: kSpaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: DynamicColors.textSecondary(context),
                        fontWeight: FontWeight.w600)),
                Text(value,
                    style: TextStyle(
                        fontSize: 15,
                        color: DynamicColors.textPrimary(context),
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;

  const _EditableField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: kAccent, size: 18),
          const SizedBox(width: kSpaceMD),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: TextStyle(
                  fontSize: 15,
                  color: DynamicColors.textPrimary(context),
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(fontSize: 11, color: kAccent),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? DynamicColors.textPrimary(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kRadiusMD),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: kSpaceMD, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: kSpaceMD),
            Text(label,
                style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(Icons.chevron_right,
                color: DynamicColors.textSecondary(context), size: 18),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final BuildContext context;
  final String title;

  const _SectionHeader({required this.context, required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: DynamicColors.textSecondary(context),
        ),
      );
}
