import 'dart:math';

import 'package:flutter/material.dart';

class SmSectorPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final Color color; 

  SmSectorPainter({
    required this.startAngle,
    required this.endAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final double radius = min(size.width / 2, size.height / 2);

    canvas.drawArc(rect.deflate(radius - size.width / 4), startAngle * pi / 180, (endAngle - startAngle) * pi / 180, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}