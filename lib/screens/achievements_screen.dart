import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/achievement.dart';
import '../models/user_streak.dart';
import '../providers/gamification_provider.dart';
import '../widgets/achievement_content.dart';

/// Full-screen achievements hub (Sprint 2.4).
///
/// Shows the total points header, current/best streak cards, and a grid of all
/// achievements from [achievementCatalog] with locked vs unlocked states.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final g = ref.watch(gamificationProvider);

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        title: Text(
          l10n.achievementsTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: DynamicColors.textPrimary(context),
          ),
        ),
      ),
      body: g.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            l10n.achievementsError,
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
        ),
        data: (state) => ListView(
          padding: const EdgeInsets.all(kSpaceMD),
          children: [
            _PointsHeaderCard(
              points: state.points,
              unlocked: state.achievementCount,
              total: achievementCatalog.length,
              l10n: l10n,
            ),
            const SizedBox(height: kSpaceMD),
            _buildStreakRow(context, l10n, state.streak),
            const SizedBox(height: kSpaceMD),
            _buildAchievementGrid(context, l10n, state),
            const SizedBox(height: kSpaceLG),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakRow(
      BuildContext context, AppLocalizations l10n, UserStreak streak) {
    return Row(
      children: [
        Expanded(
          child: _StreakCard(
            label: l10n.achievementsCurrentStreak,
            days: streak.current,
            icon: Icons.local_fire_department,
            color: kAccent,
          ),
        ),
        const SizedBox(width: kSpaceSM),
        Expanded(
          child: _StreakCard(
            label: l10n.achievementsBestStreak,
            days: streak.best,
            icon: Icons.military_tech,
            color: kInfoColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementGrid(
      BuildContext context, AppLocalizations l10n, GamificationState state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: kSpaceSM,
      crossAxisSpacing: kSpaceSM,
      childAspectRatio: 1.05,
      children: [
        for (final a in achievementCatalog)
          _AchievementTile(
            achievement: a,
            unlocked: state.unlockedAchievements.contains(a.id),
          ),
      ],
    );
  }
}

/// Gradient points header: trophy, total points, unlocked x/y progress bar.
class _PointsHeaderCard extends StatelessWidget {
  const _PointsHeaderCard({
    required this.points,
    required this.unlocked,
    required this.total,
    required this.l10n,
  });

  final int points;
  final int unlocked;
  final int total;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : unlocked / total;

    return Container(
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kAccent, kAccentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kRadiusLG),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, size: 28, color: Colors.white),
              const SizedBox(width: kSpaceMD),
              Text(
                '$points',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(width: kSpaceSM),
              Text(
                l10n.achievementsTotalPoints,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceMD),
          Text(
            l10n.achievementsUnlockedCount(unlocked, total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: kSpaceSM),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact streak stat card (current or best).
class _StreakCard extends StatelessWidget {
  const _StreakCard({
    required this.label,
    required this.days,
    required this.icon,
    required this.color,
  });

  final String label;
  final int days;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(color: DynamicColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: kSpaceSM),
          Text(
            l10n.achievementsStreakDays(days),
            style: TextStyle(
              color: DynamicColors.textPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: DynamicColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// One achievement tile in the grid.
class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement, required this.unlocked});

  final Achievement achievement;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = DynamicColors.textPrimary(context);
    final secondary = DynamicColors.textSecondary(context);
    final iconColor = unlocked ? kAccent : secondary.withOpacity(0.8);
    final titleColor = unlocked ? primary : secondary;
    final pointsColor = unlocked ? kAccent : secondary;

    return Container(
      padding: const EdgeInsets.all(kSpaceSM),
      decoration: BoxDecoration(
        color:
            unlocked ? kAccent.withOpacity(0.08) : DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(
          color: unlocked
              ? kAccent.withOpacity(0.35)
              : DynamicColors.border(context),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievementIcon(achievement.icon),
                  color: iconColor,
                  size: 22,
                ),
              ),
              if (!unlocked) ...[
                const Spacer(),
                const Icon(Icons.lock_rounded, size: 14, color: Colors.grey),
              ] else ...[
                const Spacer(),
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: kAccent.withOpacity(0.9),
                ),
              ],
            ],
          ),
          const SizedBox(height: kSpaceSM),
          Expanded(
            child: Center(
              child: Text(
                achievementTitle(l10n, achievement),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
            ),
          ),
          const SizedBox(height: kSpaceSM),
          Text(
            '+${achievement.points}',
            style: TextStyle(
              color: pointsColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
