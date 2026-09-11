import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/models/waist_to_height_ratio.dart';

void main() {
  group('WaistToHeightRatio', () {
    test('computes ratio and value rounds to two decimals', () {
      final w = WaistToHeightRatio(waistCm: 84, heightCm: 175);
      expect(w.raw, closeTo(0.48, 0.001));
      expect(w.value, 0.48);
    });

    test('classifies risk levels correctly', () {
      expect(WaistToHeightRatio(waistCm: 60, heightCm: 200).riskLevel,
          WaistToHeightRiskLevel.lean);
      expect(WaistToHeightRatio(waistCm: 80, heightCm: 180).riskLevel,
          WaistToHeightRiskLevel.healthy);
      expect(WaistToHeightRatio(waistCm: 95, heightCm: 175).riskLevel,
          WaistToHeightRiskLevel.increased);
      expect(WaistToHeightRatio(waistCm: 110, heightCm: 170).riskLevel,
          WaistToHeightRiskLevel.high);
    });

    test('rejects non-positive inputs', () {
      expect(() => WaistToHeightRatio(waistCm: 0, heightCm: 175),
          throwsArgumentError);
      expect(() => WaistToHeightRatio(waistCm: 80, heightCm: 0),
          throwsArgumentError);
    });

    test('recommendation varies by category', () {
      final healthy = WaistToHeightRatio(waistCm: 80, heightCm: 180);
      final high = WaistToHeightRatio(waistCm: 110, heightCm: 170);
      expect(healthy.recommendation, contains('Healthy'));
      expect(high.recommendation, contains('High waist'));
    });
  });
}
