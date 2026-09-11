import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/daily_challenge.dart';
import '../providers/gamification_provider.dart';
import '../widgets/achievement_content.dart';

/// Challenge history: the user's past daily challenges, newest first.
class ChallengeHistoryScreen extends ConsumerWidget {
  const ChallengeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(challengeHistoryProvider);
    final formatter = DateFormat('EEE, MMM d');

    return Scaffold(
      backgroundColor: DynamicColors.bg(context),
      appBar: AppBar(
        backgroundColor: DynamicColors.bg(context),
        elevation: 0,
        title: Text(
          l10n.challengeHistoryTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: DynamicColors.textPrimary(context),
          ),
        ),
      ),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            l10n.challengeHistoryError,
            style: TextStyle(color: DynamicColors.textSecondary(context)),
          ),
        ),
        data: (challenges) => challenges.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department,
                        size: 48, color: kAccent),
                    const SizedBox(height: kSpaceMD),
                    Text(
                      l10n.challengeHistoryEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: DynamicColors.textSecondary(context),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(kSpaceMD),
                itemCount: challenges.length,
                separatorBuilder: (_, __) => const SizedBox(height: kSpaceSM),
                itemBuilder: (context, index) =>
                    _ChallengeRow(challenges[index], formatter),
              ),
      ),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  const _ChallengeRow(this.challenge, this.formatter);

  final DailyChallenge challenge;
  final DateFormat formatter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = DateTime.tryParse(challenge.dateKey);

    return Container(
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(
          color: challenge.completed
              ? kNormalColor.withOpacity(0.4)
              : DynamicColors.border(context),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: challenge.completed
                  ? kNormalColor.withOpacity(0.12)
                  : DynamicColors.border(context),
              borderRadius: BorderRadius.circular(kRadiusMD),
            ),
            child: Icon(
              achievementIcon(challenge.icon),
              color: challenge.completed
                  ? kNormalColor
                  : DynamicColors.iconColor(context),
              size: 24,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date == null ? challenge.dateKey : formatter.format(date),
                  style: TextStyle(
                    color: DynamicColors.textSecondary(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (challenge.completed)
                const Icon(Icons.check_circle, color: kNormalColor, size: 20)
              else
                Text(
                  '${challenge.progress}/${challenge.target}',
                  style: TextStyle(
                    color: DynamicColors.textSecondary(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              const SizedBox(height: 2),
              Text(
                '+${challenge.points}',
                style: TextStyle(
                  color: challenge.completed ? kNormalColor : kAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
