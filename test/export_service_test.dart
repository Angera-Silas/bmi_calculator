import 'package:flutter_test/flutter_test.dart';

import 'package:bmi_calculator/models/bmi_record.dart';
import 'package:bmi_calculator/models/blood_pressure_record.dart';
import 'package:bmi_calculator/models/blood_sugar_record.dart';
import 'package:bmi_calculator/providers/export_controller_provider.dart';
import 'package:bmi_calculator/services/export_format.dart';
import 'package:bmi_calculator/services/export_service.dart';

const _userId = 'test-user';

BmiRecord _bmi({
  required double bmiValue,
  required int weight,
  required DateTime timestamp,
  String resultText = 'Normal Range',
}) {
  return BmiRecord(
    id: 'id-${timestamp.millisecondsSinceEpoch}',
    userId: _userId,
    height: 170,
    weight: weight,
    age: 30,
    isMale: true,
    bmiValue: bmiValue,
    bmiResult: bmiValue.toStringAsFixed(1),
    resultText: resultText,
    interpretation: '',
    timestamp: timestamp,
    healthConditions: const ['asthma'],
    pregnancyStatus: 'notApplicable',
    prePregnancyWeight: null,
    waistCm: 85.0,
  );
}

BloodPressureRecord _bp({required int sys, required int dia, DateTime? time}) {
  return BloodPressureRecord(
    id: 'bp-${sys}-$dia',
    userId: _userId,
    systolic: sys,
    diastolic: dia,
    pulse: 70,
    measurementTime: time ?? DateTime(2026, 9, 1),
    notes: 'morning reading user@example.com',
  );
}

BloodSugarRecord _glucose({required int level, DateTime? time}) {
  return BloodSugarRecord(
    id: 'gl-$level',
    userId: _userId,
    glucoseLevel: level,
    measurementType: GlucoseMeasurementType.fasting,
    measurementTime: time ?? DateTime(2026, 9, 1),
    notes: 'fasting note user@example.com',
  );
}

