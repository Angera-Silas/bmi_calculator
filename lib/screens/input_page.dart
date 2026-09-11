import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/gamification_provider.dart';
import '../providers/input_tab_provider.dart';
import '../providers/session_provider.dart';
import '../widgets/achievement_celebration.dart';
import 'input_home.dart';
import 'input_history.dart';
import 'health_dashboard.dart';
import 'stats_screen.dart';

class InputPage extends ConsumerWidget {
  const InputPage({super.key});

  static const _tabIcons = [
    (icon: Icons.monitor_weight_outlined, activeIcon: Icons.monitor_weight),
    (icon: Icons.history_outlined, activeIcon: Icons.history),
    (icon: Icons.insights_outlined, activeIcon: Icons.insights),
    (icon: Icons.space_dashboard_outlined, activeIcon: Icons.space_dashboard),
  ];

  static const _pages = [
    InputHome(),
    InputHistory(),
    StatsScreen(),
    HealthDashboard(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedIndex = ref.watch(inputTabIndexProvider);
    final tabLabels = [
      l10n.tabCalculate,
      l10n.tabHistory,
      l10n.tabInsights,
      l10n.tabDashboard
    ];
    final subtitles = [
      l10n.subtitleCalculate,
      l10n.subtitleHistory,
      l10n.subtitleInsights,
      l10n.subtitleDashboard
    ];

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
              tabLabels[selectedIndex],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: DynamicColors.textPrimary(context),
              ),
            ),
            Text(
              subtitles[selectedIndex],
              style: TextStyle(
                fontSize: 12,
                color: DynamicColors.textSecondary(context),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/achievements'),
            child: const _PointsBadge(),
          ),
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
                  _getInitials(ref),
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
        index: selectedIndex,
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
            padding: const EdgeInsets.symmetric(
                horizontal: kSpaceSM, vertical: kSpaceXS),
            child: Row(
              children: List.generate(_tabIcons.length, (i) {
                final tab = _tabIcons[i];
                final active = i == selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(inputTabIndexProvider.notifier).set(i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: kSpaceXS),
                      decoration: BoxDecoration(
                        color: active
                            ? kAccent.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(kRadiusMD),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            active ? tab.activeIcon : tab.icon,
                            color: active
                                ? kAccent
                                : DynamicColors.iconColor(context),
                            size: 22,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tabLabels[i],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w500,
                              color: active
                                  ? kAccent
                                  : DynamicColors.textSecondary(context),
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

  String _getInitials(WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session.isGuest) return 'G';
    final name = FirebaseAuth.instance.currentUser?.displayName ?? '';
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }
}

/// Trophy icon showing the user's points; listens for newly unlocked
/// achievements and plays the celebration dialog when one arrives.
class _PointsBadge extends ConsumerStatefulWidget {
  const _PointsBadge();

  @override
  ConsumerState<_PointsBadge> createState() => _PointsBadgeState();
}

class _PointsBadgeState extends ConsumerState<_PointsBadge>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final gamification = ref.read(gamificationProvider);
    if (gamification.hasValue) {
      _unlockedSeen = gamification.value!.achievementCount;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int _unlockedSeen = 0;

  @override
  Widget build(BuildContext context) {
    final gamification = ref.watch(gamificationProvider);
    final g = gamification.value;
    final points = g?.points ?? 0;

    // New unlocks since we last saw → celebrate.
    final unlocked = g?.achievementCount ?? 0;
    if (unlocked > _unlockedSeen) {
      _unlockedSeen = unlocked;
      final recent = g?.recentUnlocks ?? const [];
      if (recent.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final last = recent.last;
          showAchievementCelebration(context, last);
        });
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(right: kSpaceSM),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: kAccent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 16, color: kAccent),
              const SizedBox(width: 4),
              Text(
                '$points',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: kAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
