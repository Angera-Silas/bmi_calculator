import 'package:uuid/uuid.dart';
import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';
import '../models/wearable_metric.dart';
import 'wearable_validation_service.dart';

/// Result of converting a [WearableSnapshot] into records the app owns.
///
/// BP and glucose readings are converted into their corresponding app models
/// (so they appear in History / Dashboard / sync), and the height/weight values
/// are exposed for auto-filling the Calculate form. All reads are validated and
/// deduplicated against the user's existing records before being flagged as
/// insertable. Readings that fail validation appear in [rejections].
class WearableImportResult {
  final List<BloodPressureRecord> bpRecords;
  final List<BloodSugarRecord> glucoseRecords;
  final double? autoFillHeightCm;
  final double? autoFillWeightKg;
  final List<WearableRejection> rejections;

  const WearableImportResult({
    required this.bpRecords,
    required this.glucoseRecords,
    this.autoFillHeightCm,
    this.autoFillWeightKg,
    this.rejections = const [],
  });

  int get newRecordCount => bpRecords.length + glucoseRecords.length;
  bool get hasRejections => rejections.isNotEmpty;
}

/// Pure, testable mapping + dedup for wearable data.
///
/// "Platform integrations" for Week 19: converts the platform-agnostic
/// [WearableSnapshot] into app records and merges them into the local history.
class WearableImportService {
  const WearableImportService._();

  /// Tolerance for "already synced" dedup — a reading within this window of an
  /// existing record with the same value is considered a duplicate.
  static const Duration dedupWindow = Duration(minutes: 5);

  static const _importNote = 'Imported from wearable';

  /// Build the set of records to insert for [snapshot] given the user's
  /// existing history. Skips records that are already present.
  static WearableImportResult buildImport({
    required WearableSnapshot snapshot,
    required String userId,
    required List<BloodPressureRecord> existingBp,
    required List<BloodSugarRecord> existingGlucose,
  }) {
    final rejections = <WearableRejection>[];
    final bp = _buildBp(snapshot, userId, existingBp, rejections);
    final glucose =
        _buildGlucose(snapshot, userId, existingGlucose, rejections);

    return WearableImportResult(
      bpRecords: bp,
      glucoseRecords: glucose,
      autoFillHeightCm: _heightCm(snapshot),
      autoFillWeightKg: snapshot.latestWeightKg,
      rejections: rejections,
    );
  }

  static List<BloodPressureRecord> _buildBp(
    WearableSnapshot snapshot,
    String userId,
    List<BloodPressureRecord> existing,
    List<WearableRejection> rejections,
  ) {
    final systolic = snapshot.latestSystolic;
    final diastolic = snapshot.latestDiastolic;
    final time = _latestTime(snapshot, WearableMetric.systolic);
    if (systolic == null || diastolic == null || time == null) return const [];

    if (!WearableValidationService.validBp(systolic, diastolic)) {
      rejections.add(WearableRejection(
        metric: 'BP',
        value: systolic,
        reason: 'systolic=$systolic diastolic=$diastolic out of range',
      ));
      return const [];
    }

    final record = BloodPressureRecord(
      id: const Uuid().v4(),
      userId: userId,
      systolic: systolic.round(),
      diastolic: diastolic.round(),
      measurementTime: time,
      notes: _importNote,
    );

    final duplicate = existing.any((r) =>
        _withinWindow(r.measurementTime, time) &&
        r.systolic == record.systolic &&
        r.diastolic == record.diastolic);
    return duplicate ? const [] : [record];
  }

  static List<BloodSugarRecord> _buildGlucose(
    WearableSnapshot snapshot,
    String userId,
    List<BloodSugarRecord> existing,
    List<WearableRejection> rejections,
  ) {
    final glucose = snapshot.latestGlucoseMgdl;
    if (glucose == null) return const [];

    if (!WearableValidationService.validGlucose(glucose)) {
      rejections.add(WearableRejection(
        metric: 'Glucose',
        value: glucose,
        reason: '$glucose mg/dL out of range',
      ));
      return const [];
    }

    final time = snapshot.sampleFor(WearableMetric.bloodGlucose)?.timestamp;
    if (time == null) return const [];

    final record = BloodSugarRecord(
      id: const Uuid().v4(),
      userId: userId,
      glucoseLevel: glucose.round(),
      measurementType: GlucoseMeasurementType.random,
      measurementTime: time,
      notes: _importNote,
    );

    final duplicate = existing.any((r) =>
        _withinWindow(r.measurementTime, time) &&
        r.glucoseLevel == record.glucoseLevel);
    return duplicate ? const [] : [record];
  }

  static double? _heightCm(WearableSnapshot snapshot) {
    final meters = snapshot.latestHeightM;
    return meters == null ? null : meters * 100;
  }

  static DateTime? _latestTime(WearableSnapshot snapshot, WearableMetric m) {
    final sample = snapshot.sampleFor(m);
    return sample?.timestamp;
  }

  static bool _withinWindow(DateTime a, DateTime b) {
    final diff = a.difference(b).abs();
    return diff <= dedupWindow;
  }
}
