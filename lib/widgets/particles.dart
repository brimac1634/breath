import 'package:flutter/material.dart';
import 'dart:math';

class Particles extends StatefulWidget {
  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles>
    with SingleTickerProviderStateMixin {
  double waveRadius = 0.0;
  Animation<double> _animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: 0.0, end: 300.0).animate(controller)
      ..addListener(() {
        setState(() {
          waveRadius = _animation.value;
        });
      });

    return Container(
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: CirclePainter(),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  // final double x;
  // final double y;
  // final double dx;
  // final double dy;

  var circlePaint;

  CirclePainter() {
    circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 20; i++) {
      double centerX = Random().nextDouble() * size.width;
      double centerY = Random().nextDouble() * size.height;
      canvas.drawCircle(Offset(centerX, centerY), 4, circlePaint);
      // currentRadius += 10.0;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
