import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/bmi_record.dart';
import '../services/auth_service.dart';
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
        content: const Text('Profile updated'),
        backgroundColor: kSuccessColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusSM)),
      ),
    );
  }

  Future<void> _signOut() async {
    final isGuest = _isGuest;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DynamicColors.card(context),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD)),
        title: Text(
          isGuest ? 'Leave guest mode?' : 'Sign out?',
          style: TextStyle(color: DynamicColors.textPrimary(context)),
        ),
        content: Text(
          isGuest
              ? 'Your local data will be cleared. Sign in or create an account to keep your history.'
              : 'You can sign back in any time to access your synced data.',
          style: TextStyle(color: DynamicColors.textSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style:
                    TextStyle(color: DynamicColors.textSecondary(context))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isGuest ? 'Leave' : 'Sign Out',
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DynamicColors.card(context),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMD)),
        title: const Text('Delete account?',
            style: TextStyle(color: kErrorColor)),
        content: Text(
          'This permanently deletes your account and all data. This cannot be undone.',
          style: TextStyle(color: DynamicColors.textSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style:
                    TextStyle(color: DynamicColors.textSecondary(context))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
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
              child: Text('Cancel',
                  style:
                      TextStyle(color: DynamicColors.textSecondary(context))),
            ),
            TextButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: const Text('Save',
                  style: TextStyle(
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
                              'Guest mode — data is stored locally only. Create an account to sync across devices.',
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
                              ? 'Guest User'
                              : (_userData?['name'] ?? 'User'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: DynamicColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          _isGuest
                              ? 'Guest mode · data stored locally'
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
                          label: 'Total Checks',
                          value: '$_totalChecks',
                          icon: Icons.history,
                          color: kAccent,
                        ),
                        const SizedBox(width: kSpaceSM),
                        _StatCard(
                          label: 'Average BMI',
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
                    _SectionHeader(context: context, title: 'Personal Information'),
                    const SizedBox(height: kSpaceSM),
                    _InfoCard(
                      child: Column(
                        children: [
                          _isEditing
                              ? _EditableField(
                                  controller: _nameController,
                                  label: 'Full name',
                                  icon: Icons.person_outline,
                                )
                              : _InfoRow(
                                  icon: Icons.person_outline,
                                  label: 'Full name',
                                  value: _userData?['name'] ?? 'N/A',
                                ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: _userData?['email'] ?? 'N/A',
                          ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                          _isEditing
                              ? _EditableField(
                                  controller: _phoneController,
                                  label: 'Phone',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                )
                              : _InfoRow(
                                  icon: Icons.phone_outlined,
                                  label: 'Phone',
                                  value: _userData?['phone'] ?? 'N/A',
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: kSpaceLG),
                  ],

                  // ── Account Actions ─────────────────────────────────────────
                  _SectionHeader(context: context, title: 'Account'),
                  const SizedBox(height: kSpaceSM),

                  _InfoCard(
                    child: Column(
                      children: [
                        if (_isGuest) ...[
                          _ActionRow(
                            icon: Icons.person_add_outlined,
                            label: 'Create Account',
                            onTap: () =>
                                Navigator.pushReplacementNamed(context, '/register'),
                          ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                          _ActionRow(
                            icon: Icons.login,
                            label: 'Sign In',
                            onTap: () =>
                                Navigator.pushReplacementNamed(context, '/login'),
                          ),
                        ] else ...[
                          _ActionRow(
                            icon: Icons.lock_outline,
                            label: 'Change Password',
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
                            label: 'Delete Account',
                            color: kErrorColor,
                            onTap: _deleteAccount,
                          ),
                          Divider(
                              color: DynamicColors.border(context), height: 1),
                        ],
                        _ActionRow(
                          icon: Icons.logout,
                          label: _isGuest ? 'Leave Guest Mode' : 'Sign Out',
                          color: kErrorColor,
                          onTap: _signOut,
                        ),
                      ],
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
