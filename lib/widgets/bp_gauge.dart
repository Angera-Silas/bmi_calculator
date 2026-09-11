import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/blood_pressure_record.dart';

/// Radial gauge showing a blood pressure reading.
///
/// The colored arc runs from low (normal, green) up to crisis (red). Two
/// needles point at the systolic and diastolic values. The category badge
/// updates in real time as either value changes.
class BpGauge extends StatelessWidget {
  const BpGauge({
    super.key,
    required this.systolic,
    required this.diastolic,
    this.size = 200,
  });

  final int systolic;
  final int diastolic;
  final double size;

  /// Values from 50–220 mmHg map across the 240° gauge sweep.
  static const double _minValue = 50;
  static const double _maxValue = 220;
  static const double _sweepAngle = 240; // degrees

  Color get _categoryColor => getBpCategoryColor(BloodPressureRecord(
        id: 'gauge',
        userId: 'gauge',
        systolic: systolic,
        diastolic: diastolic,
        measurementTime: DateTime.now(),
      ).category);

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor;
    final sysAngle = _angleFor(systolic);
    final diaAngle = _angleFor(diastolic);

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(size, size),
              painter: _GaugePainter(
                activeAngle: max(sysAngle, diaAngle),
                activeColor: color,
              ),
            ),
            // Systolic needle
            _needle(context, sysAngle, color, wider: true),
            // Diastolic needle
            _needle(context, diaAngle, Colors.blueGrey.shade300, wider: false),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$systolic / $diastolic',
                  style: TextStyle(
                    fontSize: size * 0.115,
                    fontWeight: FontWeight.w900,
                    color: DynamicColors.textPrimary(context),
                  ),
                ),
                Text(
                  'mmHg',
                  style: TextStyle(
                    fontSize: 12,
                    color: DynamicColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _needle(BuildContext context, double angle, Color color,
      {required bool wider}) {
    final center = size / 2;
    final length = size * (wider ? 0.34 : 0.27);
    final radians = (angle - 90) * pi / 180;
    final tipX = center + length * cos(radians);
    final tipY = center + length * sin(radians);

    return Positioned.fill(
      child: CustomPaint(
        painter: _NeedlePainter(
          from: Offset(center, center),
          to: Offset(tipX, tipY),
          color: color,
          width: wider ? 3.5 : 2.0,
        ),
      ),
    );
  }

  double _angleFor(int value) {
    final clamped = value.clamp(_minValue, _maxValue).toDouble();
    final fraction = (clamped - _minValue) / (_maxValue - _minValue);
    // Sweep starts at 150° (bottom-left) and ends at 390° (bottom-right).
    return 150 + (fraction * _sweepAngle);
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.activeAngle, required this.activeColor});

  final double activeAngle;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background arc
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 150 * pi / 180, 240 * pi / 180, false,
        bgPaint..color = const Color(0x33FFFFFF));

    // Colored band up to the more severe reading
    final bandPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      150 * pi / 180,
      (activeAngle - 150) * pi / 180,
      false,
      bandPaint..color = activeColor,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.activeAngle != activeAngle || old.activeColor != activeColor;
}

class _NeedlePainter extends CustomPainter {
  const _NeedlePainter({
    required this.from,
    required this.to,
    required this.color,
    required this.width,
  });

  final Offset from;
  final Offset to;
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(from, to, paint);

    // Hub dot
    canvas.drawCircle(from, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_NeedlePainter old) =>
      old.color != color ||
      old.from != from ||
      old.to != to ||
      old.width != width;
}

Color getBpCategoryColor(BloodPressureCategory category) {
  switch (category) {
    case BloodPressureCategory.normal:
      return kNormalColor;
    case BloodPressureCategory.elevated:
      return kInfoColor;
    case BloodPressureCategory.stage1:
      return kWarningColor;
    case BloodPressureCategory.stage2:
      return kObeseIColor;
    case BloodPressureCategory.crisis:
      return kObeseIIIColor;
  }
}
