import 'dart:math' as math show sqrt;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation, {
    required this.color,
  }) : super(repaint: _animation);
  final Color color;
  final Animation<double>? _animation;
  void circle(Canvas canvas, Rect rect, double value) {
    final opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final  _color = color.withOpacity(opacity);
    final  size = rect.width / 2;
    final  area = size * size;
    final  radius = math.sqrt(area * value / 4);
    final  paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final  rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (var wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation!.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
