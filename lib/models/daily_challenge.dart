/// A single day's challenge. One challenge is generated per calendar day and
/// tracks progress against a target derived from the definition.
class DailyChallenge {
  final String userId;
  final String dateKey; // yyyy-MM-dd
  final String definitionId;
  final String titleKey;
  final String descriptionKey;
  final String icon;
  final int target;
  final int points;
  final int progress;
  final bool completed;
  final DateTime? completedAt;

  const DailyChallenge({
    required this.userId,
    required this.dateKey,
    required this.definitionId,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.target,
    required this.points,
    this.progress = 0,
    this.completed = false,
    this.completedAt,
  });

  DailyChallenge copyWith({
    int? progress,
    bool? completed,
    DateTime? completedAt,
  }) =>
      DailyChallenge(
        userId: userId,
        dateKey: dateKey,
        definitionId: definitionId,
        titleKey: titleKey,
        descriptionKey: descriptionKey,
        icon: icon,
        target: target,
        points: points,
        progress: progress ?? this.progress,
        completed: completed ?? this.completed,
        completedAt: completedAt ?? this.completedAt,
      );

  Map<String, dynamic> toMap() => {
        'user_id': userId,
        'date_key': dateKey,
        'definition_id': definitionId,
        'title_key': titleKey,
        'description_key': descriptionKey,
        'icon': icon,
        'target': target,
        'points': points,
        'progress': progress,
        'completed': completed ? 1 : 0,
        'completed_at': completedAt?.millisecondsSinceEpoch,
      };

  factory DailyChallenge.fromMap(Map<String, dynamic> map) => DailyChallenge(
        userId: map['user_id'] as String,
        dateKey: map['date_key'] as String,
        definitionId: map['definition_id'] as String,
        titleKey: map['title_key'] as String? ?? '',
        descriptionKey: map['description_key'] as String? ?? '',
        icon: map['icon'] as String? ?? 'task_alt',
        target: map['target'] as int,
        points: map['points'] as int? ?? 10,
        progress: map['progress'] as int? ?? 0,
        completed: (map['completed'] as int? ?? 0) == 1,
        completedAt: map['completed_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int)
            : null,
      );
}

/// Definition skeleton for the challenge catalog.
class ChallengeDefinition {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String icon;
  final int target;
  final int points;

  const ChallengeDefinition({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.target,
    required this.points,
  });
}

/// Rotating daily challenge catalog. The service picks one per calendar day
/// deterministically (by day-of-year index).
final List<ChallengeDefinition> challengeCatalog = [
  ChallengeDefinition(
    id: 'log_bmi',
    titleKey: 'challengeLogBmiTitle',
    descriptionKey: 'challengeLogBmiDesc',
    icon: 'calculate',
    target: 1,
    points: 10,
  ),
  ChallengeDefinition(
    id: 'log_bp',
    titleKey: 'challengeLogBpTitle',
    descriptionKey: 'challengeLogBpDesc',
    icon: 'bloodtype',
    target: 1,
    points: 10,
  ),
  ChallengeDefinition(
    id: 'log_glucose',
    titleKey: 'challengeLogGlucoseTitle',
    descriptionKey: 'challengeLogGlucoseDesc',
    icon: 'water_drop',
    target: 1,
    points: 10,
  ),
  ChallengeDefinition(
    id: 'log_any_three',
    titleKey: 'challengeLogAnyThreeTitle',
    descriptionKey: 'challengeLogAnyThreeDesc',
    icon: 'add_chart',
    target: 3,
    points: 15,
  ),
  ChallengeDefinition(
    id: 'log_healthy',
    titleKey: 'challengeLogHealthyTitle',
    descriptionKey: 'challengeLogHealthyDesc',
    icon: 'health_and_safety',
    target: 1,
    points: 20,
  ),
];
