import 'dart:math';
import 'package:flutter/material.dart';

class CompassViewPainter extends CustomPainter {
  final Color color;
  final int majorTickerCount;
  final int minorTickerCount;
  final CardinalityMap cardinalityMap;

  CompassViewPainter({
    required this.color,
    this.majorTickerCount = 18,
    this.minorTickerCount = 90,
    this.cardinalityMap = const {0: 'N', 90: 'E', 180: 'S', 270: 'W'},
  });

  late final majorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color
    ..strokeWidth = 2.0;

  late final minorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color.withOpacity(0.7)
    ..strokeWidth = 1.0;
  late final majorScaleStyle = TextStyle(color: color, fontSize: 18);
  late final cardinalityScaleStyle = const TextStyle(
    color: Colors.black,
    fontSize: 25,
    fontWeight: FontWeight.w700,
  );

  late final _majorTicks = _layoutScale(majorTickerCount);
  late final _minorTicks = _layoutScale(minorTickerCount);
  late final _angleDeg = _layoutAngle(_majorTicks);

  @override
  void paint(Canvas canvas, Size size) {
    const origin = Offset.zero;
    final center = size.center(origin);
    final radius = size.width / 2;
    final majorTickLength = size.width * 0.08;
    final minorTickLength = size.width * 0.055;
    canvas.save();

    for (final angle in _majorTicks) {
      final tickStart =
          Offset.fromDirection(_correctAngle(angle).toRadians(), radius);
      final tickEnd = Offset.fromDirection(
          _correctAngle(angle).toRadians(), radius - majorTickLength);
      canvas.drawLine(center + tickStart, center + tickEnd, majorScalePaint);
    }

    for (final angle in _minorTicks) {
      final tickStart =
          Offset.fromDirection(_correctAngle(angle).toRadians(), radius);
      final tickEnd = Offset.fromDirection(
          _correctAngle(angle).toRadians(), radius - minorTickLength);
      canvas.drawLine(center + tickStart, center + tickEnd, minorScalePaint);
    }

    for (final angle in _angleDeg) {
      final textPadding = majorTickLength - size.width * 0.02;
      final textPainter =
          TextSpan(text: angle.toStringAsFixed(0), style: majorScaleStyle)
              .toPainter()
            ..layout();
      final layutOffset = Offset.fromDirection(
          _correctAngle(angle).toRadians(), radius - textPadding);
      final offset = center + layutOffset;
      canvas.restore();
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle.toRadians());
      canvas.translate(-offset.dx, -offset.dy);

      textPainter.paint(
          canvas, Offset(offset.dx - (textPainter.width / 2), offset.dy));
    }

    for (final cardinality in cardinalityMap.entries) {
      final textPadding = majorTickLength + size.width * 0.02;
      final text = cardinality.value;
      final angle = cardinality.key.toDouble();
      final textPainter = TextSpan(
              text: text,
              style: cardinalityScaleStyle.copyWith(
                  color: text == 'N' ? Colors.amberAccent : Colors.black))
          .toPainter()
        ..layout();
      final layutOffset = Offset.fromDirection(
          _correctAngle(angle).toRadians(), radius - textPadding);
      final offset = center + layutOffset;
      canvas.restore();
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle.toRadians());
      canvas.translate(-offset.dx, -offset.dy);

      textPainter.paint(
          canvas, Offset(offset.dx - (textPainter.width / 2), offset.dy));
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  List<double> _layoutScale(int ticks) {
    final scale = 360 / ticks;
    return List.generate(ticks, (index) => index * scale);
  }

  List<double> _layoutAngle(List<double> ticks) {
    List<double> angle = [];
    for (var i = 0; i < ticks.length; i++) {
      if (i == ticks.length - 1) {
        double degreeValue = (ticks[i] + 360) / 2;
        angle.add(degreeValue);
      } else {
        double degreeValue = (ticks[i] + ticks[i + 1]) / 2;
        angle.add(degreeValue);
      }
    }
    return angle;
  }

  double _correctAngle(double angle) {
    return angle - 90;
  }
}

typedef CardinalityMap = Map<num, String>;

extension on TextSpan {
  TextPainter toPainter({TextDirection textDirection = TextDirection.ltr}) =>
      TextPainter(text: this, textDirection: textDirection);
}

extension on num {
  double toRadians() => this * pi / 180;
}
