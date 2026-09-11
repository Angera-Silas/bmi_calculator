/// Resting-heart-rate-based VO2max (mL/kg/min) estimate.
///
/// Non-exercise estimation method (Uth–Sørensen–Overgaard–Sørensen):
///   HRmax  ≈ 208 − 0.7·age            (Tanaka equation)
///   VO2max ≈ 15.3 · (HRmax / HRrest)
///
/// The result is classified against age/gender population norms derived from
/// the widely-cited ACSM / Cooper Institute VO2max classification tables.
class Vo2Max {
  Vo2Max({
    required int restingHeartRateBpm,
    required int age,
    required bool isMale,
  })  : _restingHeartRate = restingHeartRateBpm,
        _age = age,
        _isMale = isMale,
        _value = _estimate(restingHeartRateBpm, age) {
    if (restingHeartRateBpm < 25 || restingHeartRateBpm > 200) {
      throw ArgumentError('Resting heart rate must be between 25 and 200 bpm.');
    }
    if (age < 0 || age > 120) {
      throw ArgumentError('Age must be between 0 and 120.');
    }
  }

  final int _restingHeartRate;
  final int _age;
  final bool _isMale;
  final double _value;

  /// The resting heart rate input (bpm).
  int get restingHeartRateBpm => _restingHeartRate;

  /// Estimated VO2max rounded to one decimal (mL/kg/min).
  double get value => double.parse(_value.toStringAsFixed(1));

  /// Raw estimate for calculation.
  double get raw => _value;

  Vo2MaxCategory get category => _classify(_value, _age, _isMale);

  /// Stable display key (English default).
  String get categoryLabel => switch (category) {
        Vo2MaxCategory.veryPoor => 'Very poor',
        Vo2MaxCategory.poor => 'Poor',
        Vo2MaxCategory.fair => 'Fair',
        Vo2MaxCategory.good => 'Good',
        Vo2MaxCategory.excellent => 'Excellent',
      };

  String get recommendation => switch (category) {
        Vo2MaxCategory.veryPoor =>
          'Below-average fitness. Even light aerobic activity would help.',
        Vo2MaxCategory.poor =>
          'Low aerobic fitness. Start with brisk walks and build up gradually.',
        Vo2MaxCategory.fair =>
          'Moderate aerobic fitness. Consistent cardio can move you to good.',
        Vo2MaxCategory.good =>
          'Above-average aerobic fitness. Great work — keep it up.',
        Vo2MaxCategory.excellent =>
          'Excellent aerobic fitness for your age group.',
      };

  static double _estimate(int restingHeartRate, int age) {
    final hrMax = 208.0 - 0.7 * age;
    return 15.3 * (hrMax / restingHeartRate);
  }

  /// Thresholds per age band: index 0 = 20s … 4 = 60+.
  /// Each entry is [veryPoorMax, poorMax, fairMax, goodMax]; values above the
  /// final entry are "excellent".
  static const List<List<double>> _maleThresholds = [
    [28.0, 33.0, 38.0, 44.0],
    [25.0, 31.0, 36.0, 40.9],
    [22.0, 28.0, 33.0, 37.8],
    [20.0, 26.0, 31.0, 35.8],
    [17.0, 22.0, 27.0, 32.0],
  ];

  static const List<List<double>> _femaleThresholds = [
    [21.0, 27.0, 33.0, 39.3],
    [17.0, 24.0, 30.0, 36.0],
    [15.0, 21.0, 27.0, 32.8],
    [14.0, 20.0, 25.0, 30.8],
    [11.0, 17.0, 22.0, 27.8],
  ];

  static int _band(int age) {
    if (age < 30) return 0;
    if (age < 40) return 1;
    if (age < 50) return 2;
    if (age < 60) return 3;
    return 4;
  }

  static Vo2MaxCategory _classify(double vo2, int age, bool isMale) {
    final thresholds =
        (isMale ? _maleThresholds : _femaleThresholds)[_band(age)];
    if (vo2 <= thresholds[0]) return Vo2MaxCategory.veryPoor;
    if (vo2 <= thresholds[1]) return Vo2MaxCategory.poor;
    if (vo2 <= thresholds[2]) return Vo2MaxCategory.fair;
    if (vo2 <= thresholds[3]) return Vo2MaxCategory.good;
    return Vo2MaxCategory.excellent;
  }
}

enum Vo2MaxCategory { veryPoor, poor, fair, good, excellent }
