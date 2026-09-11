import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';

/// Radiating confetti burst used by achievement / challenge celebrations.
///
/// Painted over the full [size]; particles fly outward from the center while
/// fading as [value] goes 0 → 1. Deterministic (fixed seed) so it renders
/// identically on hot reload / rebuilds.
class ConfettiPainter extends CustomPainter {
  ConfettiPainter(this.value);

  final double value;

  static const colors = [
    kAccent,
    kAccentLight,
    kNormalColor,
    kWarningColor,
    kInfoColor
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final t = value.clamp(0.0, 1.0);
    final rng = Random(42);
    for (var i = 0; i < 24; i++) {
      final angle = rng.nextDouble() * 2 * pi;
      final distance = (0.15 + t * 0.85) *
          (size.height * 0.9) *
          (0.4 + rng.nextDouble() * 0.6);
      final x = size.width / 2 + cos(angle) * distance;
      final y = size.height / 2 + sin(angle) * distance;
      final radius = 2 + rng.nextDouble() * 3;
      final alpha = 1 - t;
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: alpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter old) => old.value != value;
}
