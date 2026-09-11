/// Streak state for a user: current run and longest-ever run (in days).
class UserStreak {
  final int current;
  final int best;

  const UserStreak({required this.current, required this.best});

  static const UserStreak empty = UserStreak(current: 0, best: 0);

  UserStreak copyWith({int? current, int? best}) => UserStreak(
        current: current ?? this.current,
        best: best ?? this.best,
      );

  Map<String, dynamic> toMap() => {'current': current, 'best': best};

  factory UserStreak.fromMap(Map<String, dynamic> map) => UserStreak(
        current: map['current'] as int? ?? 0,
        best: map['best'] as int? ?? 0,
      );
}

/// Pure streak algorithm over a set of activity day keys ("yyyy-MM-dd").
///
/// A streak is the count of consecutive days where the user logged at least
/// one measurement. The *current* streak anchors on today; if the user has no
/// activity yet today, an activity logged yesterday keeps it alive (grace day).
/// The *best* streak is the longest run anywhere in history.
class StreakCalculator {
  /// Normalizes a [DateTime] to its local "yyyy-MM-dd" key.
  static String dayKey(DateTime time) {
    final m = time.month.toString().padLeft(2, '0');
    final d = time.day.toString().padLeft(2, '0');
    return '${time.year}-$m-$d';
  }

  /// Computes current + best streaks from a set of activity day keys.
  static UserStreak compute(Set<String> activityDays, {DateTime? now}) {
    if (activityDays.isEmpty) return UserStreak.empty;
    final anchor = now ?? DateTime.now();
    final today = dayKey(anchor);
    final sorted = activityDays.toList()..sort();

    var best = 0;
    var run = 0;
    String? prevKey;
    for (final key in sorted) {
      run =
          prevKey != null && _differenceInDays(prevKey, key) == 1 ? run + 1 : 1;
      if (run > best) best = run;
      prevKey = key;
    }

    // Current streak: count back from the anchor. No activity today → try
    // yesterday first (grace), so a fresh morning doesn't reset the streak.
    var cursor = today;
    var current = 0;
    if (sorted.contains(today)) {
      while (sorted.contains(cursor)) {
        current++;
        cursor = _minusOneDay(cursor);
      }
    } else if (sorted
        .contains(dayKey(anchor.subtract(const Duration(days: 1))))) {
      cursor = dayKey(anchor.subtract(const Duration(days: 1)));
      while (sorted.contains(cursor)) {
        current++;
        cursor = _minusOneDay(cursor);
      }
    }

    return UserStreak(current: current, best: best);
  }

  static int _differenceInDays(String fromKey, String toKey) {
    final a = DateTime.parse(fromKey);
    final b = DateTime.parse(toKey);
    return b.difference(DateTime(a.year, a.month, a.day)).inDays;
  }

  static String _minusOneDay(String key) {
    final d = DateTime.parse(key);
    final prev = d.subtract(const Duration(days: 1));
    return dayKey(prev);
  }
}
