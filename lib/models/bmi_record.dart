/// Unified model used by both the local SQLite database and Firestore sync.
///
/// The [id] field is always a UUID generated locally.
/// [remoteId] is the Firestore document ID — null until first successful sync.
/// [isDeleted] enables soft-delete so offline deletions can be pushed on reconnect.
class BmiRecord {
  final String id;            // UUID — local primary key
  final String userId;        // Firebase UID or SessionService.guestId
  final int height;           // cm
  final int weight;           // kg
  final int age;
  final bool isMale;
  final double bmiValue;
  final String bmiResult;     // "23.4"
  final String resultText;    // WHO category label
  final String interpretation;
  final DateTime timestamp;
  final bool isSynced;
  final bool isDeleted;       // soft-delete flag for offline deletes
  final String? remoteId;     // Firestore doc ID — set after first push
  final List<String> healthConditions;  // Stored as comma-separated or JSON
  final String pregnancyStatus;  // For female users
  final double? prePregnancyWeight;  // kg, only for pregnant users

  const BmiRecord({
    required this.id,
    required this.userId,
    required this.height,
    required this.weight,
    required this.age,
    required this.isMale,
    required this.bmiValue,
    required this.bmiResult,
    required this.resultText,
    required this.interpretation,
    required this.timestamp,
    this.isSynced = false,
    this.isDeleted = false,
    this.remoteId,
    this.healthConditions = const [],
    this.pregnancyStatus = 'notApplicable',
    this.prePregnancyWeight,
  });

  BmiRecord copyWith({
    String? id,
    String? userId,
    int? height,
    int? weight,
    int? age,
    bool? isMale,
    double? bmiValue,
    String? bmiResult,
    String? resultText,
    String? interpretation,
    DateTime? timestamp,
    bool? isSynced,
    bool? isDeleted,
    String? remoteId,
    List<String>? healthConditions,
    String? pregnancyStatus,
    double? prePregnancyWeight,
  }) {
    return BmiRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
      bmiValue: bmiValue ?? this.bmiValue,
      bmiResult: bmiResult ?? this.bmiResult,
      resultText: resultText ?? this.resultText,
      interpretation: interpretation ?? this.interpretation,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      remoteId: remoteId ?? this.remoteId,
      healthConditions: healthConditions ?? this.healthConditions,
      pregnancyStatus: pregnancyStatus ?? this.pregnancyStatus,
      prePregnancyWeight: prePregnancyWeight ?? this.prePregnancyWeight,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'height': height,
        'weight': weight,
        'age': age,
        'is_male': isMale ? 1 : 0,
        'bmi_value': bmiValue,
        'bmi_result': bmiResult,
        'result_text': resultText,
        'interpretation': interpretation,
        'recorded_at': timestamp.millisecondsSinceEpoch,
        'is_synced': isSynced ? 1 : 0,
        'is_deleted': isDeleted ? 1 : 0,
        'remote_id': remoteId,
        'health_conditions': healthConditions.join(','),
        'pregnancy_status': pregnancyStatus,
        'pre_pregnancy_weight': prePregnancyWeight,
      };

  factory BmiRecord.fromMap(Map<String, dynamic> map) => BmiRecord(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        height: map['height'] as int,
        weight: map['weight'] as int,
        age: map['age'] as int,
        isMale: (map['is_male'] as int) == 1,
        bmiValue: (map['bmi_value'] as num).toDouble(),
        bmiResult: map['bmi_result'] as String,
        resultText: map['result_text'] as String,
        interpretation: map['interpretation'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(map['recorded_at'] as int),
        isSynced: (map['is_synced'] as int) == 1,
        isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
        remoteId: map['remote_id'] as String?,
        healthConditions: (map['health_conditions'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
        pregnancyStatus: map['pregnancy_status'] as String? ?? 'notApplicable',
        prePregnancyWeight: (map['pre_pregnancy_weight'] as num?)?.toDouble(),
      );

  /// Converts to a Firestore-friendly map (no local-only fields).
  Map<String, dynamic> toFirestoreMap(String uid) => {
        'userId': uid,
        'localId': id,
        'height': height,
        'weight': weight,
        'age': age,
        'isMale': isMale,
        'bmiResult': bmiResult,
        'resultText': resultText,
        'interpretation': interpretation,
        'timestamp': timestamp.toUtc().millisecondsSinceEpoch,
        'healthConditions': healthConditions,
        'pregnancyStatus': pregnancyStatus,
        'prePregnancyWeight': prePregnancyWeight,
      };
}
