import 'dart:math' as math;
import 'package:flutter/material.dart';

class GreenhouseDialPainter extends CustomPainter {
  final double temperatureC;
  final double humidityPct;

  const GreenhouseDialPainter({
    required this.temperatureC,
    required this.humidityPct,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.72);
    final radius = size.width * 0.38;

    // Dual-arc dial track
    final trackPaint = Paint()
      ..color = const Color(0xFFD1E7D8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi, math.pi, false, trackPaint);

    // Humidity green arc
    final humidPaint = Paint()
      ..color = const Color(0xFF059669)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;
    final normalizedHumid = (humidityPct / 100.0).clamp(0.0, 1.0);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi, math.pi * normalizedHumid, false, humidPaint);

    // Dial center pointer
    final pointerAngle = math.pi + (math.pi * normalizedHumid);
    final pointerEnd = Offset(center.dx + (radius * 0.8) * math.cos(pointerAngle), center.dy + (radius * 0.8) * math.sin(pointerAngle));
    canvas.drawLine(center, pointerEnd, Paint()..color = const Color(0xFF064E3B)..strokeWidth = 3.0..strokeCap = StrokeCap.round);
    canvas.drawCircle(center, 6, Paint()..color = const Color(0xFF059669));
  }

  @override
  bool shouldRepaint(covariant GreenhouseDialPainter oldDelegate) {
    return oldDelegate.temperatureC != temperatureC || oldDelegate.humidityPct != humidityPct;
  }
}
