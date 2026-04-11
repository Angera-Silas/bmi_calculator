import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';

/// Semicircular arc gauge that visualises a BMI value.
/// The arc spans from 15 (severely underweight) to 40 (morbidly obese)
/// and is divided into colour-coded zones.
class BMIGauge extends StatefulWidget {
  final double bmi;
  final Color categoryColor;
  final String categoryLabel;

  const BMIGauge({
    super.key,
    required this.bmi,
    required this.categoryColor,
    required this.categoryLabel,
  });

  @override
  State<BMIGauge> createState() => _BMIGaugeState();
}

class _BMIGaugeState extends State<BMIGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(260, 145),
          painter: _GaugePainter(
            bmi: widget.bmi,
            categoryColor: widget.categoryColor,
            progress: _animation.value,
            isDark: DynamicColors.isDark(context),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double bmi;
  final Color categoryColor;
  final double progress;
  final bool isDark;

  _GaugePainter({
    required this.bmi,
    required this.categoryColor,
    required this.progress,
    required this.isDark,
  });

  static const double _minBMI = 15.0;
  static const double _maxBMI = 40.0;

  // Zone boundaries and their colors on the arc
  static const List<_Zone> _zones = [
    _Zone(start: 15, end: 16, color: kSeverelyUnderweightColor),
    _Zone(start: 16, end: 18.5, color: kUnderweightColor),
    _Zone(start: 18.5, end: 25, color: kNormalColor),
    _Zone(start: 25, end: 30, color: kOverweightColor),
    _Zone(start: 30, end: 35, color: kObeseIColor),
    _Zone(start: 35, end: 40, color: kObeseIIColor),
  ];

  double _bmiToAngle(double bmi) {
    final t = (bmi - _minBMI) / (_maxBMI - _minBMI);
    return pi + t.clamp(0.0, 1.0) * pi; // π to 2π (left to right)
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2 - 10;
    const strokeWidth = 18.0;

    // ── Track background ──────────────────────────────────────────────────────
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.07);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      trackPaint,
    );

    // ── Coloured zones ────────────────────────────────────────────────────────
    final zonePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final zone in _zones) {
      final startAngle = _bmiToAngle(zone.start);
      final endAngle = _bmiToAngle(zone.end);
      zonePaint.color = zone.color.withOpacity(0.35);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        zonePaint,
      );
    }

    // ── Animated active arc ───────────────────────────────────────────────────
    final clampedBMI = bmi.clamp(_minBMI, _maxBMI);
    final targetAngle = _bmiToAngle(clampedBMI * progress + _minBMI * (1 - progress));
    final activeArcLength = targetAngle - pi;

    if (activeArcLength > 0) {
      final activePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: pi,
          endAngle: pi + activeArcLength,
          colors: [categoryColor.withOpacity(0.6), categoryColor],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi,
        activeArcLength,
        false,
        activePaint,
      );
    }

    // ── Needle ────────────────────────────────────────────────────────────────
    final needleAngle = targetAngle;
    final needleLength = radius - 10;
    final needleTip = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = categoryColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(center, needleTip, needlePaint);

    // Needle centre circle
    canvas.drawCircle(
      center,
      7,
      Paint()..color = categoryColor,
    );
    canvas.drawCircle(
      center,
      4,
      Paint()..color = isDark ? const Color(0xFF0D1117) : Colors.white,
    );

    // ── Zone labels ───────────────────────────────────────────────────────────
    final labelStyle = TextStyle(
      fontSize: 9,
      color: (isDark ? Colors.white : Colors.black).withOpacity(0.4),
      fontWeight: FontWeight.w600,
    );
    final labelBMIs = [18.5, 25.0, 30.0];
    for (final bmiv in labelBMIs) {
      final angle = _bmiToAngle(bmiv);
      final labelR = radius + 14;
      final pos = Offset(
        center.dx + labelR * cos(angle),
        center.dy + labelR * sin(angle),
      );
      final tp = TextPainter(
        text: TextSpan(text: bmiv.toString(), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress || old.bmi != bmi;
}

class _Zone {
  final double start;
  final double end;
  final Color color;
  const _Zone({required this.start, required this.end, required this.color});
}
