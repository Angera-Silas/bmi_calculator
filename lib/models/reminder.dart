import 'dart:convert';

/// Smart reminder categories (Sprint 2.3).
///
/// Pure Dart — icon/title resolution happens in the presentation layer via
/// [ReminderService] metadata + l10n keys.
enum ReminderType {
  bmiCheck('bmi_check'),
  hydration('hydration'),
  medication('medication'),
  activity('activity'),
  healthTip('health_tip'),
  dailyChallenge('daily_challenge');

  final String id;
  const ReminderType(this.id);

  static ReminderType fromId(String id) => ReminderType.values.firstWhere(
        (t) => t.id == id,
        orElse: () => ReminderType.bmiCheck,
      );
}

/// A scheduled local-notification reminder for one user.
///
/// Days of week are packed into a bitmask where bit 0 = Monday ...
/// bit 6 = Sunday (matching `DateTime.weekday - 1`). `127` means daily.
///
/// The integer [id] doubles as the base for deterministic notification IDs so
/// queued occurrences can be cancelled precisely (see [NotificationService]).
class Reminder {
  final int? id; // null until inserted (TEXT-free PK: INTEGER AUTOINCREMENT)
  final String userId;
  final ReminderType type;

  /// User-facing label — only meaningful for medication (e.g. "Metformin").
  final String? label;
  final int hour; // 0-23, local time
  final int minute; // 0-59
  final int days; // bitmask: 1 << (DateTime.weekday - 1)
  final bool enabled;

  /// Extra JSON payload (e.g. the challenge reminder contract from
  /// [ChallengeService.reminderPayload]).
  final Map<String, dynamic>? payload;
  final DateTime createdAt;

  static const int everyDay = 127; // 0b1111111

  const Reminder({
    this.id,
    required this.userId,
    required this.type,
    this.label,
    required this.hour,
    required this.minute,
    this.days = everyDay,
    this.enabled = true,
    this.payload,
    required this.createdAt,
  });

  /// Whether this reminder fires on [weekday] (DateTime convention:
  /// 1 = Monday, 7 = Sunday).
  bool enabledOn(int weekday) => (days & (1 << (weekday - 1))) != 0;

  Reminder copyWith({
    int? id,
    String? userId,
    ReminderType? type,
    String? label,
    int? hour,
    int? minute,
    int? days,
    bool? enabled,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
  }) =>
      Reminder(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        label: label ?? this.label,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        days: days ?? this.days,
        enabled: enabled ?? this.enabled,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'type': type.id,
        'label': label,
        'hour': hour,
        'minute': minute,
        'days': days,
        'enabled': enabled ? 1 : 0,
        'payload': payload == null ? null : jsonEncode(payload),
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory Reminder.fromMap(Map<String, dynamic> map) => Reminder(
        id: map['id'] as int?,
        userId: map['user_id'] as String,
        type: ReminderType.fromId(map['type'] as String),
        label: map['label'] as String?,
        hour: map['hour'] as int,
        minute: map['minute'] as int,
        days: map['days'] as int,
        enabled: (map['enabled'] as int) == 1,
        payload: map['payload'] == null
            ? null
            : (jsonDecode(map['payload'] as String) as Map)
                .cast<String, dynamic>(),
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      );
}