void main() {
  group('ExportService.exportCsv', () {
    test('generates CSV with BMI section header and rows', () {
      final records = [
        _bmi(bmiValue: 22.5, weight: 70, timestamp: DateTime(2026, 9, 1, 8)),
        _bmi(bmiValue: 23.0, weight: 71, timestamp: DateTime(2026, 9, 2, 8)),
      ];
      final csv = ExportService.exportCsv(bmiRecords: records);

      expect(csv, contains('Date,Height(cm),Weight(kg),BMI,Category'));
      expect(csv, contains('2026-09-01 08:00,170,70,22.5,Normal Range'));
      expect(csv, contains('2026-09-02 08:00,170,71,23.0,Normal Range'));
    });

    test('includes BP section when records present', () {
      final csv = ExportService.exportCsv(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        bpRecords: [_bp(sys: 120, dia: 80)],
      );

      expect(csv, contains('Blood Pressure'));
      expect(csv, contains('Date,Systolic,Diastolic,Pulse,Notes'));
      expect(csv, contains('2026-09-01 00:00,120,80,70'));
    });

    test('includes glucose section when records present', () {
      final csv = ExportService.exportCsv(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        glucoseRecords: [_glucose(level: 95)],
      );

      expect(csv, contains('Blood Glucose'));
      expect(csv, contains('Date,Level(mg/dL),Type,Notes'));
      expect(csv, contains('2026-09-01 00:00,95,fasting'));
    });

    test('anonymize redacts email addresses in notes', () {
      final csv = ExportService.exportCsv(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        bpRecords: [_bp(sys: 120, dia: 80)],
        anonymize: true,
      );

      expect(csv, isNot(contains('user@example.com')));
      expect(csv, contains('[redacted]'));
    });

    test('non-anonymized output keeps notes intact', () {
      final csv = ExportService.exportCsv(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        bpRecords: [_bp(sys: 120, dia: 80)],
      );

      expect(csv, contains('user@example.com'));
    });

    test('empty records produce only header', () {
      final csv = ExportService.exportCsv(bmiRecords: const []);
      expect(csv.trim(), 'Date,Height(cm),Weight(kg),BMI,Category');
    });
  });

  group('ExportService.exportPdf', () {
    test('generates non-empty PDF bytes with header marker', () async {
      final pdf = await ExportService.exportPdf(
        bmiRecords: [
          _bmi(bmiValue: 22.5, weight: 70, timestamp: DateTime(2026, 9, 1)),
        ],
      );

      expect(pdf, isNotEmpty);
      // PDF magic header: %PDF-
      expect(String.fromCharCodes(pdf.sublist(0, 5)), '%PDF-');
    });

    test('generates PDF with all sections when data present', () async {
      final pdf = await ExportService.exportPdf(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))
        ],
        bpRecords: [_bp(sys: 120, dia: 80)],
        glucoseRecords: [_glucose(level: 95)],
      );

      expect(pdf.length, greaterThan(500), reason: 'multi-section PDF');
    });

    test('generates valid PDF even with empty records', () async {
      final pdf = await ExportService.exportPdf(bmiRecords: const []);
      expect(String.fromCharCodes(pdf.sublist(0, 5)), '%PDF-');
    });
  });

  group('ExportService anonymization helpers', () {
    test('anonymizeBmi strips userId and personal fields', () {
      final anon = ExportService.anonymizeBmi([
        _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1)),
      ]);

      expect(anon.first.userId, 'anonymous');
      expect(anon.first.healthConditions, isEmpty);
      expect(anon.first.pregnancyStatus, 'notApplicable');
      expect(anon.first.prePregnancyWeight, isNull);
      expect(anon.first.waistCm, isNull);
      // Health data preserved
      expect(anon.first.bmiValue, 22);
      expect(anon.first.weight, 70);
    });

    test('anonymizeBp strips userId and notes', () {
      final anon = ExportService.anonymizeBp([_bp(sys: 120, dia: 80)]);
      expect(anon.first.userId, 'anonymous');
      expect(anon.first.notes, isNull);
      expect(anon.first.systolic, 120);
    });

    test('anonymizeGlucose strips userId and notes', () {
      final anon = ExportService.anonymizeGlucose([_glucose(level: 95)]);
      expect(anon.first.userId, 'anonymous');
      expect(anon.first.notes, isNull);
      expect(anon.first.glucoseLevel, 95);
    });
  });

  group('ExportController', () {
    test('default state selects BMI, anonymizes, and uses PDF', () {
      final controller = ExportController();
      // Default state: PDF format, anonymize true, BMI selected
      final state = controller.state;
      expect(state.format, ExportFormat.pdf);
      expect(state.anonymize, true);
      expect(state.selectedMetrics, contains(ExportMetric.bmi));
    });

    test('toggleMetric removes and re-adds metric', () {
      final controller = ExportController();
      controller.toggleMetric(ExportMetric.bloodPressure);
      final afterToggle = controller.state;
      expect(afterToggle.selectedMetrics, contains(ExportMetric.bloodPressure));
      controller.toggleMetric(ExportMetric.bloodPressure);
      final afterRemove = controller.state;
      expect(afterRemove.selectedMetrics,
          isNot(contains(ExportMetric.bloodPressure)));
    });

    test('generate throws when no metric selected', () async {
      final controller = ExportController();
      // Remove all metrics - start with none selected
      controller.toggleMetric(ExportMetric.bmi); // removes default BMI selection
      expect(
        () => controller.generate(
          bmiRecords: [_bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))],
          bpRecords: const [],
          glucoseRecords: const [],
        ),
        throwsStateError,
      );
    });

    test('generate returns CSV string when format is CSV', () async {
      final controller = ExportController();
      controller.setFormat(ExportFormat.csv);
      final payload = await controller.generate(
        bmiRecords: [_bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))],
        bpRecords: const [],
        glucoseRecords: const [],
      );
      expect(payload.fileName, 'health_report_anonymized.csv');
      expect(payload.text, isNotNull);
      expect(payload.text, contains('Date,Height(cm),Weight(kg),BMI,Category'));
    });

    test('generate returns PDF bytes when format is PDF', () async {
      final controller = ExportController();
      controller.setFormat(ExportFormat.pdf);
      final payload = await controller.generate(
        bmiRecords: [_bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1))],
        bpRecords: const [],
        glucoseRecords: const [],
      );
      expect(payload.fileName, 'health_report_anonymized.pdf');
      expect(payload.bytes, isNotNull);
      expect(String.fromCharCodes(payload.bytes!.sublist(0, 5)), '%PDF-');
    });

    test('preview reports latest BMI and trend for multiple records', () {
      final controller = ExportController();
      final preview = controller.preview(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1)),
          _bmi(bmiValue: 23, weight: 72, timestamp: DateTime(2026, 9, 30)),
        ],
        bpRecords: const [],
        glucoseRecords: const [],
      );
      expect(preview.bmiCount, 2);
      expect(preview.latestBmi, '23.0');
      expect(preview.trend, isNotNull);
    });

    test('respects date range filter', () async {
      final controller = ExportController();
      controller.setDateRange(DateTime(2026, 9, 2), DateTime(2026, 9, 10));
      final payload = await controller.generate(
        bmiRecords: [
          _bmi(bmiValue: 22, weight: 70, timestamp: DateTime(2026, 9, 1)),
          _bmi(bmiValue: 23, weight: 71, timestamp: DateTime(2026, 9, 5)),
          _bmi(bmiValue: 24, weight: 72, timestamp: DateTime(2026, 9, 15)),
        ],
        bpRecords: const [],
        glucoseRecords: const [],
      );
      expect(payload.text!, contains('2026-09-05 00:00'));
      expect(payload.text!, isNot(contains('2026-09-01 00:00')));
      expect(payload.text!, isNot(contains('2026-09-15 00:00')));
    });
  });
}
