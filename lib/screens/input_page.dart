import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/session_service.dart';
import 'input_home.dart';
import 'input_history.dart';
import 'stats_screen.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  int _selectedIndex = 0;

  static const _tabIcons = [
    (icon: Icons.monitor_weight_outlined, activeIcon: Icons.monitor_weight),
    (icon: Icons.history_outlined, activeIcon: Icons.history),
    (icon: Icons.insights_outlined, activeIcon: Icons.insights),
  ];

  late final List<Widget> _pages = const [
    InputHome(),
    InputHistory(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabLabels = [l10n.tabCalculate, l10n.tabHistory, l10n.tabInsights];
    final subtitles = [l10n.subtitleCalculate, l10n.subtitleHistory, l10n.subtitleInsights];

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),

      // ── App Bar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tabLabels[_selectedIndex],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: DynamicColors.textPrimary(context),
              ),
            ),
            Text(
              subtitles[_selectedIndex],
              style: TextStyle(
                fontSize: 12,
                color: DynamicColors.textSecondary(context),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              margin: const EdgeInsets.only(right: kSpaceMD),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kAccent, kAccentLight],
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
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Body ─────────────────────────────────────────────────────────────
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // ── Bottom Navigation ─────────────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: DynamicColors.surface(context),
          border: Border(top: BorderSide(color: DynamicColors.border(context))),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpaceSM, vertical: kSpaceXS),
            child: Row(
              children: List.generate(_tabIcons.length, (i) {
                final tab = _tabIcons[i];
                final active = i == _selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: kSpaceXS),
                      decoration: BoxDecoration(
                        color: active ? kAccent.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(kRadiusMD),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            active ? tab.activeIcon : tab.icon,
                            color: active ? kAccent : DynamicColors.iconColor(context),
                            size: 22,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tabLabels[i],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                              color: active ? kAccent : DynamicColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (SessionService.isGuest) return 'G';
    final name = FirebaseAuth.instance.currentUser?.displayName ?? '';
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }
}
