/// When a glucose reading was taken relative to meals.
enum GlucoseMeasurementType {
  fasting,
  postMeal,
  random;

  /// Database / Firestore storage value.
  String get storageValue => switch (this) {
        GlucoseMeasurementType.fasting => 'fasting',
        GlucoseMeasurementType.postMeal => 'post_meal',
        GlucoseMeasurementType.random => 'random',
      };

  static GlucoseMeasurementType fromStorage(String? value) => switch (value) {
        'post_meal' => GlucoseMeasurementType.postMeal,
        'random' => GlucoseMeasurementType.random,
        _ => GlucoseMeasurementType.fasting,
      };
}

/// ADA / WHO glucose status categories.
enum BloodSugarStatus {
  normal,
  prediabetes,
  diabetes,
}

/// Glucose reading in mg/dL, classified by ADA thresholds per measurement type.
///
/// Used by both the local SQLite database and Firestore sync.
/// [id] is always a locally generated UUID; [remoteId] is set after the first
/// successful push to Firestore.
class BloodSugarRecord {
  final String id; // UUID — local primary key
  final String userId; // Firebase UID or SessionService.guestId
  final int glucoseLevel; // mg/dL
  final GlucoseMeasurementType measurementType;
  final String? mealContext; // e.g. "after breakfast"
  final DateTime measurementTime;
  final String? notes;
  final bool isSynced;
  final bool isDeleted; // soft-delete flag for offline deletes
  final String? remoteId; // Firestore doc ID — set after first push

  const BloodSugarRecord({
    required this.id,
    required this.userId,
    required this.glucoseLevel,
    this.measurementType = GlucoseMeasurementType.fasting,
    this.mealContext,
    required this.measurementTime,
    this.notes,
    this.isSynced = false,
    this.isDeleted = false,
    this.remoteId,
  }) : assert(glucoseLevel >= 20 && glucoseLevel <= 800);

  BloodSugarRecord copyWith({
    String? id,
    String? userId,
    int? glucoseLevel,
    GlucoseMeasurementType? measurementType,
    String? mealContext,
    DateTime? measurementTime,
    String? notes,
    bool? isSynced,
    bool? isDeleted,
    String? remoteId,
  }) {
    return BloodSugarRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      glucoseLevel: glucoseLevel ?? this.glucoseLevel,
      measurementType: measurementType ?? this.measurementType,
      mealContext: mealContext ?? this.mealContext,
      measurementTime: measurementTime ?? this.measurementTime,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  /// ADA classification based on the measurement type.
  BloodSugarStatus get status {
    final value = glucoseLevel;
    return switch (measurementType) {
      GlucoseMeasurementType.fasting => value < 100
          ? BloodSugarStatus.normal
          : value < 126
              ? BloodSugarStatus.prediabetes
              : BloodSugarStatus.diabetes,
      GlucoseMeasurementType.postMeal ||
      GlucoseMeasurementType.random =>
        value < 140
            ? BloodSugarStatus.normal
            : value < 200
                ? BloodSugarStatus.prediabetes
                : BloodSugarStatus.diabetes,
    };
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'glucose_level': glucoseLevel,
        'measurement_type': measurementType.storageValue,
        'meal_context': mealContext,
        'measurement_time': measurementTime.millisecondsSinceEpoch,
        'notes': notes,
        'is_synced': isSynced ? 1 : 0,
        'is_deleted': isDeleted ? 1 : 0,
        'remote_id': remoteId,
      };

  factory BloodSugarRecord.fromMap(Map<String, dynamic> map) {
    return BloodSugarRecord(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      glucoseLevel: map['glucose_level'] as int,
      measurementType: GlucoseMeasurementType.fromStorage(
          map['measurement_type'] as String?),
      mealContext: map['meal_context'] as String?,
      measurementTime:
          DateTime.fromMillisecondsSinceEpoch(map['measurement_time'] as int),
      notes: map['notes'] as String?,
      isSynced: (map['is_synced'] as int? ?? 0) == 1,
      isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
      remoteId: map['remote_id'] as String?,
    );
  }

  /// Firestore representation (no local-only fields).
  Map<String, dynamic> toFirestoreMap(String uid) => {
        'userId': uid,
        'localId': id,
        'glucoseLevel': glucoseLevel,
        'measurementType': measurementType.storageValue,
        'mealContext': mealContext,
        'measurementTime': measurementTime.toUtc().millisecondsSinceEpoch,
        'notes': notes,
      };
}

/// Estimated A1C (%) from a set of readings, using the ADA eAG formula:
/// A1C% = (average glucose mg/dL + 46.7) / 28.7.
class A1CEstimator {
  /// Returns null when [records] is empty.
  static double? fromRecords(List<BloodSugarRecord> records) {
    if (records.isEmpty) return null;
    final avg = records.map((r) => r.glucoseLevel).reduce((a, b) => a + b) /
        records.length;
    return fromAverageGlucose(avg);
  }

  /// A1C (%) from a given average glucose in mg/dL.
  static double fromAverageGlucose(double avgGlucoseMgDl) {
    return (avgGlucoseMgDl + 46.7) / 28.7;
  }

  /// Current ADA classification of an A1C percentage.
  static BloodSugarStatus statusForA1C(double a1c) {
    if (a1c < 5.7) return BloodSugarStatus.normal;
    if (a1c < 6.5) return BloodSugarStatus.prediabetes;
    return BloodSugarStatus.diabetes;
  }
}
