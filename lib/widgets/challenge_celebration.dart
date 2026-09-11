import 'package:flutter/material.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/daily_challenge.dart';
import 'achievement_content.dart';
import 'confetti_painter.dart';

/// Animated overlay celebrating a completed daily challenge.
Future<void> showChallengeCelebration(
  BuildContext context,
  DailyChallenge challenge,
) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) =>
        _ChallengeCelebrationDialog(challenge: challenge),
    transitionBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: child,
      ),
    ),
  );
}

class _ChallengeCelebrationDialog extends StatefulWidget {
  const _ChallengeCelebrationDialog({required this.challenge});

  final DailyChallenge challenge;

  @override
  State<_ChallengeCelebrationDialog> createState() =>
      _ChallengeCelebrationDialogState();
}

class _ChallengeCelebrationDialogState
    extends State<_ChallengeCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final challenge = widget.challenge;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, t, _) => Transform.scale(
            scale: t,
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: DynamicColors.card(context),
                borderRadius: BorderRadius.circular(kRadiusLG),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 24),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 160,
                    height: 120,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) => CustomPaint(
                          painter: ConfettiPainter(_controller.value)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kNormalColor, kAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kNormalColor.withValues(alpha: 0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.task_alt,
                        size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${l10n.challengeCompleted} +${challenge.points}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kNormalColor,
                      letterSpacing: 0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    challengeTitle(l10n, challenge),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: DynamicColors.textPrimary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.achievementNice),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
