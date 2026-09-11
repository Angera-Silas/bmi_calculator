import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/blood_pressure_record.dart';
import '../models/blood_sugar_record.dart';
import '../models/bmi_record.dart';
import '../services/analytics_service.dart';
import '../services/export_format.dart';
import '../services/export_service.dart';

/// Which health metric sections are included in an export.
enum ExportMetric { bmi, bloodPressure, glucose }

/// Immutable state describing the user's export choices.
class ExportState {
  final ExportFormat format;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool anonymize;
  final Set<ExportMetric> selectedMetrics;
  final bool isGenerating;
  final String? error;

  const ExportState({
    this.format = ExportFormat.pdf,
    this.startDate,
    this.endDate,
    this.anonymize = true,
    this.selectedMetrics = const {ExportMetric.bmi},
    this.isGenerating = false,
    this.error,
  });

  ExportState copyWith({
    ExportFormat? format,
    DateTime? startDate,
    DateTime? endDate,
    bool? anonymize,
    Set<ExportMetric>? selectedMetrics,
    bool? isGenerating,
    String? error,
    bool clearError = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return ExportState(
      format: format ?? this.format,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      anonymize: anonymize ?? this.anonymize,
      selectedMetrics: selectedMetrics ?? this.selectedMetrics,
      isGenerating: isGenerating ?? this.isGenerating,
      error: clearError ? null : error ?? this.error,
    );
  }

  bool get hasAnyMetric => selectedMetrics.isNotEmpty;
}

/// Generated export payload — text (CSV) or bytes (PDF).
class ExportPayload {
  final String title;
  final String fileName;
  final String? text;
  final List<int>? bytes;

  const ExportPayload({
    required this.title,
    required this.fileName,
    this.text,
    this.bytes,
  });
}

/// Preview summary for the currently selected export options.
class ExportPreview {
  final int bmiCount;
  final int bpCount;
  final int glucoseCount;
  final String? latestBmi;
  final String? trend;

  const ExportPreview({
    required this.bmiCount,
    required this.bpCount,
    required this.glucoseCount,
    this.latestBmi,
    this.trend,
  });
}

/// Controller for the export screen (Sprint 3.2 Week 23).
///
/// Holds export options (format, date range, metrics, anonymization) and
/// generates the payload via the pure [ExportService].
class ExportController extends Notifier<ExportState> {
  @override
  ExportState build() => const ExportState();

  void setFormat(ExportFormat format) =>
      state = state.copyWith(format: format, clearError: true);

  void setDateRange(DateTime? start, DateTime? end) => state = state.copyWith(
        startDate: start,
        clearStartDate: start == null,
        endDate: end,
        clearEndDate: end == null,
        clearError: true,
      );

  void toggleMetric(ExportMetric metric) {
    final updated = Set<ExportMetric>.from(state.selectedMetrics);
    if (!updated.remove(metric)) updated.add(metric);
    state = state.copyWith(selectedMetrics: updated, clearError: true);
  }

  void setAnonymize(bool value) =>
      state = state.copyWith(anonymize: value, clearError: true);

  /// Applies date filters and optional anonymization to the supplied records.
  ({
    List<BmiRecord> bmi,
    List<BloodPressureRecord> bp,
    List<BloodSugarRecord> glucose,
  }) _prepareRecords({
    required List<BmiRecord> bmiRecords,
    required List<BloodPressureRecord> bpRecords,
    required List<BloodSugarRecord> glucoseRecords,
  }) {
    final bmi = _filter(bmiRecords, (r) => r.timestamp);
    final bp = _filter(bpRecords, (r) => r.measurementTime);
    final glucose = _filter(glucoseRecords, (r) => r.measurementTime);

    if (state.anonymize) {
      return (
        bmi: ExportService.anonymizeBmi(bmi),
        bp: ExportService.anonymizeBp(bp),
        glucose: ExportService.anonymizeGlucose(glucose),
      );
    }
    return (bmi: bmi, bp: bp, glucose: glucose);
  }

  List<T> _filter<T>(List<T> records, DateTime Function(T) timestampOf) {
    final start = state.startDate;
    final end = state.endDate;
    if (start == null && end == null) return records;
    return records.where((r) {
      final ts = timestampOf(r);
      if (start != null && ts.isBefore(start)) return false;
      if (end != null &&
          ts.isAfter(end.add(const Duration(days: 1)))) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Generates the export payload from the current options.
  /// Throws [StateError] if no metric is selected or no data matches.
  Future<ExportPayload> generate({
    required List<BmiRecord> bmiRecords,
    required List<BloodPressureRecord> bpRecords,
    required List<BloodSugarRecord> glucoseRecords,
  }) async {
    if (!state.hasAnyMetric) {
      throw StateError('Select at least one metric to export.');
    }

    final prepared = _prepareRecords(
      bmiRecords: bmiRecords,
      bpRecords: bpRecords,
      glucoseRecords: glucoseRecords,
    );

    final bmi = state.selectedMetrics.contains(ExportMetric.bmi)
        ? prepared.bmi
        : const <BmiRecord>[];
    final bp = state.selectedMetrics.contains(ExportMetric.bloodPressure)
        ? prepared.bp
        : const <BloodPressureRecord>[];
    final glucose = state.selectedMetrics.contains(ExportMetric.glucose)
        ? prepared.glucose
        : const <BloodSugarRecord>[];

    if (bmi.isEmpty && bp.isEmpty && glucose.isEmpty) {
      throw StateError('No records match the selected date range.');
    }

    final suffix = state.anonymize ? '_anonymized' : '';
    switch (state.format) {
      case ExportFormat.csv:
        final text = ExportService.exportCsv(
          bmiRecords: bmi,
          bpRecords: bp,
          glucoseRecords: glucose,
          anonymize: false, // already anonymized above if requested
        );
        return ExportPayload(
          title: 'Health Report',
          fileName: 'health_report$suffix.csv',
          text: text,
        );
      case ExportFormat.pdf:
        final bytes = await ExportService.exportPdf(
          bmiRecords: bmi,
          bpRecords: bp,
          glucoseRecords: glucose,
          anonymize: false,
        );
        return ExportPayload(
          title: 'Health Report',
          fileName: 'health_report$suffix.pdf',
          bytes: bytes,
        );
    }
  }

  /// Computes a preview summary for the currently selected options.
  ExportPreview preview({
    required List<BmiRecord> bmiRecords,
    required List<BloodPressureRecord> bpRecords,
    required List<BloodSugarRecord> glucoseRecords,
  }) {
    final prepared = _prepareRecords(
      bmiRecords: bmiRecords,
      bpRecords: bpRecords,
      glucoseRecords: glucoseRecords,
    );

    String? latestBmi;
    String? trend;
    if (prepared.bmi.isNotEmpty) {
      final sorted = [...prepared.bmi]
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      latestBmi = sorted.last.bmiValue.toStringAsFixed(1);
      if (sorted.length >= 2) {
        final reg = AnalyticsService.bmiRegression(sorted);
        if (reg != null) {
          final slopePerMonth = reg.$1 * 30;
          trend = slopePerMonth.abs() < 0.01
              ? 'Stable'
              : '${slopePerMonth > 0 ? '+' : ''}${slopePerMonth.toStringAsFixed(1)} BMI/month';
        }
      }
    }

    return ExportPreview(
      bmiCount: prepared.bmi.length,
      bpCount: prepared.bp.length,
      glucoseCount: prepared.glucose.length,
      latestBmi: latestBmi,
      trend: trend,
    );
  }
}

final exportControllerProvider =
    NotifierProvider<ExportController, ExportState>(ExportController.new);
