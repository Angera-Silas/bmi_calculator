/// Blood pressure categories (WHO / ACC-AHA aligned).
enum BloodPressureCategory {
  normal,
  elevated,
  stage1,
  stage2,
  crisis,
}

/// Blood pressure reading model. Used by SQLite (source of truth) and
/// Firestore sync.
///
/// The [id] field is always a UUID generated locally.
/// [remoteId] is the Firestore document ID — null until first successful sync.
/// [isDeleted] enables soft-delete so offline deletions can be pushed on reconnect.
class BloodPressureRecord {
  final String id; // UUID — local primary key
  final String userId; // Firebase UID or SessionService.guestId
  final int systolic; // mmHg
  final int diastolic; // mmHg
  final int? pulse; // bpm, optional
  final DateTime measurementTime;
  final String? notes;
  final bool isSynced;
  final bool isDeleted; // soft-delete flag for offline deletes
  final String? remoteId; // Firestore doc ID — set after first push

  const BloodPressureRecord({
    required this.id,
    required this.userId,
    required this.systolic,
    required this.diastolic,
    this.pulse,
    required this.measurementTime,
    this.notes,
    this.isSynced = false,
    this.isDeleted = false,
    this.remoteId,
  })  : assert(systolic >= 50 && systolic <= 300),
        assert(diastolic >= 30 && diastolic <= 200);

  BloodPressureRecord copyWith({
    String? id,
    String? userId,
    int? systolic,
    int? diastolic,
    int? pulse,
    DateTime? measurementTime,
    String? notes,
    bool? isSynced,
    bool? isDeleted,
    String? remoteId,
  }) {
    return BloodPressureRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      pulse: pulse ?? this.pulse,
      measurementTime: measurementTime ?? this.measurementTime,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  /// WHO blood pressure classification. Uses the worst of systolic/diastolic.
  BloodPressureCategory get category {
    final sys = _categoryFor(systolic, isSystolic: true);
    final dia = _categoryFor(diastolic, isSystolic: false);
    return sys.index >= dia.index ? sys : dia;
  }

  static BloodPressureCategory _categoryFor(int value,
      {required bool isSystolic}) {
    if (isSystolic) {
      if (value > 180) return BloodPressureCategory.crisis;
      if (value >= 140) return BloodPressureCategory.stage2;
      if (value >= 130) return BloodPressureCategory.stage1;
      if (value >= 120) return BloodPressureCategory.elevated;
      return BloodPressureCategory.normal;
    }
    if (value > 120) return BloodPressureCategory.crisis;
    if (value >= 100) return BloodPressureCategory.stage2;
    if (value >= 90) return BloodPressureCategory.stage1;
    if (value >= 80) return BloodPressureCategory.elevated;
    return BloodPressureCategory.normal;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'systolic': systolic,
        'diastolic': diastolic,
        'pulse': pulse,
        'measurement_time': measurementTime.millisecondsSinceEpoch,
        'notes': notes,
        'is_synced': isSynced ? 1 : 0,
        'is_deleted': isDeleted ? 1 : 0,
        'remote_id': remoteId,
      };

  factory BloodPressureRecord.fromMap(Map<String, dynamic> map) {
    return BloodPressureRecord(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      systolic: map['systolic'] as int,
      diastolic: map['diastolic'] as int,
      pulse: map['pulse'] as int?,
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
        'systolic': systolic,
        'diastolic': diastolic,
        'pulse': pulse,
        'measurementTime': measurementTime.toUtc().millisecondsSinceEpoch,
        'notes': notes,
      };
}
