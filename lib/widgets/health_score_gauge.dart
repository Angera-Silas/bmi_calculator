import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/health_score_service.dart';

/// Color for a given health score label.
Color getHealthScoreColor(HealthScoreLabel? label) {
  switch (label) {
    case HealthScoreLabel.excellent:
    case HealthScoreLabel.veryGood:
    case HealthScoreLabel.good:
      return kSuccessColor;
    case HealthScoreLabel.fair:
      return kWarningColor;
    case HealthScoreLabel.needsImprovement:
      return kErrorColor;
    case null:
      return kInfoColor;
  }
}

/// Animated 360° radial gauge showing the 0–100 health score.
class HealthScoreGauge extends StatefulWidget {
  const HealthScoreGauge({
    super.key,
    required this.score,
    required this.label,
    this.size = 220,
  });

  final int? score;
  final HealthScoreLabel? label;
  final double size;

  @override
  State<HealthScoreGauge> createState() => _HealthScoreGaugeState();
}

class _HealthScoreGaugeState extends State<HealthScoreGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(HealthScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = getHealthScoreColor(widget.label);

    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final targetFraction = (widget.score ?? 0) / 100.0;
            final fraction = targetFraction * _animation.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _ScoreRingPainter(
                    fraction: fraction,
                    activeColor: color,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.score != null ? '${widget.score}' : '--',
                      style: TextStyle(
                        fontSize: widget.size * 0.18,
                        fontWeight: FontWeight.w900,
                        color: DynamicColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '/ 100',
                      style: TextStyle(
                        fontSize: 13,
                        color: DynamicColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  const _ScoreRingPainter({required this.fraction, required this.activeColor});

  final double fraction;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint..color = const Color(0x22101010));

    final sweep = 2 * pi * fraction;
    if (sweep <= 0) return;
    final bandPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, sweep, false, bandPaint..color = activeColor);
  }

  @override
  bool shouldRepaint(_ScoreRingPainter old) =>
      old.fraction != fraction || old.activeColor != activeColor;
}
