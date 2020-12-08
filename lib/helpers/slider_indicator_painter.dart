import 'package:flutter/material.dart';

class SliderIndicatorPainter extends CustomPainter {
  final double position;
  final Color color;
  SliderIndicatorPainter(this.position, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(position, size.height / 2),
        20,
        Paint()
          ..color = color
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(SliderIndicatorPainter old) {
    return true;
  }
}
