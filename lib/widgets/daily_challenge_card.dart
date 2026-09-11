import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/gamification_provider.dart';
import '../services/challenge_service.dart';
import 'achievement_content.dart';
import 'challenge_celebration.dart';
import '../screens/challenge_history.dart';

/// Prominent "Today's Challenge" card on the Calculate tab.
///
/// Shows the day's challenge icon/title/description, difficulty chip, live
/// progress bar with target, completion check, and opens the challenge history
/// screen on tap. Plays a celebration the first time today's challenge is seen
/// as completed.
class DailyChallengeCard extends ConsumerStatefulWidget {
  const DailyChallengeCard({super.key});

  @override
  ConsumerState<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends ConsumerState<DailyChallengeCard> {
  String? _celebratedDateKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final g = ref.watch(gamificationProvider).value;
    final challenge = g?.todayChallenge;

    if (challenge == null) return const SizedBox.shrink();

    // Celebrate the first time we see this day's challenge as completed.
    if (challenge.completed && _celebratedDateKey != challenge.dateKey) {
      _celebratedDateKey = challenge.dateKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showChallengeCelebration(context, challenge);
      });
    }

    final progress = (g?.todayChallengeProgress ?? challenge.progress)
        .clamp(0, challenge.target);
    final completed = g?.todayChallenge?.completed ?? challenge.completed;
    final tier = switch (ChallengeService.tierOf(challenge)) {
      ChallengeTier.medium => _DifficultyTier.medium,
      ChallengeTier.hard => _DifficultyTier.hard,
      ChallengeTier.easy => _DifficultyTier.easy,
    };

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChallengeHistoryScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(kSpaceMD),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: completed
                ? [kNormalColor.withOpacity(0.2), kAccent.withOpacity(0.08)]
                : [kAccent.withOpacity(0.15), kInfoColor.withOpacity(0.08)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(kRadiusLG),
          border: Border.all(
            color: completed
                ? kNormalColor.withOpacity(0.4)
                : kAccent.withOpacity(0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_fire_department,
                    size: 18, color: kAccent),
                const SizedBox(width: kSpaceSM),
                Expanded(
                  child: Text(
                    l10n.dailyChallengeToday,
                    style: TextStyle(
                      color: DynamicColors.textPrimary(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _TierChip(tier: tier),
                const SizedBox(width: kSpaceSM),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: DynamicColors.textSecondary(context),
                ),
              ],
            ),
            const SizedBox(height: kSpaceSM),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: DynamicColors.card(context),
                    borderRadius: BorderRadius.circular(kRadiusMD),
                    border: Border.all(color: DynamicColors.border(context)),
                  ),
                  child: Icon(
                    achievementIcon(challenge.icon),
                    color: completed ? kNormalColor : kAccent,
                    size: 26,
                  ),
                ),
                const SizedBox(width: kSpaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challengeTitle(l10n, challenge),
                        style: TextStyle(
                          color: DynamicColors.textPrimary(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        challengeDescription(l10n, challenge),
                        style: TextStyle(
                          color: DynamicColors.textSecondary(context),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (completed)
                  const Icon(Icons.check_circle, color: kNormalColor, size: 26),
              ],
            ),
            const SizedBox(height: kSpaceMD),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: challenge.target == 0 ? 0 : progress / challenge.target,
                minHeight: 8,
                backgroundColor: DynamicColors.border(context),
                color: completed ? kNormalColor : kAccent,
              ),
            ),
            const SizedBox(height: kSpaceSM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$progress/${challenge.target}',
                  style: TextStyle(
                    color: DynamicColors.textSecondary(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  l10n.challengePointsFormat(challenge.points),
                  style: TextStyle(
                    color: completed ? kNormalColor : kAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _DifficultyTier {
  easy,
  medium,
  hard,
}

class _TierChip extends StatelessWidget {
  const _TierChip({required this.tier});

  final _DifficultyTier tier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (tier) {
      _DifficultyTier.easy => (l10n.challengeTierEasy, kNormalColor),
      _DifficultyTier.medium => (l10n.challengeTierMedium, kWarningColor),
      _DifficultyTier.hard => (l10n.challengeTierHard, kErrorColor),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
